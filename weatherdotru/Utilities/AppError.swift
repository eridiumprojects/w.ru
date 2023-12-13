//
//  AppError.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

enum AppError: String, Error {
    case invalidURL = "URL не найден"
    case invalidResponse = "Невалидный ответ с сервера"
}
