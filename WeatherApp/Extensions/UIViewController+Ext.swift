//
//  UIViewController+Ext.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with title: String = "Error", error: LocalizedError) {
        let alert = UIAlertController(title: title, message: error.errorDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
