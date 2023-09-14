//
//  UnitFormatterTests.swift
//  WeatherAppTests
//
//  Created by Dima Shelkov on 13/09/2023.
//

import XCTest
@testable import WeatherApp

final class UnitFormatterTests: XCTestCase {
    var unitFormatter: UnitFormatter!
    
    override func setUp() {
        super.setUp()
        unitFormatter = UnitFormatter()
    }
    
    func testConvertToCelsius() {
        let temperatureInKelvin: Double = 273.15
        let expectedResult = "0°C"
        
        let result = unitFormatter.convert(temperature: temperatureInKelvin, to: .celsius)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testConvertToFahrenheit() {
        let temperatureInKelvin: Double = 273.15
        let expectedResult = "32°F"
        
        let result = unitFormatter.convert(temperature: temperatureInKelvin, to: .fahrenheit)
        
        XCTAssertEqual(result, expectedResult)
    }
}
