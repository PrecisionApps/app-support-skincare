//
//  AlcoholDashboard.swift
//  Quitto
//
//  Dashboard for alcohol recovery - liver health, sleep quality, hydration
//

import SwiftUI

struct AlcoholDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .alcohol)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                SavingsCard(habit: habit, showMoney: true, showTime: false)
                
                UnitsAvoidedCard(habit: habit)
                
                liverRecoveryCard
                
                RecoveryPhaseCard(habit: habit)
                
                sleepQualityCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                haltCheckCard
                
                QuickActionsBar(
                    habitType: .alcohol,
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
            EmergencyInterventionSheet(habitType: .alcohol)
        }
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            MetricCard(
                metric: .liverHealth,
                value: liverHealthValue,
                progress: liverHealthProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .sleepQuality,
                value: sleepQualityValue,
                progress: sleepQualityProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .hydration,
                value: hydrationValue,
                progress: hydrationProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .mentalClarity,
                value: mentalClarityValue,
                progress: mentalClarityProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var liverRecoveryCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "cross.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Liver Recovery")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                Text("\(Int(liverHealthProgress * 100))%")
                    .font(.titleMedium)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.textTertiary.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * liverHealthProgress, height: 12)
                }
            }
            .frame(height: 12)
            
            Text(liverDescription)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            if habit.daysSinceQuit >= 30 {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Text("Liver fat may have reduced by up to 20%")
                        .font(.labelSmall)
                        .foregroundStyle(theme.glowColor)
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
    
    private var sleepQualityCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "moon.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Sleep Recovery")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            HStack(spacing: Theme.Spacing.lg) {
                VStack(spacing: Theme.Spacing.xs) {
                    Text("REM Sleep")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text(remSleepStatus)
                        .font(.bodyMedium)
                        .foregroundStyle(theme.glowColor)
                }
                
                Divider().frame(height: 40)
                    .overlay(theme.glowColor.opacity(0.1))
                
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Sleep Quality")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text(sleepQualityValue)
                        .font(.bodyMedium)
                        .foregroundStyle(theme.neonAccent)
                }
                
                Divider().frame(height: 40)
                    .overlay(theme.glowColor.opacity(0.1))
                
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Energy AM")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text(morningEnergyStatus)
                        .font(.bodyMedium)
                        .foregroundStyle(theme.glowColor)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [theme.glowColor.opacity(colorScheme == .dark ? 0.04 : 0.02), .clear],
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
    
    private var haltCheckCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("HALT Check")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("Before acting on an urge, ask yourself:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.sm) {
                HALTItem(letter: "H", word: "Hungry?", color: theme.glowColor)
                HALTItem(letter: "A", word: "Angry?", color: theme.neonAccent)
                HALTItem(letter: "L", word: "Lonely?", color: theme.glowColor)
                HALTItem(letter: "T", word: "Tired?", color: theme.neonAccent)
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
    
    private var liverHealthProgress: Double {
        let days = habit.daysSinceQuit
        switch days {
        case 0: return 0.0
        case 1...7: return Double(days) * 0.05
        case 8...30: return 0.35 + Double(days - 7) * 0.015
        case 31...90: return 0.695 + Double(days - 30) * 0.004
        default: return min(1.0, 0.935 + Double(days - 90) * 0.0007)
        }
    }
    
    private var liverHealthValue: String {
        if liverHealthProgress < 0.3 { return "Healing" }
        if liverHealthProgress < 0.6 { return "Improving" }
        if liverHealthProgress < 0.9 { return "Healthy" }
        return "Optimal"
    }
    
    private var liverDescription: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Your liver is beginning to repair itself." }
        if days < 30 { return "Liver enzymes normalizing, fat reducing." }
        if days < 90 { return "Significant liver regeneration occurring." }
        return "Your liver has made remarkable recovery."
    }
    
    private var sleepQualityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return 0.2 + Double(days) * 0.08 }
        if days < 30 { return 0.76 + Double(days - 7) * 0.008 }
        return min(1.0, 0.944 + Double(days - 30) * 0.001)
    }
    
    private var sleepQualityValue: String {
        if sleepQualityProgress < 0.4 { return "Adjusting" }
        if sleepQualityProgress < 0.7 { return "Improving" }
        if sleepQualityProgress < 0.9 { return "Good" }
        return "Excellent"
    }
    
    private var remSleepStatus: String {
        let days = habit.daysSinceQuit
        if days < 3 { return "Disrupted" }
        if days < 7 { return "Returning" }
        if days < 14 { return "Improving" }
        return "Normal"
    }
    
    private var morningEnergyStatus: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Variable" }
        if days < 14 { return "Better" }
        if days < 30 { return "Good" }
        return "Great"
    }
    
    private var hydrationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 3 { return 0.3 + Double(days) * 0.15 }
        return min(1.0, 0.75 + Double(days - 3) * 0.02)
    }
    
    private var hydrationValue: String {
        if hydrationProgress < 0.5 { return "Low" }
        if hydrationProgress < 0.8 { return "Good" }
        return "Optimal"
    }
    
    private var mentalClarityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) * 0.1 }
        if days < 30 { return 0.7 + Double(days - 7) * 0.01 }
        return min(1.0, 0.93 + Double(days - 30) * 0.001)
    }
    
    private var mentalClarityValue: String {
        if mentalClarityProgress < 0.4 { return "Foggy" }
        if mentalClarityProgress < 0.7 { return "Clearing" }
        if mentalClarityProgress < 0.9 { return "Clear" }
        return "Sharp"
    }
}

struct HALTItem: View {
    let letter: String
    let word: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(letter)
                .font(.titleLarge)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(word)
                .font(.labelSmall)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
