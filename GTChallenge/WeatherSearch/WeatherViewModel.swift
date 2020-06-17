import Foundation
import MapKit
import Combine

final class WeatherViewModel {
  init(weatherService: CurrentWeatherFetching, locationService: LocationFetching) {
    self.weatherService = weatherService
    self.locationService = locationService
    weather = recentWeatherSearchIfAvailable()
  }
  
  private let weatherService: CurrentWeatherFetching
  private let locationService: LocationFetching
  private var segmentIndex = 0
  private var disposables = Set<AnyCancellable>()
  
  var searchMode: SearchMode = .city
  var userLocation: CLLocationCoordinate2D?
  var userText: String = ""
  
  var recentSearches = [Weather]()
  var weather: Weather?
  
  func textFieldIsEnabled() -> Bool {
    return segmentIndex != 2
  }
  
  func segmentChanged(_ index: Int) {
    segmentIndex = index
    switch index {
    case 0:
      self.searchMode = .city
    case 1:
      self.searchMode = .zipCode
    case 2:
      fetchUserLocation()
      self.searchMode = .currentLocation
    default:
      break
    }
  }
  
  func recentSearchTapped() {
    userText = ""
  }
  
  func searchTapped(text: String) {
    userText = text
  }
  
  func fetchUserLocation() {
    locationService.getLocation()
    let cancellable = locationService.coordinate
      .sink(receiveCompletion: { (error) in
        switch error { 
        case .failure:
          break
         default: break
         }
      }, receiveValue: { [weak self] (coordinate) in
        self?.userLocation = coordinate
      })
    cancellable.store(in: &disposables)
  }
  
  func getWeather(completion: @escaping (Result<Void, Error>) -> Void) {
    guard !userText.isEmpty else {
      let error = NSError(domain: "No user text", code: 0, userInfo: nil)
      completion(.failure(error))
      return
    }
    switch searchMode {
    case .city:
      weatherService.fetchCurrentWeather(forCity: userText) { [weak self] (result) in
        self?.handleResult(result, completion: completion)
      }
    case.zipCode:
      weatherService.fetchCurrentWeather(forZipCode: userText){ [weak self] (result) in
        self?.handleResult(result, completion: completion)
      }
    case .currentLocation:
      guard let location = userLocation else { return }
      weatherService.fetchCurrentWeather(forLocation: location){ [weak self] (result) in
        self?.handleResult(result, completion: completion)
      }
    }
  }
  
  private func handleResult<T>(_ result: Result<T, Error>, completion: @escaping (Result<Void, Error>) -> Void) {
    switch result {
    case .success(let result):
      if let result = result as? APIResponse {
        self.saveWeather(result)
      }
      completion(.success(()))
    case .failure(let error):
      completion(.failure(error))
    }
  }
  
  func recentWeatherSearchIfAvailable() -> Weather? {
    return StorageService.shared.getWeatherInfomDisk()
  }
  
  private func saveWeather(_ response: APIResponse) {
    let weather = Weather(data: response)
    self.weather = Weather(data: response)
    
    if !recentSearches.contains(weather) {
      recentSearches.append(weather)
    }
    
    _ = StorageService.shared.saveWeatherInfoToDisk(weather)
  }
}
