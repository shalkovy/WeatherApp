//
//  UIView+Ext.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 13/09/2023.
//

import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval = 0.5) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UIView {
    func pinToCenter(to view: UIView, xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xOffset),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset)
        ])
    }
}
