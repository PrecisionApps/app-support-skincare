//
//  SugarDashboard.swift
//  Quitto
//
//  Dashboard for sugar detox - blood sugar stability, energy, weight
//

import SwiftUI

struct SugarDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .sugar)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                energyStabilityCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                cravingPatternCard
                
                RecoveryPhaseCard(habit: habit)
                
                bodyChangesCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                healthyAlternativesCard
                
                QuickActionsBar(
                    habitType: .sugar,
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
            EmergencyInterventionSheet(habitType: .sugar)
        }
    }
    
    private var energyStabilityCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Energy Stability")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
            }
            
            // Energy wave visualization
            HStack(spacing: 2) {
                ForEach(0..<24, id: \.self) { hour in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(energyBarColor(for: hour))
                        .frame(width: 10, height: energyBarHeight(for: hour))
                }
            }
            .frame(height: 60)
            
            HStack {
                Text("6 AM")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                Spacer()
                Text("12 PM")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                Spacer()
                Text("6 PM")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                Spacer()
                Text("12 AM")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
            }
            
            Text(energyDescription)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
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
                metric: .bloodSugar,
                value: bloodSugarValue,
                progress: bloodSugarProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .energyLevel,
                value: energyLevelValue,
                progress: energyLevelProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .cravingIntensity,
                value: cravingValue,
                progress: cravingProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .weightProgress,
                value: weightValue,
                progress: weightProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var cravingPatternCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "chart.line.downtrend.xyaxis")
                    .foregroundStyle(theme.glowColor)
                Text("Craving Pattern")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.textTertiary.opacity(0.1))
                    
                    // Progress (inverse - less is better)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * (1 - cravingIntensity))
                }
            }
            .frame(height: 12)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Day 1-3")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text("Peak cravings")
                        .font(.labelSmall)
                        .foregroundStyle(habit.daysSinceQuit <= 3 ? Color.alert : Color.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Week 1")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text("Declining")
                        .font(.labelSmall)
                        .foregroundStyle(habit.daysSinceQuit > 3 && habit.daysSinceQuit <= 7 ? Color.warmth : Color.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Week 2+")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text("Manageable")
                        .font(.labelSmall)
                        .foregroundStyle(habit.daysSinceQuit > 7 ? Color.accent : Color.textSecondary)
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
    
    private var bodyChangesCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Body Changes")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            VStack(spacing: Theme.Spacing.sm) {
                BodyChangeRow(change: "Taste buds resetting", status: tasteBudsStatus, unlocked: habit.daysSinceQuit >= 7, icon: "mouth.fill")
                BodyChangeRow(change: "Skin clarity improving", status: skinStatus, unlocked: habit.daysSinceQuit >= 14, icon: "face.smiling.fill")
                BodyChangeRow(change: "Inflammation reducing", status: inflammationStatus, unlocked: habit.daysSinceQuit >= 21, icon: "flame.fill")
                BodyChangeRow(change: "Insulin sensitivity up", status: insulinStatus, unlocked: habit.daysSinceQuit >= 30, icon: "chart.xyaxis.line")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var healthyAlternativesCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Healthy Alternatives")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("When cravings hit, try:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.md) {
                AlternativeItem(icon: "apple.logo", label: "Fresh fruit", color: theme.glowColor)
                AlternativeItem(icon: "drop.fill", label: "Water", color: theme.glowColor)
                AlternativeItem(icon: "leaf.fill", label: "Berries", color: theme.glowColor)
                AlternativeItem(icon: "figure.walk", label: "Walk", color: theme.glowColor)
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
    
    private func energyBarHeight(for hour: Int) -> CGFloat {
        let days = habit.daysSinceQuit
        let baseVariation: CGFloat = days < 3 ? 0.5 : days < 7 ? 0.3 : days < 14 ? 0.2 : 0.1
        let base: CGFloat = 40
        let variation = CGFloat.random(in: -baseVariation...baseVariation) * base
        return max(15, base + variation)
    }
    
    private func energyBarColor(for hour: Int) -> Color {
        let days = habit.daysSinceQuit
        if days < 3 { return hour % 4 == 0 ? Color.alert.opacity(0.7) : Color.warmth.opacity(0.5) }
        if days < 7 { return Color.warmth.opacity(0.6) }
        return theme.glowColor.opacity(0.7)
    }
    
    private var energyDescription: String {
        let days = habit.daysSinceQuit
        if days < 3 { return "Energy levels are volatile as your body adjusts. This is normal!" }
        if days < 7 { return "Energy spikes and crashes reducing. Hang in there!" }
        if days < 14 { return "Your energy is becoming more stable throughout the day." }
        return "Stable, consistent energy all day long. Great progress!"
    }
    
    private var bloodSugarProgress: Double {
        let days = habit.daysSinceQuit
        if days < 3 { return Double(days) / 3.0 * 0.4 }
        if days < 14 { return 0.4 + Double(days - 3) / 11.0 * 0.4 }
        return min(1.0, 0.8 + Double(days - 14) / 16.0 * 0.2)
    }
    
    private var bloodSugarValue: String {
        if bloodSugarProgress < 0.3 { return "Adjusting" }
        if bloodSugarProgress < 0.6 { return "Stabilizing" }
        if bloodSugarProgress < 0.9 { return "Stable" }
        return "Optimal"
    }
    
    private var energyLevelProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 7) / 23.0 * 0.5)
    }
    
    private var energyLevelValue: String {
        if energyLevelProgress < 0.3 { return "Variable" }
        if energyLevelProgress < 0.6 { return "Improving" }
        if energyLevelProgress < 0.9 { return "Steady" }
        return "Optimal"
    }
    
    private var cravingProgress: Double {
        // For cravings, higher progress = less cravings (inverted)
        let days = habit.daysSinceQuit
        if days < 3 { return Double(days) / 3.0 * 0.3 }
        if days < 14 { return 0.3 + Double(days - 3) / 11.0 * 0.5 }
        return min(1.0, 0.8 + Double(days - 14) / 16.0 * 0.2)
    }
    
    private var cravingIntensity: Double {
        1 - cravingProgress
    }
    
    private var cravingValue: String {
        if cravingProgress < 0.3 { return "Intense" }
        if cravingProgress < 0.6 { return "Moderate" }
        if cravingProgress < 0.9 { return "Mild" }
        return "Minimal"
    }
    
    private var weightProgress: Double {
        let days = habit.daysSinceQuit
        return min(1.0, Double(days) / 90.0)
    }
    
    private var weightValue: String {
        if weightProgress < 0.3 { return "Starting" }
        if weightProgress < 0.6 { return "Changing" }
        if weightProgress < 0.9 { return "Improving" }
        return "Optimizing"
    }
    
    private var tasteBudsStatus: String {
        habit.daysSinceQuit < 7 ? "Resetting" : "Reset"
    }
    
    private var skinStatus: String {
        habit.daysSinceQuit < 14 ? "Clearing" : habit.daysSinceQuit < 30 ? "Clearer" : "Clear"
    }
    
    private var inflammationStatus: String {
        habit.daysSinceQuit < 21 ? "Reducing" : "Reduced"
    }
    
    private var insulinStatus: String {
        habit.daysSinceQuit < 30 ? "Improving" : "Improved"
    }
}

struct BodyChangeRow: View {
    let change: String
    let status: String
    let unlocked: Bool
    let icon: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: unlocked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(unlocked ? Color.accent : Color.textTertiary)
            Text(change)
                .font(.bodySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            Spacer()
            Text(status)
                .font(.labelSmall)
                .foregroundStyle(unlocked ? Color.accent : Color.textTertiary)
        }
    }
}

struct AlternativeItem: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(label)
                .font(.labelSmall)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
