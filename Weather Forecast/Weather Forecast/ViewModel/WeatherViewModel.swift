//
//  WeatherViewModel.swift
//  Weather Forecast
//
//  Created by Anubhav Chaturvedi on 19/11/25.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable
@MainActor
class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    
    var weather: WeatherModel?
    var searchText: String = ""
    
    var infoMessage: String?

    var showAlert: Bool = false
    
    private var service = WeatherService()
    private var locationManager = CLLocationManager()
    private var currentUserLocation: CLLocationCoordinate2D?
    private var manualLocation: String?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
    }
    
    func getUserLocation() {
        refreshWeather()
    }
    
    func refreshWeather() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            infoMessage = nil
            showAlert = false
            currentUserLocation = nil
            locationManager.requestLocation()
            
        case .denied, .restricted:
            if let manualLocation = manualLocation, !manualLocation.isEmpty {
                getWeatherUsingManualLocation()
            } else {
                infoMessage = "Location access is denied. Please type your city or area name above and tap the search icon. We'll remember it and use it when you tap refresh."
                showAlert = true
            }
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            break
        }
    }
    
    func searchWeather() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        manualLocation = trimmed
        infoMessage = nil
        showAlert = false
        getWeatherUsingManualLocation()
    }
    
    private func getWeatherUsingManualLocation() {
        guard let manualLocation = manualLocation, !manualLocation.isEmpty else { return }
        
        Task {
            let result = await service.fetchWeather(userLocation: nil, query: manualLocation)
            await MainActor.run {
                self.weather = result
            }
        }
    }
    
    private func getWeatherUsingCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        Task {
            let result = await service.fetchWeather(userLocation: coordinate, query: nil)
            await MainActor.run {
                self.weather = result
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            infoMessage = nil
            showAlert = false
            currentUserLocation = nil
            manager.requestLocation()
            
        case .denied, .restricted:
            currentUserLocation = nil
            infoMessage = "Location access is denied. Please type your city or area name above. We'll keep using it whenever you tap refresh."
            showAlert = true
            
        case .notDetermined:
            break
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard currentUserLocation == nil else {
            locationManager.stopUpdatingLocation()
            return
        }
        
        if let coordinate = locations.last?.coordinate {
            currentUserLocation = coordinate
            getWeatherUsingCurrentLocation(coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
}
