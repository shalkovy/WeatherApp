//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

protocol WeatherViewControllerProtocol: UIViewController {
    func updateLabel(with text: String)
}

final class WeatherViewController: UIViewController, WeatherViewControllerProtocol {
    private let presenter: WeatherPresenterProtocol
    private let label = UILabel()
    
    init(presenter: WeatherPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()
        setupLabel()
        view.backgroundColor = .systemBackground
    }
    
    func updateLabel(with text: String) {
        label.text = text
    }
    
    private func setupLabel() {
        label.textColor = UIColor.textColor
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
