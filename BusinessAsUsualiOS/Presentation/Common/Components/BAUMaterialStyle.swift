//
//  BAUMaterialStyle.swift
//  BusinessAsUsualiOS
//
//  Lightweight, dependency-free "Material-flavored" building blocks driven
//  entirely by BAUTheme. These give the iOS app the same visual language as
//  the Android (Compose Material 3) and Web (MudBlazor) apps — elevation,
//  filled/tonal/outlined/text buttons with ripple-like press feedback, cards,
//  and a floating action button — using pure SwiftUI. No third-party package.
//

import SwiftUI

// MARK: - Elevation

/// Material 3-style elevation levels. Each maps to a tuned drop shadow that
/// reads consistently in light and dark mode.
enum BAUElevation: Int, CaseIterable {
    case level0 = 0
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    case level5 = 5

    /// Shadow blur radius in points.
    var radius: CGFloat {
        switch self {
        case .level0: return 0
        case .level1: return 3
        case .level2: return 6
        case .level3: return 10
        case .level4: return 14
        case .level5: return 20
        }
    }

    /// Vertical shadow offset in points.
    var y: CGFloat {
        switch self {
        case .level0: return 0
        case .level1: return 1
        case .level2: return 2
        case .level3: return 4
        case .level4: return 6
        case .level5: return 8
        }
    }

    /// Shadow opacity.
    var opacity: Double {
        switch self {
        case .level0: return 0
        case .level1: return 0.12
        case .level2: return 0.16
        case .level3: return 0.20
        case .level4: return 0.24
        case .level5: return 0.28
        }
    }
}

private struct BAUElevationModifier: ViewModifier {
    let level: BAUElevation

    func body(content: Content) -> some View {
        content.shadow(
            color: Color.black.opacity(level.opacity),
            radius: level.radius,
            x: 0,
            y: level.y
        )
    }
}

extension View {
    /// Applies a Material 3-style elevation shadow.
    func bauElevation(_ level: BAUElevation) -> some View {
        modifier(BAUElevationModifier(level: level))
    }
}

// MARK: - Card

/// A themed Material-style surface container with rounded corners and elevation.
struct BAUCard<Content: View>: View {
    @Environment(\.bauTheme) private var theme

    var cornerRadius: CGFloat = 12
    var padding: CGFloat = 16
    var elevation: BAUElevation = .level1
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(theme.outline.opacity(0.5), lineWidth: 0.5)
            )
            .bauElevation(elevation)
    }
}

extension View {
    /// Wraps the view in a themed Material-style card surface.
    func bauCard(
        cornerRadius: CGFloat = 12,
        padding: CGFloat = 16,
        elevation: BAUElevation = .level1
    ) -> some View {
        BAUCard(cornerRadius: cornerRadius, padding: padding, elevation: elevation) { self }
    }
}

// MARK: - Button styles

/// Shared visual constants for the Material-style buttons.
private enum BAUButtonMetrics {
    static let height: CGFloat = 44
    static let horizontalPadding: CGFloat = 24
    static let pressedScale: CGFloat = 0.97
    static let disabledOpacity: Double = 0.38
}

/// Filled button — high emphasis. Uses the theme's primary container.
struct BAUFilledButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        StyleBody(configuration: configuration)
    }

    struct StyleBody: View {
        @Environment(\.bauTheme) private var theme
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .font(.body.weight(.semibold))
                .foregroundColor(theme.onPrimary)
                .padding(.horizontal, BAUButtonMetrics.horizontalPadding)
                .frame(minHeight: BAUButtonMetrics.height)
                .frame(maxWidth: .infinity)
                .background(theme.primary)
                // Ripple-like press feedback: a translucent scrim of the label color.
                .overlay(Capsule().fill(theme.onPrimary.opacity(configuration.isPressed ? 0.12 : 0)))
                .clipShape(Capsule())
                .bauElevation(configuration.isPressed ? .level1 : .level2)
                .scaleEffect(configuration.isPressed ? BAUButtonMetrics.pressedScale : 1)
                .opacity(isEnabled ? 1 : BAUButtonMetrics.disabledOpacity)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

/// Tonal button — medium emphasis. A soft tint of the theme's primary.
struct BAUTonalButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        StyleBody(configuration: configuration)
    }

    struct StyleBody: View {
        @Environment(\.bauTheme) private var theme
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .font(.body.weight(.semibold))
                .foregroundColor(theme.primary)
                .padding(.horizontal, BAUButtonMetrics.horizontalPadding)
                .frame(minHeight: BAUButtonMetrics.height)
                .frame(maxWidth: .infinity)
                .background(theme.primary.opacity(0.12))
                .overlay(Capsule().fill(theme.primary.opacity(configuration.isPressed ? 0.12 : 0)))
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? BAUButtonMetrics.pressedScale : 1)
                .opacity(isEnabled ? 1 : BAUButtonMetrics.disabledOpacity)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

/// Outlined button — medium emphasis with a hairline border, transparent fill.
struct BAUOutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        StyleBody(configuration: configuration)
    }

    struct StyleBody: View {
        @Environment(\.bauTheme) private var theme
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .font(.body.weight(.semibold))
                .foregroundColor(theme.primary)
                .padding(.horizontal, BAUButtonMetrics.horizontalPadding)
                .frame(minHeight: BAUButtonMetrics.height)
                .frame(maxWidth: .infinity)
                .background(theme.primary.opacity(configuration.isPressed ? 0.12 : 0))
                .clipShape(Capsule())
                .overlay(Capsule().strokeBorder(theme.outline, lineWidth: 1))
                .scaleEffect(configuration.isPressed ? BAUButtonMetrics.pressedScale : 1)
                .opacity(isEnabled ? 1 : BAUButtonMetrics.disabledOpacity)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

/// Text button — low emphasis. No fill or border; tinted label with press scrim.
struct BAUTextButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        StyleBody(configuration: configuration)
    }

    struct StyleBody: View {
        @Environment(\.bauTheme) private var theme
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .font(.body.weight(.semibold))
                .foregroundColor(theme.primary)
                .padding(.horizontal, 12)
                .frame(minHeight: BAUButtonMetrics.height)
                .background(theme.primary.opacity(configuration.isPressed ? 0.12 : 0))
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? BAUButtonMetrics.pressedScale : 1)
                .opacity(isEnabled ? 1 : BAUButtonMetrics.disabledOpacity)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

// Dot-syntax accessors so usage reads `.buttonStyle(.bauFilled)`, etc.
extension ButtonStyle where Self == BAUFilledButtonStyle {
    static var bauFilled: BAUFilledButtonStyle { .init() }
}
extension ButtonStyle where Self == BAUTonalButtonStyle {
    static var bauTonal: BAUTonalButtonStyle { .init() }
}
extension ButtonStyle where Self == BAUOutlinedButtonStyle {
    static var bauOutlined: BAUOutlinedButtonStyle { .init() }
}
extension ButtonStyle where Self == BAUTextButtonStyle {
    static var bauText: BAUTextButtonStyle { .init() }
}

// MARK: - Floating action button

/// A Material-style floating action button. Provide a `title` to render the
/// wider "extended" (pill) variant; omit it for the circular icon-only FAB.
struct BAUFloatingActionButton: View {
    @Environment(\.bauTheme) private var theme

    let systemImage: String
    var title: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                if let title {
                    Text(title)
                        .font(.body.weight(.semibold))
                }
            }
            .foregroundColor(theme.onPrimary)
            .padding(.horizontal, title == nil ? 0 : 20)
            .frame(width: title == nil ? 56 : nil, height: 56)
            .frame(minWidth: 56)
            .background(theme.primary)
            .clipShape(title == nil ? AnyShape(Circle()) : AnyShape(Capsule()))
            .bauElevation(.level3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title ?? systemImage)
    }
}

// MARK: - Previews

#if DEBUG
private struct BAUMaterialStyle_PreviewHost: View {
    @Environment(\.bauTheme) private var theme
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button("Filled") {}.buttonStyle(.bauFilled)
                Button("Tonal") {}.buttonStyle(.bauTonal)
                Button("Outlined") {}.buttonStyle(.bauOutlined)
                Button("Text button") {}.buttonStyle(.bauText)
                Button("Disabled") {}.buttonStyle(.bauFilled).disabled(true)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Card title").font(.headline)
                    Text("An elevated Material-style surface driven by BAUTheme.")
                        .font(.subheadline)
                        .foregroundColor(theme.onSurfaceVariant)
                }
                .bauCard()

                HStack(spacing: 16) {
                    BAUFloatingActionButton(systemImage: "plus") {}
                    BAUFloatingActionButton(systemImage: "plus", title: "New") {}
                }
            }
            .padding()
        }
        .background(theme.background)
    }
}

#Preview("Light — BAU") {
    BAUMaterialStyle_PreviewHost()
        .bauTheme(ThemeRegistry.resolve(name: "bau", dark: false))
}

#Preview("Dark — Ocean") {
    BAUMaterialStyle_PreviewHost()
        .bauTheme(ThemeRegistry.resolve(name: "ocean", dark: true))
}
#endif
