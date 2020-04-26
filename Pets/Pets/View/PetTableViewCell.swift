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
    private var viewModel: PetViewModel?

    func setup(withViewModel viewModel: PetViewModel) {
        nameLabel.text = viewModel.name
        lifeSpanLabel.text = viewModel.lifeSpan
        wikiButton.isHidden = viewModel.wikiButtonAction == nil ? true : false
        temperamentCollectionView.isHidden = viewModel.temperament.count == 0 ? true : false
        temperamentCollectionView.dataSource = self

        self.viewModel = viewModel
        temperamentCollectionView.reloadData()
    }
    @IBAction func didTapWikiButton(_ sender: Any) {
        viewModel?.wikiButtonAction?()
    }
}

extension PetTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.temperament.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetTemperament", for: indexPath) as? TemperamentCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.setup(withTemperament: viewModel?.temperament[indexPath.item] ?? "")
        return cell
    }
}
