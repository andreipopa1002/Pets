import Foundation
import UIKit

struct PetViewModel {
    let name: String
    let wikiButtonAction: (() -> ())?
    let image: ((UIImage) -> ())?
    let lifeSpan: String
    let temperament: [String]
}

final class PetTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var wikiButton: UIButton!
    @IBOutlet private weak var petImageView: UIImageView!
    @IBOutlet private weak var lifeSpanLabel: UILabel!
    @IBOutlet private weak var temperamentCollectionView: UICollectionView!
}
