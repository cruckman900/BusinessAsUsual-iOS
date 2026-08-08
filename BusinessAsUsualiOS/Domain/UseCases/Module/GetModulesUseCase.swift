import Foundation

/// Use case for fetching and caching discovered business modules.
final class GetModulesUseCase {
    private let repository: ModuleRepository
    
    init(repository: ModuleRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [BAUModule] {
        try await repository.getModules()
    }
}
