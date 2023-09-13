//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import Foundation
import CoreLocation

protocol WeatherInteractorProtocol: AnyObject {
    func getCurrentLocation() throws
    func getWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> ())
}

protocol WeatherInteractorOutput: AnyObject {
    func didUpdate(_ location: CLLocation?)
    func showError(_ error: Error)
}

final class WeatherInteractor: WeatherInteractorProtocol {
    private var locationService: LocationServiceProtocol
    private let networkService: WeatherNetworkServiceProtocol
    weak var output: WeatherInteractorOutput?
    
    init(locationService: LocationServiceProtocol,
         networkService: WeatherNetworkServiceProtocol) {
        self.locationService = locationService
        self.networkService = networkService
        self.locationService.delegate = self
    }
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> ()) {
        networkService.getWeather(lat: lat, lon: lon, completion: completion)
    }
    
    func getCurrentLocation() throws {
        try locationService.checkStatusAndUpdateLocation()
    }
}

extension WeatherInteractor: LocationServiceDelegate {
    func didUpdate(_ location: CLLocation?) {
        output?.didUpdate(location)
    }
    
    func showError(_ error: WeatherAppError) {
        output?.showError(error)
    }
}
