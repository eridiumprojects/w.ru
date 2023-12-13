//
//  TemperatureUnitManager.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import Foundation

enum TemperatureUnit: String {
    case celsius = "°C"
    case fahrenheit = "°F"
}

class TemperatureUnitManager {
    static let shared = TemperatureUnitManager()

    private let temperatureUnitKey = "TemperatureUnit"
    private let userDefaults = UserDefaults.standard

    private init() {}

    var selectedUnit: TemperatureUnit {
        get { // Get temperature unit from userDefaults
            if let savedUnit = userDefaults.string(forKey: temperatureUnitKey),
               let unit = TemperatureUnit(rawValue: savedUnit) {
                return unit
            }
            return .celsius // Default to Celsius if not set
        }
        set { // Set temperature unit into userDefaults
            userDefaults.set(newValue.rawValue, forKey: temperatureUnitKey)
        }
    }

    func toggleUnit() {
        selectedUnit = (selectedUnit == .celsius) ? .fahrenheit : .celsius
    }
    
    var unitStringForAPI: String {
        return (selectedUnit == .celsius) ? AppStrings.metric : AppStrings.imperial // Get query parameters to pass in API call
    }
}

