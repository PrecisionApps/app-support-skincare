//
//  ModeAmbientBackground.swift
//  Quitto
//
//  Animated floating particles + MeshGradient backgrounds per habit type.
//  Each mode gets a unique ambient atmosphere with themed floating elements.
//

import SwiftUI

// MARK: - Mode Ambient Background

struct ModeAmbientBackground: View {
    let habitType: HabitType
    let intensity: BackgroundIntensity
    
    @Environment(\.colorScheme) private var colorScheme
    
    enum BackgroundIntensity {
        case subtle    // For scroll views behind content
        case medium    // For hero sections
        case vibrant   // For onboarding / celebration
    }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    var body: some View {
        ZStack {
            // Base color
            baseLayer
            
            // Mesh gradient layer
            theme.meshGradient
                .opacity(meshOpacity)
            
            // Floating particles
            FloatingParticlesView(
                symbols: theme.particleSymbols,
                colors: theme.ambientColors,
                glowColor: theme.glowColor,
                count: particleCount
            )
            
            // Ambient orbs
            AmbientOrbsView(
                colors: theme.ambientColors,
                glowColor: theme.glowColor,
                count: orbCount
            )
        }
        .ignoresSafeArea()
    }
    
    private var baseLayer: some View {
        Group {
            if colorScheme == .dark {
                Color.surfaceDark
            } else {
                LinearGradient(
                    colors: [Color.surfacePrimary, Color.surfaceSecondary],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
    
    private var meshOpacity: Double {
        switch intensity {
        case .subtle: return colorScheme == .dark ? 0.15 : 0.1
        case .medium: return colorScheme == .dark ? 0.25 : 0.18
        case .vibrant: return colorScheme == .dark ? 0.4 : 0.3
        }
    }
    
    private var particleCount: Int {
        switch intensity {
        case .subtle: return 8
        case .medium: return 14
        case .vibrant: return 22
        }
    }
    
    private var orbCount: Int {
        switch intensity {
        case .subtle: return 2
        case .medium: return 3
        case .vibrant: return 5
        }
    }
}

// MARK: - Floating Particles View

struct FloatingParticlesView: View {
    let symbols: [String]
    let colors: [Color]
    let glowColor: Color
    let count: Int
    
    @State private var particles: [FloatingParticle] = []
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            
            Canvas { context, size in
                for particle in particles {
                    let x = particle.baseX * size.width + sin(time * particle.speedX + particle.phaseX) * particle.amplitudeX * size.width
                    let y = particle.baseY * size.height + cos(time * particle.speedY + particle.phaseY) * particle.amplitudeY * size.height
                    let opacity = 0.15 + 0.2 * sin(time * particle.pulseSpeed + particle.pulsePhase)
                    let scale = particle.scale * (1.0 + 0.15 * sin(time * particle.pulseSpeed * 0.7 + particle.pulsePhase))
                    
                    context.opacity = max(0.05, opacity)
                    
                    let symbolName = particle.symbol
                    let resolved = context.resolve(
                        Image(systemName: symbolName)
                            .resizable()
                    )
                    
                    let iconSize = CGSize(width: 16 * scale, height: 16 * scale)
                    let rect = CGRect(
                        x: x - iconSize.width / 2,
                        y: y - iconSize.height / 2,
                        width: iconSize.width,
                        height: iconSize.height
                    )
                    
                    context.drawLayer { ctx in
                        ctx.addFilter(.shadow(color: particle.color.opacity(0.1), radius: 3))
                        ctx.draw(resolved, in: rect)
                    }
                }
            }
        }
        .onAppear {
            generateParticles()
        }
        .allowsHitTesting(false)
    }
    
    private func generateParticles() {
        particles = (0..<count).map { i in
            let symbolIndex = i % symbols.count
            let colorIndex = i % colors.count
            return FloatingParticle(
                id: i,
                symbol: symbols[symbolIndex],
                color: colors[colorIndex],
                baseX: CGFloat.random(in: 0.05...0.95),
                baseY: CGFloat.random(in: 0.05...0.95),
                amplitudeX: CGFloat.random(in: 0.03...0.1),
                amplitudeY: CGFloat.random(in: 0.02...0.08),
                speedX: Double.random(in: 0.15...0.5),
                speedY: Double.random(in: 0.1...0.4),
                phaseX: Double.random(in: 0...Double.pi * 2),
                phaseY: Double.random(in: 0...Double.pi * 2),
                scale: CGFloat.random(in: 0.6...1.8),
                pulseSpeed: Double.random(in: 0.3...0.8),
                pulsePhase: Double.random(in: 0...Double.pi * 2)
            )
        }
    }
}

struct FloatingParticle: Identifiable {
    let id: Int
    let symbol: String
    let color: Color
    let baseX: CGFloat
    let baseY: CGFloat
    let amplitudeX: CGFloat
    let amplitudeY: CGFloat
    let speedX: Double
    let speedY: Double
    let phaseX: Double
    let phaseY: Double
    let scale: CGFloat
    let pulseSpeed: Double
    let pulsePhase: Double
}

// MARK: - Ambient Orbs View

struct AmbientOrbsView: View {
    let colors: [Color]
    let glowColor: Color
    let count: Int
    
    @State private var orbs: [AmbientOrb] = []
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            
            Canvas { context, size in
                for orb in orbs {
                    let x = orb.baseX * size.width + sin(time * orb.speed + orb.phase) * orb.radius * 0.3
                    let y = orb.baseY * size.height + cos(time * orb.speed * 0.7 + orb.phase) * orb.radius * 0.2
                    let pulseFactor = 1.0 + 0.2 * sin(time * orb.pulseSpeed + orb.pulsePhase)
                    let currentRadius = orb.radius * pulseFactor
                    
                    let center = CGPoint(x: x, y: y)
                    
                    let gradient = Gradient(colors: [
                        orb.color.opacity(0.15),
                        orb.color.opacity(0.05),
                        orb.color.opacity(0.0)
                    ])
                    
                    context.drawLayer { ctx in
                        ctx.addFilter(.blur(radius: currentRadius * 0.4))
                        ctx.fill(
                            Path(ellipseIn: CGRect(
                                x: center.x - currentRadius,
                                y: center.y - currentRadius,
                                width: currentRadius * 2,
                                height: currentRadius * 2
                            )),
                            with: .radialGradient(
                                gradient,
                                center: center,
                                startRadius: 0,
                                endRadius: currentRadius
                            )
                        )
                    }
                }
            }
        }
        .onAppear {
            generateOrbs()
        }
        .allowsHitTesting(false)
    }
    
    private func generateOrbs() {
        orbs = (0..<count).map { i in
            AmbientOrb(
                id: i,
                color: colors[i % colors.count],
                baseX: CGFloat.random(in: 0.1...0.9),
                baseY: CGFloat.random(in: 0.1...0.9),
                radius: CGFloat.random(in: 60...150),
                speed: Double.random(in: 0.08...0.25),
                phase: Double.random(in: 0...Double.pi * 2),
                pulseSpeed: Double.random(in: 0.15...0.4),
                pulsePhase: Double.random(in: 0...Double.pi * 2)
            )
        }
    }
}

struct AmbientOrb: Identifiable {
    let id: Int
    let color: Color
    let baseX: CGFloat
    let baseY: CGFloat
    let radius: CGFloat
    let speed: Double
    let phase: Double
    let pulseSpeed: Double
    let pulsePhase: Double
}

// MARK: - Mode-Specific Animated Illustration Overlay

struct ModeIllustrationOverlay: View {
    let habitType: HabitType
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    var body: some View {
        switch theme.visualMetaphor {
        case .risingSmoke:
            SmokeWispsAnimation(color: theme.glowColor)
        case .clearWater:
            WaterRipplesAnimation(color: theme.glowColor)
        case .neuralNetwork:
            NeuralPulseAnimation(color: theme.glowColor)
        case .sunriseHorizon:
            SunriseGlowAnimation(color: theme.glowColor)
        case .shieldFortress:
            ShieldPulseAnimation(color: theme.glowColor)
        case .naturalGrowth:
            GrowthSproutAnimation(color: theme.glowColor)
        case .mountainClarity:
            MountainMistAnimation(color: theme.glowColor)
        case .energyWave:
            EnergyWaveAnimation(color: theme.glowColor)
        case .cleanBreeze:
            BreezeFlowAnimation(color: theme.glowColor)
        case .realWorldQuest:
            QuestStarsAnimation(color: theme.glowColor)
        case .starConstellation:
            ConstellationAnimation(color: theme.glowColor)
        }
    }
}

// MARK: - Smoke Wisps (Smoking)

struct SmokeWispsAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                for i in 0..<6 {
                    let fi = Double(i)
                    let x = size.width * (0.2 + 0.1 * fi) + sin(time * 0.3 + fi) * 20
                    let baseY = size.height * 0.8
                    let y = baseY - (time * 15 + fi * 40).truncatingRemainder(dividingBy: size.height * 0.6)
                    let opacity = max(0, 0.15 - (baseY - y) / (size.height * 0.8) * 0.15)
                    let radius = 20 + (baseY - y) / size.height * 30
                    
                    let gradient = Gradient(colors: [
                        color.opacity(opacity),
                        color.opacity(0)
                    ])
                    
                    context.drawLayer { ctx in
                        ctx.addFilter(.blur(radius: radius * 0.6))
                        ctx.fill(
                            Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 1.5)),
                            with: .radialGradient(gradient, center: CGPoint(x: x, y: y), startRadius: 0, endRadius: radius)
                        )
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Water Ripples (Alcohol)

struct WaterRipplesAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height * 0.6)
                for i in 0..<4 {
                    let fi = Double(i)
                    let expandRate = (time * 0.3 + fi * 0.8).truncatingRemainder(dividingBy: 3.0)
                    let radius = expandRate * 80
                    let opacity = max(0, 0.12 - expandRate * 0.04)
                    
                    context.stroke(
                        Path(ellipseIn: CGRect(
                            x: center.x - radius,
                            y: center.y - radius * 0.3,
                            width: radius * 2,
                            height: radius * 0.6
                        )),
                        with: .color(color.opacity(opacity)),
                        lineWidth: 2
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Neural Pulse (Porn)

struct NeuralPulseAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let nodeCount = 8
                var nodes: [(CGPoint, Double)] = []
                
                for i in 0..<nodeCount {
                    let fi = Double(i)
                    let x = size.width * (0.15 + 0.1 * fi) + sin(time * 0.4 + fi * 1.2) * 15
                    let y = size.height * (0.2 + 0.08 * fi) + cos(time * 0.35 + fi * 0.9) * 12
                    let pulse = 0.1 + 0.08 * sin(time * 1.5 + fi * 2.1)
                    nodes.append((CGPoint(x: x, y: y), pulse))
                }
                
                // Draw connections
                for i in 0..<nodes.count {
                    for j in (i+1)..<min(i+3, nodes.count) {
                        let from = nodes[i].0
                        let to = nodes[j].0
                        let pulseOpacity = (nodes[i].1 + nodes[j].1) / 2
                        
                        var path = Path()
                        path.move(to: from)
                        path.addLine(to: to)
                        
                        context.stroke(
                            path,
                            with: .color(color.opacity(pulseOpacity)),
                            lineWidth: 1
                        )
                    }
                }
                
                // Draw nodes
                for (point, pulse) in nodes {
                    let nodeRadius: CGFloat = 4 + CGFloat(pulse) * 10
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: point.x - nodeRadius / 2,
                            y: point.y - nodeRadius / 2,
                            width: nodeRadius,
                            height: nodeRadius
                        )),
                        with: .color(color.opacity(pulse + 0.05))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Sunrise Glow (Social Media)

struct SunriseGlowAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let sunY = size.height * 0.7 + sin(time * 0.15) * 10
                let sunX = size.width * 0.5
                
                for i in 0..<5 {
                    let fi = Double(i)
                    let radius = 40 + fi * 25 + sin(time * 0.3 + fi) * 8
                    let opacity = max(0, 0.08 - fi * 0.015)
                    
                    let gradient = Gradient(colors: [
                        color.opacity(opacity),
                        color.opacity(0)
                    ])
                    
                    context.drawLayer { ctx in
                        ctx.addFilter(.blur(radius: 10))
                        ctx.fill(
                            Path(ellipseIn: CGRect(
                                x: sunX - radius,
                                y: sunY - radius,
                                width: radius * 2,
                                height: radius * 2
                            )),
                            with: .radialGradient(gradient, center: CGPoint(x: sunX, y: sunY), startRadius: 0, endRadius: radius)
                        )
                    }
                }
                
                // Rays
                for i in 0..<8 {
                    let angle = Double(i) * .pi / 4 + time * 0.05
                    let rayLength = 60 + sin(time * 0.5 + Double(i)) * 15
                    let startDist: Double = 35
                    
                    var path = Path()
                    path.move(to: CGPoint(
                        x: sunX + cos(angle) * startDist,
                        y: sunY + sin(angle) * startDist
                    ))
                    path.addLine(to: CGPoint(
                        x: sunX + cos(angle) * (startDist + rayLength),
                        y: sunY + sin(angle) * (startDist + rayLength)
                    ))
                    
                    context.stroke(path, with: .color(color.opacity(0.06)), lineWidth: 2)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Shield Pulse (Gambling)

struct ShieldPulseAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let centerX = size.width * 0.5
                let centerY = size.height * 0.45
                
                for i in 0..<3 {
                    let fi = Double(i)
                    let scale = 1.0 + fi * 0.3 + sin(time * 0.4 + fi * 1.5) * 0.08
                    let opacity = max(0, 0.1 - fi * 0.03)
                    let shieldWidth = 80 * scale
                    let shieldHeight = 100 * scale
                    
                    var path = Path()
                    path.move(to: CGPoint(x: centerX, y: centerY - shieldHeight / 2))
                    path.addQuadCurve(
                        to: CGPoint(x: centerX + shieldWidth / 2, y: centerY - shieldHeight * 0.15),
                        control: CGPoint(x: centerX + shieldWidth / 2, y: centerY - shieldHeight / 2)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: centerX, y: centerY + shieldHeight / 2),
                        control: CGPoint(x: centerX + shieldWidth * 0.35, y: centerY + shieldHeight * 0.25)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: centerX - shieldWidth / 2, y: centerY - shieldHeight * 0.15),
                        control: CGPoint(x: centerX - shieldWidth * 0.35, y: centerY + shieldHeight * 0.25)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: centerX, y: centerY - shieldHeight / 2),
                        control: CGPoint(x: centerX - shieldWidth / 2, y: centerY - shieldHeight / 2)
                    )
                    
                    context.stroke(path, with: .color(color.opacity(opacity)), lineWidth: 1.5)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Growth Sprout (Sugar)

struct GrowthSproutAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                for i in 0..<5 {
                    let fi = Double(i)
                    let baseX = size.width * (0.15 + fi * 0.18)
                    let baseY = size.height * 0.85
                    let height = 30 + fi * 12 + sin(time * 0.3 + fi * 1.5) * 8
                    let sway = sin(time * 0.5 + fi * 0.8) * 6
                    
                    // Stem
                    var stem = Path()
                    stem.move(to: CGPoint(x: baseX, y: baseY))
                    stem.addQuadCurve(
                        to: CGPoint(x: baseX + sway, y: baseY - height),
                        control: CGPoint(x: baseX + sway * 0.5, y: baseY - height * 0.6)
                    )
                    context.stroke(stem, with: .color(color.opacity(0.12)), lineWidth: 2)
                    
                    // Leaf
                    let leafSize = 6 + sin(time * 0.6 + fi) * 2
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: baseX + sway - leafSize / 2,
                            y: baseY - height - leafSize / 2,
                            width: leafSize,
                            height: leafSize
                        )),
                        with: .color(color.opacity(0.15))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Mountain Mist (Cannabis)

struct MountainMistAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                // Mountain silhouette
                var mountain = Path()
                mountain.move(to: CGPoint(x: 0, y: size.height * 0.75))
                mountain.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.5))
                mountain.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.35 + sin(time * 0.1) * 3))
                mountain.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.45))
                mountain.addLine(to: CGPoint(x: size.width, y: size.height * 0.65))
                mountain.addLine(to: CGPoint(x: size.width, y: size.height))
                mountain.addLine(to: CGPoint(x: 0, y: size.height))
                mountain.closeSubpath()
                
                context.fill(mountain, with: .color(color.opacity(0.04)))
                context.stroke(mountain, with: .color(color.opacity(0.08)), lineWidth: 1)
                
                // Mist layers
                for i in 0..<4 {
                    let fi = Double(i)
                    let y = size.height * (0.5 + fi * 0.08) + sin(time * 0.2 + fi) * 5
                    let opacity = 0.04 + sin(time * 0.15 + fi * 1.2) * 0.02
                    
                    let gradient = Gradient(colors: [
                        color.opacity(0),
                        color.opacity(max(0, opacity)),
                        color.opacity(0)
                    ])
                    
                    context.fill(
                        Path(CGRect(x: 0, y: y - 15, width: size.width, height: 30)),
                        with: .linearGradient(gradient, startPoint: CGPoint(x: 0, y: y), endPoint: CGPoint(x: size.width, y: y))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Energy Wave (Caffeine)

struct EnergyWaveAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                for wave in 0..<3 {
                    let fw = Double(wave)
                    var path = Path()
                    let baseY = size.height * (0.4 + fw * 0.15)
                    let amplitude = 15 + fw * 5
                    let frequency = 0.02 + fw * 0.005
                    let speed = time * (1.0 + fw * 0.3)
                    
                    path.move(to: CGPoint(x: 0, y: baseY))
                    for x in stride(from: 0, through: size.width, by: 2) {
                        let y = baseY + sin(Double(x) * frequency + speed) * amplitude
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    context.stroke(
                        path,
                        with: .color(color.opacity(0.08 - fw * 0.02)),
                        lineWidth: 2 - fw * 0.5
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Breeze Flow (Vaping)

struct BreezeFlowAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                for i in 0..<6 {
                    let fi = Double(i)
                    let baseY = size.height * (0.15 + fi * 0.13)
                    let startX = -30 + (time * 20 + fi * 50).truncatingRemainder(dividingBy: size.width + 60)
                    let width = 60 + fi * 15
                    let opacity = 0.06 + sin(time * 0.4 + fi) * 0.03
                    
                    var path = Path()
                    path.move(to: CGPoint(x: startX, y: baseY))
                    path.addQuadCurve(
                        to: CGPoint(x: startX + width, y: baseY + sin(time * 0.3 + fi) * 8),
                        control: CGPoint(x: startX + width / 2, y: baseY - 10)
                    )
                    
                    context.stroke(
                        path,
                        with: .color(color.opacity(max(0, opacity))),
                        lineWidth: 2
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Quest Stars (Gaming)

struct QuestStarsAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                for i in 0..<10 {
                    let fi = Double(i)
                    let x = size.width * (0.1 + fi * 0.09) + sin(time * 0.3 + fi * 2) * 10
                    let y = size.height * (0.15 + (fi * 0.07).truncatingRemainder(dividingBy: 0.7)) + cos(time * 0.25 + fi * 1.5) * 8
                    let twinkle = 0.08 + 0.1 * sin(time * 2 + fi * 1.8)
                    let starSize = 3 + sin(time * 1.5 + fi * 2.3) * 1.5
                    
                    // Four-pointed star
                    var star = Path()
                    star.move(to: CGPoint(x: x, y: y - starSize))
                    star.addLine(to: CGPoint(x: x + starSize * 0.3, y: y - starSize * 0.3))
                    star.addLine(to: CGPoint(x: x + starSize, y: y))
                    star.addLine(to: CGPoint(x: x + starSize * 0.3, y: y + starSize * 0.3))
                    star.addLine(to: CGPoint(x: x, y: y + starSize))
                    star.addLine(to: CGPoint(x: x - starSize * 0.3, y: y + starSize * 0.3))
                    star.addLine(to: CGPoint(x: x - starSize, y: y))
                    star.addLine(to: CGPoint(x: x - starSize * 0.3, y: y - starSize * 0.3))
                    star.closeSubpath()
                    
                    context.fill(star, with: .color(color.opacity(max(0.02, twinkle))))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Constellation (Other)

struct ConstellationAnimation: View {
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let points: [(CGFloat, CGFloat)] = [
                    (0.2, 0.3), (0.35, 0.15), (0.5, 0.25), (0.65, 0.1),
                    (0.8, 0.3), (0.7, 0.5), (0.5, 0.45), (0.3, 0.55),
                    (0.15, 0.65), (0.45, 0.7), (0.75, 0.65), (0.85, 0.8)
                ]
                
                let resolved = points.map { p in
                    CGPoint(
                        x: p.0 * size.width + sin(time * 0.2 + Double(p.0 * 10)) * 3,
                        y: p.1 * size.height + cos(time * 0.15 + Double(p.1 * 10)) * 3
                    )
                }
                
                // Lines
                let connections: [(Int, Int)] = [
                    (0,1), (1,2), (2,3), (3,4), (4,5), (5,6), (6,7),
                    (7,0), (2,6), (5,10), (8,9), (9,10), (10,11)
                ]
                
                for (a, b) in connections {
                    guard a < resolved.count, b < resolved.count else { continue }
                    var line = Path()
                    line.move(to: resolved[a])
                    line.addLine(to: resolved[b])
                    context.stroke(line, with: .color(color.opacity(0.06)), lineWidth: 1)
                }
                
                // Stars
                for (i, point) in resolved.enumerated() {
                    let pulse = 0.1 + 0.08 * sin(time * 1.5 + Double(i) * 2)
                    let r = 3 + sin(time * 1.2 + Double(i)) * 1
                    context.fill(
                        Path(ellipseIn: CGRect(x: point.x - r, y: point.y - r, width: r * 2, height: r * 2)),
                        with: .color(color.opacity(max(0.04, pulse)))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}
