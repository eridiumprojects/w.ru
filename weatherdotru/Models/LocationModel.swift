//
//  LocationModel.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

struct LocationResponse: Codable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String?
    var state: String?
    
    var countryString: String {
        country != nil ? String(", \(country!)") : ""
    }
    
    var stateString: String {
        state != nil ? String(", \(state!)") : ""
    }
}
