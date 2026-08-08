import Foundation
import Alamofire

/// Alamofire-based implementation of MobileUIRepository.
final class MobileUIRepositoryImpl: MobileUIRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getModuleUI(moduleId: String) async throws -> ModuleUi {
        let endpoint = APIEndpoint(path: "/api/mobile-ui/\(moduleId)", method: .get)
        return try await apiClient.request(endpoint)
    }
    
    func getScreenData(moduleId: String, screenKey: String) async throws -> [[String: String]] {
        let endpoint = APIEndpoint(
            path: "/api/mobile-ui/\(moduleId)/screens/\(screenKey)/data",
            method: .get
        )
        return try await apiClient.request(endpoint)
    }
}
