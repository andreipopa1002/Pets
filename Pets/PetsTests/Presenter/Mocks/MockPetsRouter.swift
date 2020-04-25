import Foundation
import XCTest
@testable import Pets

class MockPetsRouter: PetsRouterInterface {
    private(set) var spyPresentError = [Error]()
    private(set) var spyOpenUrl = [URL]()
    var expectation: XCTestExpectation?

    func present(error: Error) {
        spyPresentError.append(error)
        expectation?.fulfill()
    }

    func open(url: URL) {
        spyOpenUrl.append(url)
        expectation?.fulfill()
    }
}
