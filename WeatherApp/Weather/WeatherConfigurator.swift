//
//  WeatherConfigurator.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

final class WeatherConfigurator {
    func configure() -> UIViewController {
        let locationService = LocationService()
        let networkService = WeatherNetworkService()
        let interactor = WeatherInteractor(locationService: locationService, networkService: networkService)
        let presenter = WeatherPresenter(interactor: interactor)
        let controller = WeatherViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }
}
