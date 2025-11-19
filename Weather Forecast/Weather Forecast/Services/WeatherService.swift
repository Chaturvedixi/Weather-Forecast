//
//  WeatherService.swift
//  Weather Forecast
//
//  Created by Anubhav Chaturvedi on 18/11/25.
//

import Foundation
import CoreLocation

 struct WeatherService {
    
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
     func fetchWeather(userLocation: CLLocationCoordinate2D?,query: String?) async -> WeatherModel? {
        
         guard let apiKey = apiKey else {
                 print("API key not found")
                 return nil
             }
             
             var qParam = ""
             
             //  Use user location if available
             if let userLocation = userLocation {
                 qParam = "\(userLocation.latitude),\(userLocation.longitude)"
             }
             // If location denied or nil → use manual query
             else if let place = query, !place.isEmpty {
                 qParam = place
             }
             // Optional fallback (use a default location)
             else {
                 qParam = "New Delhi"
             }
             
             // Build URL
             guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(qParam)") else {
                 print("Invalid URL")
                 return nil
             }
            
            //2. Send request
            do {
              let (data, _) = try await URLSession.shared.data(from: url)
                
                //3.  Parse the JSON
                let decoder = JSONDecoder()
                let result = try decoder.decode(WeatherModel.self, from: data)
                return result
                
            }
            catch {
                print(error)
            }
            
        
        return nil
    }
}

