//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

protocol WeatherViewControllerProtocol: UIViewController {
    func updateLabel(with text: String)
    func updateActivity(_ isFetching: Bool)
}

final class WeatherViewController: UIViewController, WeatherViewControllerProtocol {
    private let presenter: WeatherPresenterProtocol
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let activity = UIActivityIndicatorView(style: .large)
    
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
        layoutWeatherLabel()
        layoutActivity()
        setupNavBar()
        view.backgroundColor = .systemBackground
    }
    
    func updateActivity(_ isFetching: Bool) {
        isFetching ? activity.startAnimating() : activity.stopAnimating()
        
        UIView.animate(withDuration: 0.5) {
            self.weatherLabel.alpha = isFetching ? 0.0 : 1.0
        }
    }
    
    func updateLabel(with text: String) {
        weatherLabel.text = text
    }
    
    private func layoutActivity() {
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func layoutWeatherLabel() {
        view.addSubview(weatherLabel)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchTapped))
    }
    
    @objc
    private func searchTapped() {
        presenter.searchButtonTapped(from: self.navigationController)
    }
}
