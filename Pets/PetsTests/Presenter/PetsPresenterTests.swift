import XCTest
@testable import Pets

final class PetsPresenterTests: XCTestCase {
    private var presenter: PetsPresenter!
    private var mockedInteractor: MockPetsInteractor!
    private var mockedRouter: MockPetsRouter!

    override func setUpWithError() throws {
        mockedInteractor = MockPetsInteractor()
        mockedRouter = MockPetsRouter()
        presenter = PetsPresenter(interactor: mockedInteractor, router: mockedRouter)

    }

    override func tearDownWithError() throws {
        presenter = nil
        mockedInteractor = nil
        mockedRouter = nil
    }

    // MARK: - search
    func test_WhenSearch_ThenInteractorSearch() {
        presenter.search(breed: "wof")
        XCTAssertEqual(mockedInteractor.spySearchBreed, ["wof"])
    }

    // MARK: - didFetched
    func test_WhenDidFetched_ThenViewModelBuilderWithBreeds() {
        XCTFail()
    }

    // MARK: - didFailedFetch
    func test_WhenDidFailedFetch_ThenRouterPresentError() {
        let error = DescriptiveError(customDescription: "the error")
        presenter.didFailedFetch(error: error)
        XCTAssertEqual(mockedRouter.spyPresentError.map {$0.localizedDescription}, ["the error"])
    }
}

private class MockPetsInteractor: PetsInteractorInterface {
    private(set) var spySearchBreed = [String]()
    func search(breed: String) {
        spySearchBreed.append(breed)
    }
}
