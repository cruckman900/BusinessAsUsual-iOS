//
//  APIError.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/15/26.
//
import Foundation
import Alamofire

enum APIError: Error {
    case network(Error)
    case decoding(Error)
    case unknown

    static func from(_ error: AFError) -> APIError {
        return .network(error)
    }

    static func from(_ error: Error) -> APIError {
        return .network(error)
    }
}
