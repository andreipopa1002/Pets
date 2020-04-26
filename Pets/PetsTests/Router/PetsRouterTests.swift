import XCTest
@testable import Pets

final class PetsRouterTests: XCTestCase {
    private var router: PetsRouter!
    private var mockedUrlOpenner: MockUrlOpenner!
    private var mockedErrorViewFactory: MockErrorViewControllerFactory!

    override func setUpWithError() throws {
        mockedUrlOpenner = MockUrlOpenner()
        mockedErrorViewFactory = MockErrorViewControllerFactory()
        router = PetsRouter(errorViewFactory: mockedErrorViewFactory, urlOpenner: mockedUrlOpenner)
    }

    override func tearDownWithError() throws {
        router = nil
        mockedUrlOpenner = nil
        mockedErrorViewFactory = nil
    }

    func test_WhenOpenUrl_ThenUlrOpennerOpenUrl() {
        let url = URL(string: "www.g.com")!
        router.open(url: url)
        XCTAssertEqual(mockedUrlOpenner.spyOpen.map{ $0.url}, [url])
    }

    func test_WhenOpenUrl_ThenUlrOpennerEmptyOptions() {
        let url = URL(string: "www.g.com")!
        router.open(url: url)
        let options: [[UIApplication.OpenExternalURLOptionsKey : Any]] = mockedUrlOpenner.spyOpen.map{ $0.options}
        options.forEach {
            XCTAssertTrue($0.isEmpty)
        }
    }

    func test_WhenOpenUrl_ThenUlrOpennerNilCompletion() {
        let url = URL(string: "www.g.com")!
        router.open(url: url)
        let completions: [((Bool) -> Void)?] = mockedUrlOpenner.spyOpen.map {$0.completion}
        completions.forEach {
            XCTAssertNil($0)
        }
    }

    
}

private class MockUrlOpenner: UrlOpenerInterface {
    private(set) var spyOpen = [(url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completion: ((Bool) -> Void)?)]()

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        spyOpen.append((url: url, options: options, completion: completion))
    }


}

private class MockErrorViewControllerFactory: ErrorViewControllerFactoryInterface {
    private(set) var spyViewControlllerError = [Error]()
    var stubbedViewController = UIViewController()

    func viewController(forError: Error) -> UIViewController {
        spyViewControlllerError.append(forError)
        return stubbedViewController
    }
}
