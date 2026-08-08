//
//  GetEmployeeListSpecUseCase.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

public protocol GetEmployeeListSpecUseCase {
    func execute(specUrl: String) async throws -> ScreenSpecDTO
}

public final class GetEmployeeListSpecUseCaseImpl: GetEmployeeListSpecUseCase {
    private let repository: UISpecRepositoryProtocol

    public init(repository: UISpecRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(specUrl: String) async throws -> ScreenSpecDTO {
        try await repository.getEmployeeListSpec(from: specUrl)
    }
}
