import Combine
import Foundation
import MapKit

protocol CurrentWeatherFetching {
  func fetchCurrentWeather(forCity city: String, completion: @escaping (Result<APIResponse, Error>) -> Void)
  func fetchCurrentWeather(forZipCode zipCode: String, completion: @escaping (Result<APIResponse, Error>) -> Void)
  func fetchCurrentWeather(forLocation location: CLLocationCoordinate2D, completion: @escaping (Result<APIResponse, Error>) -> Void)
}

struct WeatherService {
  init(client: WeatherClient) {
    self.client = client
  }
  private let client: WeatherClient
}

extension WeatherService: CurrentWeatherFetching {
  func fetchCurrentWeather(forLocation location: CLLocationCoordinate2D, completion: @escaping (Result<APIResponse, Error>) -> Void) {
    let components = client.currentWeatherComponents(for: .location(location))
    return client.fetchCurrentWeather(components: components) { (result) in
      self.handleResult(result, completion: completion)
    }
  }
  
  func fetchCurrentWeather(forCity city: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
    let components = client.currentWeatherComponents(for: .city(city))
    return client.fetchCurrentWeather(components: components) { (result) in
      self.handleResult(result, completion: completion)
    }
  }
  
  func fetchCurrentWeather(forZipCode zipCode: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
    let components = client.currentWeatherComponents(for: .zipCode(zipCode))
    return client.fetchCurrentWeather(components: components) { (result) in
      self.handleResult(result, completion: completion)
    }
  }
  
  private func handleResult(_ result: Result<APIResponse, Error>, completion: @escaping (Result<APIResponse, Error>) -> Void) {
    DispatchQueue.main.async {
      switch result {
      case .success(let result):
        completion(.success(result))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}






