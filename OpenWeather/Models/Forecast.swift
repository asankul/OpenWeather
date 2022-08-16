//
//  Weather.swift
//  7Timer
//
//  Created by Асанкул Садыков on 13/8/22.

struct Forecast {
    let weather: [Weather]
    let main: Main
    let name: String
    
    init(weather: [Weather] = [], main: Main = Main(), name: String = "") {
        self.weather = weather
        self.main = main
        self.name = name
    }
    
    init(forecastData: [String: Any]) {
        weather = Weather.getWeather(from: forecastData["weather"] ?? [])
        main = Main.getMain(from: forecastData["main"] ?? Main())  
        name = forecastData["name"] as? String ?? "NoName"
    }
    
    static func getForecast(from value: Any) -> Forecast {
        guard let forecastData = value as? [String: Any] else { return Forecast()}
        return Forecast(forecastData: forecastData)
    }
}

struct Weather {
    let icon: String
    
    init(weatherData: [String: Any]) {
        icon = weatherData["icon"] as? String ?? "NoIcon"
    }
    
    static func getWeather(from weather: Any) -> [Weather] {
        guard let weatherData = weather as? [[String: Any]] else { return []}
        return weatherData.compactMap { Weather(weatherData: $0) }
    }
}

struct Main {
    let temp: Double
    
    init(temp: Double = 0.0) {
        self.temp = temp
    }
    
    init(mainData: [String: Any]) {
        temp = mainData["temp"] as? Double ?? 0.0
    }
    
    static func getMain(from main: Any) -> Main {
        guard let mainData = main as? [String: Any] else { return Main()}
        return Main(mainData: mainData)
    }
}
