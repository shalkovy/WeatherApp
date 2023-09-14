//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 07/09/2023.
//

import UIKit

protocol WeatherViewControllerProtocol: AnyObject {
    func updateLabel(with text: String)
    func updateActivity(shouldAnimate: Bool)
    func show(error: Error)
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
    
    private lazy var tempUnitSwitch: UISwitch = {
        let tSwitch = UISwitch()
        let action = UIAction { [weak self] action in
            self?.presenter.switchTemperatureUnit()
        }
        tSwitch.addAction(action, for: .valueChanged)
        return tSwitch
    }()
    
    private lazy var darkModeSwitch: UISwitch = {
        let dmSwitch = UISwitch()
        let action = UIAction { [weak self] action in
            self?.changeInterfaceStyle()
        }
        dmSwitch.addAction(action, for: .valueChanged)
        dmSwitch.isOn = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        return dmSwitch
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
        layoutViews()
        view.backgroundColor = .systemBackground
    }
    
    func show(error: Error) {
        showAlert(error)
    }
    
    func updateActivity(shouldAnimate: Bool) {
        shouldAnimate ? activity.startAnimating() : activity.stopAnimating()
        
        UIView.animate(withDuration: 0.5) {
            self.weatherLabel.alpha = shouldAnimate ? 0.0 : 1.0
        }
    }
    
    func updateLabel(with text: String) {
        weatherLabel.fadeTransition()
        weatherLabel.text = text
    }
    
    private func changeInterfaceStyle() {
        guard let window = view.window else { return }
        let currentMode: UIUserInterfaceStyle
        if window.overrideUserInterfaceStyle == .unspecified {
            currentMode = UIScreen.main.traitCollection.userInterfaceStyle
        } else {
            currentMode = window.overrideUserInterfaceStyle
        }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = currentMode == .dark ? .light : .dark
        }
    }
    
    private func layoutViews() {
        layoutWeatherLabel()
        layoutActivity()
        setupNavBar()
        layoutTemperatureSwitch()
        layoutDarkModeSwitch()
    }
    
    private func layoutTemperatureSwitch() {
        view.addSubview(tempUnitSwitch)
        tempUnitSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempUnitSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tempUnitSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16)
        ])
    }
    
    private func layoutDarkModeSwitch() {
        view.addSubview(darkModeSwitch)
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            darkModeSwitch.topAnchor.constraint(equalTo: tempUnitSwitch.bottomAnchor, constant: 8),
            darkModeSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -16)
        ])
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
        presenter.searchButtonTapped(from: self)
    }
}
