//
//  ViewController.swift
//  7Timer
//
//  Created by Асанкул Садыков on 13/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var searchCity: UISearchBar!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var weatherTemp: UILabel!
    @IBOutlet var stackViewInfo: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewInfo.isHidden = true
        fetchCityWeather(from: Link.forecastLink.rawValue)
        setSearchBar()
        searchCity.delegate = self
    }
    
    private func setSearchBar() {
        searchCity.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchCity.searchTextField.textColor = .white
    }
    
    private func setData(with forecast: Forecast) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        cityName.text = forecast.name
        weatherTemp.text = "\(Int(forecast.main.temp))°C"
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "We coudn't find the city, try again",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            self.searchCity.text = ""
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchUrl = searchCity.text?.replacingOccurrences(of: " ", with: "%20")
        fetchCityWeather(from: "https://api.openweathermap.org/data/2.5/weather?q=\(searchUrl ?? "limassol")&appid=12816ee3690f4ea2c47e71a8e2ea7412&units=metric")
    }
}

// MARK: - Networking
extension ViewController {
    private func fetchCityWeather(from url: String) {
        NetworkManager.shared.fetch(from: url) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.setData(with: forecast)
                self?.fetchImage(from: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "10g")@2x.png")
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
    
    private func fetchImage(from url: String) {
        NetworkManager.shared.fetchData(from: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.weatherIcon.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
                self?.stackViewInfo.isHidden = false
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
     }
}
