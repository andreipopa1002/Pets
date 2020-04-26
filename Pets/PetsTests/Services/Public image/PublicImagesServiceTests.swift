import XCTest
import Kingfisher
@testable import Pets

final class PublicImagesServiceTests: XCTestCase {
    private var service: PublicImagesService!
    private var mockedRequestModifier: MockImageDownloadRequestModifier!

    override func setUpWithError() throws {
        mockedRequestModifier = MockImageDownloadRequestModifier()
        service = PublicImagesService(requestModifier: mockedRequestModifier)
    }

    override func tearDownWithError() throws {
        service = nil
        mockedRequestModifier = nil
    }

    func test_WhenImageSource_ThenUrlWithComponents() {
        let imageSource = service.imageSource(forBreedId: 12)

        XCTAssertEqual(
            imageSource.url.absoluteString, "https://api.thedogapi.com/v1/images/search?breed_id=12&format=src&size=thumb"
        )
    }

    func test_WhenImageSource_ThenOneModifier() {
        let imageSource = service.imageSource(forBreedId: 12)
        XCTAssertEqual(imageSource.modifiers.count, 1)
    }

    func test_WhenImageSource_ThenModifierRequestModifier() {
        let imageSource = service.imageSource(forBreedId: 12)
        var capturedModifier: ImageDownloadRequestModifier?
        if case KingfisherOptionsInfoItem.requestModifier(let modifier) = imageSource.modifiers[0] {
            capturedModifier = modifier
        }

        XCTAssertTrue(capturedModifier as AnyObject === mockedRequestModifier)
    }

}

private class MockImageDownloadRequestModifier: ImageDownloadRequestModifier {
    private(set) var spyModified = [URLRequest]()
    var stubbedRequest = URLRequest(url: URL(string: "www.g.c")!)

    func modified(for request: URLRequest) -> URLRequest? {
        return stubbedRequest
    }
}
