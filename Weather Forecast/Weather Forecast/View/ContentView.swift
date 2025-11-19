//
//  ContentView.swift
//  Weather Forecast
//
//  Created by Anubhav Chaturvedi on 18/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(WeatherViewModel.self) var weatherViewModel
    
    var body: some View {
        
        @Bindable var weatherViewModel = weatherViewModel
        
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing:20) {
                
                HStack {
                    Button {
                        weatherViewModel.refreshWeather()
                    } label: {
                        Image(systemName: "arrow.clockwise.square.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.redclr)
                            .shadow(radius: 5)
                    }
                    
                    TextField("Enter location", text: $weatherViewModel.searchText)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10.0)
                        .shadow(radius: 5)
                    
                    Button {
                        weatherViewModel.searchWeather()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 8)
                
                
                
                ScrollView {
                    Image(systemName: weatherViewModel.weather?.current.condition.conditionName ?? "cloud.rain")
                        .font(.system(size: 200))
                    
                    VStack(spacing:0) {
                        Text("\(weatherViewModel.weather?.current.tempString ?? "0")°C")
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 100))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Spacer()
                            Text(weatherViewModel.weather?.current.condition.text ?? "Weather")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                        }
                        
                        VStack(spacing:105) {
                            HStack {
                                Spacer()
                                Text(weatherViewModel.weather?.location.name ?? "Location")
                                    .font(.system(size: 50))
                                    .fontWeight(.bold)
                            }
                            
                            Text("Wind Speed: \(weatherViewModel.weather?.current.windKphString ?? "0")km/h")
                                .font(.system(size: 30))
                                .fontWeight(.semibold)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding()
        }
        .onAppear {
            weatherViewModel.getUserLocation()
        }

        .alert(
            "Location Access",
            isPresented: $weatherViewModel.showAlert
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(weatherViewModel.infoMessage ?? "Location access is denied. Please enter your location manually.")
        }
    }
}

#Preview {
    ContentView()
        .environment(WeatherViewModel())
}

