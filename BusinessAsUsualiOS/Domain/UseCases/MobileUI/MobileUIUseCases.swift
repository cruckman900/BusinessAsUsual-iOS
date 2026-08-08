import Foundation

/// Use case for fetching a module's UI contract.
final class GetModuleUIContractUseCase {
    private let repository: MobileUIRepository
    
    init(repository: MobileUIRepository) {
        self.repository = repository
    }
    
    func execute(moduleId: String) async throws -> ModuleUi {
        try await repository.getModuleUI(moduleId: moduleId)
    }
}

/// Use case for fetching screen data (rows for list/timeline/board screens).
final class GetScreenDataUseCase {
    private let repository: MobileUIRepository
    
    init(repository: MobileUIRepository) {
        self.repository = repository
    }
    
    func execute(moduleId: String, screenKey: String) async throws -> [[String: String]] {
        try await repository.getScreenData(moduleId: moduleId, screenKey: screenKey)
    }
}
