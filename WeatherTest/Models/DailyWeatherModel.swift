//
//  DailyWeatherModel.swift
//  WeatherTest
//
//  Created by Vladimir on 13.12.2023.
//

import Foundation

// MARK: - Welcome
struct DailyWeatherWelcome: Codable {
    let cod: String
    let message, cnt: Int
    let list: [DailyWeatherList]
    let city: DailyWeatherCity
}

// MARK: - City
struct DailyWeatherCity: Codable {
    let id: Int
    let name: String
    let coord: DailyWeatherCoord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct DailyWeatherCoord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct DailyWeatherList: Codable {
    let dt: Int
    let main: MainClass
    let weather: [DailyWeather]
    let clouds: DailyWeatherClouds
    let wind: DailyWind
    let visibility: Int
    let pop: Double
    let sys: DailySys
    let dtTxt: String
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct DailyWeatherClouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct DailySys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct DailyWeather: Codable {
    let id: Int
    let main: MainEnum
    let description, icon: String
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct DailyWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

let latLonApiFor3hours5days = "https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid=d50296f92bf04f36dc5167b96c5ddeef"
let latLonApiFor6hours = "https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&cnt=6&appid=d50296f92bf04f36dc5167b96c5ddeef"
let cityApiFor3Hours5Days = "api.openweathermap.org/data/2.5/forecast?q={cityName}&appid=d50296f92bf04f36dc5167b96c5ddeef"
