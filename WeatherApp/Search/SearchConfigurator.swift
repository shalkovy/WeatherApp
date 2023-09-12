//
//  SearchConfigurator.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 10/09/2023.
//

import UIKit

final class SearchConfigurator {
    func configure(with searchDelegate: SearchPresenterDelegate) -> UIViewController {
        let searchNetworkService = SearchNetworkService()
        let interactor = SearchInteractor(networkService: searchNetworkService)
        let router = SearchRouter()
        let presenter = SearchPresenter(interactor: interactor, router: router)
        let viewController = SearchViewController(presenter: presenter)
        presenter.view = viewController
        presenter.delegate = searchDelegate
        return viewController
    }
}
