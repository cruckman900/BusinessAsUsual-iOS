import Foundation
import Combine

/// ViewModel for the Dashboard screen - fetches discovered modules from the backend.
/// Matches Android's DashboardViewModel.
@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var modules: [BAUModule] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getModulesUseCase: GetModulesUseCase
    
    init(getModulesUseCase: GetModulesUseCase = DIContainer.shared.getModulesUseCase) {
        self.getModulesUseCase = getModulesUseCase
    }
    
    func loadModules() async {
        isLoading = true
        errorMessage = nil
        
        do {
            modules = try await getModulesUseCase.execute()
            isLoading = false
        } catch {
            errorMessage = "Failed to load modules: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func retry() {
        Task {
            await loadModules()
        }
    }
}
