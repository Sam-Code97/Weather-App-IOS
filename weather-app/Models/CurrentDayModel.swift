//
//  CurrentDayModel.swift
//  weather-app
//
//  Created by Sam on 2024-02-04.
//

import Foundation
import Observation

@Observable
class CurrentDayModel {
    let temperature_2m: Float
    let relative_humidity_2m: Int
    let apparent_temperature: Float
    let is_day: Float
    let weather_code: Float
    let wind_speed_10m: Float
    
    init(current: Current) {
        self.temperature_2m = current.temperature_2m
        self.relative_humidity_2m = current.relative_humidity_2m
        self.apparent_temperature = current.apparent_temperature
        self.is_day = current.is_day
        self.weather_code = current.weather_code
        self.wind_speed_10m = current.wind_speed_10m
    }
}
