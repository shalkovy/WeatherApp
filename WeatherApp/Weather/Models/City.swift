//
//  City.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 12/09/2023.
//

import Foundation

struct City: Codable, Hashable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
    
    var fullCityName: String {
        return [name, state, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
