//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import Foundation
import CoreLocation

protocol WeatherInteractorProtocol: AnyObject {
    func getCurrentLocation()
    func getWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> ())
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
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> ()) {
        networkService.getWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                completion(nil)
                self?.output?.showError(error)
            }
        }
    }
    
    func getCurrentLocation() {
        do {
            try locationService.checkStatusAndUpdateLocation()
        } catch {
            output?.showError(error)
        }
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
