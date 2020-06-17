//  Created by Micah Napier
//

import UIKit

protocol RecentSearchCellInterface {
  var locationName: String { get }
  var weatherDescription: String { get }
}

struct RecentSearchCellViewModel {
  let cell: RecentSearchCellInterface
  init(cell: RecentSearchCellInterface) {
    self.cell = cell
  }
}

class RecentSearchCell: UITableViewCell {
  @IBOutlet private weak var locationNameLabel: UILabel!
  @IBOutlet private weak var weatherDescriptionLabel: UILabel!
  
  func configure(with viewModel: RecentSearchCellViewModel) {
    locationNameLabel.text = viewModel.cell.locationName
    weatherDescriptionLabel.text = viewModel.cell.weatherDescription
  }
}
