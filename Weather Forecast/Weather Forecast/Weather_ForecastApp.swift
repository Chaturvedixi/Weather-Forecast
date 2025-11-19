//
//  Weather_ForecastApp.swift
//  Weather Forecast
//
//  Created by Anubhav Chaturvedi on 18/11/25.
//

import SwiftUI

@main
struct Weather_ForecastApp: App {
    
    @State var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(weatherViewModel)
        }
    }
}
