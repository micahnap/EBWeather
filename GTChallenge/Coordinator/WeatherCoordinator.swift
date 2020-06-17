import UIKit

class WeatherCoordinator {

  private let weatherService: WeatherService = WeatherService(client: WeatherClient())
  
  var weatherViewController: WeatherViewController {
    let locationService = LocationService()
    let viewModel = WeatherViewModel(weatherService: weatherService, locationService: locationService)
    let weatherViewController = WeatherViewController(viewModel: viewModel)
    weatherViewController.coordinator = self
    return weatherViewController
  }
  
  private weak var _navigationController: UINavigationController?
  var navigationController: UINavigationController {
    if let navigationController = _navigationController {
      return navigationController
    }
    let navigationController = UINavigationController()
    _navigationController = navigationController
    navigationController.setViewControllers([weatherViewController], animated: false)
    return navigationController
  }
}

extension WeatherCoordinator: WeatherViewControllerCoordinator {
  func weatherViewController(_ viewController: WeatherViewController, didTapRecentSearchButtonFor recentSearches: [Weather]) {
    let viewModel = RecentSearchViewModel(recentSearches: recentSearches)
    let viewController = RecentSearchViewController(viewModel: viewModel)
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension WeatherCoordinator: RecentSearchViewControllerCoordinator {
  func recentSearchViewControllerDidTapRecentSearch(_ viewController: RecentSearchViewController) {
    navigationController.popViewController(animated: true)
  }
}
