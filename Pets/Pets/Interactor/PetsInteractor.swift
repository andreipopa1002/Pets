import Foundation

protocol PetsInteractorInterface {
    func search(breed: String)
    func imageSource(forBreedId breedId: Int) -> PublicImageSource
}

protocol PetsInteractorOutputInterface: AnyObject {
    func didFetched(breeds: [Breed])
    func didFailedFetch(error: Error)
}

final class PetsInteractor {
    private let breedService: BreedServiceInterface
    private let imageService: PublicImagesServiceInterface
    weak var output: PetsInteractorOutputInterface?

    init(
        breedService: BreedServiceInterface,
        imageService: PublicImagesServiceInterface) {
        self.breedService = breedService
        self.imageService = imageService
    }
}

extension PetsInteractor: PetsInteractorInterface {
    func search(breed: String) {
        breedService.search(breed: breed) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didFailedFetch(error: error)
            case .success(let breeds):
                self?.output?.didFetched(breeds: breeds)
            }
        }
    }

    func imageSource(forBreedId breedId: Int) -> PublicImageSource {
        return imageService.imageSource(forBreedId: breedId)
    }
}
