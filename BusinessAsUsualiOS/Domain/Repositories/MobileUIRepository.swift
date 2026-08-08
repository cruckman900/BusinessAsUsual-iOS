import Foundation

/// Repository for fetching contract-driven UI specifications and screen data for modules.
protocol MobileUIRepository {
    /// Fetch the full UI contract for a module (screens, navigation, actions).
    func getModuleUI(moduleId: String) async throws -> ModuleUi
    
    /// Fetch row data for a specific screen (list/timeline/board/card-collection screens).
    /// - Parameters:
    ///   - moduleId: The module identifier (e.g., "hr", "crm")
    ///   - screenKey: The screen key from the contract (e.g., "employee-list")
    func getScreenData(moduleId: String, screenKey: String) async throws -> [[String: String]]
}
