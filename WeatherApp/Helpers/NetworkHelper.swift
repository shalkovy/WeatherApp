//
//  NetworkHelper.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation

enum NetworkError: Error {
    case wrongURL
    case failedToDecode
    case unableToComplete
    case invalidResponse
    case invalidData
}

protocol NetworkHelperProtocol {
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ())
}

struct NetworkHelper: NetworkHelperProtocol {
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()) {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        
        debugPrint(url)
        
        var urlRequest = URLRequest (url: url)
        urlRequest.httpMethod = endpoint.method
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask (with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(NetworkError.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(responseObject))
                } else {
                    completion(.failure(NetworkError.failedToDecode))
                }
            }
        }
        
        dataTask.resume()
    }
}
