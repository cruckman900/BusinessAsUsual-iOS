//
//  BAUModule.swift
//  BusinessAsUsualiOS
//
//  A navigable feature module shown on the dashboard and in the navigation
//  drawer. The Android app discovers these from the backend at runtime; until
//  the iOS networking layer is wired up we expose the known modules statically.
//

import Foundation

struct BAUModule: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    /// SF Symbol name used for the module's icon.
    let icon: String
    /// Destination route pushed when the module is opened.
    let route: Route
}

enum BAUModules {
    /// Dashboard is always the first navigation entry (matches Android).
    static let dashboard = BAUModule(
        id: "dashboard",
        name: "Dashboard",
        description: "Your workspace overview",
        icon: "square.grid.2x2.fill",
        route: .dashboard
    )

    /// Feature modules currently available in the iOS app.
    static let features: [BAUModule] = [
        BAUModule(
            id: "hr",
            name: "HR",
            description: "People, roles, and org structure",
            icon: "person.2.fill",
            route: .hr
        ),
        BAUModule(
            id: "finance",
            name: "Finance",
            description: "Budgets, invoices, and reporting",
            icon: "dollarsign.circle.fill",
            route: .finance
        ),
        BAUModule(
            id: "crm",
            name: "CRM",
            description: "Customers, leads, and deals",
            icon: "person.crop.circle.badge.checkmark",
            route: .crm
        ),
    ]

    /// Full drawer menu: Dashboard first, then feature modules (matches
    /// Android `buildNavigationItems`).
    static var navigationItems: [BAUModule] { [dashboard] + features }
}
