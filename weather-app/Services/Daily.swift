//
//  ForecastData.swift
//  weather-app
//
//  Created by Sam on 2024-02-04.
//

import Foundation

struct Daily:Decodable {
    let time: [String]
    let weather_code: [Float]
    let temperature_2m_max: [Float]
    let temperature_2m_min: [Float]
    let precipitation_sum: [Float]
    let wind_speed_10m_max: [Float]
}
