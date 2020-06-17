//  Created by Micah Napier
//

import XCTest
import MapKit
import Combine

@testable import GTChallenge

class SearchModeTests: XCTestCase {
  func testSearchModesMatchesExpectedUnderlyingValues() {
    var searchMode = SearchMode.city
    XCTAssertEqual(searchMode.placeholderText, "Search by city name")
    XCTAssertEqual(searchMode.keyboardInputType, .alphabet)
    XCTAssertEqual(searchMode.searchText, "")
    
    searchMode = SearchMode.currentLocation
    XCTAssertEqual(searchMode.placeholderText, "My location")
    XCTAssertEqual(searchMode.keyboardInputType, .alphabet)
    XCTAssertEqual(searchMode.searchText, "My location")
    
    searchMode = SearchMode.zipCode
    XCTAssertEqual(searchMode.placeholderText, "Search by zip code")
    XCTAssertEqual(searchMode.keyboardInputType, .numberPad)
    XCTAssertEqual(searchMode.searchText, "")
  }
}
