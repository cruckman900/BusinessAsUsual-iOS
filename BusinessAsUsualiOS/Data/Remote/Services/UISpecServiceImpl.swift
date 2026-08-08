//
//  UISpecServiceImpl.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

public protocol UISpecServiceProtocol {
    func fetchModuleSpec(from url: URL) async throws -> ModuleUISpecDTO
    func fetchScreenSpec<T: Decodable>(from url: URL, as type: T.Type) async throws -> T
}

public final class UISpecService: UISpecServiceProtocol {
    private let urlSession: URLSession

    public init(session: URLSession = .shared) {
        self.urlSession = session
    }

    public func fetchModuleSpec(from url: URL) async throws -> ModuleUISpecDTO {
        try await fetchJSON(from: url, as: ModuleUISpecDTO.self)
    }

    public func fetchScreenSpec<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
        try await fetchJSON(from: url, as: type)
    }

    private func fetchJSON<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await urlSession.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
