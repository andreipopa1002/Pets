import XCTest
@testable import Pets

final class PetsPresenterTests: XCTestCase {
    private var presenter: PetsPresenter!
    private var mockedInteractor: MockPetsInteractor!
    private var mockedRouter: MockPetsRouter!
    private var mockedViewModelBuilder: MockViewModelBuilder!
    private var mockedPresenterOutput: MockPresenterOutput!

    override func setUpWithError() throws {
        mockedInteractor = MockPetsInteractor()
        mockedRouter = MockPetsRouter()
        mockedViewModelBuilder = MockViewModelBuilder()
        presenter = PetsPresenter(
            interactor: mockedInteractor,
            router: mockedRouter,
            viewModelBuilder: mockedViewModelBuilder
        )
        mockedPresenterOutput = MockPresenterOutput()
        presenter.output = mockedPresenterOutput

    }

    override func tearDownWithError() throws {
        presenter = nil
        mockedInteractor = nil
        mockedRouter = nil
        mockedViewModelBuilder = nil
        mockedPresenterOutput = nil
    }

    func test_outputIsWeak() {
        var output: PetsPresenterOutput? = MockPresenterOutput()
        presenter.output = output
        output = nil

        XCTAssertNil(presenter.output)
    }

    // MARK: - search
    func test_WhenSearch_ThenInteractorSearch() {
        presenter.search(breed: "wof")
        XCTAssertEqual(mockedInteractor.spySearchBreed, ["wof"])
    }

    func test_WhenSearch_ThenOutputStartLoading() {
        presenter.search(breed: "")
        XCTAssertEqual(mockedPresenterOutput.spyStartLoadingCallCount, 1)
    }

    // MARK: - didFetched
    func test_WhenDidFetched_ThenViewModelBuilderWithBreeds() {
        presenter.didFetched(breeds: [.stub])
        XCTAssertEqual([[.stub]], mockedViewModelBuilder.spyBreeds)
    }

    func test_WhenDidFetched_ThenViewStopLoading() {
        mockedPresenterOutput.expectation = expectation(description: "main thread")
        presenter.didFetched(breeds: [.stub])
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(self.mockedPresenterOutput.spyStopLoadingCallCount,1)
        }
    }

    func test_WhenDidFetched_ThenViewReceivesViewModelsFromBuilder() {
        mockedPresenterOutput.expectation = expectation(description: "main thread")
        mockedViewModelBuilder.stubbedViewModel = [.stub]
        presenter.didFetched(breeds: [.stub])
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(
                self.mockedPresenterOutput.spyShowViewModels,
                [[.stub]])
        }
    }

    // MARK: - didFailedFetch
    func test_WhenDidFailedFetch_ThenRouterPresentError() {
        mockedRouter.expectation = expectation(description: "main thread")
        presenter.didFailedFetch(error: DescriptiveError(customDescription: "failed fetch"))
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(self.mockedRouter.spyPresentError.map {$0.localizedDescription}, ["failed fetch"])
        }
    }

    func test_WhenDidFailedFetch_ThenOutputStopLoading() {
        mockedRouter.expectation = expectation(description: "main thread")
        presenter.didFailedFetch(error: DescriptiveError(customDescription: "failed fetch"))
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(self.mockedPresenterOutput.spyStopLoadingCallCount, 1)
        }
    }
}

private class MockViewModelBuilder: ViewModelBuilderInterface {
    private(set) var spyBreeds = [[Breed]]()
    var stubbedViewModel = [PetViewModel]()

    func buildViewModel(fromBreeds breeds: [Breed]) -> [PetViewModel] {
        spyBreeds.append(breeds)
        return stubbedViewModel
    }
}

private class MockPresenterOutput: PetsPresenterOutput {
    private(set) var spyShowViewModels = [[PetViewModel]]()
    var expectation: XCTestExpectation?
    private(set) var spyStartLoadingCallCount = 0
    private(set) var spyStopLoadingCallCount = 0

    func show(viewModels: [PetViewModel]) {
        spyShowViewModels.append(viewModels)
        expectation?.fulfill()
    }

    func startLoading() {
        spyStartLoadingCallCount += 1
    }

    func stopLoading() {
        spyStopLoadingCallCount += 1
    }

}

extension PetViewModel: Equatable {
    public static func == (lhs: PetViewModel, rhs: PetViewModel) -> Bool {
        return lhs.name == rhs.name &&
            lhs.lifeSpan == rhs.lifeSpan &&
            lhs.temperament == rhs.temperament
    }

    static var stub: PetViewModel {
        return PetViewModel(
            name: "",
            wikiButtonAction: nil,
            imageViewModel: .stub,
            lifeSpan: "",
            temperament: []
        )
    }
}

extension PetViewModel.ImageViewModel {
    static var stub: PetViewModel.ImageViewModel {
        return PetViewModel.ImageViewModel(
            placeholder: UIImage(),
            source: .stub
        )
    }
}

