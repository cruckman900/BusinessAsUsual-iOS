import Foundation

/// Repository for discovering available business modules.
protocol ModuleRepository {
    /// Fetch all available modules from the backend.
    func getModules() async throws -> [BAUModule]
}
