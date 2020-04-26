import Foundation
import UIKit

final class TemperamentCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var temperamentLabel: UILabel!

    func setup(withTemperament temperament: String) {
        temperamentLabel.text = temperament
    }
}
