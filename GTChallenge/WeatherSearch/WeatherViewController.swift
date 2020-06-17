
import UIKit
import CoreLocation
import Combine

protocol WeatherViewControllerCoordinator: AnyObject {
  func weatherViewController(_ viewController: WeatherViewController, didTapRecentSearchButtonFor recentSearches: [Weather])
}

class WeatherViewController: UIViewController {
  init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var coordinator: WeatherViewControllerCoordinator?
  
  @IBOutlet private weak var cityName: UILabel!
  @IBOutlet private weak var temperature: UILabel!
  @IBOutlet private weak var weatherDescription: UILabel!
  @IBOutlet private weak var minTemp: UILabel!
  @IBOutlet private weak var maxTemp: UILabel!
  @IBOutlet private weak var windSpeed: UILabel!
  @IBOutlet private weak var humidity: UILabel!
  @IBOutlet private weak var searchTextField: UITextField!
  
  @IBAction private func segmentChanged(_ sender: UISegmentedControl) {
    viewModel.segmentChanged(sender.selectedSegmentIndex)
    updateSearchTextField()
  }
  
  @IBAction private func searchTapped(_ sender: Any) {
    viewModel.searchTapped(text: searchTextField.text ?? "")
    searchTextField.resignFirstResponder()
    fetchWeather()
  }
  
  @IBAction private func recentSearchTapped(_ sender: Any) {
    guard !viewModel.recentSearches.isEmpty else {
      showAlert(title: "Oops!", message: "There are no recent searches")
      return
    }
    viewModel.recentSearchTapped()
    searchTextField.text = ""
    coordinator?.weatherViewController(self, didTapRecentSearchButtonFor: viewModel.recentSearches)
  }
  
  private let viewModel: WeatherViewModel
  private var disposables = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configure()
  }

  private func updateSearchTextField() {
    searchTextField.text = viewModel.searchMode.searchText
    searchTextField.placeholder = viewModel.searchMode.placeholderText
    searchTextField.isEnabled = viewModel.textFieldIsEnabled()
    searchTextField.keyboardType = viewModel.searchMode.keyboardInputType
    searchTextField.reloadInputViews()
  }
  
  private func configure() {
    guard let weather: WeatherInterface = viewModel.recentWeatherSearchIfAvailable() else { return }
    cityName.text = weather.name
    weatherDescription.text = weather.description
    temperature.text = weather.temperature
    minTemp.text = weather.minTemperature
    maxTemp.text = weather.maxTemperature
    humidity.text = weather.humidity
    windSpeed.text = weather.windSpeed
  }
  
  private func fetchWeather() {
    viewModel.getWeather { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success:
        self.configure()
      case .failure(let error):
        assertionFailure("\(error)")
        self.showAlert(title: "Unknown city", message: "cannot find city")
      }
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

extension WeatherViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}


