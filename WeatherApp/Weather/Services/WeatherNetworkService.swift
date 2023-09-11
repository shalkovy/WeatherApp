//
//  WeatherNetworkService.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation
import CoreLocation

protocol WeatherNetworkServiceProtocol {
    func getCurrentWeather(location: CLLocation,
                           completion: @escaping (Result<WeatherData, Error>) -> ())
}

final class WeatherNetworkService: WeatherNetworkServiceProtocol {
    private let helper: NetworkHelperProtocol
    
    init(helper: NetworkHelperProtocol = NetworkHelper()) {
        self.helper = helper
    }
    
    func getCurrentWeather(location: CLLocation,
                           completion: @escaping (Result<WeatherData, Error>) -> ()) {
        let endpoint = CurrentWeatherEndpoint.getWeather(lat: location.coordinate.latitude,
                                                         lon: location.coordinate.longitude)
        helper.request(endpoint: endpoint, completion: completion)
    }
}
