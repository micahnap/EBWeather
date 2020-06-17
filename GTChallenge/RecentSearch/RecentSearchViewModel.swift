//  Created by Micah Napier

import Foundation

struct RecentSearchViewModel {
  init(recentSearches: [Weather]) {
    self.dataSource = recentSearches
  }
  
  let dataSource: [Weather]
  
  func didTapRecentSearch(_ weather: Weather) {
    _ = StorageService.shared.saveWeatherInfoToDisk(weather)
  }
}
