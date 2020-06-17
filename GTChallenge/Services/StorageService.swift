//  Created by Micah Napier
//

import Foundation
import CoreData

protocol WeatherStorage {
  func getWeatherInfomDisk() -> Weather?
  func saveWeatherInfoToDisk(_ weather: Weather) -> Bool
}

class StorageService {
  static let shared = StorageService()
}

extension StorageService: WeatherStorage {
  static let filename = "weather.json"

  func saveWeatherInfoToDisk(_ weather: Weather) -> Bool {
    let url = getDocumentsURL().appendingPathComponent(StorageService.filename)
      let encoder = JSONEncoder()
      do {
        let data = try encoder.encode(weather)
        try data.write(to: url, options: [])
        return true
      } catch {
        return false
      }
  }

  func getWeatherInfomDisk() -> Weather? {
      let url = getDocumentsURL().appendingPathComponent(StorageService.filename)
      let decoder = JSONDecoder()
      do {
          let data = try Data(contentsOf: url, options: [])
          let weather = try decoder.decode(Weather.self, from: data)
          return weather
      } catch {
        return nil
      }
  }
  
  private func getDocumentsURL() -> URL {
      if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
          return url
      } else {
          fatalError("Could not retrieve documents directory")
      }
  }
}
