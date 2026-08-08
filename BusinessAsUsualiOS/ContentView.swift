//
//  ContentView.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//
//  The dashboard landing screen. SwiftUI port of the Android DashboardScreen:
//  a "Welcome back" hero card followed by tappable module cards.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.bauTheme) private var theme

    private let modules = BAUModules.features

    var body: some View {
        BAUScreenShell(
            title: "Dashboard",
            breadcrumbs: ["Dashboard"],
            currentRoute: .dashboard
        ) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    welcomeHero

                    Text("Modules")
                        .font(.headline)
                        .foregroundColor(theme.onBackground)
                        .padding(.top, 4)

                    ForEach(modules) { module in
                        moduleCard(module)
                    }
                }
                .padding(16)
            }
        }
    }

    private var welcomeHero: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome back")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.onPrimary)
            Text(modules.isEmpty
                 ? "Loading your workspace…"
                 : "You have \(modules.count) module\(modules.count == 1 ? "" : "s") available")
                .font(.subheadline)
                .foregroundColor(theme.onPrimary.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(theme.primary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
    }

    private func moduleCard(_ module: BAUModule) -> some View {
        Button {
            router.navigate(to: module.route)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: module.icon)
                    .font(.system(size: 28))
                    .foregroundColor(theme.primary)
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(module.name)
                        .font(.headline)
                        .foregroundColor(theme.onSurface)
                    Text(module.description)
                        .font(.caption)
                        .foregroundColor(theme.onSurface.opacity(0.8))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(theme.onSurface.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.outline, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }
}
