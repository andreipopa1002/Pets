import Foundation

struct Breed: Decodable, Equatable {
    let id: String
    let name: String
    let temperament: String
    let wikipediaUrl: URL?
    let lifeSpan: String
}

typealias BreedSearchResult = Result<[Breed], Error>
typealias BreedSearchCompletion = ((BreedSearchResult)-> ())

protocol BreedServiceInterface {
    func search(breed: String, completion:@escaping BreedSearchCompletion)
}
