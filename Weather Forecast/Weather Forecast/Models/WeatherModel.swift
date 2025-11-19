//
//  WeatherModel.swift
//  Weather Forecast
//
//  Created by Anubhav Chaturvedi on 18/11/25.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let location: Location
    let current: Current
}

// MARK: - Location
struct Location: Codable {
    let name: String
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double
    let condition: Condition
    let windKph: Double
    
    var tempString: String{
        return String(format: "%.1f", tempC )
    }
    
    var windKphString: String{
        return String(format: "%.1f", windKph )
    }
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let code: Int
    
    var conditionName: String {
        switch code {

        case 1000:
            return "sun.max"

        case 1003:
            return "cloud.sun"

        case 1006:
            return "cloud"

        case 1009:
            return "smoke"

        case 1030, 1135, 1147:
            return "cloud.fog"

        case 1063, 1180...1195:
            return "cloud.rain"

        case 1087:
            return "cloud.bolt"

        case 1066, 1069, 1072,
             1114, 1117,
             1210...1225,
             1237, 1249, 1252:
            return "cloud.snow"

        case 1273...1282:
            return "cloud.bolt.rain"

        default:
            return "cloud"
        }
    }
}




