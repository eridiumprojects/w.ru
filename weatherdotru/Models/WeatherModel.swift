//
//  WeatherModel.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

struct WeatherResponse: Codable {
    var weather: [Weather]
    var main: Main
    var visibility: Int
    var wind: Wind
    var sys: Sys
    var name: String

    struct Weather: Codable {
        var main: String
    }

    struct Main: Codable {
        var temp: Double
        var feelsLike: Double
        var tempMin: Double
        var tempMax: Double
        var pressure: Int
        var humidity: Int
        
        // Strings
        var tempString: String {
            String(format: "%.0f \(TemperatureUnitManager.shared.selectedUnit.rawValue)", temp)
        }
        var tempMinString: String {
            String(format: "%.0f \(TemperatureUnitManager.shared.selectedUnit.rawValue)", tempMin)
        }
        var tempMaxString: String {
            String(format: "%.0f \(TemperatureUnitManager.shared.selectedUnit.rawValue)", tempMax)
        }
        var feelsLikeString: String {
            String(format: "%.0f \(TemperatureUnitManager.shared.selectedUnit.rawValue)", feelsLike)
        }
        var humidityString: String {
            String("\(humidity)%")
        }
        var pressureString: String {
            String("\(pressure) Па")
        }
    }

    struct Wind: Codable {
        var speed: Double
        
        // Strings
        var windString: String {
            String("\(speed) м/с")
        }
    }

    struct Sys: Codable {
        var sunrise: Int
        var sunset: Int
    }
    
    var visibilityString: String {
        String("\(visibility) м")
    }
}

struct WeatherCollectionViewItem {
    let imageName: String?
    let title: String
    let value: String
}
