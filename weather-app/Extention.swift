//
//  Extention.swift
//  weather-app
//
//  Created by Sam on 2024-02-09.
//

import Foundation

func date(from dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // Customize this based on your format
    formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
    return formatter.date(from: dateString)
}
/*func formattedCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: currentDate)
}*/

func weekdayName(from date: Date) -> String {
    date.formatted(Date.FormatStyle().weekday())
}

func weatherDescription(forWeatherCode code: Int) -> String {
    switch code {
    case 0:
        return "Clear sky"
    case 1...2:
        return "Mainly clear"
    case 3...44:
        return "Cloudy"
    case 45...50:
        return "Fog"
    case 51...55:
        return "Drizzle"
    case 56...59:
        return "Freezing Drizzle"
    case 60...65:
        return "Rain"
    case 66...69:
        return "Freezing Rain"
    case 70...75:
        return "Snow fall"
    case 76...79:
        return "Snow grains"
    case 80...83:
        return "Rain showers"
    case 84...86:
        return "Snow showers"
    case 95:
        return "Thunderstorm"
    case 96...99:
        return "Thunderstorm with hail"
    default:
        return "Unknown weather condition"
    }
}

func weatherIconString(forWeatherCode code: Int, isDay: Bool) -> String {
    switch code {
    case 0:
        return isDay ? "w.clearsky.day" : "w.clearsky.night"
    case 1...2:
        return isDay ? "w.mainlyclear.day" : "w.mainlyclear.night"
    case 3...44:
        return "w.Cloudy"
    case 45...50:
        return "w.fog"
    case 51...55:
        return "w.drizzle"
    case 56...59:
        return "w.FreezingDrizzle"
    case 60...65:
        return "w.rain"
    case 66...69:
        return "w.FreezingRain"
    case 70...75:
        return "w.SnowFall"
    case 76...79:
        return "w.SnowGrains"
    case 80...83:
        return "w.RainShowers"
    case 84...86:
        return "w.SnowShowers"
    case 95:
        return "w.Thunderstorm"
    case 96...99:
        return "w.ThunderstormWithHail"
    default:
        return "Unknown weather condition"
    }
    

}
