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
