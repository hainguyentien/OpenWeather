//
//  LocationModel.swift
//  OpenWeather
//
//  Created by Rambo on 9/18/19.
//  Copyright © 2019 Rambo. All rights reserved.
//

import Foundation

struct CityModel : Codable {
    let id: Int
    let name: String
    let country: String
    let coord: LatLng
}

struct LatLng : Codable {
    let lat: Double
    let lon: Double
}
