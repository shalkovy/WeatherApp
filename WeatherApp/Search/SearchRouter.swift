//
//  SearchRouter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 12/09/2023.
//

import UIKit

protocol SearchRouterProtocol {
    func back(from navController: UINavigationController?)
}

final class SearchRouter: SearchRouterProtocol {
    func back(from navController: UINavigationController?) {
        navController?.popViewController(animated: true)
    }
}
