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

protocol SearchPresenterDelegate: AnyObject {
    func didSelect(_ city: City)
}

final class SearchPresenter: SearchPresenterProtocol {
    private let interactor: SearchInteractorProtocol
    private let router: SearchRouterProtocol
    
    weak var view: SearchViewControllerProtocol?
    weak var delegate: SearchPresenterDelegate?
    
    init(interactor: SearchInteractorProtocol,
         router: SearchRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func didSelect(_ city: City, from vc: UIViewController) {
        delegate?.didSelect(city)
        router.back(from: vc.navigationController)
    }
    
    func search(for city: String) {
        view?.updateActivity(shouldAnimate: true)
        interactor.search(city) { [weak self] result in
            switch result {
            case .success(let cities):
                self?.view?.updateActivity(shouldAnimate: false)
                guard cities.count > 1 else {
                    self?.view?.showAlert(WeatherAppError.nothingFound)
                    return
                }
                self?.updateViewWith(cities)
            case .failure(let error):
                self?.view?.updateActivity(shouldAnimate: false)
                self?.view?.showAlert(error)
            }
        }
    }
    
    private func updateViewWith(_ cities: [City]) {
        let unique = Array(Set(cities))
        view?.updateWith(unique)
    }
}
