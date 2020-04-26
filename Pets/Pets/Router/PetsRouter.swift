import Foundation
import UIKit

protocol PetsRouterInterface {
    func present(error: Error)
    func open(url: URL)
}

protocol UrlOpenerInterface {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}
extension UIApplication: UrlOpenerInterface {}

final class PetsRouter {
    private let errorViewFactory: ErrorViewControllerFactoryInterface
    private let urlOpenner: UrlOpenerInterface
    weak var view: UIViewController?

    init(errorViewFactory: ErrorViewControllerFactoryInterface, urlOpenner: UrlOpenerInterface) {
        self.errorViewFactory = errorViewFactory
        self.urlOpenner = urlOpenner
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
        urlOpenner.open(url,options: [:],completionHandler: nil)
    }
}


