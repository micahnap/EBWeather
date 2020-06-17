//  Created by Micah Napier
//

import XCTest
import MapKit
import Combine

@testable import GTChallenge

class WeatherViewModelTests: XCTestCase {
  
  func testWeatherTextFieldShouldBeEnabled() {
      let viewModel = WeatherViewModel(weatherService: MockWeatherService(), locationService: MockLocationService())
    
    viewModel.segmentChanged(0)
    XCTAssertTrue(viewModel.textFieldIsEnabled())
    viewModel.segmentChanged(1)
    XCTAssertTrue(viewModel.textFieldIsEnabled())
    viewModel.segmentChanged(2)
    XCTAssertFalse(viewModel.textFieldIsEnabled())
    viewModel.segmentChanged(5)
    XCTAssertTrue(viewModel.textFieldIsEnabled())
  }
  
  func testSegmentChangesToCorrectSearchMode() {
      let viewModel = WeatherViewModel(weatherService: MockWeatherService(), locationService: MockLocationService())
    
    viewModel.segmentChanged(0)
    XCTAssertEqual(viewModel.searchMode, .city)
    viewModel.segmentChanged(1)
    XCTAssertEqual(viewModel.searchMode, .zipCode)
    viewModel.segmentChanged(2)
    XCTAssertEqual(viewModel.searchMode, .currentLocation)
    viewModel.segmentChanged(5)
    XCTAssertEqual(viewModel.searchMode, .currentLocation)
    
  }
  
  func testUserTextClearsWhenRecentSearchIsTapped() {
    let viewModel = WeatherViewModel(weatherService: MockWeatherService(), locationService: MockLocationService())
    
    viewModel.userText = "User Text"
    viewModel.recentSearchTapped()
    XCTAssertTrue(viewModel.userText.isEmpty)
  }
  
  func testUserTextIsCapturedWhenSearchTapped() {
    let viewModel = WeatherViewModel(weatherService: MockWeatherService(), locationService: MockLocationService())
    viewModel.searchTapped(text: "User Text")
    XCTAssertEqual(viewModel.userText, "User Text")
  }
  
  func testReturnsAnErrorWhenUserSearchesWithNoText() {
    let viewModel = WeatherViewModel(weatherService: MockWeatherService(), locationService: MockLocationService())
    
    viewModel.getWeather(completion: { result in 
      switch result {
      case .failure(let error):
        XCTAssertNotNil(error)
        return
      case .success():
        XCTFail("Should not work with no user text")
        return
      }
    })
  }
  
  func testTheRightCallIsBeingMadeGivenSearchMode() {
    let viewModel = WeatherViewModel(weatherService: MockWeatherService(), locationService: MockLocationService())
    viewModel.userText = "User Text"
    
    viewModel.searchMode = .city
    viewModel.getWeather(completion: { result in 
      switch result {
      case .failure(let error as NSError):
        XCTAssertEqual(error.domain, "city error")
        return
      case .success():
        XCTFail("Should not work with no user text")
        return
      }
  })
      viewModel.searchMode = .zipCode
      viewModel.getWeather(completion: { result in 
        switch result {
        case .failure(let error as NSError):
          XCTAssertEqual(error.domain, "zip code error")
          return
        case .success():
          XCTFail("Should not work with no user text")
          return
        }
    })
    
      viewModel.searchMode = .currentLocation
      viewModel.getWeather(completion: { result in 
        switch result {
        case .failure(let error as NSError):
          XCTAssertEqual(error.domain, "location error")
          return
        case .success():
          XCTFail("Should not work with no user text")
          return
        }
    })
 }
}
