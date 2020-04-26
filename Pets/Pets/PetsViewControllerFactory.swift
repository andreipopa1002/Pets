import Foundation
import UIKit
import NetworkingS

final class PetsViewControllerFactory {
    func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
        .instantiateViewController(identifier: "PetsViewController") as! ViewController
        let breedService = BreedService(client: decodingClient())
        let interactor = PetsInteractor(breedService: breedService)
        let router = PetsRouter(errorViewFactory: ErrorViewControllerFactory())
        let presenter = PetsPresenter(
            interactor: interactor,
            router: router,
            viewModelBuilder: ViewModelBuilder(router: router)
        )
        interactor.output = presenter
        presenter.output = view
        view.presenter = presenter
        return view
    }
}

private extension PetsViewControllerFactory {
    func decodingClient() -> DecodingServiceInterface {
        let clientFactory = ClientFactory(session: URLSession.shared)
        let authorizedService = clientFactory.authorizesService(tokenProvider: AuthorizationInjector())
        return clientFactory.decodingService(authorizationService: authorizedService)
    }
}
