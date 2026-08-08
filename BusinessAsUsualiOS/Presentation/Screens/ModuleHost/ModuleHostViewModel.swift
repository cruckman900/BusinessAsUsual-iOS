import Foundation
import Combine

/// ViewModel for the Module Host screen - fetches UI contract and manages in-module navigation.
/// Matches Android's implicit state management in ModuleHostScreen.
@MainActor
final class ModuleHostViewModel: ObservableObject {
    @Published var moduleUi: ModuleUi?
    @Published var selectedScreen: String? = "__overview__" // Client-side sentinel for Overview
    @Published var screenData: [String: [[String: String]]] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let moduleId: String
    private let getModuleUIUseCase: GetModuleUIContractUseCase
    private let getScreenDataUseCase: GetScreenDataUseCase
    
    init(moduleId: String,
         getModuleUIUseCase: GetModuleUIContractUseCase = DIContainer.shared.getModuleUIContractUseCase,
         getScreenDataUseCase: GetScreenDataUseCase = DIContainer.shared.getScreenDataUseCase) {
        self.moduleId = moduleId
        self.getModuleUIUseCase = getModuleUIUseCase
        self.getScreenDataUseCase = getScreenDataUseCase
    }
    
    func loadModuleUI() async {
        isLoading = true
        errorMessage = nil
        
        do {
            moduleUi = try await getModuleUIUseCase.execute(moduleId: moduleId)
            isLoading = false
        } catch {
            errorMessage = "Failed to load module UI: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func loadScreenData(screenKey: String) async {
        guard moduleUi != nil else { return }
        
        // Skip if data is already loaded
        if screenData[screenKey] != nil {
            return
        }
        
        do {
            let data = try await getScreenDataUseCase.execute(moduleId: moduleId, screenKey: screenKey)
            screenData[screenKey] = data
        } catch {
            // Silently fail for now - the screen will show empty state
            print("Failed to load screen data for \(screenKey): \(error)")
        }
    }
    
    func selectScreen(_ screenKey: String) {
        selectedScreen = screenKey
        
        // Load data if it's a list/timeline/board/card-collection screen
        if let moduleUi = moduleUi,
           let screen = moduleUi.screens[screenKey] {
            let needsData = screen is ListScreenSpec ||
                           screen is TimelineScreenSpec ||
                           screen is BoardScreenSpec ||
                           screen is CardCollectionScreenSpec
            
            if needsData {
                Task {
                    await loadScreenData(screenKey: screenKey)
                }
            }
        }
    }
    
    func retry() {
        Task {
            await loadModuleUI()
        }
    }
    
    /// Title for breadcrumbs (module name or screen label).
    var breadcrumbTitle: String {
        guard let moduleUi = moduleUi else { return moduleId }
        
        if selectedScreen == "__overview__" {
            return moduleUi.displayName
        }
        
        // Find the screen label from navigation items
        if let selectedScreen = selectedScreen,
           let navItem = moduleUi.navigation.items.first(where: { $0.screen == selectedScreen }) {
            return navItem.label
        }
        
        return moduleUi.displayName
    }
}
