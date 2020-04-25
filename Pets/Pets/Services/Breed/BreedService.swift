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
        var urlComponents = URLComponents(string: Environment.baseUrl + "/v1/breeds/search")!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: breed)]
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        fetchBreeds(request: request) { result in
            switch result {
            case .success(let tuple):
                completion(.success(tuple.model ?? []))
            case .failure(let error):
                if case .networkError(let nError) = error {
                    completion(.failure(nError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

private extension BreedService {
    func fetchBreeds(request: URLRequest, completion:@escaping DecodingServiceCompletion<[Breed]>) {
        client.fetch(request: request, completion: completion)
    }
}
