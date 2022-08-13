//
//  ViewController.swift
//  7Timer
//
//  Created by Асанкул Садыков on 13/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityName: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var weatherTemp: UILabel!
    @IBOutlet var stackViewInfo: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewInfo.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchWeather()
    }
    
    private func setData(with forecast: Forecast) {
        cityName.text = forecast.name
        weatherTemp.text = "\(Int(forecast.main.temp))°C"
    }


}

// MARK: - Networking
extension ViewController {
    private func fetchWeather() {
        NetworkManager.shared.fetch(Forecast.self, from: Link.forecastLink.rawValue) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.setData(with: forecast)
                self?.fetchImage(from: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "10g")@2x.png")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchImage(from url: String) {
        NetworkManager.shared.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.weatherIcon.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
                self?.stackViewInfo.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
     }
}

