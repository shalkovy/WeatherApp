//
//  SearchInteractor.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 10/09/2023.
//

import Foundation

protocol SearchInteractorProtocol {
    func search(_ cityName: String, completion: @escaping (Result<[City], Error>) -> ())
}

final class SearchInteractor: SearchInteractorProtocol {
    private let searchNetworkService: SearchNetworkServiceProtocol
    
    init(networkService: SearchNetworkServiceProtocol) {
        self.searchNetworkService = networkService
    }
    
    func search(_ cityName: String, completion: @escaping (Result<[City], Error>) -> ()) {
        searchNetworkService.search(by: cityName, completion: completion)
    }
}
