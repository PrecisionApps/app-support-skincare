//
//  DashboardComponents.swift
//  Quitto
//
//  Reusable dashboard components for habit-specific views
//

import SwiftUI

// MARK: - Hero Timer Card

struct HeroTimerCard: View {
    let habit: Habit
    let animateProgress: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var timeline: RecoveryTimeline {
        RecoveryTimeline.timeline(for: habit.habitType)
    }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Mode identity badge at top
            ModeIdentityBadge(habitType: habit.habitType, style: .compact)
            
            // Time display with mode-specific gradient
            VStack(spacing: Theme.Spacing.xs) {
                Text(timeDisplay)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .contentTransition(.numericText())
                    .enhancedShimmer(color: theme.neonAccent.opacity(0.5), duration: 3, delay: 1)
                
                Text(timeLabel)
                    .font(.bodyMedium)
                    .foregroundStyle(Color.textSecondary)
            }
            
            // Mode Hero Illustration with Progress Ring
            ZStack {
                // Outer progress ring
                ProgressRing(
                    progress: animateProgress ? timeline.progress(days: habit.daysSinceQuit) : 0,
                    lineWidth: 14,
                    size: 200,
                    gradient: LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                // Mode-specific hero illustration (replaces generic icon)
                VStack(spacing: Theme.Spacing.sm) {
                    ModeHeroIllustration(habitType: habit.habitType, size: 110)
                    
                    if let nextMilestone = timeline.nextMilestone(days: habit.daysSinceQuit) {
                        Text("Next: \(nextMilestone.timeDescription)")
                            .font(.labelSmall)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
            .pulseGlow(color: theme.glowColor, radius: 20, minOpacity: 0.05, maxOpacity: 0.15, speed: 2.5)
            
            // Streak badge with mode-specific label
            if habit.streakDays > 0 {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(Color.warmth)
                        .symbolEffect(.bounce, options: .repeating.speed(0.5))
                    
                    Text("\(habit.streakDays) day streak")
                        .font(.labelLarge)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text("•")
                        .foregroundStyle(Color.textTertiary)
                    
                    Text(theme.modeSpecificTerms.streakLabel)
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .background(
                    Capsule()
                        .fill(Color.warmth.opacity(0.15))
                )
            }
            
            // Victory phrase instead of generic tagline
            Text(theme.modeSpecificTerms.victoryPhrase)
                .font(.bodyMedium)
                .foregroundStyle(theme.glowColor)
                .italic()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.xl)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                
                // Subtle mode-colored gradient overlay
                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.glowColor.opacity(colorScheme == .dark ? 0.06 : 0.03),
                                .clear,
                                theme.neonAccent.opacity(colorScheme == .dark ? 0.04 : 0.02)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            theme.glowColor.opacity(0.2),
                            theme.glowColor.opacity(0.05),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .modifier(Theme.shadow(.md))
    }
    
    private var timeDisplay: String {
        let days = habit.daysSinceQuit
        if days > 0 { return "\(days)" }
        let hours = habit.hoursSinceQuit
        if hours > 0 { return "\(hours)" }
        return "\(habit.minutesSinceQuit)"
    }
    
    private var timeLabel: String {
        let days = habit.daysSinceQuit
        let terms = theme.modeSpecificTerms
        if days > 0 { return days == 1 ? "day \(terms.streakLabel)" : "days \(terms.streakLabel)" }
        let hours = habit.hoursSinceQuit
        if hours > 0 { return hours == 1 ? "hour \(terms.streakLabel)" : "hours \(terms.streakLabel)" }
        return "minutes \(terms.streakLabel)"
    }
}

// MARK: - Metric Card

struct MetricCard: View {
    let metric: DashboardMetric
    let value: String
    let progress: Double
    let habitColor: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Image(systemName: metric.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [habitColor, habitColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Spacer()
                
                // Mini progress indicator with gradient stroke
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [habitColor, habitColor.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .stroke(Color.textTertiary.opacity(0.2), lineWidth: 3)
                    )
            }
            
            Text(value)
                .font(.titleLarge)
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text(metric.displayName)
                .font(.labelSmall)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                
                // Subtle mode-colored tint in the corner
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                habitColor.opacity(colorScheme == .dark ? 0.06 : 0.03),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(habitColor.opacity(0.08), lineWidth: 0.5)
        )
        .modifier(Theme.shadow(.sm))
    }
}

// MARK: - Recovery Phase Card

struct RecoveryPhaseCard: View {
    let habit: Habit
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var timeline: RecoveryTimeline {
        RecoveryTimeline.timeline(for: habit.habitType)
    }
    
    private var currentMilestone: RecoveryMilestone? {
        timeline.currentMilestone(days: habit.daysSinceQuit)
    }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Current Phase")
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor.opacity(0.7))
                    
                    if let milestone = currentMilestone {
                        Text(milestone.title)
                            .font(.titleMedium)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    }
                }
                
                Spacer()
                
                if let milestone = currentMilestone {
                    ZStack {
                        Circle()
                            .fill(theme.glowColor.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: milestone.icon)
                            .font(.system(size: 22))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.neonAccent, theme.glowColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            
            if let milestone = currentMilestone {
                Text(milestone.description)
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                
                Divider()
                    .overlay(theme.glowColor.opacity(0.1))
                
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Health Benefits Unlocked:")
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor.opacity(0.6))
                    
                    ForEach(milestone.healthBenefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [theme.neonAccent, theme.glowColor],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            
                            Text(benefit)
                                .font(.bodySmall)
                                .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                        }
                    }
                    
                    if !milestone.sources.isEmpty {
                        SourceAttributionLabel(source: milestone.sources.joined(separator: ", "))
                            .padding(.top, Theme.Spacing.xs)
                    }
                }
                
                MedicalDisclaimerBanner(compact: true)
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
                            colors: [
                                theme.glowColor.opacity(colorScheme == .dark ? 0.05 : 0.02),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [theme.glowColor.opacity(0.15), theme.glowColor.opacity(0.03)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        )
        .modifier(Theme.shadow(.sm))
    }
}

// MARK: - Savings Card

struct SavingsCard: View {
    let habit: Habit
    let showMoney: Bool
    let showTime: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            if showMoney && habit.moneySaved > 0 {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    HStack(spacing: Theme.Spacing.xs) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.warmth, theme.neonAccent],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Saved")
                            .font(.labelSmall)
                            .foregroundStyle(Color.textTertiary)
                    }
                    
                    Text(formatMoney(habit.moneySaved))
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if showMoney && showTime && habit.moneySaved > 0 {
                Divider()
                    .frame(height: 50)
                    .overlay(theme.glowColor.opacity(0.1))
            }
            
            if showTime {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    HStack(spacing: Theme.Spacing.xs) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.calm, theme.glowColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Time Reclaimed")
                            .font(.labelSmall)
                            .foregroundStyle(Color.textTertiary)
                    }
                    
                    Text(formatTime(habit.timeSavedMinutes))
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                            colors: [
                                theme.glowColor.opacity(colorScheme == .dark ? 0.04 : 0.02),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(theme.glowColor.opacity(0.06), lineWidth: 0.5)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private func formatMoney(_ amount: Double) -> String {
        if amount >= 1000 {
            return "$\(String(format: "%.1f", amount / 1000))k"
        }
        return "$\(Int(amount))"
    }
    
    private func formatTime(_ minutes: Int) -> String {
        if minutes >= 1440 {
            let days = minutes / 1440
            return "\(days)d"
        } else if minutes >= 60 {
            let hours = minutes / 60
            return "\(hours)h"
        }
        return "\(minutes)m"
    }
}

// MARK: - Units Avoided Card

struct UnitsAvoidedCard: View {
    let habit: Habit
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.xs) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text(theme.modeSpecificTerms.unitLabel.capitalized)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
            }
            
            Text("\(habit.unitsAvoided)")
                .font(.displayMedium)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
}

// MARK: - Motivational Fact Card

struct MotivationalFactCard: View {
    let fact: MotivationalFact
    let habitColor: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [habitColor.opacity(0.2), habitColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: fact.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [habitColor, habitColor.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(fact.timeframe)
                    .font(.labelMedium)
                    .foregroundStyle(habitColor)
                
                Text(fact.fact)
                    .font(.bodySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                
                if !fact.source.isEmpty {
                    SourceAttributionLabel(source: fact.source)
                }
            }
            
            Spacer()
        }
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                habitColor.opacity(colorScheme == .dark ? 0.04 : 0.02),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(habitColor.opacity(0.06), lineWidth: 0.5)
        )
    }
}

// MARK: - Quick Actions Bar

struct QuickActionsBar: View {
    let habitType: HabitType
    let onCravingTap: () -> Void
    let onJournalTap: () -> Void
    let onEmergencyTap: () -> Void
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            QuickActionButton(
                title: theme.modeSpecificTerms.emergencyTitle.components(separatedBy: " ").first ?? "Craving",
                icon: "exclamationmark.triangle.fill",
                color: .alert
            ) {
                onCravingTap()
            }
            
            QuickActionButton(
                title: "Journal",
                icon: "pencil.line",
                color: .calm
            ) {
                onJournalTap()
            }
            
            QuickActionButton(
                title: "SOS",
                icon: "sos",
                color: theme.glowColor
            ) {
                onEmergencyTap()
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(title)
                    .font(.labelSmall)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .fill(color)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Milestone Timeline

struct MilestoneTimeline: View {
    let habit: Habit
    let showAll: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var timeline: RecoveryTimeline {
        RecoveryTimeline.timeline(for: habit.habitType)
    }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    private var visibleMilestones: [RecoveryMilestone] {
        if showAll {
            return timeline.milestones
        }
        // Show completed + next 2
        let days = habit.daysSinceQuit
        let completed = timeline.milestones.filter { $0.dayThreshold <= days }
        let upcoming = timeline.milestones.filter { $0.dayThreshold > days }.prefix(2)
        return completed + upcoming
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text("Your Journey")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Spacer()
                
                // Mode label
                Text(theme.modeSpecificTerms.progressVerb.capitalized)
                    .font(.labelSmall)
                    .foregroundStyle(theme.glowColor)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(visibleMilestones.enumerated()), id: \.element.id) { index, milestone in
                    MilestoneRow(
                        milestone: milestone,
                        isUnlocked: milestone.dayThreshold <= habit.daysSinceQuit,
                        isCurrent: isCurrentMilestone(milestone),
                        habitColor: theme.glowColor,
                        neonColor: theme.neonAccent,
                        isLast: index == visibleMilestones.count - 1
                    )
                }
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
                            colors: [
                                theme.glowColor.opacity(colorScheme == .dark ? 0.04 : 0.02),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(theme.glowColor.opacity(0.06), lineWidth: 0.5)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private func isCurrentMilestone(_ milestone: RecoveryMilestone) -> Bool {
        guard let current = timeline.currentMilestone(days: habit.daysSinceQuit) else { return false }
        return current.id == milestone.id
    }
}

struct MilestoneRow: View {
    let milestone: RecoveryMilestone
    let isUnlocked: Bool
    let isCurrent: Bool
    let habitColor: Color
    var neonColor: Color = .accent
    let isLast: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.md) {
            // Timeline indicator
            VStack(spacing: 0) {
                ZStack {
                    if isUnlocked {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [neonColor, habitColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                            .shadow(color: habitColor.opacity(isUnlocked ? 0.1 : 0), radius: 2)
                    } else {
                        Circle()
                            .fill(Color.textTertiary.opacity(0.3))
                            .frame(width: 32, height: 32)
                    }
                    
                    if isUnlocked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Image(systemName: milestone.icon)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(
                            isUnlocked
                                ? LinearGradient(
                                    colors: [habitColor.opacity(0.5), habitColor.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                : LinearGradient(
                                    colors: [Color.textTertiary.opacity(0.2), Color.textTertiary.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                        )
                        .frame(width: 2, height: 8)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                HStack {
                    Text(milestone.title)
                        .font(.bodyMedium)
                        .fontWeight(isCurrent ? .semibold : .regular)
                        .foregroundStyle(
                            isUnlocked
                                ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                : Color.textTertiary
                        )
                    
                    if isCurrent {
                        Text("NOW")
                            .font(.labelSmall)
                            .foregroundStyle(.white)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [neonColor, habitColor],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                }
                
                Text(milestone.timeDescription)
                    .font(.labelSmall)
                    .foregroundStyle(isUnlocked ? habitColor : Color.textTertiary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Coping Strategy Card

struct CopingStrategyCard: View {
    let strategy: CopingStrategy
    let habitColor: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [habitColor.opacity(0.2), habitColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: strategy.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [habitColor, habitColor.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(strategy.title)
                    .font(.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text(strategy.description)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(strategy.duration)
                .font(.labelSmall)
                .foregroundStyle(habitColor.opacity(0.6))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(habitColor.opacity(0.08))
                )
        }
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                habitColor.opacity(colorScheme == .dark ? 0.03 : 0.015),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(habitColor.opacity(0.05), lineWidth: 0.5)
        )
    }
}
