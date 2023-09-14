//
//  SearchNetworkService.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 11/09/2023.
//

import Foundation

protocol SearchNetworkServiceProtocol {
    func search(by name: String,
                completion: @escaping (Result<[City], Error>) -> ())
}

final class SearchNetworkService: SearchNetworkServiceProtocol {
    private let helper: NetworkHelperProtocol
    
    init(helper: NetworkHelperProtocol = NetworkHelper()) {
        self.helper = helper
    }
    
    func search(by name: String, completion: @escaping (Result<[City], Error>) -> ()) {
        let searchEndpoint = SearchEndpoint.findCities(byName: name)
        helper.request(endpoint: searchEndpoint,
                       completion: completion)
    }
}
