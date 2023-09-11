//
//  CurrentWeatherEndpoint.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation
import CoreLocation

enum CurrentWeatherEndpoint: Endpoint {
    case getWeather(lat: CLLocationDegrees, lon: CLLocationDegrees)
    
    var scheme: String {
        switch self {
        case .getWeather:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getWeather:
            return "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/weather"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getWeather(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: lat.description),
                URLQueryItem(name: "lon", value: lon.description),
                URLQueryItem(name: "appid", value: Keys.apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        }
    }
    
    var method: String {
        switch self {
        case .getWeather:
            return "GET"
        }
    }
}
