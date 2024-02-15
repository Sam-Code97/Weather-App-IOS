//
//  ForecastModel.swift
//  weather-app
//
//  Created by Sam on 2024-02-04.
//

import Foundation
import Observation

@Observable
class DailyModel{
    let time: [String]
    let weather_code: [Float]
    let temperature_2m_max: [Float]
    let temperature_2m_min: [Float]
    let precipitation_sum: [Float]
    let wind_speed_10m_max: [Float]
    
    init(daily: Daily) {
        self.time = daily.time
        self.weather_code = daily.weather_code
        self.temperature_2m_max = daily.temperature_2m_max
        self.temperature_2m_min = daily.temperature_2m_min
        self.precipitation_sum = daily.precipitation_sum
        self.wind_speed_10m_max = daily.wind_speed_10m_max
    }
}
