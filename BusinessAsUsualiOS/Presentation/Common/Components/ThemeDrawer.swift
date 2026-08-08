//
//  ThemeDrawer.swift
//  BusinessAsUsualiOS
//
//  SwiftUI port of the Android ThemeDrawer: a "Dark Mode" toggle followed by
//  the list of all selectable themes, with the active one highlighted.
//

import SwiftUI

struct ThemeDrawer: View {
    @Environment(\.bauTheme) private var theme
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Themes")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(16)

            Toggle(isOn: $themeManager.darkTheme) {
                Text("Dark Mode")
            }
            .tint(theme.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Divider().background(theme.outline)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(ThemeRegistry.all) { option in
                        themeRow(option)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }
        }
        .padding(.top, 24)
    }

    @ViewBuilder
    private func themeRow(_ option: ThemeOption) -> some View {
        let isSelected = themeManager.themeName == option.id
        // Swatch previews the theme's primary color.
        let preview = ThemeRegistry.resolve(name: option.id, dark: themeManager.darkTheme)
        Button {
            themeManager.themeName = option.id
        } label: {
            HStack(spacing: 16) {
                Circle()
                    .fill(preview.primary)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(theme.outline, lineWidth: 1))
                Text(option.displayName)
                    .foregroundColor(isSelected ? theme.primary : theme.onSurface)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(theme.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(isSelected ? theme.primary.opacity(0.12) : Color.clear)
            )
        }
    }
}
