//
//  SearchInteractorTests.swift
//  WeatherAppTests
//
//  Created by Dima Shelkov on 14/09/2023.
//

import XCTest
@testable import WeatherApp

final class SearchInteractorTests: XCTestCase {
    
    var interactor: SearchInteractor!
    var mockNetworkService: MockSearchNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockSearchNetworkService()
        interactor = SearchInteractor(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testSearchWithSuccess() {
        let expectedCities = [
            City(name: "New York", lat: 40.7128, lon: -74.0060, country: nil, state: nil),
            City(name: "Los Angeles", lat: 34.0522, lon: -118.2437, country: nil, state: nil)]
        
        mockNetworkService.mockSearchResult = .success(expectedCities)
        
        let expectation = XCTestExpectation(description: "Search completion")
        
        interactor.search("New York") { result in
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities, expectedCities)
            case .failure:
                XCTFail("Expected success result")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchWithFailure() {
        mockNetworkService.mockSearchResult = .failure(WeatherAppError.defaultError)
        
        let expectation = XCTestExpectation(description: "Search completion")
        
        interactor.search("NonExistentCity") { result in
            switch result {
            case .success:
                XCTFail("Expected failure result")
            case .failure(let error):
                XCTAssertEqual(error as? WeatherAppError, WeatherAppError.defaultError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockSearchNetworkService: SearchNetworkServiceProtocol {
    var mockSearchResult: Result<[City], Error>?
    
    func search(by cityName: String, completion: @escaping (Result<[City], Error>) -> ()) {
        if let result = mockSearchResult {
            completion(result)
        }
    }
}

