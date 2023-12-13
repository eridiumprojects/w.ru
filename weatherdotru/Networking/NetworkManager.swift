//
//  NetworkManager.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import Foundation

final class NetworkManager {
    static  let shared          = NetworkManager()
    private let decoder         = JSONDecoder()

    private init() {
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
    }
    
    func getWeatherData(lat: Double, long: Double) async throws -> WeatherResponse {
        
        let request = try await makeRequest(with: URL(string: API.baseURL + "data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(API.apiKey)&units=\(TemperatureUnitManager.shared.unitStringForAPI)"))

        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
            throw AppError.invalidResponse
        }

        return try decoder.decode(WeatherResponse.self, from: data)
    }
    
    func getLocation(location: String) async throws -> [LocationResponse] {
                
        let request = try await makeRequest(with: URL(string: API.baseURL + "geo/1.0/direct?q=\(location)&limit=5&appid=\(API.apiKey)"))

        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
            throw AppError.invalidResponse
        }

        return try decoder.decode([LocationResponse].self, from: data)
    }
    
    // Create API request function
    func makeRequest(with url: URL?, type: HTTPMethod = .GET) async throws -> URLRequest {

        guard let apiURL = url else {
            throw AppError.invalidURL
        }

        var request = URLRequest(url: apiURL)
        request.httpMethod = type.rawValue
        return request
    }
    
}
