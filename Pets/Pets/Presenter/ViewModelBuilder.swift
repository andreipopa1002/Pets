import Foundation
import UIKit

protocol ViewModelBuilderInterface {
    func buildViewModel(fromBreeds breeds: [Breed]) -> [PetViewModel]
}

final class ViewModelBuilder: ViewModelBuilderInterface {
    private var router: PetsRouterInterface

    init(router: PetsRouterInterface) {
        self.router = router
    }

    func buildViewModel(fromBreeds breeds: [Breed]) -> [PetViewModel] {
        var viewModels = [PetViewModel]()
        breeds.forEach {
            viewModels.append(PetViewModel(
                name: $0.name,
                wikiButtonAction: wikiAction(forBreed: $0),
                image: nil,
                lifeSpan: $0.lifeSpan,
                temperament: temperament(fromString: $0.temperament)
            ))
        }
        return viewModels
    }
}

private extension ViewModelBuilder {
    func temperament(fromString temperament: String) -> [String] {
        let temperamentArray = temperament.split(separator: Character(",")).map {String($0)}
        return temperamentArray.map {$0.trimmingCharacters(in: CharacterSet.whitespaces)}
    }

    func wikiAction(forBreed breed:Breed) -> (() -> ())? {
        guard let wikipediaUrl = breed.wikipediaUrl else {return nil}

        return { [weak self] in
            self?.router.open(url: wikipediaUrl)
        }
    }
}
