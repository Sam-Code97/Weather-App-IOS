//
//  Model.swift
//  weather-app
//
//  Created by Sam on 2024-02-01.
//

import Foundation
import Observation
import CoreLocation
import WidgetKit

@Observable
class FeedModel {
    
    let locationService = LocationManager()
    var current: CurrentDayModel?
    var daily: DailyModel?
    
    
    func loadData(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) async throws {
        
        let lat = latitude ?? 0.0
        let lon = longitude ?? 0.0
        let url = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,wind_speed_10m_max&timezone=auto"
        
        guard let url = URL(string: url ) else {
            return
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        do{
            let feed = try JSONDecoder().decode(FeedData.self, from: data)
            current = CurrentDayModel(current: feed.current)
            daily = DailyModel(daily: feed.daily)
            
            let userDefaults = UserDefaults(suiteName: "group.com.samaliwa.weather")
            userDefaults?.set(locationService.address?.locality, forKey: "city")
            userDefaults?.set((feed.current.temperature_2m), forKey: "temp")
            userDefaults?.set((feed.current.weather_code), forKey: "weather_code")
            userDefaults?.set(Bool(truncating: Int(feed.current.is_day) as NSNumber), forKey: "is_day")
            WidgetCenter.shared.reloadAllTimelines()
            //
        } catch{
            print(error)
        }
    }
    
}
