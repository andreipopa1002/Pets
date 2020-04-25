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

    // MARK: - didFetched
    func test_WhenDidFetched_ThenViewModelBuilderWithBreeds() {
        presenter.didFetched(breeds: [.stub])
        XCTAssertEqual([[.stub]], mockedViewModelBuilder.spyBreeds)
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
}

private class MockPetsInteractor: PetsInteractorInterface {
    private(set) var spySearchBreed = [String]()
    func search(breed: String) {
        spySearchBreed.append(breed)
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
    func show(viewModels: [PetViewModel]) {
        spyShowViewModels.append(viewModels)
        expectation?.fulfill()
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
            image: nil,
            lifeSpan: "",
            temperament: []
        )
    }
}
