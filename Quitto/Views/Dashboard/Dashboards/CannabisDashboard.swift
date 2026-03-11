//
//  CannabisDashboard.swift
//  Quitto
//
//  Dashboard for cannabis recovery - memory, motivation, sleep patterns
//

import SwiftUI

struct CannabisDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .cannabis)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                clarityMeterCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                thcEliminationCard
                
                RecoveryPhaseCard(habit: habit)
                
                dreamRecoveryCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                naturalCopingCard
                
                QuickActionsBar(
                    habitType: .cannabis,
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
            EmergencyInterventionSheet(habitType: .cannabis)
        }
    }
    
    private var clarityMeterCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(theme.glowColor)
                Text("Mental Clarity")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                Text("\(Int(clarityProgress * 100))%")
                    .font(.titleMedium)
                    .foregroundStyle(theme.glowColor)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.textTertiary.opacity(0.2), lineWidth: 16)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .trim(from: 0, to: animateProgress ? clarityProgress : 0)
                    .stroke(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 32))
                        .foregroundStyle(theme.glowColor)
                    Text(clarityStatus)
                        .font(.labelMedium)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            
            Text(clarityDescription)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            MetricCard(
                metric: .memoryClarity,
                value: memoryValue,
                progress: memoryProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .motivation,
                value: motivationValue,
                progress: motivationProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .sleepPattern,
                value: sleepValue,
                progress: sleepProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .anxietyLevel,
                value: anxietyValue,
                progress: anxietyProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var thcEliminationCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(theme.glowColor)
                Text("THC Elimination")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.textTertiary.opacity(0.2))
                        .frame(height: 16)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * thcEliminationProgress, height: 16)
                }
            }
            .frame(height: 16)
            
            HStack {
                Text("Day 1")
                    .font(.labelSmall)
                Spacer()
                Text("Week 2")
                    .font(.labelSmall)
                Spacer()
                Text("Month 1")
                    .font(.labelSmall)
            }
            .foregroundStyle(Color.textTertiary)
            
            Text(thcDescription)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            if habit.daysSinceQuit >= 30 {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(theme.glowColor)
                    Text("Drug test ready!")
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor)
                }
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var dreamRecoveryCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "moon.stars.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Dream Recovery")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text("Cannabis suppresses REM sleep. As you recover, dreams return—often vivid!")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.md) {
                DreamStage(stage: "Suppressed", active: habit.daysSinceQuit < 3, icon: "moon.zzz.fill")
                DreamStage(stage: "Returning", active: habit.daysSinceQuit >= 3 && habit.daysSinceQuit < 14, icon: "moon.fill")
                DreamStage(stage: "Vivid", active: habit.daysSinceQuit >= 14 && habit.daysSinceQuit < 30, icon: "moon.stars.fill")
                DreamStage(stage: "Normal", active: habit.daysSinceQuit >= 30, icon: "sparkles")
            }
            
            if habit.daysSinceQuit >= 7 && habit.daysSinceQuit < 30 {
                Text("💡 Vivid dreams are a sign of REM rebound—your brain is healing!")
                    .font(.labelSmall)
                    .foregroundStyle(Color.warmth)
                    .padding(.top, Theme.Spacing.xs)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var naturalCopingCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Natural Coping Methods")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("Replace the high with natural alternatives:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            VStack(spacing: Theme.Spacing.sm) {
                NaturalCopingRow(icon: "figure.run", title: "Exercise", description: "Natural endorphins surpass any high")
                NaturalCopingRow(icon: "brain.head.profile", title: "Meditation", description: "Learn to sit with yourself")
                NaturalCopingRow(icon: "drop.fill", title: "Cold shower", description: "Dopamine boost without substances")
                NaturalCopingRow(icon: "person.2.fill", title: "Connection", description: "Real bonds, real fulfillment")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(theme.glowColor.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(theme.glowColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Computed Properties
    
    private var clarityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.3 }
        if days < 30 { return 0.3 + Double(days - 7) / 23.0 * 0.4 }
        if days < 90 { return 0.7 + Double(days - 30) / 60.0 * 0.2 }
        return min(1.0, 0.9 + Double(days - 90) / 90.0 * 0.1)
    }
    
    private var clarityStatus: String {
        if clarityProgress < 0.3 { return "Foggy" }
        if clarityProgress < 0.5 { return "Clearing" }
        if clarityProgress < 0.7 { return "Clearer" }
        if clarityProgress < 0.9 { return "Sharp" }
        return "Crystal"
    }
    
    private var clarityDescription: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Your brain is adjusting. Mental fog is normal during this phase." }
        if days < 14 { return "Cognitive function is improving. You may notice better focus." }
        if days < 30 { return "Significant mental clarity gains. Your brain is rewiring." }
        return "Your natural cognitive abilities are fully accessible again."
    }
    
    private var memoryProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.4 }
        if days < 60 { return 0.4 + Double(days - 14) / 46.0 * 0.4 }
        return min(1.0, 0.8 + Double(days - 60) / 30.0 * 0.2)
    }
    
    private var memoryValue: String {
        if memoryProgress < 0.3 { return "Healing" }
        if memoryProgress < 0.6 { return "Improving" }
        if memoryProgress < 0.9 { return "Sharp" }
        return "Excellent"
    }
    
    private var motivationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 21 { return Double(days) / 21.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 21) / 69.0 * 0.5)
    }
    
    private var motivationValue: String {
        if motivationProgress < 0.3 { return "Building" }
        if motivationProgress < 0.6 { return "Growing" }
        if motivationProgress < 0.9 { return "Strong" }
        return "Driven"
    }
    
    private var sleepProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.3 } // Sleep often worse initially
        if days < 30 { return 0.3 + Double(days - 7) / 23.0 * 0.5 }
        return min(1.0, 0.8 + Double(days - 30) / 60.0 * 0.2)
    }
    
    private var sleepValue: String {
        if sleepProgress < 0.3 { return "Disrupted" }
        if sleepProgress < 0.6 { return "Improving" }
        if sleepProgress < 0.9 { return "Better" }
        return "Restored"
    }
    
    private var anxietyProgress: Double {
        // Higher = less anxiety
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.3 } // Anxiety often increases first
        if days < 60 { return 0.3 + Double(days - 14) / 46.0 * 0.5 }
        return min(1.0, 0.8 + Double(days - 60) / 30.0 * 0.2)
    }
    
    private var anxietyValue: String {
        if anxietyProgress < 0.3 { return "Elevated" }
        if anxietyProgress < 0.6 { return "Reducing" }
        if anxietyProgress < 0.9 { return "Low" }
        return "Calm"
    }
    
    private var thcEliminationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 3 { return Double(days) / 3.0 * 0.2 }
        if days < 14 { return 0.2 + Double(days - 3) / 11.0 * 0.4 }
        if days < 30 { return 0.6 + Double(days - 14) / 16.0 * 0.3 }
        return min(1.0, 0.9 + Double(days - 30) / 60.0 * 0.1)
    }
    
    private var thcDescription: String {
        let days = habit.daysSinceQuit
        if days < 3 { return "THC is being released from fat cells and eliminated." }
        if days < 14 { return "Most active THC metabolites are clearing from your system." }
        if days < 30 { return "THC levels dropping significantly. Nearly clean!" }
        return "Most THC has been eliminated from your body."
    }
}

struct DreamStage: View {
    let stage: String
    let active: Bool
    let icon: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(active ? Color.accent : Color.textTertiary)
            Text(stage)
                .font(.labelSmall)
                .foregroundStyle(active ? Color.accent : Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(active ? Color.accent.opacity(0.15) : Color.clear)
        )
    }
}

struct NaturalCopingRow: View {
    let icon: String
    let title: String
    let description: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accent)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodySmall)
                    .fontWeight(.medium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Text(description)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, Theme.Spacing.sm)
        .padding(.horizontal, Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary.opacity(0.5) : Color.surfaceElevated.opacity(0.5))
        )
    }
}
