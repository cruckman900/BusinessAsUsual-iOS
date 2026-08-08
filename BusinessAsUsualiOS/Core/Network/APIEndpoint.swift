//
//  APIEndpoint.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/15/26.
//
import Foundation
import Alamofire

/// A simple representation of an API endpoint used by `APIClient`.
struct APIEndpoint {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }

    let path: String
    let method: Method
    let parameters: Parameters?
    let encoding: ParameterEncoding
    let headers: HTTPHeaders?

    init(path: String,
         method: Method = .get,
         parameters: Parameters? = nil,
         encoding: ParameterEncoding = URLEncoding.default,
         headers: HTTPHeaders? = nil)
    {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }

    /// Convenience initializer for endpoints that send an `Encodable` JSON body.
    init<Body: Encodable>(path: String,
                          method: Method = .post,
                          body: Body,
                          headers: HTTPHeaders? = nil)
    {
        self.path = path
        self.method = method
        self.parameters = body.asDictionary()
        self.encoding = JSONEncoding.default
        self.headers = headers
    }
}

private extension Encodable {
    /// Encodes the value to a JSON dictionary suitable for Alamofire `Parameters`.
    func asDictionary() -> Parameters? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let dictionary = object as? Parameters else {
            return nil
        }
        return dictionary
    }
}
