//
//  Theme.swift
//  Quitto
//

import SwiftUI

// MARK: - Color Tokens

extension Color {
    // Primary Accent - Encouraging green
    static let accent = Color(hue: 162, saturation: 84, lightness: 39)
    static let accentLight = Color(hue: 160, saturation: 60, lightness: 55)
    static let accentDark = Color(hue: 164, saturation: 86, lightness: 28)
    
    // Secondary Palette
    static let warmth = Color(hue: 24, saturation: 95, lightness: 64)
    static let warmthLight = Color(hue: 28, saturation: 90, lightness: 72)
    static let calm = Color(hue: 217, saturation: 91, lightness: 60)
    static let calmLight = Color(hue: 217, saturation: 85, lightness: 70)
    static let alert = Color(hue: 0, saturation: 84, lightness: 60)
    static let alertLight = Color(hue: 0, saturation: 75, lightness: 70)
    
    // Surfaces
    static let surfacePrimary = Color(hue: 210, saturation: 40, lightness: 98)
    static let surfaceSecondary = Color(hue: 214, saturation: 32, lightness: 91)
    static let surfaceTertiary = Color(hue: 216, saturation: 20, lightness: 95)
    static let surfaceElevated = Color(hue: 0, saturation: 0, lightness: 100)
    
    // Dark Surfaces
    static let surfaceDark = Color(hue: 220, saturation: 13, lightness: 10)
    static let surfaceDarkSecondary = Color(hue: 218, saturation: 14, lightness: 15)
    static let surfaceDarkTertiary = Color(hue: 217, saturation: 12, lightness: 20)
    
    // Text
    static let textPrimary = Color(hue: 222, saturation: 47, lightness: 11)
    static let textSecondary = Color(hue: 215, saturation: 16, lightness: 47)
    static let textTertiary = Color(hue: 215, saturation: 20, lightness: 65)
    
    // Dark Text
    static let textPrimaryDark = Color(hue: 210, saturation: 40, lightness: 98)
    static let textSecondaryDark = Color(hue: 215, saturation: 20, lightness: 65)
    static let textTertiaryDark = Color(hue: 215, saturation: 16, lightness: 50)
    
    // Semantic Colors
    static let success = Color.accent
    static let warning = Color.warmth
    static let danger = Color.alert
    static let info = Color.calm
}

// MARK: - Theme Environment

struct Theme {
    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let pill: CGFloat = 9999
    }
    
    // MARK: - Shadows
    static func shadow(_ style: ShadowStyle) -> some ViewModifier {
        ShadowModifier(style: style)
    }
    
    enum ShadowStyle {
        case sm, md, lg, glow
    }
    
    // MARK: - Animation
    enum Animation {
        static let `default` = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.7)
        static let bouncy = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6)
        static let snappy = SwiftUI.Animation.spring(response: 0.25, dampingFraction: 0.8)
        static let slow = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
    }
}

// MARK: - Shadow Modifier

struct ShadowModifier: ViewModifier {
    let style: Theme.ShadowStyle
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        switch style {
        case .sm:
            content.shadow(color: shadowColor.opacity(0.05), radius: 1, x: 0, y: 1)
        case .md:
            content.shadow(color: shadowColor.opacity(0.07), radius: 4, x: 0, y: 4)
        case .lg:
            content.shadow(color: shadowColor.opacity(0.1), radius: 10, x: 0, y: 10)
        case .glow:
            content.shadow(color: Color.accent.opacity(0.1), radius: 8, x: 0, y: 0)
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Adaptive Colors

extension View {
    func adaptiveBackground() -> some View {
        modifier(AdaptiveBackgroundModifier())
    }
}

struct AdaptiveBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                colorScheme == .dark
                    ? Color.surfaceDark
                    : Color.surfacePrimary
            )
    }
}

// MARK: - Font Extensions

extension Font {
    static let displayLarge = Font.system(size: 48, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 36, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 28, weight: .bold, design: .rounded)
    
    static let titleLarge = Font.system(size: 24, weight: .semibold)
    static let titleMedium = Font.system(size: 20, weight: .semibold)
    static let titleSmall = Font.system(size: 18, weight: .semibold)
    
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let bodyMedium = Font.system(size: 15, weight: .regular)
    static let bodySmall = Font.system(size: 13, weight: .regular)
    
    static let labelLarge = Font.system(size: 14, weight: .medium)
    static let labelMedium = Font.system(size: 12, weight: .medium)
    static let labelSmall = Font.system(size: 11, weight: .medium)
    
    static let monoLarge = Font.system(size: 32, weight: .bold, design: .monospaced)
    static let monoMedium = Font.system(size: 24, weight: .bold, design: .monospaced)
    static let monoSmall = Font.system(size: 16, weight: .semibold, design: .monospaced)
}

// MARK: - Gradient Helpers

extension LinearGradient {
    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [.accentLight, .accent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var warmthGradient: LinearGradient {
        LinearGradient(
            colors: [.warmthLight, .warmth],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var calmGradient: LinearGradient {
        LinearGradient(
            colors: [.calmLight, .calm],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func surfaceGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [.surfaceDark, .surfaceDarkSecondary],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                colors: [.surfacePrimary, .surfaceSecondary],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
