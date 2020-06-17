import UIKit

enum SearchMode {
  case city
  case zipCode
  case currentLocation
}

extension SearchMode {
  var placeholderText: String {
    switch self {
    case .city:
      return "Search by city name"
    case .currentLocation:
      return "My location"
    case .zipCode:
      return "Search by zip code"
    }
  }
}

extension SearchMode {
  var keyboardInputType: UIKeyboardType {
    switch self {
    case .city, .currentLocation:
      return .alphabet
    case .zipCode:
      return .numberPad
    }
  }
}

extension SearchMode {
  var searchText: String {
    switch self {
    case .city, .zipCode:
      return ""
    case .currentLocation:
      return "My location"
    }
  }
}
