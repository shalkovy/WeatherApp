//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

protocol WeatherRouterProtocol {
    func navigateToSearch(_ navController: UINavigationController?)
}

final class WeatherRouter: WeatherRouterProtocol {
    func navigateToSearch(_ navController: UINavigationController?) {
        let searchController = SearchConfigurator().configure()
        navController?.pushViewController(searchController, animated: true)
    }
}
