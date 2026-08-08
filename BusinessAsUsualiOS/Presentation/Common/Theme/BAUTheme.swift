//
//  BAUTheme.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/29/25.
//
//  SwiftUI port of the Android theme system. Colors mirror the Material 3
//  ColorSchemes defined in external-android .../ui/theme/*.kt exactly.
//

import SwiftUI

/// A resolved color palette for a single theme + light/dark mode.
struct BAUTheme {
    let primary: Color
    let onPrimary: Color
    let secondary: Color
    let onSecondary: Color
    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color

    /// Derived low-emphasis foreground used for captions/secondary text.
    var onSurfaceVariant: Color { onSurface.opacity(0.7) }
    /// Derived hairline/border color.
    var outline: Color { onSurface.opacity(0.3) }
}

// MARK: - Environment plumbing

private struct BAUThemeKey: EnvironmentKey {
    static let defaultValue = ThemeRegistry.resolve(name: "bau", dark: false)
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

// MARK: - Theme catalog

/// A selectable theme, mirroring the Android `resolveTheme` registry.
struct ThemeOption: Identifiable, Hashable {
    let id: String       // e.g. "bau" — stable key used for persistence
    let displayName: String
}

enum ThemeRegistry {
    /// All selectable themes, in the same order the Android ThemeDrawer lists them.
    static let all: [ThemeOption] = [
        ThemeOption(id: "bau", displayName: "BAU"),
        ThemeOption(id: "hazard", displayName: "Hazard"),
        ThemeOption(id: "midnight", displayName: "Midnight"),
        ThemeOption(id: "armada", displayName: "Armada"),
        ThemeOption(id: "ocean", displayName: "Ocean"),
        ThemeOption(id: "steel", displayName: "Steel"),
        ThemeOption(id: "sunset", displayName: "Sunset"),
        ThemeOption(id: "emerald", displayName: "Emerald"),
        ThemeOption(id: "purple", displayName: "Purple"),
        ThemeOption(id: "brownstone", displayName: "Brownstone"),
    ]

    /// Resolves a theme key + mode into a concrete palette. Mirrors
    /// `ThemeRegistry.resolveTheme(themeName, dark)` on Android.
    static func resolve(name: String, dark: Bool) -> BAUTheme {
        switch name {
        case "hazard":     return dark ? hazardDark : hazardLight
        case "midnight":   return dark ? midnightDark : midnightLight
        case "armada":     return dark ? armadaDark : armadaLight
        case "ocean":      return dark ? oceanDark : oceanLight
        case "steel":      return dark ? steelDark : steelLight
        case "sunset":     return dark ? sunsetDark : sunsetLight
        case "emerald":    return dark ? emeraldDark : emeraldLight
        case "purple":     return dark ? purpleDark : purpleLight
        case "brownstone": return dark ? brownstoneDark : brownstoneLight
        case "bau":        fallthrough
        default:           return dark ? bauDark : bauLight
        }
    }

    // Convenience for the default theme environment value / previews.
    static let bau = bauLight

    // MARK: BAU
    static let bauLight = BAUTheme(
        primary: Color(hex: "#1E88E5"), onPrimary: .white,
        secondary: Color(hex: "#FFC107"), onSecondary: .black,
        background: Color(hex: "#F7F9FC"), onBackground: Color(hex: "#1A1A1A"),
        surface: .white, onSurface: Color(hex: "#1A1A1A"))
    static let bauDark = BAUTheme(
        primary: Color(hex: "#1E88E5"), onPrimary: .white,
        secondary: Color(hex: "#FFC107"), onSecondary: .black,
        background: Color(hex: "#0F1116"), onBackground: Color(hex: "#E6E6E6"),
        surface: Color(hex: "#1A1C20"), onSurface: Color(hex: "#E6E6E6"))

    // MARK: Hazard
    static let hazardLight = BAUTheme(
        primary: Color(hex: "#FFD600"), onPrimary: Color(hex: "#0A0A0A"),
        secondary: Color(hex: "#FFD600"), onSecondary: Color(hex: "#0A0A0A"),
        background: Color(hex: "#FDFDFD"), onBackground: Color(hex: "#0A0A0A"),
        surface: .white, onSurface: Color(hex: "#0A0A0A"))
    static let hazardDark = BAUTheme(
        primary: Color(hex: "#FFD600"), onPrimary: Color(hex: "#0A0A0A"),
        secondary: Color(hex: "#FFD600"), onSecondary: Color(hex: "#0A0A0A"),
        background: Color(hex: "#0A0A0A"), onBackground: .white,
        surface: Color(hex: "#1E1E1E"), onSurface: .white)

    // MARK: Midnight
    static let midnightLight = BAUTheme(
        primary: Color(hex: "#0A1A2F"), onPrimary: .white,
        secondary: Color(hex: "#00E5FF"), onSecondary: .black,
        background: Color(hex: "#F5F8FA"), onBackground: Color(hex: "#0A1A2F"),
        surface: .white, onSurface: Color(hex: "#0A1A2F"))
    static let midnightDark = BAUTheme(
        primary: Color(hex: "#00E5FF"), onPrimary: Color(hex: "#0A1A2F"),
        secondary: Color(hex: "#00E5FF"), onSecondary: Color(hex: "#0A1A2F"),
        background: Color(hex: "#0A1A2F"), onBackground: .white,
        surface: Color(hex: "#12263A"), onSurface: .white)

    // MARK: Armada
    static let armadaLight = BAUTheme(
        primary: Color(hex: "#4A148C"), onPrimary: .white,
        secondary: Color(hex: "#00E5C1"), onSecondary: .black,
        background: Color(hex: "#F8F5FC"), onBackground: Color(hex: "#4A148C"),
        surface: .white, onSurface: Color(hex: "#4A148C"))
    static let armadaDark = BAUTheme(
        primary: Color(hex: "#00E5C1"), onPrimary: Color(hex: "#1A0F2A"),
        secondary: Color(hex: "#00E5C1"), onSecondary: Color(hex: "#1A0F2A"),
        background: Color(hex: "#4A148C"), onBackground: .white,
        surface: Color(hex: "#1A0F2A"), onSurface: .white)

    // MARK: Ocean
    static let oceanLight = BAUTheme(
        primary: Color(hex: "#0277BD"), onPrimary: .white,
        secondary: Color(hex: "#26C6DA"), onSecondary: .black,
        background: Color(hex: "#E3F2FD"), onBackground: Color(hex: "#01579B"),
        surface: .white, onSurface: Color(hex: "#01579B"))
    static let oceanDark = BAUTheme(
        primary: Color(hex: "#26C6DA"), onPrimary: Color(hex: "#01579B"),
        secondary: Color(hex: "#26C6DA"), onSecondary: Color(hex: "#01579B"),
        background: Color(hex: "#01579B"), onBackground: .white,
        surface: Color(hex: "#003C6C"), onSurface: .white)

    // MARK: Steel
    static let steelLight = BAUTheme(
        primary: Color(hex: "#37474F"), onPrimary: .white,
        secondary: Color(hex: "#64B5F6"), onSecondary: .black,
        background: Color(hex: "#F0F4F7"), onBackground: Color(hex: "#37474F"),
        surface: .white, onSurface: Color(hex: "#37474F"))
    static let steelDark = BAUTheme(
        primary: Color(hex: "#64B5F6"), onPrimary: Color(hex: "#263238"),
        secondary: Color(hex: "#64B5F6"), onSecondary: Color(hex: "#263238"),
        background: Color(hex: "#263238"), onBackground: .white,
        surface: Color(hex: "#1C262B"), onSurface: .white)

    // MARK: Sunset
    static let sunsetLight = BAUTheme(
        primary: Color(hex: "#FF7043"), onPrimary: .white,
        secondary: Color(hex: "#F06292"), onSecondary: .black,
        background: Color(hex: "#FFF3E0"), onBackground: Color(hex: "#BF360C"),
        surface: .white, onSurface: Color(hex: "#BF360C"))
    static let sunsetDark = BAUTheme(
        primary: Color(hex: "#F06292"), onPrimary: Color(hex: "#BF360C"),
        secondary: Color(hex: "#F06292"), onSecondary: Color(hex: "#BF360C"),
        background: Color(hex: "#BF360C"), onBackground: .white,
        surface: Color(hex: "#4E1F0A"), onSurface: .white)

    // MARK: Emerald
    static let emeraldLight = BAUTheme(
        primary: Color(hex: "#2E7D32"), onPrimary: .white,
        secondary: Color(hex: "#FFD54F"), onSecondary: .black,
        background: Color(hex: "#E8F5E9"), onBackground: Color(hex: "#1B5E20"),
        surface: .white, onSurface: Color(hex: "#1B5E20"))
    static let emeraldDark = BAUTheme(
        primary: Color(hex: "#FFD54F"), onPrimary: Color(hex: "#1B5E20"),
        secondary: Color(hex: "#FFD54F"), onSecondary: Color(hex: "#1B5E20"),
        background: Color(hex: "#1B5E20"), onBackground: .white,
        surface: Color(hex: "#0D3B12"), onSurface: .white)

    // MARK: Purple
    static let purpleLight = BAUTheme(
        primary: Color(hex: "#6A1B9A"), onPrimary: .white,
        secondary: Color(hex: "#BA68C8"), onSecondary: .black,
        background: Color(hex: "#F3E5F5"), onBackground: Color(hex: "#4A148C"),
        surface: .white, onSurface: Color(hex: "#4A148C"))
    static let purpleDark = BAUTheme(
        primary: Color(hex: "#BA68C8"), onPrimary: Color(hex: "#4A148C"),
        secondary: Color(hex: "#BA68C8"), onSecondary: Color(hex: "#4A148C"),
        background: Color(hex: "#4A148C"), onBackground: .white,
        surface: Color(hex: "#2E0A47"), onSurface: .white)

    // MARK: Brownstone
    static let brownstoneLight = BAUTheme(
        primary: Color(hex: "#6D4C41"), onPrimary: .white,
        secondary: Color(hex: "#D7CCC8"), onSecondary: .black,
        background: Color(hex: "#EFEBE9"), onBackground: Color(hex: "#4E342E"),
        surface: .white, onSurface: Color(hex: "#4E342E"))
    static let brownstoneDark = BAUTheme(
        primary: Color(hex: "#D7CCC8"), onPrimary: Color(hex: "#4E342E"),
        secondary: Color(hex: "#D7CCC8"), onSecondary: Color(hex: "#4E342E"),
        background: Color(hex: "#4E342E"), onBackground: .white,
        surface: Color(hex: "#3E2723"), onSurface: .white)
}
