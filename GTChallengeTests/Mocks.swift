@testable import GTChallenge
import Foundation
import MapKit
import Combine

struct MockWeatherService: CurrentWeatherFetching {
  func fetchCurrentWeather(forCity city: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
    let error = NSError(domain: "city error", code: 0, userInfo: nil)
    completion(.failure(error))
  }
  
  func fetchCurrentWeather(forZipCode zipCode: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let error = NSError(domain: "zip code error", code: 0, userInfo: nil)
    completion(.failure(error))
  }
  
  func fetchCurrentWeather(forLocation location: CLLocationCoordinate2D, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let error = NSError(domain: "location error", code: 0, userInfo: nil)
    completion(.failure(error))
  }
}

struct MockLocationService: LocationFetching {
  func getLocation() {}
  var coordinate = CurrentValueSubject<CLLocationCoordinate2D?, Error>(nil)
}
