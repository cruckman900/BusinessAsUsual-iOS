//
//  BAUTheme.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/29/25.
//

import SwiftUI

struct BAUTheme {
    let primary: Color
    let onPrimary: Color
    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color
}

private struct BAUThemeKey: EnvironmentKey {
    static let defaultValue = BAUTheme(
        primary: Color.blue,
        onPrimary: Color.white,
        background: Color.white,
        onBackground: Color.black,
        surface: Color.white,
        onSurface: Color.black
    )
}

extension EnvironmentValues {
    var bauTheme: BAUTheme {
        get { self[BAUThemeKey.self] }
        set { self[BAUThemeKey.self] = newValue }
    }
}

extension View {
    func bauTheme(_ theme: BAUTheme) -> some View {
        environment(\.bauTheme, theme)
    }
}

enum ThemeRegistry {
    static let bau = BAUTheme(
        primary: Color("BAUPrimary"),
        onPrimary: .white,
        background: Color("BAUBackground"),
        onBackground: .black,
        surface: Color("BAUSurface"),
        onSurface: .black
    )
    
    static let hazard = BAUTheme(
        primary: Color.yellow,
        onPrimary: .black,
        background: Color.black,
        onBackground: .white,
        surface: Color.black.opacity(0.9),
        onSurface: .white
    )
}
