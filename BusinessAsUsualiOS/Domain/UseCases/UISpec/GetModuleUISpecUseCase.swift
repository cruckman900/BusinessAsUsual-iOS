//
//  GetModuleUISpecUseCase.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

public protocol GetModuleUISpecUseCase {
    func execute(specUrl: String) async throws -> ModuleUISpecDTO
}

public final class GetModuleUISpecUseCaseImpl: GetModuleUISpecUseCase {
    private let repository: UISpecRepositoryProtocol

    public init(repository: UISpecRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(specUrl: String) async throws -> ModuleUISpecDTO {
        try await repository.getModuleSpec(from: specUrl)
    }
}
