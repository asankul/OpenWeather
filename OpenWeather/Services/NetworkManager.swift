//
//  NetworkManager.swift
//  7Timer
//
//  Created by Асанкул Садыков on 13/8/22.
//

import Foundation
import Alamofire

enum Link: String {
    case forecastLink = "https://api.openweathermap.org/data/2.5/weather?lat=34.68406&lon=33.03794&appid=12816ee3690f4ea2c47e71a8e2ea7412&units=metric"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch(from url: String, completion: @escaping(Result<Forecast, AFError>)-> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let forecast = Forecast.getForecast(from: value)
                    completion(.success(forecast))
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func fetchData(from url: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataRequest in
                switch dataRequest.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print(error)
                }
            }
    }
}
