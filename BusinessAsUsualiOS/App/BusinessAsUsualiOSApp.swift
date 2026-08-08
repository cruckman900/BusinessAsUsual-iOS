//
//  BusinessAsUsualiOSApp.swift
//  BusinessAsUsualiOS
//
//  Main app entry point with Splash → Dashboard → Module navigation flow.
//

import SwiftUI

@main
struct BusinessAsUsualiOSApp: App {
    @StateObject private var themeManager = ThemeManager()
    @State private var showSplash = true
    @State private var navigationPath = NavigationPath()

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreen {
                    showSplash = false
                }
                .bauTheme(themeManager.theme)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(themeManager.theme.primary)
            } else {
                NavigationStack(path: $navigationPath) {
                    DashboardScreen { module in
                        // Navigate to module when tapped
                        navigationPath.append(AppDestination.module(module.id))
                    }
                    .navigationDestination(for: AppDestination.self) { destination in
                        switch destination {
                        case .dashboard:
                            DashboardScreen { module in
                                navigationPath.append(AppDestination.module(module.id))
                            }
                            
                        case .module(let moduleId):
                            ModuleHostScreen(moduleId: moduleId)
                            
                        // Legacy routes (will be removed once all screens are dynamic)
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
                .environmentObject(themeManager)
                .bauTheme(themeManager.theme)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(themeManager.theme.primary)
            }
        }
    }
}
