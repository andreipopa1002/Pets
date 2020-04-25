import Foundation
import UIKit

protocol PetsRouterInterface {
    func present(error: Error)
    func open(url: URL)
}

final class PetsRouter {
    private let errorViewFactory: ErrorViewControllerFactoryInterface
    weak var view: UIViewController?

    init(errorViewFactory: ErrorViewControllerFactoryInterface) {
        self.errorViewFactory = errorViewFactory
    }
}

extension PetsRouter: PetsRouterInterface {
    func present(error: Error) {
        view?.present(
            errorViewFactory.viewController(forError: error),
            animated: true,
            completion: nil
        )

    }

    func open(url: URL) {
        
    }
}


