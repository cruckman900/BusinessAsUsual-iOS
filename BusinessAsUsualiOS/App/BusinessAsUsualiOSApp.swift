//
//  BusinessAsUsualiOSApp.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/29/25.
//

import SwiftUI

@main
struct BusinessAsUsualiOSApp: App {
    @StateObject private var router = NavigationRouter()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .dashboard:
                            ContentView()

                        case .hr:
                            HRScreen()

                        case .finance:
                            FinanceScreen()

                        case .crm:
                            CRMScreen()

                        case .detail(let id):
                            DetailScreen(id: id)
                        }
                    }
            }
            .environmentObject(router)
            .environmentObject(themeManager)
            .bauTheme(themeManager.theme)
            .preferredColorScheme(themeManager.colorScheme)
            .tint(themeManager.theme.primary)
        }
    }
}
