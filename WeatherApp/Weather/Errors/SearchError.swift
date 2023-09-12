//
//  SearchError.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 12/09/2023.
//

import Foundation

enum SearchError: LocalizedError {
    case nothingFound

    var errorDescription: String? {
        switch self {
        case .nothingFound:
            return "Nothing found"
        }
    }
}
