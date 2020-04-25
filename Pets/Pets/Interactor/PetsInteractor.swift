import Foundation

protocol PetsInteractorInterface {
    func search(breed: String)
}

protocol PetsInteractorOutputInterface: AnyObject {
    func didFetched(breeds: [Breed])
    func didFailedFetch(error: Error)
}

final class PetsInteractor {
    private let breedService: BreedServiceInterface
    weak var output: PetsInteractorOutputInterface?

    init(breedService: BreedServiceInterface) {
        self.breedService = breedService
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
}
