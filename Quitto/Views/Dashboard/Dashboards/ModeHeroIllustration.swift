//
//  ModeHeroIllustration.swift
//  Quitto
//
//  Programmatic SwiftUI hero illustrations per habit type.
//  Each mode gets a unique, animated visual identity composition.
//

import SwiftUI

// MARK: - Mode Hero Illustration

struct ModeHeroIllustration: View {
    let habitType: HabitType
    let size: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            theme.glowColor.opacity(colorScheme == .dark ? 0.25 : 0.15),
                            theme.glowColor.opacity(0)
                        ],
                        center: .center,
                        startRadius: size * 0.2,
                        endRadius: size * 0.55
                    )
                )
                .frame(width: size * 1.1, height: size * 1.1)
                .breathingScale(min: 0.95, max: 1.05, duration: 3)
            
            // Mode-specific illustration
            illustrationForMode
                .frame(width: size, height: size)
        }
    }
    
    @ViewBuilder
    private var illustrationForMode: some View {
        switch habitType {
        case .smoking:
            SmokingHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .alcohol:
            AlcoholHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .porn:
            BrainRebootHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .socialMedia:
            SocialMediaHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .gambling:
            GamblingHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .sugar:
            SugarHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .cannabis:
            CannabisHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .caffeine:
            CaffeineHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .vaping:
            VapingHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .gaming:
            GamingHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        case .other:
            GenericHeroIllustration(theme: theme, size: size, colorScheme: colorScheme)
        }
    }
}

// MARK: - Smoking Hero

private struct SmokingHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            // Background circle with gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Inner decorative ring
            Circle()
                .stroke(theme.glowColor.opacity(0.15), lineWidth: 2)
                .frame(width: size * 0.75, height: size * 0.75)
            
            // Lungs icon - primary
            Image(systemName: "lungs.fill")
                .font(.system(size: size * 0.3, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .floating(yOffset: 3, duration: 2.5)
            
            // Surrounding icons
            ForEach(0..<4) { i in
                let angle = Double(i) * .pi / 2 + .pi / 4
                let radius = size * 0.32
                Image(systemName: ["wind", "heart.fill", "leaf.fill", "sparkle"][i])
                    .font(.system(size: size * 0.08))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.5))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Alcohol Hero

private struct AlcoholHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Water drop pattern
            Circle()
                .stroke(theme.glowColor.opacity(0.1), lineWidth: 1.5)
                .frame(width: size * 0.8, height: size * 0.8)
            
            Circle()
                .stroke(theme.glowColor.opacity(0.08), lineWidth: 1)
                .frame(width: size * 0.65, height: size * 0.65)
            
            Image(systemName: "drop.fill")
                .font(.system(size: size * 0.28, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .floating(yOffset: 3, duration: 3)
            
            ForEach(0..<3) { i in
                let angle = Double(i) * .pi * 2 / 3 - .pi / 2
                let radius = size * 0.35
                Image(systemName: ["moon.stars.fill", "brain.head.profile", "sparkle"][i])
                    .font(.system(size: size * 0.07))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.45))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Brain Reboot Hero (Porn)

private struct BrainRebootHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Neural network circles
            ForEach(0..<6) { i in
                let angle = Double(i) * .pi / 3
                let radius = size * 0.28
                Circle()
                    .fill(theme.glowColor.opacity(0.08))
                    .frame(width: size * 0.12, height: size * 0.12)
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: size * 0.28, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .floating(yOffset: 2, duration: 2)
            
            // Bolt accents
            ForEach(0..<4) { i in
                let angle = Double(i) * .pi / 2 + .pi / 4
                let radius = size * 0.33
                Image(systemName: "bolt.fill")
                    .font(.system(size: size * 0.06))
                    .foregroundStyle(theme.neonAccent.opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Social Media Hero

private struct SocialMediaHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Sunrise arc
            Circle()
                .trim(from: 0.25, to: 0.75)
                .stroke(
                    LinearGradient(
                        colors: [theme.neonAccent.opacity(0.3), theme.glowColor.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
                .frame(width: size * 0.7, height: size * 0.7)
                .rotationEffect(.degrees(180))
            
            Image(systemName: "sun.max.fill")
                .font(.system(size: size * 0.25, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .floating(yOffset: 3, duration: 3.5)
            
            ForEach(0..<5) { i in
                let angle = Double(i) * .pi * 2 / 5 - .pi / 2
                let radius = size * 0.35
                Image(systemName: ["person.fill", "leaf.fill", "eye.fill", "book.fill", "figure.walk"][i])
                    .font(.system(size: size * 0.06))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Gambling Hero

private struct GamblingHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Shield outline
            Image(systemName: "shield.fill")
                .font(.system(size: size * 0.5))
                .foregroundStyle(theme.glowColor.opacity(0.08))
            
            Image(systemName: "shield.fill")
                .font(.system(size: size * 0.28, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .floating(yOffset: 2, duration: 2.5)
            
            // Dollar signs orbit
            ForEach(0..<3) { i in
                let angle = Double(i) * .pi * 2 / 3 - .pi / 6
                let radius = size * 0.33
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: size * 0.08))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Sugar Hero

private struct SugarHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Leaf ring
            ForEach(0..<8) { i in
                let angle = Double(i) * .pi / 4
                let radius = size * 0.3
                Image(systemName: "leaf.fill")
                    .font(.system(size: size * 0.06))
                    .foregroundStyle(theme.glowColor.opacity(0.15))
                    .rotationEffect(.radians(angle + .pi / 2))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
            
            Image(systemName: "heart.fill")
                .font(.system(size: size * 0.25, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .floating(yOffset: 3, duration: 2)
        }
    }
}

// MARK: - Cannabis Hero

private struct CannabisHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Mountain peaks
            Image(systemName: "mountain.2.fill")
                .font(.system(size: size * 0.35))
                .foregroundStyle(theme.glowColor.opacity(0.08))
                .offset(y: size * 0.12)
            
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.25, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .floating(yOffset: 3, duration: 3)
            
            ForEach(0..<4) { i in
                let angle = Double(i) * .pi / 2
                let radius = size * 0.32
                Image(systemName: ["sun.max.fill", "brain.head.profile", "moon.stars.fill", "figure.mind.and.body"][i])
                    .font(.system(size: size * 0.06))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Caffeine Hero

private struct CaffeineHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Energy rings
            ForEach(0..<3) { i in
                Circle()
                    .stroke(theme.neonAccent.opacity(0.08 + Double(i) * 0.03), lineWidth: 1.5)
                    .frame(
                        width: size * (0.5 + CGFloat(i) * 0.15),
                        height: size * (0.5 + CGFloat(i) * 0.15)
                    )
            }
            
            Image(systemName: "bolt.fill")
                .font(.system(size: size * 0.28, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .floating(yOffset: 2, duration: 1.8)
            
            ForEach(0..<3) { i in
                let angle = Double(i) * .pi * 2 / 3 - .pi / 2
                let radius = size * 0.35
                Image(systemName: ["sunrise.fill", "battery.100", "moon.fill"][i])
                    .font(.system(size: size * 0.07))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Vaping Hero

private struct VapingHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Breeze lines
            ForEach(0..<4) { i in
                let yOffset = CGFloat(i) * size * 0.06 - size * 0.09
                Capsule()
                    .fill(theme.glowColor.opacity(0.06 + Double(i) * 0.02))
                    .frame(width: size * (0.4 - CGFloat(i) * 0.05), height: 2)
                    .offset(y: yOffset + size * 0.18)
            }
            
            Image(systemName: "wind")
                .font(.system(size: size * 0.28, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .floating(yOffset: 3, duration: 2.5)
            
            ForEach(0..<4) { i in
                let angle = Double(i) * .pi / 2 + .pi / 4
                let radius = size * 0.33
                Image(systemName: ["lungs.fill", "leaf.fill", "sparkle", "heart.fill"][i])
                    .font(.system(size: size * 0.06))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Gaming Hero

private struct GamingHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // XP bar arc
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    LinearGradient(
                        colors: [theme.neonAccent.opacity(0.3), theme.glowColor.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: size * 0.7, height: size * 0.7)
                .rotationEffect(.degrees(-135))
            
            Image(systemName: "trophy.fill")
                .font(.system(size: size * 0.25, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .floating(yOffset: 3, duration: 2)
            
            ForEach(0..<5) { i in
                let angle = Double(i) * .pi * 2 / 5 - .pi / 2
                let radius = size * 0.35
                Image(systemName: ["figure.run", "star.fill", "person.2.fill", "paintbrush.fill", "book.fill"][i])
                    .font(.system(size: size * 0.06))
                    .foregroundStyle(theme.ambientColors[i % theme.ambientColors.count].opacity(0.4))
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
        }
    }
}

// MARK: - Generic Hero

private struct GenericHeroIllustration: View {
    let theme: HabitModeTheme
    let size: CGFloat
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.ambientColors[0].opacity(0.2),
                            theme.ambientColors[1].opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Star points
            ForEach(0..<8) { i in
                let angle = Double(i) * .pi / 4
                let radius = size * 0.3
                Circle()
                    .fill(theme.glowColor.opacity(0.08))
                    .frame(width: 6, height: 6)
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
            }
            
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.28, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .floating(yOffset: 3, duration: 2.5)
        }
    }
}
