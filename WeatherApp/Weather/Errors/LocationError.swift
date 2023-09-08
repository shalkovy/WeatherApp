//
//  LocationError.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 08/09/2023.
//

import Foundation

enum LocationError: LocalizedError {
    case permissionDenied
    case defaultError

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Permisson to your location denied. Change app location access in Settings"
        case .defaultError:
            return "Ooops! \nSomething went wrong"
        }
    }
}
