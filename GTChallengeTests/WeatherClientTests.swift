//  Created by Micah Napier
//

import XCTest
import MapKit
@testable import GTChallenge

class WeatherClientTests: XCTestCase {
  
  let client = WeatherClient()
  
  func testCorrectQueryItemComponentsGivenAPICallEnum() {
    let apiCallCity: WeatherClient.APICall = .city("Sydney")
    let apiCallZipCode: WeatherClient.APICall = .zipCode("90210")
    
    let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees())
    
    let apiCallLocation: WeatherClient.APICall = .location(coordinate)
    let cityComponents = client.currentWeatherComponents(for: apiCallCity)
    let zipComponents = client.currentWeatherComponents(for: apiCallZipCode)
    let locationComponents = client.currentWeatherComponents(for: apiCallLocation)
    
    guard let cityQueryItems = cityComponents.queryItems, 
      let zipQueryItems = zipComponents.queryItems,
      let locationQueryItems = locationComponents.queryItems  else {
      XCTFail("No query itmes")
      return 
    }

    XCTAssert(cityQueryItems.contains(URLQueryItem(name: "q", value: "Sydney")))
    XCTAssert(zipQueryItems.contains(URLQueryItem(name: "zip", value: "90210")))
    XCTAssert(locationQueryItems.contains(URLQueryItem(name: "lat", value: String(coordinate.latitude))))
    XCTAssert(locationQueryItems.contains(URLQueryItem(name: "lon", value: String(coordinate.longitude))))
  }

}
