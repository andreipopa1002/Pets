import Foundation

protocol PetsPresenterInterface {
    func search(breed: String)
}

protocol PetsPresenterOutput: AnyObject {
    func show(viewModels: [PetViewModel])
    func startLoading()
    func stopLoading()
}

final class PetsPresenter {
    private let interactor: PetsInteractorInterface
    private let router: PetsRouterInterface
    private let viewModelBuilder: ViewModelBuilderInterface
    weak var output: PetsPresenterOutput?

    init(
        interactor: PetsInteractorInterface,
        router: PetsRouterInterface,
        viewModelBuilder: ViewModelBuilderInterface
    ) {
        self.interactor = interactor
        self.router = router
        self.viewModelBuilder = viewModelBuilder
    }
}

extension PetsPresenter: PetsPresenterInterface {
    func search(breed: String) {
        output?.startLoading()
        interactor.search(breed: breed)
    }
}

extension PetsPresenter: PetsInteractorOutputInterface {
    func didFetched(breeds: [Breed]) {
        let viewModels = viewModelBuilder.buildViewModel(fromBreeds: breeds)
        DispatchQueue.main.async {
            self.output?.stopLoading()
            self.output?.show(viewModels: viewModels)
        }
    }

    func didFailedFetch(error: Error) {
        DispatchQueue.main.async {
            self.output?.stopLoading()
            self.router.present(error: error)
        }
    }
}
