//
//  MainScreen.swift
//  weather-app
//
//  Created by Sam on 2024-02-01.
//

import SwiftUI
import WidgetKit

struct MainScreen: View {
    
    //
    @State private var model = FeedModel()
    @State private var isDay = true
    @State private var currentTime = Date()
    @State private var showingDetailPopup = false
    @State private var location_icon_is_tapped = false
    var body: some View {
        VStack{//////
            HStack{
                Image(systemName: location_icon_is_tapped ? "location.fill" : "location")
                    .imageScale(.large)
                    .scaleEffect(location_icon_is_tapped ? 1.5 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: location_icon_is_tapped)
                    .onTapGesture {
                        location_icon_is_tapped = true
                        model.locationService.requestLocation()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // ChatGPT
                            location_icon_is_tapped = false
                        }
                    }
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            
            
            VStack {

                if let location = model.locationService.address {
                    Text("\((location.locality)!)").task {
                        try? await model.loadData(latitude: location.location?.coordinate.latitude, longitude: location.location?.coordinate.longitude)
                    }
                    .font(.system(size: 25, design: .monospaced))
                } else {
                    Text("Stockholm").task {
                        try? await model.loadData(latitude: 59.329323, longitude: 18.068581)
                    }
                    .font(.system(size: 25, design: .monospaced))
                }
                Text(currentTime, style: .time)
                    .font(.system(size: 25, design: .monospaced))
                    .onAppear { // ChatGPT
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                            self.currentTime = Date()
                        }
                    }
                        
                if let current = model.current {
                    let weather = weatherDescription(forWeatherCode: Int(current.weather_code))
                    let weatherIcon = weatherIconString(forWeatherCode: Int(current.weather_code), isDay: isDay)
                    HStack{
                        Image(weatherIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 170, height: nil)
                            .padding()
                        VStack{
                            Text("\(Int(floor(current.temperature_2m)))°")
                                .font(.system(size: 60, weight: .light, design: .rounded))
                                .padding(.horizontal)
                            Text(weather)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                        }
                    }
                    .onAppear(perform: {
                        isDay = Bool(truncating: Int(current.is_day) as NSNumber)
                        
                    })
                    
                    HStack{
                        VStack(alignment: .leading){
                            if let daily = model.daily{
                                Text("Max: \(Int(daily.temperature_2m_max[0]))°").padding(.horizontal)
                                    .font(.system(size: 18, weight: .light, design: .rounded))
                            }
                            Text("Humidity:").padding(.horizontal)
                            Text("Feels like:").padding(.horizontal)
                            Text("Wind speed:").padding(.horizontal)
                        }
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        VStack(alignment: .leading){
                            if let daily = model.daily{
                                Text("Min: \(Int(daily.temperature_2m_min[0]))°")
                                    .font(.system(size: 18, weight: .light, design: .rounded))
                            }
                            Text("\(current.relative_humidity_2m)%")
                            Text("\(Int(floor(current.apparent_temperature)))°")
                            Text("\(Int(floor(current.wind_speed_10m))) km/h")
                        }
                        .font(.system(size: 18, weight: .light, design: .rounded))
                    }
                    .padding()
                    
                }
                    
        
                if let daily = model.daily {
                    Spacer()
                    VStack{
                        HStack{
                            ForEach(1..<5){ day in
                                let dateString = daily.time[day]
                                let date = date(from: dateString)
                                let weekday = date.map { weekdayName(from: $0) } ?? "Invalid date"
                                Spacer()
                                Text("\(weekday)").frame(alignment: .top).padding(.horizontal)
                                Spacer()
                            }
                        }
                        HStack(alignment: .center){
                            ForEach(1..<5){ day in
                                let weatherIcon = weatherIconString(forWeatherCode: Int(daily.weather_code[day]), isDay: isDay)
                                Spacer()
                                Image("\(weatherIcon)")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        HStack{
                            ForEach(1..<5){ day in
                                let medTemp = Int((daily.temperature_2m_max[day] + daily.temperature_2m_min[day])/2)
                                Spacer()
                                Text("\(medTemp)°")
                                    .frame(alignment: .top)
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                    }
                    
                    .background(
                        Image(isDay ? "forecast.small.day" : "forecast.small.night")
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            
                    )
                    .onTapGesture{
                        showingDetailPopup = true
                    }
                    .popover(isPresented: $showingDetailPopup, content: {
                        ZStack {
                            Image(isDay ? "forecast.big.day" : "forecast.big.night")
                                .resizable()
                                //.scaledToFit()
                                .lineLimit(nil)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            VStack{
                                ForEach(0..<7){ day in
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        let dateString = daily.time[day]
                                        let date = date(from: dateString)
                                        let weekday = date.map { weekdayName(from: $0) } ?? "Invalid date"
                                        let weatherIcon = weatherIconString(forWeatherCode: Int(daily.weather_code[day]), isDay: isDay)
                                        let minTemp = Int(floor(daily.temperature_2m_min[day]))
                                        let maxTemp = Int(floor(daily.temperature_2m_max[day]))
                                        let windSpeed = Int(daily.wind_speed_10m_max[day])
                                        if (day == 0) {
                                            Text("Today")
                                        }
                                        else{
                                            Text("\(weekday)")
                                        }
                                        Spacer()
                                        Image("\(weatherIcon)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 90, height: nil)
                                        Spacer()
                                        Text("\(minTemp)° / \(maxTemp)°")
                                        Spacer()
                                        Text("\(windSpeed) km/h")
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .onTapGesture {
                            showingDetailPopup = false
                        }
                    })
                }
                
                Spacer()
                
            }
            .padding()
            .onAppear {
                model.locationService.requestLocation()
            }
        }
        .background(
            Image(
                isDay ? "background.day" : "background.night")
                .frame(width: .infinity, height: .infinity
            )
        )
        .preferredColorScheme(isDay ? .light : .dark)
    }
}

#Preview {
    MainScreen()
}
