//  Created by Micah Napier

import Foundation

struct MainInfo: Decodable {
  let humidity: Int
  let temperature: Double
  let minTemperature: Double
  let maxTemperature: Double
  
  enum CodingKeys: String, CodingKey {
    case humidity
    case temperature = "temp"
    case minTemperature = "temp_min"
    case maxTemperature = "temp_max"
  }
}

struct WeatherInfo: Decodable {
  let main: String
}

struct WindInfo: Decodable {
  let speed: Double
}

struct APIResponse: Decodable {
  let main: MainInfo
  let name: String
  let wind: WindInfo?
  let weather: [WeatherInfo]
}
