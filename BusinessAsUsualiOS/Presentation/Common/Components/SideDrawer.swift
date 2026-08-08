//
//  SideDrawer.swift
//  BusinessAsUsualiOS
//
//  A lightweight modal side drawer that slides in from the leading or trailing
//  edge over a dimming scrim — the SwiftUI equivalent of Material's
//  ModalNavigationDrawer used throughout the Android app.
//

import SwiftUI

enum DrawerEdge {
    case leading
    case trailing
}

struct SideDrawer<DrawerContent: View>: View {
    @Environment(\.bauTheme) private var theme

    @Binding var isOpen: Bool
    let edge: DrawerEdge
    var width: CGFloat = 300
    @ViewBuilder let drawerContent: () -> DrawerContent

    var body: some View {
        ZStack(alignment: edge == .leading ? .leading : .trailing) {
            if isOpen {
                // Scrim — tap to dismiss.
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture { close() }

                drawerContent()
                    .frame(width: width)
                    .frame(maxHeight: .infinity)
                    .background(theme.surface)
                    .foregroundColor(theme.onSurface)
                    .ignoresSafeArea(edges: .vertical)
                    .transition(.move(edge: edge == .leading ? .leading : .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isOpen)
    }

    private func close() { isOpen = false }
}
