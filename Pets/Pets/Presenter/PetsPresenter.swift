import Foundation

protocol PetsPresenterInterface {
    func search(breed: String)
}

final class PetsPresenter {
    let interactor: PetsInteractorInterface
    let router: PetsRouterInterface

    init(interactor: PetsInteractorInterface, router: PetsRouterInterface) {
        self.interactor = interactor
        self.router = router
    }
}

extension PetsPresenter: PetsPresenterInterface {
    func search(breed: String) {
        interactor.search(breed: breed)
    }
}

extension PetsPresenter: PetsInteractorOutputInterface {
    func didFetched(breeds: [Breed]) {
    }

    func didFailedFetch(error: Error) {
        router.present(error: error)
    }


}
