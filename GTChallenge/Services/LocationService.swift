// Created by Micah Napier

import Foundation
import CoreLocation
import MapKit
import Combine

protocol LocationFetching {
  func getLocation()
  var coordinate: CurrentValueSubject<CLLocationCoordinate2D?, Error> { get set }
}

class LocationService: NSObject {
  var coordinate = CurrentValueSubject<CLLocationCoordinate2D?, Error>(nil)
}

extension LocationService: LocationFetching {
  
  func getLocation() {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
}

extension LocationService: CLLocationManagerDelegate {
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      coordinate.send(location)
    }
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if [.denied, .restricted].contains(status) {
      coordinate.send(nil)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    coordinate.send(nil)
  }
}
