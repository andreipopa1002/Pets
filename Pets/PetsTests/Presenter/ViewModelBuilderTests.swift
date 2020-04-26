import XCTest
@testable import Pets

final class ViewModelBuilderTests: XCTestCase {
    private var builder: ViewModelBuilder!
    private var mockedRouter: MockPetsRouter!

    override func setUpWithError() throws {
        mockedRouter = MockPetsRouter()
        builder = ViewModelBuilder(router: mockedRouter)
    }

    override func tearDownWithError() throws {
        builder = nil
        mockedRouter = nil
    }

    func test_GivenNoBreed_WhenBuildViewModel_ThenEmptyViewModel() {
        XCTAssertTrue(builder.buildViewModel(fromBreeds: []).isEmpty)
    }

    func test_Given2Breeds_WhenBuildViewModel_ThenViewModel2Names() {
        let viewModel = builder.buildViewModel(fromBreeds: stubbedBreeds())
        XCTAssertEqual(viewModel.map{ $0.name}, ["name1", "name2"])
    }

    func test_Given2Breeds_WhenBuildViewModel_ThenViewModel2LifeSpans() {
        let viewModel = builder.buildViewModel(fromBreeds: stubbedBreeds())
        XCTAssertEqual(viewModel.map{$0.lifeSpan}, ["Life span:\nlifeSpan1", "Life span:\nlifeSpan2"])
    }

    func test_Given2Breeds_WhenBuildViewModel_ThenViewModel2Temperament() {
        let viewModel = builder.buildViewModel(fromBreeds: stubbedBreeds())
        XCTAssertEqual(viewModel.map{$0.temperament}, [["temp11", "temp12", "temp13"], ["temp21", "temp22"]])

    }

    func test_Given2Breeds_OneWikiURL_WhenBuildViewModel_ThenOneWikiAction() {
        let viewModel = builder.buildViewModel(fromBreeds: stubbedBreeds())
        let viewModelsWithWikiAction = viewModel.filter {$0.wikiButtonAction != nil}
        XCTAssertEqual(viewModelsWithWikiAction.map {$0.name}, ["name1"])
    }

    func test_Given2Breeds_OneWikiURL_WhenBuildViewModel_ThenActionCallsRouter() {
        let viewModel = builder.buildViewModel(fromBreeds: stubbedBreeds())
        let viewModelWithWikiAction = viewModel.compactMap {$0.wikiButtonAction}
        viewModelWithWikiAction.forEach {$0()}
        XCTAssertEqual(mockedRouter.spyOpenUrl, [URL(string: "www.url1.com")!])
    }
}

private extension ViewModelBuilderTests {
    func stubbedBreeds() -> [Breed] {
        return [
            Breed(
                id: 0,
                name: "name1",
                temperament: "  temp11 ,temp12, temp13    ",
                wikipediaUrl: URL(string: "www.url1.com")!,
                lifeSpan: "lifeSpan1"
            ),
            Breed(
                id: 1,
                name: "name2",
                temperament: "    temp21     , temp22",
                wikipediaUrl: nil,
                lifeSpan: "lifeSpan2"
            )
        ]
    }
}
