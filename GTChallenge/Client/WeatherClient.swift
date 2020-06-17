//  Created by Micah Napier
//

import Foundation
import MapKit

struct WeatherClient {
  func fetchCurrentWeather(components: URLComponents, result: @escaping (Result<APIResponse, Error>) -> Void) {
    guard let url = components.url else {
      let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        result(.failure(error))
      }
      if let data = data {
        let decoder = JSONDecoder()
        do {
          let data = try decoder.decode(APIResponse.self, from: data)
          result(.success(data))
        } catch (let error) {
          result(.failure(error))
        }
      }
    }.resume()
  }
}

extension WeatherClient {
  enum APICall {
    case city(String)
    case zipCode(String)
    case location(CLLocationCoordinate2D)
  }
  
  struct WeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5/weather"
    static let key = "70a3466af8db6bd67fd264eb8b010130"
  }
  
  func currentWeatherComponents(for apiCall: APICall) -> URLComponents {
    var components = URLComponents()
    components.scheme = WeatherAPI.scheme
    components.host = WeatherAPI.host
    components.path = WeatherAPI.path
    
    switch apiCall {
    case .city(let city):
      components.queryItems = queryItems(for: .city(city))
    case .zipCode(let zipCode):
      components.queryItems = queryItems(for: .zipCode(zipCode))
    case .location(let location):
      components.queryItems = queryItems(for: .location(location))
    }
    
    return components
  }
  
  private func queryItems(for apiCall: APICall) -> [URLQueryItem] {
   var queryItems = [
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "imperial"),
      URLQueryItem(name: "APPID", value: WeatherAPI.key)
    ]
    
    switch apiCall {
    case .city(let city):
      queryItems.append(URLQueryItem(name: "q", value: city))
    case .zipCode(let zipCode):
      queryItems.append(URLQueryItem(name: "zip", value: zipCode))
    case .location(let location):
      queryItems.append(URLQueryItem(name: "lat", value: String(location.latitude)))
      queryItems.append(URLQueryItem(name: "lon", value: String(location.longitude)))
    }
    return queryItems
  }
}

enum WeatherAPIError: Error {
  case parsing(description: String)
  case network(description: String)
}
