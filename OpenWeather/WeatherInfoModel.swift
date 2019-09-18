//
//  WeatherInfoModel.swift
//  OpenWeather
//
//  Created by Rambo on 9/18/19.
//  Copyright © 2019 Rambo. All rights reserved.
//

import Foundation


struct WeatherInfoModel : Codable {
    let main: MainInfo
    let name: String?
    let clouds: CloudInfo?
    let rain: RainInfo?
    let weather: [DescriptionInfo]?
    let wind: WindInfo?
    let sys: SystemInfo?
}

struct CloudInfo: Codable {
    let all: Float?
}

struct MainInfo: Codable {
    let temp: Float?
    let pressure: Float?
    let humidity: Float?
    let temp_max: Float?
    let temp_min: Float?
}

struct RainInfo: Codable {

}

struct DescriptionInfo: Codable {
    let description: String?
    let main: String?
}

struct WindInfo: Codable {
    let speed: Double?
    let deg: Float?
}

struct SystemInfo: Codable {
    let sunrise: Double?
    let sunset: Double?
}
