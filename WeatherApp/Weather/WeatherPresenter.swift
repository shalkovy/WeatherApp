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
    private let formatter: TemperatureFormatter
    private var tempUnit: UnitTemperature
    private var weatherData: WeatherData?
    weak var view: WeatherViewControllerProtocol?
    
    init(interactor: WeatherInteractorProtocol,
         router: WeatherRouterProtocol,
         formatter: TemperatureFormatter = TemperatureFormatter()) {
        self.interactor = interactor
        self.router = router
        self.formatter = formatter
        self.tempUnit = Locale.current.usesMetricSystem ? .celsius : .fahrenheit
    }
    
    func switchTemperatureUnit() {
        tempUnit = tempUnit == .celsius ? UnitTemperature.fahrenheit : UnitTemperature.celsius
        view?.updateLabel(with: displayedData())
    }
    
    func didLoad() {
        view?.updateActivity(animate: true)
        getCurrentLocation()
    }
    
    func searchButtonTapped(from vc: UIViewController) {
        router.navigateToSearch(vc.navigationController, delegate: self)
    }
    
    private func getCurrentLocation() {
        do {
            try interactor.getCurrentLocation()
        } catch {
            view?.updateActivity(animate: false)
            view?.showAlert(error)
        }
    }
    
    private func handleWeather(_ result: Result<WeatherData, Error>) {
        view?.updateActivity(animate: false)
        switch result {
        case .success(let data):
            weatherData = data
            view?.updateLabel(with: displayedData())
        case .failure(let error):
            view?.showAlert(error)
        }
    }
    
    private func displayedData() -> String {
        guard let data = weatherData else { return "" }
        return data.name + "\n" + formatter.convert(temperature: data.main.temp,
                                                    to: tempUnit)
    }
}

extension WeatherPresenter: WeatherInteractorOutput {
    func didUpdate(_ location: CLLocation?) {
        guard let location else { return }
        view?.updateActivity(animate: true)
        interactor.getWeather(lat: location.coordinate.latitude,
                              lon: location.coordinate.longitude) { [weak self] result in
            self?.handleWeather(result)
        }
    }
    
    func showError(_ error: Error) {
        view?.updateActivity(animate: false)
        view?.showAlert(error)
    }
}

extension WeatherPresenter: SearchPresenterDelegate {
    func didSelect(_ city: City) {
        view?.updateActivity(animate: true)
        interactor.getWeather(lat: city.lat, lon: city.lon) { [weak self] result in
            self?.handleWeather(result)
        }
    }
}
