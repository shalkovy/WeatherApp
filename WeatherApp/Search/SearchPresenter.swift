//
//  SearchPresenter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 10/09/2023.
//

import UIKit

protocol SearchPresenterProtocol {
    func search(for city: String)
    func didSelect(_ city: City, from vc: UIViewController)
}

final class SearchPresenter: SearchPresenterProtocol {
    private let interactor: SearchInteractorProtocol
    private let router: SearchRouterProtocol
    
    weak var view: SearchViewControllerProtocol?
    
    init(interactor: SearchInteractorProtocol,
         router: SearchRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func didSelect(_ city: City, from vc: UIViewController) {
        router.back(from: vc.navigationController)
    }
    
    func search(for city: String) {
        view?.updateActivity(true)
        interactor.search(city) { [weak self] result in
            switch result {
            case .success(let cities):
                self?.view?.updateActivity(false)
                guard cities.count > 1 else {
                    self?.view?.showErrorAlert(error: SearchError.nothingFound)
                    return
                }
                self?.updateViewWith(cities)
            case .failure(let error):
                self?.view?.updateActivity(false)
                if let localized = error as? LocalizedError {
                    self?.view?.showErrorAlert(error: localized)
                } else {
                    print(error)
                }
            }
        }
    }
    
    private func updateViewWith(_ cities: [City]) {
        let unique = Array(Set(cities))
        view?.updateWith(unique)
    }
}
