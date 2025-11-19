# Weather-Forecast
Simple Weather Forecast iOS app using SwiftUI and WeatherAPI

An iOS app that fetches and displays current weather data using the [WeatherAPI](https://www.weatherapi.com/) based on:

- The user's **current location** (when location permission is allowed), or  
- A **manually entered city name** (when location permission is denied or the user prefers manual search).

---

## Features

- Request **location access** and fetch weather for the current location.
- If location permission is **denied**, show an **alert** guiding the user to enter a city name manually.
- Allow users to **search weather by city name** at any time.
- Store the last **manually entered location** and reuse it when the user taps **Refresh** (if location is denied).
- Display:
  - Temperature (°C)
  - Weather condition text
  - Weather icon (using SF Symbols mapped from WeatherAPI condition codes)
  - Wind speed (km/h)
  - Location name
- **Refresh button** to manually update weather data.

---

## Architecture

The app follows a simple **MVVM (Model–View–ViewModel)** architecture.

### Models (`WeatherModel.swift`)

- `WeatherModel` – root model containing:
  - `location: Location`
  - `current: Current`
- `Location` – currently stores:
  - `name` (city/location name)
- `Current` – holds:
  - `tempC` (current temperature in °C)
  - `condition: Condition`
  - `windKph` (wind speed in km/h)
  - Computed properties:
    - `tempString`
    - `windKphString`
- `Condition` – stores:
  - `text` (condition description)
  - `code` (WeatherAPI condition code)
  - `conditionName` – maps WeatherAPI condition codes to **SF Symbols** (e.g. `sun.max`, `cloud.rain`, `cloud.bolt.rain`).

### Service (`WeatherService.swift`)

- Responsible for making **network requests** to WeatherAPI.
- Uses:
  ```swift
  https://api.weatherapi.com/v1/current.json?key=API_KEY&q=QUERY
QUERY is either:

"latitude,longitude" (e.g., "26.85,80.917") when using GPS

A city name (e.g., "Lucknow") when using manual input.

Loads the API key securely from Info.plist using:

swift
Copy code
let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
ViewModel (WeatherViewModel.swift)
Annotated with @Observable to work with SwiftUI’s new data model.

Responsibilities:

Requesting and handling location permissions (CLLocationManagerDelegate).

Coordinating between location, manual input, and WeatherService.

Exposing data and state to the View:

weather: WeatherModel?

searchText: String

infoMessage: String?

showAlert: Bool

Managing:

manualLocation – last manually searched location (used when permission denied).

currentUserLocation – GPS coordinates.

Public methods used by the View:

getUserLocation() – called on app launch.

refreshWeather() – called when user taps the Refresh button.

searchWeather() – called when user taps the Search button.

Private helpers:

getWeatherUsingManualLocation()

getWeatherUsingCurrentLocation(_ coordinate: CLLocationCoordinate2D)

Behaviour Logic
On launch / onAppear → getUserLocation() → internally calls refreshWeather().

Refresh button (refreshWeather()):

If authorized → uses GPS, requests location, fetches weather for current coordinates.

If denied/restricted:

If manualLocation exists → fetches weather using that city.

If no manual location → shows an alert with a clear message:

Ask the user to type a city name and tap the search icon.

Search button (searchWeather()):

Uses the text from searchText.

Stores it in manualLocation.

Fetches weather for that city.

Clears any previous alert.

View (ContentView.swift)
Injected with WeatherViewModel using:

swift
Copy code
@Environment(WeatherViewModel.self) var weatherViewModel
UI elements:

Top HStack containing:

Refresh button – calls weatherViewModel.refreshWeather().

TextField for manual location entry (binds to searchText).

Search button – calls weatherViewModel.searchWeather().

A ScrollView showing:

Large weather icon (SF Symbol).

Current temperature.

Weather condition text.

Location name.

Wind speed.

.alert attached to the view to show:

Title: "Location Access"

Message: infoMessage from WeatherViewModel.

Requirements
Xcode: 15.x or later

iOS: iOS 17+ (SwiftUI + @Observable)

Swift: Swift 5.9+

A WeatherAPI account and API key:

Sign up at weatherapi.com

Setup
Clone the repository

bash
Copy code
git clone https://github.com/<your-username>/Weather-Forecast.git
cd Weather-Forecast
Open the project

Open Weather Forecast.xcodeproj or .xcworkspace in Xcode.

Add your WeatherAPI key

Open Info.plist.

Add a new key: API_KEY of type String.

Set its value to your WeatherAPI key.

Build & Run

Select a simulator or physical device.

Press Cmd + R to run the app.

Usage
On first launch, the app asks for location permission.

If allowed → it fetches weather for your current location.

If permission is denied:

Tap Refresh → an alert will guide you to manually enter a city.

Type a city name in the text field and tap the Search icon.

The app will remember this city and use it again when you tap Refresh.

You can manually search any time, even if location permission is allowed.

Assumptions & Limitations
Only current weather is displayed (no hourly/weekly forecast).

Requires an active internet connection.

API key is expected to be present in Info.plist under the key API_KEY.

Basic error handling is implemented via console logs and user alerts; no advanced retry logic yet.

Possible Improvements
Show a loading indicator while fetching data.

Better error UI (e.g., "City not found", network error states).

Add hourly / 7-day forecast view.

Add unit tests for:

WeatherService

WeatherViewModel logic

Localize strings for multiple languages.

