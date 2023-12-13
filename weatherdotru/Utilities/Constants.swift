//
//  Constants.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import UIKit

struct API {
    static let apiKey = "c8ae40cd01d9a41fd6196e100bb1d771"
    static let baseURL = "https://api.openweathermap.org/"
}

enum AppStrings {
    static let locationDenied =             "Доступ к данной геолокации запрещен"
    static let enableAccessInSetting =      "Пожалуйста, поделитесь своей геопозицией в настройках с данным приложением"
    static let cancel =                     "Отменить"
    static let settings =                   "Настройки"
    static let alreadyCurrentData =         "Геопозиция уже включена"
    static let feelslike =                  "Ощущается"
    static let wind =                       "Ветер"
    static let humidity =                   "Влажность"
    static let visibility =                 "Видимость"
    static let pressure =                   "Давление"
    static let error =                      "Ошибка!"
    static let sunset =                     "Закат"
    static let sunrise =                    "Рассвет"
    static let metric =                     "metric"
    static let imperial =                   "imperial"
    static let ok =                         "OK"
}

enum appImages {
    static let thermometer =                "thermometer.medium"
    static let wind =                       "wind.circle.fill"
    static let humidity =                   "humidity"
    static let eye =                        "eye.circle.fill"
    static let pressure =                   "rectangle.compress.vertical"
    static let sunset =                     "sunset.fill"
    static let sunrise =                    "sunrise.fill"
}

enum appColors {
    static let accentColor =                UIColor(named: "AccentColor")
}
