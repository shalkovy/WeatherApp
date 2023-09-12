//
//  WeatherNetworkService.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation
import CoreLocation

protocol WeatherNetworkServiceProtocol {
    func getWeather(lat: Double,
                    lon: Double,
                    completion: @escaping (Result<WeatherData, Error>) -> ())
}

final class WeatherNetworkService: WeatherNetworkServiceProtocol {
    private let helper: NetworkHelperProtocol
    
    init(helper: NetworkHelperProtocol = NetworkHelper()) {
        self.helper = helper
    }
    
    func getWeather(lat: Double,
                    lon: Double,
                    completion: @escaping (Result<WeatherData, Error>) -> ()) {
        let endpoint = CurrentWeatherEndpoint.getWeather(lat: lat, lon: lon)
        helper.request(endpoint: endpoint, completion: completion)
    }
}
