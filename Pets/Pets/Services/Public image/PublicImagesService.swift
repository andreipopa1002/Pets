import Foundation
import NetworkingS
import Kingfisher

struct PublicImageSource {
    let url: URL
    let modifiers: KingfisherOptionsInfo
}

protocol PublicImagesServiceInterface {
    func imageSource(forBreedId breedId: Int) -> PublicImageSource
}

final class PublicImagesService {
    private let requestModifier: ImageDownloadRequestModifier

    init(
        requestModifier: ImageDownloadRequestModifier) {
        self.requestModifier = requestModifier
    }
}

extension PublicImagesService: PublicImagesServiceInterface {
    func imageSource(forBreedId breedId: Int) -> PublicImageSource {
        return PublicImageSource(
            url: imageUrl(breedId: breedId),
            modifiers: [.requestModifier(requestModifier)]
        )
    }
}

private extension PublicImagesService {
    func imageUrl(breedId: Int) -> URL {
        var urlComponents = URLComponents(string: Environment.baseUrl + "/v1/images/search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "breed_id", value: "\(breedId)"),
            URLQueryItem(name: "format", value: "src"),
            URLQueryItem(name: "size", value: "thumb")
        ]

        return urlComponents.url!
    }
}
