//
//  SearchEndpoint.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 11/09/2023.
//

import Foundation

enum SearchEndpoint: Endpoint {
    case findCities(byName: String)
    
    var scheme: String {
        switch self {
        case .findCities:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .findCities:
            return "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .findCities:
            return "/geo/1.0/direct"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .findCities(let name):
            return [
                URLQueryItem(name: "q", value: name),
                URLQueryItem(name: "appid", value: Keys.apiKey),
                URLQueryItem(name: "limit", value: "5")
            ]
        }
    }
    
    var method: String {
        switch self {
        case .findCities:
            return "GET"
        }
    }
}
