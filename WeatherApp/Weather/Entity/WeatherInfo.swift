//
//  WeatherInfo.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
