import Foundation
import NetworkingS

final class BreedService {
    private let client: DecodingServiceInterface

    init(client: DecodingServiceInterface) {
        self.client = client
    }
}

extension BreedService: BreedServiceInterface {
    func search(breed: String, completion:@escaping BreedSearchCompletion) {
        let stringUrl = Environment.baseUrl + "/v1/breeds/search"
        let request = URLRequest(url: URL(string: stringUrl)!)
        fetchBreeds(request: request) { result in
            switch result {
            case .success(let tuple):
                completion(.success(tuple.model ?? []))
                break
            case .failure:
                break
            }
        }
    }
}

private extension BreedService {
    func fetchBreeds(request: URLRequest, completion:@escaping DecodingServiceCompletion<[Breed]>) {
        client.fetch(request: request, completion: completion)
    }
}
