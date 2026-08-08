import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    // Minimal stub - adjust to your auth flow (token storage/refresh) as needed.
    private let lock = NSLock()

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        // If you have a token provider, set Authorization header here.
        // e.g. request.setValue("Bearer \(TokenStore.shared.token)", forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }

    // For now, do not implement retry logic. You can add token refresh and retry here.
    func retry(_ request: Request, for session: Session, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
