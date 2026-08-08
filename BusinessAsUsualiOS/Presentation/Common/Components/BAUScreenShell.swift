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
    let content: Content

    @EnvironmentObject private var themeManager: ThemeManager

    @State private var showMenu = false
    @State private var showThemes = false

    init(
        title: String,
        breadcrumbs: [String],
        currentRoute: Route? = nil, // Optional for backward compatibility
        @ViewBuilder _ content: () -> Content
    ) {
        self.title = title
        self.breadcrumbs = breadcrumbs
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

            // Navigation drawer (leading edge) - TODO: Phase 6 - restore with dynamic modules
            SideDrawer(isOpen: $showMenu, edge: .leading) {
                VStack {
                    Text("Navigation")
                        .font(.title2)
                        .padding()
                    Text("Module navigation will be restored in Phase 6")
                        .font(.caption)
                        .foregroundColor(theme.onBackground.opacity(0.6))
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.background)
            }

            // Theme drawer (trailing edge).
            SideDrawer(isOpen: $showThemes, edge: .trailing) {
                ThemeDrawer(themeManager: themeManager)
            }
        }
        .bauTheme(theme)
        .navigationBarBackButtonHidden(true)
    }

    /// Tapping a breadcrumb navigates back to that level - TODO: Phase 6 - restore navigation
    private func handleCrumbTap(_ index: Int) {
        // Disabled until Phase 6 navigation integration
        print("Breadcrumb tapped: \(breadcrumbs[index])")
    }
}
