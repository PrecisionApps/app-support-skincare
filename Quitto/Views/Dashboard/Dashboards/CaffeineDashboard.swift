//
//  CaffeineDashboard.swift
//  Quitto
//
//  Dashboard for caffeine recovery - natural energy, sleep quality, anxiety
//

import SwiftUI

struct CaffeineDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .caffeine)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                naturalEnergyCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                withdrawalTimelineCard
                
                RecoveryPhaseCard(habit: habit)
                
                sleepImprovementCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                energyBoostersCard
                
                QuickActionsBar(
                    habitType: .caffeine,
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
            EmergencyInterventionSheet(habitType: .caffeine)
        }
    }
    
    private var naturalEnergyCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Natural Energy Level")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
            }
            
            // Energy meter
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(Color.textTertiary.opacity(0.1))
                    .frame(height: 80)
                
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * naturalEnergyProgress)
                }
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
                
                HStack {
                    Image(systemName: "battery.0")
                        .foregroundStyle(Color.textTertiary)
                    Spacer()
                    Text("\(Int(naturalEnergyProgress * 100))%")
                        .font(.displaySmall)
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "battery.100")
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(.horizontal, Theme.Spacing.md)
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
                metric: .naturalEnergy,
                value: naturalEnergyValue,
                progress: naturalEnergyProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .sleepQuality,
                value: sleepQualityValue,
                progress: sleepQualityProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .anxietyLevel,
                value: anxietyValue,
                progress: anxietyProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .hydration,
                value: hydrationValue,
                progress: hydrationProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var withdrawalTimelineCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Withdrawal Timeline")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            VStack(spacing: Theme.Spacing.sm) {
                WithdrawalStage(
                    time: "12-24 hours",
                    symptom: "Headache begins",
                    active: habit.hoursSinceQuit >= 12 && habit.daysSinceQuit < 2,
                    passed: habit.daysSinceQuit >= 2,
                    color: theme.glowColor
                )
                
                WithdrawalStage(
                    time: "Day 2-3",
                    symptom: "Peak withdrawal",
                    active: habit.daysSinceQuit >= 2 && habit.daysSinceQuit < 4,
                    passed: habit.daysSinceQuit >= 4,
                    color: theme.glowColor
                )
                
                WithdrawalStage(
                    time: "Day 4-7",
                    symptom: "Symptoms fade",
                    active: habit.daysSinceQuit >= 4 && habit.daysSinceQuit < 7,
                    passed: habit.daysSinceQuit >= 7,
                    color: theme.glowColor
                )
                
                WithdrawalStage(
                    time: "Week 2+",
                    symptom: "Natural energy returns",
                    active: habit.daysSinceQuit >= 7,
                    passed: habit.daysSinceQuit >= 14,
                    color: theme.glowColor
                )
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var sleepImprovementCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "moon.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Sleep Improvement")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            HStack(spacing: Theme.Spacing.lg) {
                SleepMetric(label: "Fall Asleep", value: fallAsleepTime, icon: "bed.double.fill")
                SleepMetric(label: "Deep Sleep", value: deepSleepStatus, icon: "moon.zzz.fill")
                SleepMetric(label: "Wake Quality", value: wakeQuality, icon: "sunrise.fill")
            }
            
            if habit.daysSinceQuit >= 7 {
                Text("☀️ Without caffeine disrupting adenosine, your sleep architecture is normalizing!")
                    .font(.labelSmall)
                    .foregroundStyle(Color.warmth)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var energyBoostersCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Natural Energy Boosters")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("Try these instead of caffeine:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.sm) {
                EnergyBooster(icon: "figure.walk", label: "Walk", detail: "10 min")
                EnergyBooster(icon: "drop.fill", label: "Cold Water", detail: "Face splash")
                EnergyBooster(icon: "apple.logo", label: "Apple", detail: "Natural sugar")
                EnergyBooster(icon: "wind", label: "Deep Breaths", detail: "5 cycles")
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
    
    private var naturalEnergyProgress: Double {
        let days = habit.daysSinceQuit
        if days < 3 { return 0.2 } // Low during withdrawal
        if days < 7 { return 0.2 + Double(days - 3) / 4.0 * 0.3 }
        if days < 14 { return 0.5 + Double(days - 7) / 7.0 * 0.3 }
        if days < 30 { return 0.8 + Double(days - 14) / 16.0 * 0.15 }
        return min(1.0, 0.95 + Double(days - 30) / 60.0 * 0.05)
    }
    
    private var naturalEnergyValue: String {
        if naturalEnergyProgress < 0.3 { return "Low" }
        if naturalEnergyProgress < 0.5 { return "Building" }
        if naturalEnergyProgress < 0.7 { return "Growing" }
        if naturalEnergyProgress < 0.9 { return "Good" }
        return "Optimal"
    }
    
    private var energyDescription: String {
        let days = habit.daysSinceQuit
        if days < 3 { return "Energy is low as adenosine receptors reset. This is temporary!" }
        if days < 7 { return "Your body is learning to produce energy naturally again." }
        if days < 14 { return "Natural energy levels are stabilizing. No more crashes!" }
        return "Your natural energy exceeds what caffeine provided—consistently!"
    }
    
    private var sleepQualityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 3 { return 0.4 }
        if days < 7 { return 0.4 + Double(days - 3) / 4.0 * 0.3 }
        if days < 14 { return 0.7 + Double(days - 7) / 7.0 * 0.2 }
        return min(1.0, 0.9 + Double(days - 14) / 16.0 * 0.1)
    }
    
    private var sleepQualityValue: String {
        if sleepQualityProgress < 0.5 { return "Adjusting" }
        if sleepQualityProgress < 0.7 { return "Improving" }
        if sleepQualityProgress < 0.9 { return "Good" }
        return "Excellent"
    }
    
    private var anxietyProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.5 }
        if days < 21 { return 0.5 + Double(days - 7) / 14.0 * 0.35 }
        return min(1.0, 0.85 + Double(days - 21) / 9.0 * 0.15)
    }
    
    private var anxietyValue: String {
        if anxietyProgress < 0.4 { return "Variable" }
        if anxietyProgress < 0.7 { return "Calming" }
        if anxietyProgress < 0.9 { return "Calm" }
        return "Peaceful"
    }
    
    private var hydrationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 3 { return 0.5 + Double(days) * 0.1 }
        return min(1.0, 0.8 + Double(days - 3) / 27.0 * 0.2)
    }
    
    private var hydrationValue: String {
        if hydrationProgress < 0.6 { return "Improving" }
        if hydrationProgress < 0.8 { return "Good" }
        return "Optimal"
    }
    
    private var fallAsleepTime: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Variable" }
        if days < 14 { return "Faster" }
        return "Quick"
    }
    
    private var deepSleepStatus: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Increasing" }
        if days < 14 { return "Better" }
        return "Optimal"
    }
    
    private var wakeQuality: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Groggy" }
        if days < 14 { return "Clearer" }
        return "Refreshed"
    }
}

struct WithdrawalStage: View {
    let time: String
    let symptom: String
    let active: Bool
    let passed: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Circle()
                .fill(passed ? Color.accent : (active ? color : Color.textTertiary.opacity(0.3)))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(time)
                    .font(.labelMedium)
                    .foregroundStyle(active ? color : (passed ? Color.accent : Color.textTertiary))
                Text(symptom)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
            
            if passed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.accent)
            } else if active {
                Text("NOW")
                    .font(.labelSmall)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Theme.Spacing.sm)
                    .padding(.vertical, 2)
                    .background(color)
                    .clipShape(Capsule())
            }
        }
    }
}

struct SleepMetric: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .font(.labelMedium)
                .foregroundStyle(Color.accent)
            Text(label)
                .font(.labelSmall)
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct EnergyBooster: View {
    let icon: String
    let label: String
    let detail: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accent)
            Text(label)
                .font(.labelSmall)
                .foregroundStyle(Color.textPrimary)
            Text(detail)
                .font(.labelSmall)
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
    }
}
