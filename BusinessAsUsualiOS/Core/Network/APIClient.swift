//
//  APIClient.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/15/26.
//

import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL: String
    private let session: Session
    
    init(baseURL: String = Configuration.apiBaseURL) {
        self.baseURL = baseURL
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        let interceptor = AuthInterceptor()
        self.session = Session(configuration: configuration, interceptor: interceptor)
    }
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        let url = baseURL + endpoint.path

        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: HTTPMethod(rawValue: endpoint.method.rawValue),
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: APIError.from(error))
                }
            }
        }
    }
    
    /// Generic request method (infers type from context).
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        try await request(endpoint, responseType: T.self)
    }
}
