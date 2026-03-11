//
//  GamblingDashboard.swift
//  Quitto
//
//  Dashboard for gambling recovery - money saved, impulse control, financial health
//

import SwiftUI

struct GamblingDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .gambling)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                moneySavedHeroCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                financialRecoveryCard
                
                RecoveryPhaseCard(habit: habit)
                
                urgeControlCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                realWinsCard
                
                QuickActionsBar(
                    habitType: .gambling,
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
            EmergencyInterventionSheet(habitType: .gambling)
        }
    }
    
    private var moneySavedHeroCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "banknote.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Money NOT Lost")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
            }
            
            Text(formatMoney(habit.moneySaved))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("That you would have gambled away")
                .font(.labelSmall)
                .foregroundStyle(Color.textSecondary)
            
            Divider()
            
            HStack {
                VStack {
                    Text(formatMoney(projectedYearlySavings))
                        .font(.titleMedium)
                        .foregroundStyle(theme.glowColor)
                    Text("Yearly projection")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
                
                VStack {
                    Text("\(habit.unitsAvoided)")
                        .font(.titleMedium)
                        .foregroundStyle(theme.glowColor)
                    Text("Bets avoided")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.md))
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            MetricCard(
                metric: .impulseControl,
                value: impulseControlValue,
                progress: impulseControlProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .financialHealth,
                value: financialHealthValue,
                progress: financialHealthProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .stressLevel,
                value: stressLevelValue,
                progress: stressLevelProgress,
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
    
    private var financialRecoveryCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Financial Recovery")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            VStack(spacing: Theme.Spacing.sm) {
                FinancialRow(
                    icon: "arrow.down.circle.fill",
                    label: "Debt pressure",
                    status: debtPressureStatus,
                    color: debtPressureColor
                )
                
                FinancialRow(
                    icon: "creditcard.fill",
                    label: "Spending control",
                    status: spendingControlStatus,
                    color: spendingControlColor
                )
                
                FinancialRow(
                    icon: "building.columns.fill",
                    label: "Savings growth",
                    status: savingsGrowthStatus,
                    color: savingsGrowthColor
                )
                
                FinancialRow(
                    icon: "heart.fill",
                    label: "Financial peace",
                    status: financialPeaceStatus,
                    color: financialPeaceColor
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
    
    private var urgeControlCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "bolt.slash.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Urge Control Training")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text("When the urge hits, remember:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                UrgeControlTip(number: "1", tip: "The house ALWAYS wins long-term")
                UrgeControlTip(number: "2", tip: "Play the tape forward—remember the losses")
                UrgeControlTip(number: "3", tip: "Call your sponsor or helpline (1-800-522-4700)")
                UrgeControlTip(number: "4", tip: "Wait 24 hours before any gambling decision")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var realWinsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Real Wins")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("These are the jackpots that actually matter:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            VStack(spacing: Theme.Spacing.sm) {
                RealWinRow(win: "Family trust rebuilding", unlocked: habit.daysSinceQuit >= 30, icon: "house.fill")
                RealWinRow(win: "Financial stability", unlocked: habit.daysSinceQuit >= 60, icon: "chart.line.uptrend.xyaxis")
                RealWinRow(win: "Mental freedom", unlocked: habit.daysSinceQuit >= 90, icon: "brain.head.profile")
                RealWinRow(win: "Self-respect", unlocked: habit.daysSinceQuit >= 7, icon: "person.fill.checkmark")
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
    
    private func formatMoney(_ amount: Double) -> String {
        if amount >= 10000 {
            return "$\(String(format: "%.1f", amount / 1000))k"
        } else if amount >= 1000 {
            return "$\(Int(amount))"
        }
        return "$\(Int(amount))"
    }
    
    private var projectedYearlySavings: Double {
        guard habit.daysSinceQuit > 0 else { return 0 }
        let dailyRate = habit.moneySaved / Double(habit.daysSinceQuit)
        return dailyRate * 365
    }
    
    private var impulseControlProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.4 }
        if days < 60 { return 0.4 + Double(days - 14) / 46.0 * 0.4 }
        return min(1.0, 0.8 + Double(days - 60) / 30.0 * 0.2)
    }
    
    private var impulseControlValue: String {
        if impulseControlProgress < 0.3 { return "Building" }
        if impulseControlProgress < 0.6 { return "Growing" }
        if impulseControlProgress < 0.9 { return "Strong" }
        return "Mastery"
    }
    
    private var financialHealthProgress: Double {
        let days = habit.daysSinceQuit
        return min(1.0, Double(days) / 180.0)
    }
    
    private var financialHealthValue: String {
        if financialHealthProgress < 0.25 { return "Recovering" }
        if financialHealthProgress < 0.5 { return "Stabilizing" }
        if financialHealthProgress < 0.75 { return "Improving" }
        return "Healthy"
    }
    
    private var stressLevelProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) * 0.1 }
        if days < 30 { return 0.7 + Double(days - 7) * 0.01 }
        return min(1.0, 0.93 + Double(days - 30) * 0.001)
    }
    
    private var stressLevelValue: String {
        if stressLevelProgress < 0.4 { return "Easing" }
        if stressLevelProgress < 0.7 { return "Lower" }
        if stressLevelProgress < 0.9 { return "Calm" }
        return "Peaceful"
    }
    
    private var mentalClarityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 14) / 76.0 * 0.5)
    }
    
    private var mentalClarityValue: String {
        if mentalClarityProgress < 0.4 { return "Clearing" }
        if mentalClarityProgress < 0.7 { return "Clearer" }
        if mentalClarityProgress < 0.9 { return "Clear" }
        return "Sharp"
    }
    
    private var debtPressureStatus: String {
        habit.daysSinceQuit < 30 ? "Relieving" : habit.daysSinceQuit < 90 ? "Reduced" : "Managed"
    }
    
    private var debtPressureColor: Color {
        habit.daysSinceQuit < 30 ? .warmth : habit.daysSinceQuit < 90 ? .calm : .accent
    }
    
    private var spendingControlStatus: String {
        habit.daysSinceQuit < 14 ? "Learning" : habit.daysSinceQuit < 60 ? "Improving" : "Controlled"
    }
    
    private var spendingControlColor: Color {
        habit.daysSinceQuit < 14 ? .warmth : habit.daysSinceQuit < 60 ? .calm : .accent
    }
    
    private var savingsGrowthStatus: String {
        habit.daysSinceQuit < 30 ? "Starting" : habit.daysSinceQuit < 90 ? "Growing" : "Strong"
    }
    
    private var savingsGrowthColor: Color {
        habit.daysSinceQuit < 30 ? .warmth : habit.daysSinceQuit < 90 ? .calm : .accent
    }
    
    private var financialPeaceStatus: String {
        habit.daysSinceQuit < 14 ? "Building" : habit.daysSinceQuit < 60 ? "Growing" : "Found"
    }
    
    private var financialPeaceColor: Color {
        habit.daysSinceQuit < 14 ? .warmth : habit.daysSinceQuit < 60 ? .calm : .accent
    }
}

struct FinancialRow: View {
    let icon: String
    let label: String
    let status: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(label)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text(status)
                .font(.labelMedium)
                .foregroundStyle(color)
        }
    }
}

struct UrgeControlTip: View {
    let number: String
    let tip: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            Text(number)
                .font(.labelMedium)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(Circle().fill(Color.textTertiary))
            Text(tip)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
        }
    }
}

struct RealWinRow: View {
    let win: String
    let unlocked: Bool
    let icon: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: unlocked ? "trophy.fill" : "trophy")
                .foregroundStyle(unlocked ? Color.warmth : Color.textTertiary)
            Text(win)
                .font(.bodySmall)
                .foregroundStyle(
                    unlocked
                        ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        : Color.textTertiary
                )
            Spacer()
            if unlocked {
                Image(systemName: icon)
                    .foregroundStyle(Color.accent)
            }
        }
    }
}
