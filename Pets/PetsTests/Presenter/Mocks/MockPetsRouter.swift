import Foundation
@testable import Pets

class MockPetsRouter: PetsRouterInterface {
    private(set) var spyPresentError = [Error]()
    private(set) var spyOpenUrl = [URL]()

    func present(error: Error) {
        spyPresentError.append(error)
    }

    func open(url: URL) {
        spyOpenUrl.append(url)
    }
}
