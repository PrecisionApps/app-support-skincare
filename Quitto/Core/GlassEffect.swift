//
//  GlassEffect.swift
//  Quitto
//
//  iOS 26 Liquid Glass effects with iOS 18 fallbacks
//

import SwiftUI

// MARK: - Glass Effect View Modifier

struct GlassEffectModifier: ViewModifier {
    let cornerRadius: CGFloat
    let tint: Color?
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.tint(tint ?? .clear), in: .rect(cornerRadius: cornerRadius))
        } else {
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(fallbackMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(borderColor, lineWidth: 0.5)
                )
        }
    }
    
    private var fallbackMaterial: some ShapeStyle {
        colorScheme == .dark
            ? Color.surfaceDarkSecondary.opacity(0.85)
            : Color.surfaceElevated.opacity(0.9)
    }
    
    private var borderColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.1)
            : Color.black.opacity(0.05)
    }
}

// MARK: - Floating Glass Card Modifier

struct FloatingGlassModifier: ViewModifier {
    let cornerRadius: CGFloat
    let habitColor: Color?
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular.tint(habitColor?.opacity(0.1) ?? .clear),
                    in: .rect(cornerRadius: cornerRadius)
                )
                .shadow(color: (habitColor ?? .accent).opacity(0.15), radius: 12, x: 0, y: 6)
        } else {
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill((habitColor ?? .accent).opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(colorScheme == .dark ? 0.15 : 0.3),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Tab Bar Glass Container

struct TabBarGlassModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular, in: .capsule)
        } else {
            content
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.2), lineWidth: 0.5)
                )
        }
    }
}

// MARK: - Hero Card Glass Effect

struct HeroGlassModifier: ViewModifier {
    let habitColor: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular.tint(habitColor.opacity(0.05)),
                    in: .rect(cornerRadius: Theme.Radius.xl)
                )
                .shadow(color: habitColor.opacity(0.2), radius: 20, x: 0, y: 10)
        } else {
            content
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                )
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .fill(habitColor.opacity(0.05))
                        .blur(radius: 20)
                        .offset(y: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    habitColor.opacity(0.3),
                                    habitColor.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: habitColor.opacity(0.15), radius: 16, x: 0, y: 8)
        }
    }
}

// MARK: - Button Glass Effect

struct ButtonGlassModifier: ViewModifier {
    let isPressed: Bool
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular.tint(color.opacity(isPressed ? 0.3 : 0.2)),
                    in: .rect(cornerRadius: Theme.Radius.md)
                )
        } else {
            content
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                        .fill(color.opacity(isPressed ? 0.25 : 0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - View Extensions

extension View {
    func glassBackground(cornerRadius: CGFloat = Theme.Radius.lg, tint: Color? = nil) -> some View {
        modifier(GlassEffectModifier(cornerRadius: cornerRadius, tint: tint))
    }
    
    func floatingGlass(cornerRadius: CGFloat = Theme.Radius.lg, habitColor: Color? = nil) -> some View {
        modifier(FloatingGlassModifier(cornerRadius: cornerRadius, habitColor: habitColor))
    }
    
    func tabBarGlass() -> some View {
        modifier(TabBarGlassModifier())
    }
    
    func heroGlass(habitColor: Color) -> some View {
        modifier(HeroGlassModifier(habitColor: habitColor))
    }
    
    func buttonGlass(isPressed: Bool = false, color: Color = .accent) -> some View {
        modifier(ButtonGlassModifier(isPressed: isPressed, color: color))
    }
}

// MARK: - Haptic Feedback Helper

struct HapticFeedback {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Adaptive Card Style

struct AdaptiveCardStyle: ViewModifier {
    let habitColor: Color?
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(Theme.Spacing.md)
            .floatingGlass(cornerRadius: Theme.Radius.lg, habitColor: habitColor)
    }
}

extension View {
    func adaptiveCard(habitColor: Color? = nil) -> some View {
        modifier(AdaptiveCardStyle(habitColor: habitColor))
    }
}
