//
//  PornDashboard.swift
//  Quitto
//
//  Dashboard for porn addiction recovery - dopamine reset, focus, relationship health
//

import SwiftUI

struct PornDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .porn)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                rebootProgressCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                brainRewiringCard
                
                RecoveryPhaseCard(habit: habit)
                
                benefitsUnlockedCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                urgeSurfingCard
                
                QuickActionsBar(
                    habitType: .porn,
                    onCravingTap: { showCravingSheet = true },
                    onJournalTap: { showJournalSheet = true },
                    onEmergencyTap: { showEmergency = true }
                )
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, 100)
        }
        .onAppear {
            withAnimation(Theme.Animation.slow.delay(0.3)) {
                animateProgress = true
            }
        }
        .sheet(isPresented: $showEmergency) {
            EmergencyInterventionSheet(habitType: .porn)
        }
    }
    
    private var rebootProgressCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Text("90-Day Reboot Progress")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                Text("\(min(habit.daysSinceQuit, 90))/90 days")
                    .font(.labelMedium)
                    .foregroundStyle(theme.glowColor)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.textTertiary.opacity(0.2))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * min(Double(habit.daysSinceQuit) / 90.0, 1.0), height: 20)
                    
                    // Milestone markers
                    ForEach([7, 14, 30, 60, 90], id: \.self) { day in
                        Circle()
                            .fill(habit.daysSinceQuit >= day ? theme.glowColor : Color.textTertiary)
                            .frame(width: 8, height: 8)
                            .offset(x: geo.size.width * Double(day) / 90.0 - 4)
                    }
                }
            }
            .frame(height: 20)
            
            HStack {
                Text("Week 1")
                    .font(.labelSmall)
                Spacer()
                Text("Month 1")
                    .font(.labelSmall)
                Spacer()
                Text("90 Days")
                    .font(.labelSmall)
            }
            .foregroundStyle(Color.textTertiary)
            
            if habit.daysSinceQuit >= 90 {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Text("Reboot Complete! Keep building!")
                        .font(.bodyMedium)
                        .foregroundStyle(theme.glowColor)
                }
                .padding(.top, Theme.Spacing.sm)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [theme.glowColor.opacity(colorScheme == .dark ? 0.05 : 0.02), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(theme.glowColor.opacity(0.08), lineWidth: 0.5)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            MetricCard(
                metric: .dopamineBalance,
                value: dopamineValue,
                progress: dopamineProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .focusLevel,
                value: focusValue,
                progress: focusProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .selfControl,
                value: selfControlValue,
                progress: selfControlProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .relationshipHealth,
                value: relationshipValue,
                progress: relationshipProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var brainRewiringCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Brain Rewiring")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                RewiringRow(
                    title: "Dopamine Receptors",
                    status: dopamineReceptorStatus,
                    progress: dopamineProgress,
                    color: theme.glowColor
                )
                
                RewiringRow(
                    title: "Neural Pathways",
                    status: neuralPathwayStatus,
                    progress: neuralPathwayProgress,
                    color: theme.neonAccent
                )
                
                RewiringRow(
                    title: "Prefrontal Cortex",
                    status: prefrontalStatus,
                    progress: prefrontalProgress,
                    color: theme.glowColor
                )
            }
            
            Text("Your brain is actively creating new, healthier patterns.")
                .font(.labelSmall)
                .foregroundStyle(theme.glowColor.opacity(0.7))
                .italic()
        }
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [theme.glowColor.opacity(colorScheme == .dark ? 0.05 : 0.02), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(theme.glowColor.opacity(0.08), lineWidth: 0.5)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var benefitsUnlockedCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Benefits Unlocking")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            VStack(spacing: Theme.Spacing.sm) {
                BenefitRow(benefit: "Increased energy", unlocked: habit.daysSinceQuit >= 7, icon: "bolt.fill")
                BenefitRow(benefit: "Better focus", unlocked: habit.daysSinceQuit >= 14, icon: "scope")
                BenefitRow(benefit: "More confidence", unlocked: habit.daysSinceQuit >= 30, icon: "person.fill.checkmark")
                BenefitRow(benefit: "Deeper connections", unlocked: habit.daysSinceQuit >= 60, icon: "heart.fill")
                BenefitRow(benefit: "Full rewiring", unlocked: habit.daysSinceQuit >= 90, icon: "brain")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var urgeSurfingCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "water.waves")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Urge Surfing")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text("Urges are like waves—they rise, peak, and fall. You don't have to act on them.")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.md) {
                UrgeSurfingStep(number: "1", text: "Notice", icon: "eye.fill")
                UrgeSurfingStep(number: "2", text: "Accept", icon: "hand.raised.fill")
                UrgeSurfingStep(number: "3", text: "Breathe", icon: "wind")
                UrgeSurfingStep(number: "4", text: "Ride", icon: "water.waves")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(theme.glowColor.opacity(colorScheme == .dark ? 0.1 : 0.07))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [theme.glowColor.opacity(0.4), theme.neonAccent.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Computed Properties
    
    private var dopamineProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.4 }
        if days < 60 { return 0.4 + Double(days - 14) / 46.0 * 0.4 }
        return min(1.0, 0.8 + Double(days - 60) / 30.0 * 0.2)
    }
    
    private var dopamineValue: String {
        if dopamineProgress < 0.3 { return "Resetting" }
        if dopamineProgress < 0.6 { return "Healing" }
        if dopamineProgress < 0.9 { return "Balanced" }
        return "Optimal"
    }
    
    private var focusProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) * 0.08 }
        if days < 30 { return 0.56 + Double(days - 7) * 0.015 }
        return min(1.0, 0.905 + Double(days - 30) * 0.002)
    }
    
    private var focusValue: String {
        if focusProgress < 0.4 { return "Scattered" }
        if focusProgress < 0.7 { return "Improving" }
        if focusProgress < 0.9 { return "Sharp" }
        return "Laser"
    }
    
    private var selfControlProgress: Double {
        let days = habit.daysSinceQuit
        return min(1.0, Double(days) / 90.0)
    }
    
    private var selfControlValue: String {
        if selfControlProgress < 0.3 { return "Building" }
        if selfControlProgress < 0.6 { return "Stronger" }
        if selfControlProgress < 0.9 { return "Strong" }
        return "Mastery"
    }
    
    private var relationshipProgress: Double {
        let days = habit.daysSinceQuit
        if days < 30 { return Double(days) / 30.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 30) / 60.0 * 0.5)
    }
    
    private var relationshipValue: String {
        if relationshipProgress < 0.3 { return "Healing" }
        if relationshipProgress < 0.6 { return "Growing" }
        if relationshipProgress < 0.9 { return "Healthy" }
        return "Thriving"
    }
    
    private var dopamineReceptorStatus: String {
        let days = habit.daysSinceQuit
        if days < 14 { return "Resensitizing" }
        if days < 60 { return "Recovering" }
        return "Healthy"
    }
    
    private var neuralPathwayProgress: Double {
        min(1.0, Double(habit.daysSinceQuit) / 90.0)
    }
    
    private var neuralPathwayStatus: String {
        let days = habit.daysSinceQuit
        if days < 21 { return "Weakening old" }
        if days < 60 { return "Building new" }
        return "Rewired"
    }
    
    private var prefrontalProgress: Double {
        let days = habit.daysSinceQuit
        if days < 30 { return Double(days) / 30.0 * 0.6 }
        return min(1.0, 0.6 + Double(days - 30) / 60.0 * 0.4)
    }
    
    private var prefrontalStatus: String {
        let days = habit.daysSinceQuit
        if days < 30 { return "Strengthening" }
        if days < 90 { return "Improving" }
        return "Strong"
    }
}

struct RewiringRow: View {
    let title: String
    let status: String
    let progress: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text(status)
                .font(.labelMedium)
                .foregroundStyle(color)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 20, height: 20)
                .background(Circle().stroke(Color.textTertiary.opacity(0.2), lineWidth: 3))
        }
    }
}

struct BenefitRow: View {
    let benefit: String
    let unlocked: Bool
    let icon: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: unlocked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(unlocked ? Color.accent : Color.textTertiary)
            
            Text(benefit)
                .font(.bodySmall)
                .foregroundStyle(
                    unlocked
                        ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        : Color.textTertiary
                )
            
            Spacer()
            
            if unlocked {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.accent)
            }
        }
    }
}

struct UrgeSurfingStep: View {
    let number: String
    let text: String
    let icon: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(Color.textTertiary.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.textSecondary)
            }
            Text(text)
                .font(.labelSmall)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
