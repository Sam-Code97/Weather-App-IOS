//
//  CurrentDayWidget.swift
//  CurrentDayWidget
//
//  Created by Sam Aliwa on 2024-02-10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let defaults = UserDefaults(suiteName: "group.com.samaliwa.weather")
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), temp: 0.0, city: "Locating..", weather_code: 50, is_day: false)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let temp = defaults?.double(forKey: "temp") ?? 0.0
        let city = defaults?.string(forKey: "city") ?? "Unknown"
        let weather_code = defaults?.integer(forKey: "weather_code") ?? 0
        let is_day = defaults?.bool(forKey: "is_day") ?? false
        let entry = SimpleEntry(date: Date(), temp: temp, city: city, weather_code: weather_code, is_day: is_day)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let temp = defaults?.double(forKey: "temp") ?? 0.0
        let city = defaults?.string(forKey: "city") ?? "Unknown"
        let weather_code = defaults?.integer(forKey: "weather_code") ?? 0
        let is_day = defaults?.bool(forKey: "is_day") ?? false
        let entry = SimpleEntry(date: Date(), temp: temp, city: city, weather_code: weather_code, is_day: is_day)
        let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let temp: Double
    let city: String
    let weather_code: Int
    let is_day: Bool
}

struct CurrentDayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {

        VStack {
            Text("\(entry.date.formatted(Date.FormatStyle().weekday(.wide)))")
                .font(.caption)
            Text(entry.city)
                .font(.headline)
            
            HStack{
                Image(weatherIconString(forWeatherCode: entry.weather_code, isDay: entry.is_day))
                    .resizable()
                    .scaledToFit()
                    
                VStack{
                    Text("\(Int(entry.temp))°")
                        .font(.title3)
                    Text("\(weatherDescription(forWeatherCode: Int(entry.temp)))")
                        .font(.caption)
                }   
            }
        }
        .foregroundStyle(entry.is_day ? .black : .white)
        .background(Image(entry.is_day ? "background.day" : "background.night") )
    }
}
//
struct CurrentDayWidget: Widget {
    let kind: String = "CurrentDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CurrentDayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CurrentDayWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Today's Weather")
        .description("Shows the current weather of your location")
    }
}

#Preview(as: .systemSmall) {
    CurrentDayWidget()
} timeline: {
    SimpleEntry(date: Date(), temp: 5.0, city: "Stockholm", weather_code: 50, is_day: false)
    SimpleEntry(date: Date(), temp: 9.0, city: "Västerås", weather_code: 50, is_day: true)
}
