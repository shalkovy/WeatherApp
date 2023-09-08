//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import Foundation

protocol WeatherPresenterProtocol {
    func didLoad()
}

final class WeatherPresenter: WeatherPresenterProtocol {
    private let interactor: WeatherInteractorProtocol
    weak var view: WeatherViewControllerProtocol?
    
    init(interactor: WeatherInteractorProtocol) {
        self.interactor = interactor
    }
    
    func didLoad() {
        interactor.getWeatherForCurrentLocation { [weak self] result in
            switch result {
            case .success(let data):
                let weather = data.name + "\n" + String(format: "%.1f", data.main.temp)
                self?.view?.updateLabel(with: weather)
            case .failure(let error):
                if let localized = error as? LocalizedError {
                    self?.view?.showErrorAlert(error: error as! LocalizedError)
                } else {
                    print(error)
                }
            }
        }
    }
}
