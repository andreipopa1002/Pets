import Foundation
import NetworkingS

final class AuthorizationInjector {
    let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension AuthorizationInjector: AuthorizationInjectorInterface {
    func injectAuthorization(intoRequest: URLRequest) -> URLRequest {
        var intoRequest = intoRequest
        intoRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        return  intoRequest
    }
}
