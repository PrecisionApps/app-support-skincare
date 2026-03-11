//
//  Components.swift
//  Quitto
//

import SwiftUI

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    @State private var tapCount = 0
    
    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button {
            tapCount += 1
            action()
        } label: {
            HStack(spacing: Theme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                isEnabled
                    ? LinearGradient.accentGradient
                    : LinearGradient(colors: [.textTertiary], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
            .modifier(Theme.shadow(.md))
        }
        .buttonStyle(ScaleButtonStyle())
        .onChange(of: tapCount) { _, _ in
            HapticFeedback.impact(.medium)
        }
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(Color.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                Capsule()
                    .stroke(Color.accent, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Ghost Button

struct GhostButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.xs) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(Color.textSecondary)
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
        }
        .buttonStyle(ScaleButtonStyle(scale: 0.98))
    }
}

// MARK: - Icon Button

struct IconButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void
    
    init(
        _ icon: String,
        size: CGFloat = 44,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.45, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
                .frame(width: size, height: size)
                .background(Color.surfaceSecondary.opacity(0.5))
                .clipShape(Circle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.96
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(Theme.Animation.snappy, value: configuration.isPressed)
    }
}

// MARK: - Card View

struct CardView<Content: View>: View {
    let content: Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Theme.Spacing.md)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .modifier(Theme.shadow(.md))
    }
    
    private var cardBackground: some View {
        Group {
            if colorScheme == .dark {
                Color.surfaceDarkSecondary
            } else {
                Color.surfaceElevated
            }
        }
    }
}

// MARK: - Glass Card

struct GlassCard<Content: View>: View {
    let content: Content
    let habitColor: Color?
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(habitColor: Color? = nil, @ViewBuilder content: () -> Content) {
        self.habitColor = habitColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Theme.Spacing.md)
            .floatingGlass(cornerRadius: Theme.Radius.lg, habitColor: habitColor)
    }
}

// MARK: - Progress Ring

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let gradient: LinearGradient
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        size: CGFloat = 100,
        gradient: LinearGradient = .accentGradient
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.gradient = gradient
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.textTertiary.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(Theme.Animation.slow) {
                animatedProgress = min(progress, 1.0)
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(Theme.Animation.default) {
                animatedProgress = min(newValue, 1.0)
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.displaySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text(title)
                .font(.bodySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
}

// MARK: - Shimmer Effect

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: -geo.size.width + (phase * geo.size.width * 2))
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Celebration Particles

struct CelebrationParticle: View {
    @State private var isAnimating = false
    let color: Color
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .scaleEffect(isAnimating ? 0 : 1)
            .offset(
                x: isAnimating ? CGFloat.random(in: -100...100) : 0,
                y: isAnimating ? CGFloat.random(in: -150...50) : 0
            )
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(
                    .easeOut(duration: 1.0)
                    .delay(delay)
                ) {
                    isAnimating = true
                }
            }
    }
}

struct CelebrationView: View {
    let colors: [Color] = [.accent, .warmth, .calm, .accentLight, .warmthLight]
    
    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                CelebrationParticle(
                    color: colors[index % colors.count],
                    delay: Double(index) * 0.02
                )
            }
        }
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient.accentGradient
                )
            
            VStack(spacing: Theme.Spacing.sm) {
                Text(title)
                    .font(.titleMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle, let action {
                PrimaryButton(actionTitle, action: action)
                    .frame(width: 200)
            }
        }
        .padding(Theme.Spacing.xl)
    }
}

// MARK: - Previews

#Preview("Buttons") {
    VStack(spacing: 20) {
        PrimaryButton("Start Journey", icon: "arrow.right") {}
        
        SecondaryButton("Learn More", icon: "info.circle") {}
        
        GhostButton("Skip", icon: "chevron.right") {}
        
        HStack {
            IconButton("xmark") {}
            IconButton("heart.fill") {}
            IconButton("square.and.arrow.up") {}
        }
    }
    .padding()
}

#Preview("Cards") {
    VStack(spacing: 20) {
        CardView {
            Text("Regular Card Content")
        }
        
        GlassCard {
            Text("Glass Card Content")
        }
        
        StatCard(
            title: "Days Clean",
            value: "14",
            icon: "flame.fill",
            color: .warmth
        )
    }
    .padding()
    .background(Color.surfacePrimary)
}

#Preview("Progress") {
    VStack(spacing: 40) {
        ProgressRing(progress: 0.7, size: 120)
        
        ProgressRing(progress: 0.45, gradient: .warmthGradient)
        
        CelebrationView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.surfacePrimary)
}

#Preview("Empty State") {
    EmptyStateView(
        icon: "leaf.fill",
        title: "No Habits Yet",
        message: "Start your journey by adding your first habit to quit.",
        actionTitle: "Add Habit"
    ) {}
}
