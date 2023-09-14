//
//  SearchPresenterTests.swift
//  WeatherAppTests
//
//  Created by Dima Shelkov on 14/09/2023.
//

import XCTest
@testable import WeatherApp

class SearchPresenterTests: XCTestCase {
    var presenter: SearchPresenter!
    var mockInteractor: MockSearchInteractor!
    var mockRouter: MockSearchRouter!
    var mockView: MockSearchViewController!
    var mockDelegate: MockSearchPresenterDelegate!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockSearchInteractor()
        mockRouter = MockSearchRouter()
        mockView = MockSearchViewController()
        mockDelegate = MockSearchPresenterDelegate()
        
        presenter = SearchPresenter(
            interactor: mockInteractor,
            router: mockRouter
        )
        
        presenter.view = mockView
        presenter.delegate = mockDelegate
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testDidSelect_ShouldDelegateToPresenterDelegate() {
        let selectedCity = City(name: "New York", lat: 40.7128, lon: -74.0060, country: nil, state: nil)
        let mockViewController = UIViewController()
        
        presenter.didSelect(selectedCity, from: mockViewController)
        
        XCTAssertEqual(mockDelegate.didSelectCity, selectedCity)
        XCTAssertTrue(mockRouter.backCalled)
    }
    
    func testSearch_WithSuccessResult_ShouldUpdateView() {
        let expectedCities = [
            City(name: "New York", lat: 40.7128, lon: -74.0060, country: nil, state: nil),
            City(name: "Los Angeles", lat: 34.0522, lon: -118.2437, country: nil, state: nil)
        ]
        
        mockInteractor.mockSearchResult = .success(expectedCities)
        
        presenter.search(for: "New York")
        
        XCTAssertTrue(mockView.updateActivityCalled)
        XCTAssertEqual(mockView.updatedCities, expectedCities)
        XCTAssertFalse(mockView.showAlertCalled)
    }
    
    func testSearch_WithNoResults_ShouldShowAlert() {
        mockInteractor.mockSearchResult = .success([])
        
        presenter.search(for: "NonExistentCity")
        
        XCTAssertTrue(mockView.updateActivityCalled)
        XCTAssertTrue(mockView.showAlertCalled)
        XCTAssertEqual(mockView.showAlertError as? WeatherAppError, WeatherAppError.nothingFound)
    }
    
    func testSearch_WithFailureResult_ShouldShowErrorAlert() {
        mockInteractor.mockSearchResult = .failure(WeatherAppError.defaultError)
        
        presenter.search(for: "InvalidCity")
        
        XCTAssertTrue(mockView.updateActivityCalled)
        XCTAssertTrue(mockView.showAlertCalled)
        XCTAssertEqual(mockView.showAlertError as? WeatherAppError, WeatherAppError.defaultError)
    }
}

class MockSearchInteractor: SearchInteractorProtocol {
    var mockSearchResult: Result<[City], Error>?
    
    func search(_ cityName: String, completion: @escaping (Result<[City], Error>) -> ()) {
        if let result = mockSearchResult {
            completion(result)
        }
    }
}

class MockSearchRouter: SearchRouterProtocol {
    var backCalled = false
    
    func back(from navController: UINavigationController?) {
        backCalled = true
    }
}

class MockSearchViewController: SearchViewControllerProtocol {
    var updateActivityCalled = false
    var updatedCities: [City]?
    var showAlertCalled = false
    var showAlertError: Error?
    
    func updateActivity(shouldAnimate: Bool) {
        updateActivityCalled = true
    }
    
    func updateWith(_ cities: [City]) {
        updatedCities = cities
    }
    
    func show(error: Error) {
        showAlertCalled = true
        showAlertError = error
    }
}

class MockSearchPresenterDelegate: SearchPresenterDelegate {
    var didSelectCity: City?
    
    func didSelect(_ city: City) {
        didSelectCity = city
    }
}
