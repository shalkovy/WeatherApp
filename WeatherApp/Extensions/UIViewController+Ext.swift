//
//  UIViewController+Ext.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Error", _ error: Error) {
        let alert = ErrorHandlingService().alertController(title: title, error: error)
        present(alert, animated: true, completion: nil)
    }
}
