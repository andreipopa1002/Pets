import XCTest
@testable import Pets

final class PetsInteractorTests: XCTestCase {
    private var interactor: PetsInteractor!
    private var mockedBreedService: MockBreedService!
    private var mockedOutput: MockInteractorOutput!

    override func setUpWithError() throws {
        mockedBreedService = MockBreedService()
        mockedOutput = MockInteractorOutput()
        interactor = PetsInteractor(breedService: mockedBreedService)
        interactor.output = mockedOutput
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockedBreedService = nil
        mockedOutput = nil
    }

    func test_WhenInit_ThenOutputIsNil() {
        var output: PetsInteractorOutputInterface? = MockInteractorOutput()
        interactor.output = output
        output = nil
        XCTAssertNil(interactor.output)
    }

    func test_WhenSearch_ThenSearchBreed() {
        interactor.search(breed: "breed")
        XCTAssertEqual(mockedBreedService.spySearchBreed, ["breed"])
    }

    func test_GivenSuccess_WhenSearch_ThenOutputBreeds() {
        interactor.search(breed: "")
        mockedBreedService.spySearchBreedCompletion?(.success([Breed.stub]))
        XCTAssertEqual(mockedOutput.spyDidFetchBreeds, [[Breed.stub]])
    }

    func test_GivenFailure_WhenSearch_ThenOutputError() {
        interactor.search(breed: "")
        mockedBreedService.spySearchBreedCompletion?(.failure(DescriptiveError(customDescription: "my error")))
        XCTAssertEqual(mockedOutput.spyDidFailedFetch.map {$0.localizedDescription}, ["my error"])
    }



}

private class MockBreedService: BreedServiceInterface {
    private(set) var spySearchBreed = [String]()
    private(set) var spySearchBreedCompletion: BreedSearchCompletion?

    func search(breed: String, completion: @escaping BreedSearchCompletion) {
        spySearchBreed.append(breed)
        spySearchBreedCompletion = completion
    }
}

private class MockInteractorOutput: PetsInteractorOutputInterface {
    var spyDidFetchBreeds = [[Breed]]()
    var spyDidFailedFetch = [Error]()

    func didFetched(breeds: [Breed]) {
        spyDidFetchBreeds.append(breeds)
    }

    func didFailedFetch(error: Error) {
        spyDidFailedFetch.append(error)
    }


}
