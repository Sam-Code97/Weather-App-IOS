//
//  Data.swift
//  weather-app
//
//  Created by Sam on 2024-02-04.
//

import Foundation

struct FeedData: Decodable {
    let current: Current
    let daily: Daily
}
