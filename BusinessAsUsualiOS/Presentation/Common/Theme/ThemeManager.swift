//
//  ThemeManager.swift
//  BusinessAsUsualiOS
//
//  Holds the app-wide theme selection (which palette + light/dark) and
//  resolves it to a concrete `BAUTheme`. Mirrors the theme state that the
//  Android app keeps in MainActivity and feeds into BAUTheme/ThemeRegistry.
//

import SwiftUI
import Combine

final class ThemeManager: ObservableObject {
    private enum Keys {
        static let themeName = "bau.theme.name"
        static let darkMode = "bau.theme.dark"
    }

    /// Selected theme key, e.g. "bau", "ocean". Persisted across launches.
    @Published var themeName: String {
        didSet { UserDefaults.standard.set(themeName, forKey: Keys.themeName) }
    }

    /// Whether dark palettes are active. Persisted across launches.
    @Published var darkTheme: Bool {
        didSet { UserDefaults.standard.set(darkTheme, forKey: Keys.darkMode) }
    }

    init() {
        let defaults = UserDefaults.standard
        self.themeName = defaults.string(forKey: Keys.themeName) ?? "bau"
        self.darkTheme = defaults.bool(forKey: Keys.darkMode)
    }

    /// The concrete palette for the current selection.
    var theme: BAUTheme {
        ThemeRegistry.resolve(name: themeName, dark: darkTheme)
    }

    /// Drives SwiftUI's system color scheme so system controls match.
    var colorScheme: ColorScheme { darkTheme ? .dark : .light }
}
