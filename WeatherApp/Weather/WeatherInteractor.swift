//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import Foundation
import CoreLocation

protocol WeatherInteractorProtocol: AnyObject {
    func getWeather(for location: City?,
                    completion: @escaping (Result<WeatherData, Error>) -> ())
}

final class WeatherInteractor: WeatherInteractorProtocol {
    private var locationService: LocationServiceProtocol
    private let networkService: WeatherNetworkServiceProtocol
    private var currentLocation: CLLocation?
    
    init(locationService: LocationServiceProtocol,
         networkService: WeatherNetworkServiceProtocol) {
        self.locationService = locationService
        self.networkService = networkService
        self.locationService.delegate = self
    }
    
    func getWeather(for location: City? = nil,
                    completion: @escaping (Result<WeatherData, Error>) -> ()) {
        if let city = location {
            networkService.getWeather(lat: city.lat, lon: city.lon, completion: completion)
        } else {
            getWeatherForCurrentLocation(completion: completion)
        }
    }
    
    private func getWeatherForCurrentLocation(completion: @escaping (Result<WeatherData, Error>) -> ()) {
        do {
            try locationService.checkStatusAndUpdateLocation()
        } catch {
            completion(.failure(error))
        }
        
        guard let location = currentLocation else { return }
        networkService.getWeather(lat: location.coordinate.latitude,
                                  lon: location.coordinate.longitude,
                                  completion: completion)
    }
}

extension WeatherInteractor: LocationServiceDelegate {
    func didUpdate(_ location: CLLocation?) {
        currentLocation = location
    }
}
