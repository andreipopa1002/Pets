import Foundation
import NetworkingS

final class AuthorizationInjector: AuthorizationInjectorInterface {
    func injectAuthorization(intoRequest: URLRequest) -> URLRequest {
        var intoRequest = intoRequest
        intoRequest.addValue("465ac605-a3a0-4c23-85ab-a3a6c06e3f9c", forHTTPHeaderField: "x-api-key")
        return  intoRequest
    }
}
