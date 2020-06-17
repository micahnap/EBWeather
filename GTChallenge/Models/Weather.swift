//  Created by Micah Napier
//

import Foundation

protocol WeatherInterface {
  var name: String { get }
  var description: String { get }
  var temperature: String { get }
  var humidity: String { get }
  var maxTemperature: String { get }
  var minTemperature: String { get }
  var windSpeed: String { get }
}

struct Weather: WeatherInterface, Equatable, Codable {
  var name: String = ""
  var temperature: String = ""
  var humidity: String = ""
  var maxTemperature: String = ""
  var minTemperature: String = ""
  var description: String = ""
  var windSpeed: String = ""
}

extension Weather {
  init(data: APIResponse) {
    name = data.name
    temperature = String(data.main.temperature)
    humidity = String(data.main.humidity)
    maxTemperature = String(data.main.maxTemperature)
    minTemperature = String(data.main.minTemperature)
    description = data.weather.first?.main ?? ""
    
    if let wind = data.wind {
      windSpeed = String(wind.speed)
    }
  }
}

extension Weather: RecentSearchCellInterface {
  var locationName: String { return name }
  var weatherDescription: String { return description }
}
