import XCTest
@testable import Pets

final class ImageRequestModifierTests: XCTestCase {
    private var modifier: ImageRequestModifier!

    override func setUpWithError() throws {
        modifier = ImageRequestModifier(apiKey: "my key")
    }

    override func tearDownWithError() throws {
        modifier = nil
    }

    func test_WhenModified_ThenRequestHasApiKey() {
        let urlRequest = URLRequest(url: URL(string: "www.f.c")!)
        let modifiedRequest = modifier.modified(for: urlRequest)
        XCTAssertEqual(modifiedRequest?.allHTTPHeaderFields?["x-api-key"], "my key")
    }
}
