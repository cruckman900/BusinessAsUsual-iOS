//
//  BAUNavigationDrawer.swift
//  BusinessAsUsualiOS
//
//  SwiftUI port of the Android BAUNavigationDrawer content: profile header,
//  the module menu (Dashboard first), a version label, a Sign Out action, and
//  the "Powered by LinearDescent" attribution.
//

import SwiftUI

struct BAUNavigationDrawer: View {
    @Environment(\.bauTheme) private var theme

    let items: [BAUModule]
    let currentRoute: Route
    var onSelect: (BAUModule) -> Void
    var onSignOut: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DrawerProfileHeader()

            Divider()
                .background(theme.outline)
                .padding(.vertical, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(items) { item in
                        drawerItem(item)
                    }
                }
                .padding(.horizontal, 8)
            }

            Divider().background(theme.outline)

            VStack(alignment: .leading, spacing: 12) {
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(theme.onSurfaceVariant)

                Button(action: onSignOut) {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.body)
                        .foregroundColor(theme.onSurface)
                }

                Text("Powered by LinearDescent")
                    .font(.caption)
                    .foregroundColor(theme.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .padding(.top, 24)
    }

    @ViewBuilder
    private func drawerItem(_ item: BAUModule) -> some View {
        let isSelected = item.route == currentRoute
        Button {
            onSelect(item)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .frame(width: 24)
                    .foregroundColor(isSelected ? theme.primary : theme.onSurface)
                Text(item.name)
                    .foregroundColor(isSelected ? theme.primary : theme.onSurface)
                Spacer()
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
