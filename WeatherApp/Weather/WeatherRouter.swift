//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

protocol WeatherRouterProtocol {
    func navigateToSearch(_ navController: UINavigationController?, delegate: SearchPresenterDelegate)
}

final class WeatherRouter: WeatherRouterProtocol {
    func navigateToSearch(_ navController: UINavigationController?, delegate: SearchPresenterDelegate) {
        let searchController = SearchConfigurator().configure(with: delegate)
        navController?.pushViewController(searchController, animated: true)
    }
}
