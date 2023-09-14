//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit
import CoreLocation

protocol WeatherPresenterProtocol {
    func didLoad()
    func searchButtonTapped(from vc: UIViewController)
    func switchTemperatureUnit()
}

final class WeatherPresenter: WeatherPresenterProtocol {
    private let interactor: WeatherInteractorProtocol
    private let router: WeatherRouterProtocol
    private let formatter: UnitFormatter
    private(set) var tempUnit: UnitTemperature
    private var weatherData: WeatherData?
    weak var view: WeatherViewControllerProtocol?
    
    init(interactor: WeatherInteractorProtocol,
         router: WeatherRouterProtocol,
         formatter: UnitFormatter = UnitFormatter(),
         tempUnit: UnitTemperature = Locale.current.usesMetricSystem ? .celsius : .fahrenheit) {
        self.interactor = interactor
        self.router = router
        self.formatter = formatter
        self.tempUnit = tempUnit
    }
    
    func switchTemperatureUnit() {
        tempUnit = tempUnit == .celsius ? .fahrenheit : .celsius
        updateWeather()
    }
    
    func didLoad() {
        view?.updateActivity(shouldAnimate: true)
        interactor.getCurrentLocation()
    }
    
    func searchButtonTapped(from vc: UIViewController) {
        router.navigateToSearch(vc.navigationController, delegate: self)
    }
    
    private func updateWeather() {
        view?.updateActivity(shouldAnimate: false)
        guard let weatherData else { return }
        let temperatureString = formatter.convert(temperature: weatherData.main.temp,
                                                             to: tempUnit)
        let displayText = "\(weatherData.name)\n\(temperatureString)"
        view?.updateLabel(with: displayText)
    }
}

extension WeatherPresenter: WeatherInteractorOutput {
    func didUpdate(_ location: CLLocation?) {
        guard let location else { return }
        view?.updateActivity(shouldAnimate: true)
        interactor.getWeather(lat: location.coordinate.latitude,
                              lon: location.coordinate.longitude) { [weak self] data in
            self?.weatherData = data
            self?.updateWeather()
        }
    }
    
    func showError(_ error: Error) {
        view?.show(error: error)
        view?.updateActivity(shouldAnimate: false)
    }
}

extension WeatherPresenter: SearchPresenterDelegate {
    func didSelect(_ city: City) {
        view?.updateActivity(shouldAnimate: true)
        interactor.getWeather(lat: city.lat, lon: city.lon) { [weak self] data in
            self?.weatherData = data
            self?.updateWeather()
        }
    }
}
