//
//  LocationService.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    var delegate: LocationServiceDelegate? { get set }
    func checkStatusAndUpdateLocation() throws
}

protocol LocationServiceDelegate: AnyObject {
    func didUpdate(_ location: CLLocation?)
    func showError(_ error: WeatherAppError)
}

final class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager: CLLocationManager
    weak var delegate: LocationServiceDelegate?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        super.init()
        locationManager.delegate = self
    }

    func checkStatusAndUpdateLocation() throws {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            throw WeatherAppError.permissionDenied
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            throw WeatherAppError.defaultError
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdate(locations.first)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            delegate?.showError(.permissionDenied)
        default:
            return
        }
    }
}
