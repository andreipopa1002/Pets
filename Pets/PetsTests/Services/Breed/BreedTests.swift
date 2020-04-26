import XCTest
@testable import Pets

final class BreedTests: XCTestCase {
    private var decoder: JSONDecoder!

    override func setUpWithError() throws {
        decoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        decoder = nil
    }

    func test_GivenJSONWithAllFields_WhenDecode_ThenBreedWithAllFields() {
        let breeds = try? decoder.decode([Breed].self, from: Data(stubbedFullJSON.utf8))
        XCTAssertEqual(
            breeds,
            [Breed(
                id: 55,
                name: "Boxer",
                temperament: "Devoted, Fearless, Friendly, Cheerful, Energetic, Loyal, Playful, Confident, Intelligent, Bright, Brave, Calm",
                wikipediaUrl: URL(string: "http://www.google.com"),
                lifeSpan: "8 - 10 years"
                )]
        )
    }

    func test_GivenJSONWitoutOptionalFields_WhenDecode_ThenBreedHasNilFields() {
        let breeds = try? decoder.decode([Breed].self, from: Data(stubbedJSONWithoutOptionalFields.utf8))
        XCTAssertEqual(
            breeds,
            [Breed(
                id: 55,
                name: "Boxer",
                temperament: "Devoted, Fearless, Friendly, Cheerful, Energetic, Loyal, Playful, Confident, Intelligent, Bright, Brave, Calm",
                wikipediaUrl: nil,
                lifeSpan: "8 - 10 years"
                )]
        )
    }
}

private extension BreedTests {
    var stubbedJSONWithoutOptionalFields: String { """
    [{
        "id": 55,
        "name": "Boxer",
        "bred_for": "Bull-baiting, guardian",
        "breed_group": "Working",
        "life_span": "8 - 10 years",
        "temperament": "Devoted, Fearless, Friendly, Cheerful, Energetic, Loyal, Playful, Confident, Intelligent, Bright, Brave, Calm"
    }]
    """
        }


    var stubbedFullJSON: String { """
[{
    "id": 55,
    "name": "Boxer",
    "bred_for": "Bull-baiting, guardian",
    "breed_group": "Working",
    "life_span": "8 - 10 years",
    "wikipedia_url": "http://www.google.com",
    "temperament": "Devoted, Fearless, Friendly, Cheerful, Energetic, Loyal, Playful, Confident, Intelligent, Bright, Brave, Calm"
}]
"""
    }
}
