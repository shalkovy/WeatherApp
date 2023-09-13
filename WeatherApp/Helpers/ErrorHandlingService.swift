//
//  ErrorHandlingService.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 13/09/2023.
//

import UIKit

final class ErrorHandlingService {
    func alertController(title: String, error: Error) -> UIAlertController {
        let description: String?
        if let localized = error as? LocalizedError {
            description = localized.errorDescription
        } else {
            description = error.localizedDescription
        }
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        if let location = error as? WeatherAppError {
            guard location == .permissionDenied else { return alert }
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            alert.addAction(settingsAction)
        }
        return alert
    }
}
