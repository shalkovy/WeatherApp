//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

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
        view?.updateActivity(true)
        interactor.getWeather(for: nil) { [weak self] result in
            self?.handleWeather(result)
        }
    }
    
    func searchButtonTapped(from vc: UIViewController) {
        router.navigateToSearch(vc.navigationController, delegate: self)
    }
    
    private func handleWeather(_ result: Result<WeatherData, Error>) {
        view?.updateActivity(false)
        switch result {
        case .success(let data):
            weatherData = data
            view?.updateLabel(with: displayedData())
        case .failure(let error):
            if let localized = error as? LocalizedError {
                view?.showErrorAlert(error: localized)
            } else {
                print(error)
            }
        }
    }
    
    private func displayedData() -> String {
        guard let data = weatherData else { return "" }
        return data.name + "\n" + formatter.convert(temperature: data.main.temp,
                                                    to: tempUnit)
    }
}

extension WeatherPresenter: SearchPresenterDelegate {
    func didSelect(_ city: City) {
        view?.updateActivity(true)
        interactor.getWeather(for: city) { [weak self] result in
            self?.handleWeather(result)
        }
    }
}
