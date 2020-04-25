import XCTest
import NetworkingS
@testable import Pets

final class BreedServiceTests: XCTestCase {
    private var service: BreedService!
    private var mockedDecodingClient: MockDecodingService!

    override func setUpWithError() throws {
        mockedDecodingClient = MockDecodingService()
        service = BreedService(client: mockedDecodingClient)
    }

    override func tearDownWithError() throws {
        service = nil
        mockedDecodingClient = nil
    }

    func test_GivenBreed_WhenSearch_ThenRequestHasUrl() {
        service.search(breed: "bit") { _ in }
        let expectedUrl = URL(string: "https://api.thedogapi.com/v1/breeds/search?q=bit")
        XCTAssertEqual(mockedDecodingClient.spyRequest.map {$0.url}, [expectedUrl])
    }

    func test_GivenComplexBreed_WhenSearch_ThenQueryEncoded() {
        service.search(breed: "a more complex breed") { _ in }
        let expectedUrl = URL(string: "https://api.thedogapi.com/v1/breeds/search?q=a%20more%20complex%20breed")
        XCTAssertEqual(mockedDecodingClient.spyRequest.map {$0.url}, [expectedUrl])
    }

    func test_WhenSearch_ThenRequestHasApplicationJson() {
        service.search(breed: "") { _ in }
        XCTAssertEqual(
            mockedDecodingClient.spyRequest.map {$0.allHTTPHeaderFields},
            [["Accept": "application/json"]])
    }

    func test_GivenSuccessWithNilBreeds_WhenSearch_ThenCompletionWithEmptyBreeds() {
        var capturedBreeds: [Breed]?
        service.search(breed: "") { result in
            if case .success(let breeds) = result {
                capturedBreeds = breeds
            }
        }
        let completion = inferredCompletion()
        completion?(.success((model: nil, response: nil)))

        XCTAssertEqual(capturedBreeds, [])
    }

    func test_GivenSuccessWithBreeds_WhenSearch_ThenCompletionWithBreeds() {
        var capturedBreeds: [Breed]?
        service.search(breed: "") { result in
            if case .success(let breeds) = result {
                capturedBreeds = breeds
            }
        }
        let completion = inferredCompletion()
        completion?(.success((model: [.stub], response: nil)))

        XCTAssertEqual(capturedBreeds, [.stub])
    }

    func test_GivenFailureWithUnauthorized_WhenSearch_ThenCompletionWithUnauthorized() {
        var capturedError: Error?
        service.search(breed: "") { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }
        let completion = inferredCompletion()
        completion?(.failure(.unauthorized))

        XCTAssertEqual(capturedError as? AuthorizedServiceError, AuthorizedServiceError.unauthorized)
    }

    func test_GivenFailureWithNetworkError_WhenSearch_ThenCompletionWithNetworkError() {
        var capturedError: Error?
        service.search(breed: "") { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }
        let completion = inferredCompletion()
        completion?(.failure(.networkError(DescriptiveError(customDescription: "my error"))))

        XCTAssertEqual(capturedError?.localizedDescription, "my error")
    }

}

private extension BreedServiceTests {
    func inferredCompletion() -> DecodingServiceCompletion<[Breed]>? {
        return mockedDecodingClient.spyCompletion as? DecodingServiceCompletion<[Breed]>
    }
}

extension Breed {
    static var stub: Breed {
        return Breed(id: "",
                     name: "",
                     temperament: "",
                     wikipediaUrl: URL(string:"www.a.c")!,
                     lifeSpan: ""
        )
    }
}
