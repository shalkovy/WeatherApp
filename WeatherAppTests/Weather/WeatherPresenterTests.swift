//
//  WeatherPresenterTests.swift
//  WeatherAppTests
//
//  Created by Dima Shelkov on 13/09/2023.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class WeatherPresenterTests: XCTestCase {
    var presenter: WeatherPresenter!
    var mockInteractor: MockWeatherInteractor!
    var mockRouter: MockWeatherRouter!
    var mockView: MockWeatherViewController!
    
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockWeatherInteractor()
        mockRouter = MockWeatherRouter()
        mockView = MockWeatherViewController()
        
        presenter = WeatherPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            temperatureFormatter: TemperatureFormatter(),
            tempUnit: .celsius
        )
        presenter.view = mockView
        
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        super.tearDown()
    }
    
    func testSwitchTemperatureUnit() {
        XCTAssertEqual(presenter.tempUnit, UnitTemperature.celsius)
        presenter.switchTemperatureUnit()
        XCTAssertEqual(presenter.tempUnit, UnitTemperature.fahrenheit)
        presenter.switchTemperatureUnit()
        XCTAssertEqual(presenter.tempUnit, UnitTemperature.celsius)
    }
    
    func testDidLoad() {
        presenter.didLoad()
        
        XCTAssertTrue(mockView.updateActivityCalled)
        XCTAssertTrue(mockInteractor.getCurrentLocationCalled)
    }
    
    func testSearchButtonTapped() {
        let mockViewController = UIViewController()
        presenter.searchButtonTapped(from: mockViewController)
        
        XCTAssertTrue(mockRouter.navigateToSearchCalled)
        XCTAssertEqual(mockRouter.navigateToSearchViewController, mockViewController.navigationController)
        XCTAssertTrue(mockRouter.navigateToSearchDelegate === presenter)
    }
    
    func testDidUpdateWeather() {
        presenter.didLoad()
        
        XCTAssertTrue(mockInteractor.getCurrentLocationCalled)
        XCTAssertTrue(mockView.updateActivityCalled)
    }
    
    func testDidSelectCity() {
        let city = City(name: "Test City", lat: 0, lon: 0, country: nil, state: nil)
        presenter.didSelect(city)
        
        XCTAssertTrue(mockInteractor.getWeatherCalled)
        XCTAssertTrue(mockView.updateActivityCalled)
        XCTAssertEqual(mockView.updateLabelText, "Test City\n20°C")
    }
    
    func testDidReceiveError() {
        let testError = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        presenter.showError(testError)
        XCTAssertTrue(mockView.updateActivityCalled)
        XCTAssertTrue(mockView.showAlertCalled)
        XCTAssertEqual(mockView.showAlertError as NSError?, testError)
    }
}

class MockWeatherInteractor: WeatherInteractorProtocol {
    var getCurrentLocationCalled = false
    var getWeatherCalled = false
    var getWeatherLocation: City?
    
    func getCurrentLocation() {
        getCurrentLocationCalled = true
    }
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> ()) {
        getWeatherCalled = true
        let testData = WeatherData(weather: [],
                                   main: MainInfo(temp: 293.15),
                                   timezone: 0,
                                   id: 0,
                                   name: "Test City",
                                   cod: 0)
        completion(testData)
    }
}

class MockWeatherRouter: WeatherRouterProtocol {
    var navigateToSearchCalled = false
    var navigateToSearchViewController: UINavigationController?
    var navigateToSearchDelegate: SearchPresenterDelegate?
    
    func navigateToSearch(_ navController: UINavigationController?, delegate: SearchPresenterDelegate) {
        navigateToSearchCalled = true
        navigateToSearchViewController = navController
        navigateToSearchDelegate = delegate
    }
}

class MockWeatherViewController: WeatherViewControllerProtocol {
    var updateActivityCalled = false
    var updateLabelCalled = false
    var updateLabelText: String?
    var showAlertCalled = false
    var showAlertError: Error?
    
    func updateActivity(animate: Bool) {
        updateActivityCalled = true
    }
    
    func updateLabel(with text: String) {
        updateLabelCalled = true
        updateLabelText = text
    }
    
    func show(error: Error) {
        showAlertCalled = true
        showAlertError = error
    }
}
