//
//  UnitFormatter.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 12/09/2023.
//

import Foundation

final class UnitFormatter {
    func convert(temperature: Double,
                 to unit: UnitTemperature) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.unitStyle = .medium
        
        let source = Measurement(value: temperature, unit: UnitTemperature.kelvin)
        let result = measurementFormatter.string(from: source.converted(to: unit))
        return result
    }
}
