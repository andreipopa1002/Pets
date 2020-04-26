import Foundation
import Kingfisher

final class ImageRequestModifier: ImageDownloadRequestModifier {
    private let apiKey: String
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    func modified(for request: URLRequest) -> URLRequest? {
        var request = request
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        return request
    }
}
