//
//  UISpecRepositoryImpl.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

public protocol UISpecRepositoryProtocol {
    func getModuleSpec(from urlString: String) async throws -> ModuleUISpecDTO
    func getEmployeeListSpec(from urlString: String) async throws -> ScreenSpecDTO
}

public final class UISpecRepositoryImpl: UISpecRepositoryProtocol {
    private let service: UISpecServiceProtocol

    public init(service: UISpecServiceProtocol = UISpecService()) {
        self.service = service
    }

    public func getModuleSpec(from urlString: String) async throws -> ModuleUISpecDTO {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        return try await service.fetchModuleSpec(from: url)
    }

    public func getEmployeeListSpec(from urlString: String) async throws -> ScreenSpecDTO {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        // The employee list spec is a screen spec; decode as ScreenSpecDTO
        return try await service.fetchScreenSpec(from: url, as: ScreenSpecDTO.self)
    }
}
