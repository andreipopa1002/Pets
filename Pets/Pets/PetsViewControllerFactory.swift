import Foundation
import UIKit
import NetworkingS

final class PetsViewControllerFactory {
    func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
        .instantiateViewController(identifier: "PetsViewController") as! PetsViewController

        let interactor = PetsInteractor(
            breedService: BreedService(client: decodingClient()),
            imageService: PublicImagesService(requestModifier: ImageRequestModifier(apiKey: Environment.apiKey)
            )
        )
        let router = PetsRouter(
            errorViewFactory: ErrorViewControllerFactory(),
            urlOpenner: UIApplication.shared
        )
        let viewModelBuilder = ViewModelBuilder(router: router, interactor: interactor)
        let presenter = PetsPresenter(
            interactor: interactor,
            router: router,
            viewModelBuilder: viewModelBuilder
        )
        
        interactor.output = presenter
        presenter.output = view
        router.view = view
        view.presenter = presenter
        return view
    }
}

private extension PetsViewControllerFactory {
    func decodingClient() -> DecodingServiceInterface {
        let clientFactory = ClientFactory(session: URLSession.shared)
        let authorizedService = clientFactory.authorizesService(
            tokenProvider: AuthorizationInjector(apiKey: Environment.apiKey)
        )
        return clientFactory.decodingService(authorizationService: authorizedService)
    }
}
