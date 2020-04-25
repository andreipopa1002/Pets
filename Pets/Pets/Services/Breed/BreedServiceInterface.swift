import Foundation

struct Breed: Decodable {
    let id: String
    let name: String
    let temperament: String
    let wikipediaUrl: String
}

typealias BreedSearchResult = Result<[Breed], Error>
typealias BreedSearchCompletion = ((BreedSearchResult)-> ())

protocol BreedServiceInterface {
    func search(breed: String, completion:@escaping BreedSearchCompletion)
}
