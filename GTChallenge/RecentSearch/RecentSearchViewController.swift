//  Created by Micah Napier

import UIKit

protocol RecentSearchViewControllerCoordinator: AnyObject {
  func recentSearchViewControllerDidTapRecentSearch(_ viewController: RecentSearchViewController)
}

class RecentSearchViewController: UIViewController {
  init(viewModel: RecentSearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var coordinator: RecentSearchViewControllerCoordinator?
  
  @IBOutlet private weak var tableView: UITableView!
  
  private let cellIdentifier = "cellIdentifier"
  private let viewModel: RecentSearchViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(UINib(nibName: "RecentSearchCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
  }
}

extension RecentSearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RecentSearchCell else {
      return UITableViewCell()
    }
    let recentSearch = viewModel.dataSource[indexPath.row]
    let viewModel = RecentSearchCellViewModel(cell: recentSearch)
    cell.configure(with: viewModel)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let recentSearch = viewModel.dataSource[indexPath.row]
    viewModel.didTapRecentSearch(recentSearch)
    coordinator?.recentSearchViewControllerDidTapRecentSearch(self)
  }
  
}


