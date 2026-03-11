//
//  ShimmerEffect.swift
//  Quitto
//
//  Shimmer, pulse glow, neon highlight, and visual flair view modifiers.
//  iOS 26 glass-aware with iOS 18 fallbacks.
//

import SwiftUI

// MARK: - Shimmer Effect

struct EnhancedShimmerModifier: ViewModifier {
    let color: Color
    let duration: Double
    let delay: Double
    
    @State private var phase: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            color.opacity(0.15),
                            color.opacity(0.3),
                            color.opacity(0.15),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: phase * (geo.size.width * 1.6))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            withAnimation(
                                .linear(duration: duration)
                                .repeatForever(autoreverses: false)
                            ) {
                                phase = 1
                            }
                        }
                    }
                }
                .mask(content)
            )
    }
}

// MARK: - Pulse Glow Effect

struct PulseGlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let minOpacity: Double
    let maxOpacity: Double
    let speed: Double
    
    @State private var isGlowing = false
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(isGlowing ? min(maxOpacity, 0.15) : min(minOpacity, 0.05)),
                radius: isGlowing ? radius * 0.5 : radius * 0.25
            )
            .onAppear {
                withAnimation(
                    .easeInOut(duration: speed)
                    .repeatForever(autoreverses: true)
                ) {
                    isGlowing = true
                }
            }
    }
}

// MARK: - Neon Border Effect

struct NeonBorderModifier: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    let glowRadius: CGFloat
    let animated: Bool
    
    @State private var phase: Double = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        color.opacity(animated ? (0.12 + 0.08 * sin(phase)) : 0.15),
                        lineWidth: lineWidth
                    )
            )
            .onAppear {
                if animated {
                    withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                        phase = .pi * 2
                    }
                }
            }
    }
}

// MARK: - Breathing Scale Effect

struct BreathingScaleModifier: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double
    
    @State private var isExpanded = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isExpanded ? maxScale : minScale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isExpanded = true
                }
            }
    }
}

// MARK: - Gradient Text Modifier

struct GradientTextModifier: ViewModifier {
    let colors: [Color]
    let animated: Bool
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        if animated {
            content
                .overlay(
                    LinearGradient(
                        colors: colors + colors,
                        startPoint: UnitPoint(x: offset, y: 0),
                        endPoint: UnitPoint(x: offset + 1, y: 1)
                    )
                    .mask(content)
                )
                .onAppear {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        offset = 1
                    }
                }
        } else {
            content
                .overlay(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .mask(content)
                )
        }
    }
}

// MARK: - Floating Animation

struct FloatingModifier: ViewModifier {
    let yOffset: CGFloat
    let duration: Double
    
    @State private var isFloating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -yOffset : yOffset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isFloating = true
                }
            }
    }
}

// MARK: - Sparkle Overlay

struct SparkleOverlayModifier: ViewModifier {
    let color: Color
    let count: Int
    
    @State private var sparkles: [SparkleData] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(
                TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    
                    GeometryReader { geo in
                        Canvas { context, size in
                            for sparkle in sparkles {
                                let x = sparkle.x * size.width
                                let y = sparkle.y * size.height
                                let twinkle = 0.3 + 0.7 * max(0, sin(time * sparkle.speed + sparkle.phase))
                                let s = sparkle.size * twinkle
                                
                                // Draw a 4-pointed star
                                var star = Path()
                                star.move(to: CGPoint(x: x, y: y - s))
                                star.addLine(to: CGPoint(x: x + s * 0.25, y: y - s * 0.25))
                                star.addLine(to: CGPoint(x: x + s, y: y))
                                star.addLine(to: CGPoint(x: x + s * 0.25, y: y + s * 0.25))
                                star.addLine(to: CGPoint(x: x, y: y + s))
                                star.addLine(to: CGPoint(x: x - s * 0.25, y: y + s * 0.25))
                                star.addLine(to: CGPoint(x: x - s, y: y))
                                star.addLine(to: CGPoint(x: x - s * 0.25, y: y - s * 0.25))
                                star.closeSubpath()
                                
                                context.fill(star, with: .color(color.opacity(twinkle * 0.5)))
                            }
                        }
                    }
                }
                .allowsHitTesting(false)
            )
            .onAppear {
                sparkles = (0..<count).map { _ in
                    SparkleData(
                        x: CGFloat.random(in: 0.05...0.95),
                        y: CGFloat.random(in: 0.05...0.95),
                        size: CGFloat.random(in: 3...8),
                        speed: Double.random(in: 1.5...3.5),
                        phase: Double.random(in: 0...Double.pi * 2)
                    )
                }
            }
    }
    
    struct SparkleData {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let speed: Double
        let phase: Double
    }
}

// MARK: - Mode Accent Line

struct ModeAccentLineModifier: ViewModifier {
    let color: Color
    let position: Edge
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.8), color.opacity(0.2)],
                            startPoint: position == .leading ? .top : .leading,
                            endPoint: position == .leading ? .bottom : .trailing
                        )
                    )
                    .frame(
                        width: isVertical ? 3 : nil,
                        height: isVertical ? nil : 3
                    )
            }
    }
    
    private var isVertical: Bool {
        position == .leading || position == .trailing
    }
    
    private var alignment: Alignment {
        switch position {
        case .leading: return .leading
        case .trailing: return .trailing
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

// MARK: - Sparkle Overlay View (Standalone)

struct SparkleOverlayView: View {
    let color: Color
    let particleCount: Int
    
    @State private var sparkles: [SparkleParticle] = []
    @State private var animating = false
    
    struct SparkleParticle: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let delay: Double
        let duration: Double
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(sparkles) { sparkle in
                    Image(systemName: "sparkle")
                        .font(.system(size: sparkle.size))
                        .foregroundStyle(color)
                        .position(x: sparkle.x * geo.size.width, y: sparkle.y * geo.size.height)
                        .opacity(animating ? Double.random(in: 0.3...1.0) : 0)
                        .scaleEffect(animating ? CGFloat.random(in: 0.6...1.4) : 0.1)
                        .animation(
                            .easeInOut(duration: sparkle.duration)
                            .repeatForever(autoreverses: true)
                            .delay(sparkle.delay),
                            value: animating
                        )
                }
            }
        }
        .onAppear {
            sparkles = (0..<particleCount).map { _ in
                SparkleParticle(
                    x: CGFloat.random(in: 0.05...0.95),
                    y: CGFloat.random(in: 0.05...0.95),
                    size: CGFloat.random(in: 8...18),
                    delay: Double.random(in: 0...1.5),
                    duration: Double.random(in: 0.8...2.0)
                )
            }
            withAnimation {
                animating = true
            }
        }
    }
}

// MARK: - View Extensions

extension View {
    func enhancedShimmer(
        color: Color = .white,
        duration: Double = 2.5,
        delay: Double = 0
    ) -> some View {
        modifier(EnhancedShimmerModifier(color: color, duration: duration, delay: delay))
    }
    
    func pulseGlow(
        color: Color,
        radius: CGFloat = 12,
        minOpacity: Double = 0.1,
        maxOpacity: Double = 0.4,
        speed: Double = 1.5
    ) -> some View {
        modifier(PulseGlowModifier(
            color: color,
            radius: radius,
            minOpacity: minOpacity,
            maxOpacity: maxOpacity,
            speed: speed
        ))
    }
    
    func neonBorder(
        color: Color,
        cornerRadius: CGFloat = Theme.Radius.lg,
        lineWidth: CGFloat = 1.5,
        glowRadius: CGFloat = 8,
        animated: Bool = true
    ) -> some View {
        modifier(NeonBorderModifier(
            color: color,
            cornerRadius: cornerRadius,
            lineWidth: lineWidth,
            glowRadius: glowRadius,
            animated: animated
        ))
    }
    
    func breathingScale(
        min: CGFloat = 0.97,
        max: CGFloat = 1.03,
        duration: Double = 2.5
    ) -> some View {
        modifier(BreathingScaleModifier(minScale: min, maxScale: max, duration: duration))
    }
    
    func gradientText(
        colors: [Color],
        animated: Bool = false
    ) -> some View {
        modifier(GradientTextModifier(colors: colors, animated: animated))
    }
    
    func floating(
        yOffset: CGFloat = 4,
        duration: Double = 2.5
    ) -> some View {
        modifier(FloatingModifier(yOffset: yOffset, duration: duration))
    }
    
    func sparkleOverlay(
        color: Color = .white,
        count: Int = 6
    ) -> some View {
        modifier(SparkleOverlayModifier(color: color, count: count))
    }
    
    func modeAccentLine(
        color: Color,
        position: Edge = .leading
    ) -> some View {
        modifier(ModeAccentLineModifier(color: color, position: position))
    }
}
