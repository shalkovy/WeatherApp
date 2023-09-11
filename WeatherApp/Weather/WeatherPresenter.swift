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
        interactor.getWeatherForCurrentLocation { [weak self] result in
            switch result {
            case .success(let data):
                let weather = data.name + "\n" + String(format: "%.1f", data.main.temp)
                self?.view?.updateLabel(with: weather)
            case .failure(let error):
                if let localized = error as? LocalizedError {
                    self?.view?.showErrorAlert(error: localized)
                } else {
                    print(error)
                    
                }
            }
        }
    }
    
    func searchButtonTapped(from navController: UINavigationController?) {
        router.navigateToSearch(navController)
    }
}
