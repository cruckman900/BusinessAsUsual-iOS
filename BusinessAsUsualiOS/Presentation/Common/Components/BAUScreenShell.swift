//
//  BAUScreenShell.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//
//  SwiftUI port of the Android BAUScreenScaffold: top app bar, scrollable
//  content over the theme background, breadcrumb footer, plus the navigation
//  drawer (leading) and theme drawer (trailing) presented as modal overlays.
//

import Foundation
import SwiftUI

struct BAUScreenShell<Content: View>: View {
    let title: String
    let breadcrumbs: [String]
    let currentRoute: Route
    let content: Content

    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var showMenu = false
    @State private var showThemes = false

    init(
        title: String,
        breadcrumbs: [String],
        currentRoute: Route = .dashboard,
        @ViewBuilder _ content: () -> Content
    ) {
        self.title = title
        self.breadcrumbs = breadcrumbs
        self.currentRoute = currentRoute
        self.content = content()
    }

    private var theme: BAUTheme { themeManager.theme }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                BAUTopBar(
                    title: title,
                    onMenuTap: { showMenu = true },
                    onThemeTap: { showThemes = true },
                    onSettingsTap: {}
                )

                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.background)

                BAUBreadcrumbBar(crumbs: breadcrumbs, onCrumbTap: handleCrumbTap)
            }
            .background(theme.background)

            // Navigation drawer (leading edge).
            SideDrawer(isOpen: $showMenu, edge: .leading) {
                BAUNavigationDrawer(
                    items: BAUModules.navigationItems,
                    currentRoute: currentRoute,
                    onSelect: { module in
                        showMenu = false
                        router.select(module.route)
                    }
                )
            }

            // Theme drawer (trailing edge).
            SideDrawer(isOpen: $showThemes, edge: .trailing) {
                ThemeDrawer(themeManager: themeManager)
            }
        }
        .bauTheme(theme)
        .navigationBarBackButtonHidden(true)
    }

    /// Tapping a breadcrumb navigates back to that level, matching Android:
    /// the first crumb always returns to the dashboard; a module crumb reopens
    /// that module.
    private func handleCrumbTap(_ index: Int) {
        guard index < breadcrumbs.count else { return }
        if index == 0 {
            router.select(.dashboard)
            return
        }
        let label = breadcrumbs[index]
        if let module = BAUModules.features.first(where: { $0.name == label }) {
            router.select(module.route)
        } else {
            router.select(.dashboard)
        }
    }
}
