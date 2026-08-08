//
//  DrawerProfileHeader.swift
//  BusinessAsUsualiOS
//
//  SwiftUI port of the Android DrawerProfileHeader: an avatar, the user's
//  name, and their location, shown at the top of the navigation drawer.
//

import SwiftUI

struct DrawerProfileHeader: View {
    @Environment(\.bauTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(theme.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Christopher Ruckman")
                    .font(.headline)
                Text("Rayland, Ohio")
                    .font(.caption)
                    .foregroundColor(theme.onSurfaceVariant)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}
