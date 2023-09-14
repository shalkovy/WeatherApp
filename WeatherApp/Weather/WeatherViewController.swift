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
        label.font = .boldSystemFont(ofSize: Constants.fontSize)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var temperatureUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.font = .boldSystemFont(ofSize: Constants.fontSize)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "°C/°F"
        return label
    }()
    
    private lazy var darkModeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.font = .boldSystemFont(ofSize: Constants.fontSize)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "Light/Dark"
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
        
        UIView.animate(withDuration: Constants.animationDuration) {
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
        UIView.transition(with: window,
                          duration: Constants.animationDuration,
                          options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = currentMode == .dark ? .light : .dark
        }
    }
    
    private func layoutViews() {
        layoutWeatherLabel()
        layoutActivity()
        setupNavigationBar()
        layoutTemperatureLabel()
        layoutTemperatureSwitch()
        layoutDarkModeLabel()
        layoutDarkModeSwitch()
    }
    
    private func layoutDarkModeLabel() {
        view.addSubview(darkModeLabel)
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            darkModeLabel.topAnchor.constraint(
                equalTo: tempUnitSwitch.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            darkModeLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.trailing
            )
        ])
    }
    
    private func layoutTemperatureLabel() {
        view.addSubview(temperatureUnitsLabel)
        temperatureUnitsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            temperatureUnitsLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            temperatureUnitsLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.trailing
            )
        ])
    }
    
    private func layoutTemperatureSwitch() {
        view.addSubview(tempUnitSwitch)
        tempUnitSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempUnitSwitch.topAnchor.constraint(
                equalTo: temperatureUnitsLabel.bottomAnchor
            ),
            tempUnitSwitch.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.trailing
            )
        ])
    }
    
    private func layoutDarkModeSwitch() {
        view.addSubview(darkModeSwitch)
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            darkModeSwitch.topAnchor.constraint(
                equalTo: darkModeLabel.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            darkModeSwitch.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.trailing
            )
        ])
    }
    
    private func layoutActivity() {
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.pinToCenter(to: view)
    }
    
    private func layoutWeatherLabel() {
        view.addSubview(weatherLabel)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.pinToCenter(to: view)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.searchImage,
            style: .plain,
            target: self,
            action: #selector(searchTapped))
    }
    
    @objc
    private func searchTapped() {
        presenter.searchButtonTapped(from: self)
    }
}

extension WeatherViewController {
    enum Constants {
        static let trailing: CGFloat = -16
        static let verticalSpacing: CGFloat = 8
        static let animationDuration = 0.5
        static let fontSize: CGFloat = 18
        static let searchImage = UIImage(systemName: "magnifyingglass")
    }
}
