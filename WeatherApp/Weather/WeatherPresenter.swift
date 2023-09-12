//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

protocol WeatherPresenterProtocol {
    func didLoad()
    func searchButtonTapped(from navController: UINavigationController?)
}

final class WeatherPresenter: WeatherPresenterProtocol {
    private let interactor: WeatherInteractorProtocol
    private let router: WeatherRouterProtocol
    weak var view: WeatherViewControllerProtocol?
    
    init(interactor: WeatherInteractorProtocol,
         router: WeatherRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func didLoad() {
        view?.updateActivity(true)
        interactor.getWeather(for: nil) { [weak self] result in
            self?.handleWeather(result)
        }
    }
    
    func searchButtonTapped(from navController: UINavigationController?) {
        router.navigateToSearch(navController, delegate: self)
    }
    
    private func handleWeather(_ result: Result<WeatherData, Error>) {
        view?.updateActivity(false)
        switch result {
        case .success(let data):
            let weather = data.name + "\n" + String(format: "%.1f", data.main.temp)
            view?.updateLabel(with: weather)
        case .failure(let error):
            if let localized = error as? LocalizedError {
                view?.showErrorAlert(error: localized)
            } else {
                print(error)
            }
        }
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
