//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation

struct WeatherData: Codable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct MainInfo: Codable {
    let temp: Double
}
