//
//  WeatherInteractorTests.swift
//  WeatherAppTests
//
//  Created by Dima Shelkov on 13/09/2023.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class WeatherInteractorTests: XCTestCase {
    var interactor: WeatherInteractor!
    var mockLocationService: MockLocationService!
    var mockNetworkService: MockNetworkService!
    var mockInteractorOutput: MockInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockLocationService = MockLocationService()
        mockNetworkService = MockNetworkService()
        mockInteractorOutput = MockInteractorOutput()
        
        interactor = WeatherInteractor(locationService: mockLocationService,
                                       networkService: mockNetworkService)
        interactor.output = mockInteractorOutput
    }
    
    func testGetWeather() {
        let testLat = 42.0
        let testLon = -42.0
        
        interactor.getWeather(lat: testLat, lon: testLon) { weatherData in
            XCTAssertNotNil(weatherData)
            XCTAssertTrue(self.mockNetworkService.getWeatherCalled)
            XCTAssertEqual(self.mockNetworkService.getWeatherLat, testLat)
            XCTAssertEqual(self.mockNetworkService.getWeatherLon, testLon)
            XCTAssertFalse(self.mockInteractorOutput.didUpdateCalled)
        }
    }
    
    func testGetCurrentLocation() {
        XCTAssertFalse(mockLocationService.checkStatusAndUpdateLocationCalled)
        
        interactor.getCurrentLocation()
        XCTAssertTrue(mockLocationService.checkStatusAndUpdateLocationCalled)
        XCTAssertFalse(mockInteractorOutput.showErrorCalled)
    }
    
    func testLocationServiceError() {
        let testError = WeatherAppError.defaultError
        mockLocationService.delegate?.showError(testError)
        XCTAssertTrue(mockInteractorOutput.showErrorCalled)
        XCTAssertEqual(mockInteractorOutput.receivedError as? WeatherAppError, testError)
    }
    
    func testLocationServiceDidUpdate() {
        let testLocation = CLLocation(latitude: 42.0, longitude: 42.0)
        mockLocationService.delegate?.didUpdate(testLocation)
        XCTAssertTrue(mockInteractorOutput.didUpdateCalled)
        XCTAssertEqual(mockInteractorOutput.receivedLocation, testLocation)
    }
}

class MockLocationService: LocationServiceProtocol {
    var delegate: LocationServiceDelegate?
    var checkStatusAndUpdateLocationCalled = false
    
    func checkStatusAndUpdateLocation() throws {
        checkStatusAndUpdateLocationCalled = true
    }
}

class MockNetworkService: WeatherNetworkServiceProtocol {
    var getWeatherCalled = false
    var getWeatherLat: Double = 0.0
    var getWeatherLon: Double = 0.0
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        getWeatherCalled = true
        getWeatherLat = lat
        getWeatherLon = lon
        let testData = WeatherData(weather: [],
                                   main: MainInfo(temp: 293.15),
                                   timezone: 0,
                                   id: 0,
                                   name: "Test City",
                                   cod: 0)
        completion(.success(testData))
    }
}

class MockInteractorOutput: WeatherInteractorOutput {
    var didUpdateCalled = false
    var showErrorCalled = false
    var receivedLocation: CLLocation?
    var receivedError: Error?
    
    func didUpdate(_ location: CLLocation?) {
        didUpdateCalled = true
        receivedLocation = location
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
        receivedError = error
    }
}
