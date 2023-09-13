//
//  SearchByNameEndpoint.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 11/09/2023.
//

import Foundation

// http://api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid={API key}

enum SearchByNameEndpoint: Endpoint {
    case getCityBy(name: String)
    
    var scheme: String {
        switch self {
        case .getCityBy:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getCityBy:
            return "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .getCityBy:
            return "/geo/1.0/direct"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getCityBy(let name):
            return [
                URLQueryItem(name: "q", value: name),
                URLQueryItem(name: "appid", value: Keys.apiKey),
//                URLQueryItem(name: "limit", value: 5)
                URLQueryItem(name: "limit", value: "5")
            ]
        }
    }
    
    var method: String {
        switch self {
        case .getCityBy:
            return "GET"
        }
    }
}
