import Foundation

struct Breed: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case id, name, temperament
        case wikipediaUrl = "wikipedia_url"
        case lifeSpan = "life_span"
    }

    let id: Int
    let name: String
    let temperament: String?
    let wikipediaUrl: URL?
    let lifeSpan: String
}

typealias BreedSearchResult = Result<[Breed], Error>
typealias BreedSearchCompletion = ((BreedSearchResult)-> ())

protocol BreedServiceInterface {
    func search(breed: String, completion:@escaping BreedSearchCompletion)
}
