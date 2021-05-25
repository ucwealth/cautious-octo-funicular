//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Decagon on 28/04/2021.
//

import Foundation

struct WeatherResponse: Codable {
    let current: currentWeatherObject
    let daily: [dailyWeather]
}

struct currentWeatherObject : Codable {
    let dt: Int
    let temp: Double
    let weather: [weatherValues]
}
struct dailyWeather: Codable {
    let dt: Int
    let temp: tempObject
    let weather: [weatherValues]
}
struct tempObject: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
struct weatherValues: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
