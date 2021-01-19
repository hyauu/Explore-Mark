//
//  CurrentWeatherData.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 18/1/2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let base: String
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    let coord: OWCoord
    let weather: [OWWeather]
}
