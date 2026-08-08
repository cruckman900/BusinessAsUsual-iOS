import Foundation

/// Navigation destination in the app. Supports both static routes (Dashboard)
/// and dynamic module routes (any backend-discovered module).
enum AppDestination: Hashable {
    case dashboard
    case module(String) // moduleId
    
    // Legacy static routes (can be removed once all screens are dynamic)
    case hr
    case finance
    case crm
    case detail(String)
}
