//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation

protocol Endpoint {
    // HTTP or HTTPS
    var scheme: String { get }
    
    // "api.openweathermap.org"
    var baseURL: String { get }
    
    // "data/2.5/"
    var path: String { get }
    
    // [URLQueryItem(name: "appid", value: API_KEY]
    var parameters: [URLQueryItem] { get }
    
    // "GET"
    var method: String { get }
}
