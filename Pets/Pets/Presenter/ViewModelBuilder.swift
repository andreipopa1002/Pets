import Foundation
import UIKit

protocol ViewModelBuilderInterface {
    func buildViewModel(fromBreeds breeds: [Breed]) -> [PetViewModel]
}

final class ViewModelBuilder {
    private let router: PetsRouterInterface
    private let interactor: PetsInteractorInterface

    init(
        router: PetsRouterInterface,
        interactor: PetsInteractorInterface
    ) {
        self.router = router
        self.interactor = interactor
    }
}

extension ViewModelBuilder: ViewModelBuilderInterface {
    func buildViewModel(fromBreeds breeds: [Breed]) -> [PetViewModel] {
        var viewModels = [PetViewModel]()
        breeds.forEach {
            viewModels.append(PetViewModel(
                name: $0.name,
                wikiButtonAction: wikiAction(forBreed: $0),
                imageViewModel: imageViewModel(forBreedId: $0.id),
                lifeSpan: "Life span:\n" + $0.lifeSpan,
                temperament: temperament(fromString: $0.temperament)
            ))
        }
        return viewModels
    }
}

private extension ViewModelBuilder {
    func imageViewModel(forBreedId breedId: Int) -> PetViewModel.ImageViewModel {
        PetViewModel.ImageViewModel(
            placeholder: UIImage(named: "pet_placeholder")!,
            source: interactor.imageSource(forBreedId: breedId)
        )
    }

    func temperament(fromString temperament: String?) -> [String] {
        guard let temperament = temperament else { return [] }
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
