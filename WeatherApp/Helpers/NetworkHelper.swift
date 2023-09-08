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
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            guard response != nil, let data = data else { return }
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode (T.self, from: data) {
                    completion(.success(responseObject))
                } else {
                    completion(.failure(NetworkError.failedToDecode))
                }
            }
        }
        
        dataTask.resume()
    }
}
