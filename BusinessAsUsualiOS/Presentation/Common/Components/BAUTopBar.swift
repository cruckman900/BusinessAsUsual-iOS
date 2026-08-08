//
//  BAUTopBar.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//
//  SwiftUI port of the Android BAUTopBar: leading menu button, brand logo +
//  "Business As Usual" title with the current screen as a subtitle, and
//  trailing theme + settings buttons. Colored with the active theme's primary.
//

import SwiftUI

struct BAUTopBar: View {
    @Environment(\.bauTheme) private var theme

    /// The current screen name, shown as a subtitle under the app name.
    let title: String
    var onMenuTap: () -> Void = {}
    var onThemeTap: () -> Void = {}
    var onSettingsTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onMenuTap) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .semibold))
            }
            .accessibilityLabel("Menu")

            // Brand logo (SF Symbol placeholder for the app icon/logo).
            Image(systemName: "briefcase.fill")
                .font(.system(size: 22))

            VStack(alignment: .leading, spacing: 0) {
                Text("Business As Usual")
                    .font(.headline)
                    .fontWeight(.bold)
                if !title.isEmpty {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(theme.onPrimary.opacity(0.8))
                }
            }

            Spacer(minLength: 8)

            Button(action: onThemeTap) {
                Image(systemName: "circle.lefthalf.filled")
                    .font(.system(size: 20))
            }
            .accessibilityLabel("Theme")

            Button(action: onSettingsTap) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
            }
            .accessibilityLabel("Settings")
        }
        .foregroundColor(theme.onPrimary)
        .padding(.horizontal, 16)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(theme.primary)
    }
}
