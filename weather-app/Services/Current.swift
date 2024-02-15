//
//  CurrentDayData.swift
//  weather-app
//
//  Created by Sam on 2024-02-04.
//

import Foundation

struct Current: Decodable {
    let temperature_2m: Float
    let relative_humidity_2m: Int
    let apparent_temperature: Float
    let is_day: Float
    let weather_code: Float
    let wind_speed_10m: Float
}
