import XCTest
@testable import Pets

class AuthorizationInjectorTests: XCTestCase {
    private var injector: AuthorizationInjector!

    override func setUpWithError() throws {
        injector = AuthorizationInjector(apiKey: "key")
    }

    override func tearDownWithError() throws {
        injector = nil
    }

    func test_WhenInject_ThenApiKeyIsAdded() throws {
        let urlRequest = URLRequest(url: URL(string: "www.f.c")!)
        let modifiedRequest = injector.injectAuthorization(intoRequest: urlRequest)
        XCTAssertEqual(modifiedRequest.allHTTPHeaderFields?["x-api-key"], "key")
    }
}
