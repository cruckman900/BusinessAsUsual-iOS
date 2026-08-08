import Foundation
import Alamofire

/// Alamofire-based implementation of ModuleRepository.
final class ModuleRepositoryImpl: ModuleRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getModules() async throws -> [BAUModule] {
        let endpoint = APIEndpoint(path: "/api/modules", method: .get)
        return try await apiClient.request(endpoint)
    }
}
