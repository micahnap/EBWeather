//  Created by Micah Napier
//

import XCTest
import MapKit
import Combine

@testable import GTChallenge

class StorageServiceTests: XCTestCase {
  func testStoredValuesCanBeRetrieved() {
    let storageService = StorageService()
    let weather = Weather(name: "London", temperature: "92", humidity: "0", maxTemperature: "25", minTemperature: "22")
    XCTAssertTrue(storageService.saveWeatherInfoToDisk(weather))
    XCTAssertNotNil(storageService.getWeatherInfomDisk())
  }
}
