//
//  VapingDashboard.swift
//  Quitto
//
//  Dashboard for vaping recovery - lung capacity, nicotine detox, breath quality
//

import SwiftUI

struct VapingDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .vaping)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                puffsAvoidedCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                nicotineDetoxCard
                
                RecoveryPhaseCard(habit: habit)
                
                lungHealingCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                oralFixationCard
                
                QuickActionsBar(
                    habitType: .vaping,
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
            EmergencyInterventionSheet(habitType: .vaping)
        }
    }
    
    private var puffsAvoidedCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "cloud.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Puffs Avoided")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
            }
            
            Text("\(habit.unitsAvoided)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.neonAccent, theme.glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack {
                VStack {
                    Text(formatMoney(habit.moneySaved))
                        .font(.titleMedium)
                        .foregroundStyle(theme.glowColor)
                    Text("Saved")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
                
                VStack {
                    Text(chemicalsAvoided)
                        .font(.titleMedium)
                        .foregroundStyle(theme.glowColor)
                    Text("Chemicals avoided")
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
        .modifier(Theme.shadow(.sm))
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            MetricCard(
                metric: .lungCapacity,
                value: lungCapacityValue,
                progress: lungCapacityProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .nicotineLevel,
                value: nicotineLevelValue,
                progress: nicotineLevelProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .breathQuality,
                value: breathQualityValue,
                progress: breathQualityProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .circulation,
                value: circulationValue,
                progress: circulationProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var nicotineDetoxCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "chart.line.downtrend.xyaxis")
                    .foregroundStyle(theme.glowColor)
                Text("Nicotine Detox")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            // Nicotine level visualization
            VStack(spacing: Theme.Spacing.sm) {
                HStack {
                    Text("Nicotine in body")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Spacer()
                    Text(nicotinePercentage)
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(theme.glowColor.opacity(0.2))
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.alert)
                            .frame(width: geo.size.width * nicotineRemaining, height: 16)
                    }
                }
                .frame(height: 16)
            }
            
            Text(nicotineDescription)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            if habit.daysSinceQuit >= 3 {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.accent)
                    Text("Nicotine-free body achieved!")
                        .font(.labelMedium)
                        .foregroundStyle(Color.accent)
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
    
    private var lungHealingCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "lungs.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Lung Healing")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            VStack(spacing: Theme.Spacing.sm) {
                LungHealingStage(stage: "Bronchial tubes relaxing", progress: bronchialProgress, color: theme.glowColor)
                LungHealingStage(stage: "Cilia regenerating", progress: ciliaProgress, color: theme.glowColor)
                LungHealingStage(stage: "Lung capacity improving", progress: lungCapacityProgress, color: theme.glowColor)
                LungHealingStage(stage: "Inflammation reducing", progress: inflammationProgress, color: theme.glowColor)
            }
            
            if habit.daysSinceQuit >= 30 {
                Text("🌬️ Your lungs are making remarkable recovery!")
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
    
    private var oralFixationCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Oral Fixation Alternatives")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("Keep your mouth busy without vaping:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.md) {
                OralAlternative(icon: "mouth.fill", label: "Sugar-free gum")
                OralAlternative(icon: "carrot.fill", label: "Carrot sticks")
                OralAlternative(icon: "drop.fill", label: "Ice water")
                OralAlternative(icon: "straw.fill", label: "Straw breathing")
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
        if amount >= 1000 { return "$\(String(format: "%.1f", amount / 1000))k" }
        return "$\(Int(amount))"
    }
    
    private var chemicalsAvoided: String {
        // Approximate chemicals per puff
        let chemicals = habit.unitsAvoided * 7000 / 200 // ~7000 chemicals per 200 puffs
        if chemicals >= 1000 { return "\(chemicals / 1000)k+" }
        return "\(chemicals)"
    }
    
    private var lungCapacityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.2 }
        if days < 30 { return 0.2 + Double(days - 7) / 23.0 * 0.4 }
        if days < 90 { return 0.6 + Double(days - 30) / 60.0 * 0.3 }
        return min(1.0, 0.9 + Double(days - 90) / 90.0 * 0.1)
    }
    
    private var lungCapacityValue: String {
        if lungCapacityProgress < 0.3 { return "Healing" }
        if lungCapacityProgress < 0.6 { return "Improving" }
        if lungCapacityProgress < 0.9 { return "Good" }
        return "Excellent"
    }
    
    private var nicotineLevelProgress: Double {
        // Inverse - lower is better
        let hours = habit.hoursSinceQuit
        if hours < 72 { return Double(hours) / 72.0 }
        return 1.0
    }
    
    private var nicotineLevelValue: String {
        if nicotineLevelProgress < 0.5 { return "Leaving" }
        if nicotineLevelProgress < 1.0 { return "Almost gone" }
        return "Clear"
    }
    
    private var nicotineRemaining: Double {
        let hours = habit.hoursSinceQuit
        if hours >= 72 { return 0 }
        return 1 - Double(hours) / 72.0
    }
    
    private var nicotinePercentage: String {
        let remaining = Int(nicotineRemaining * 100)
        return "\(remaining)% remaining"
    }
    
    private var nicotineDescription: String {
        let hours = habit.hoursSinceQuit
        if hours < 24 { return "Nicotine levels are dropping rapidly." }
        if hours < 48 { return "Nicotine nearly eliminated from bloodstream." }
        if hours < 72 { return "Final traces of nicotine leaving your body." }
        return "Your body is completely nicotine-free!"
    }
    
    private var breathQualityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.4 }
        if days < 30 { return 0.4 + Double(days - 7) / 23.0 * 0.4 }
        return min(1.0, 0.8 + Double(days - 30) / 60.0 * 0.2)
    }
    
    private var breathQualityValue: String {
        if breathQualityProgress < 0.3 { return "Clearing" }
        if breathQualityProgress < 0.6 { return "Better" }
        if breathQualityProgress < 0.9 { return "Fresh" }
        return "Clean"
    }
    
    private var circulationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 14) / 76.0 * 0.5)
    }
    
    private var circulationValue: String {
        if circulationProgress < 0.3 { return "Improving" }
        if circulationProgress < 0.6 { return "Better" }
        if circulationProgress < 0.9 { return "Good" }
        return "Optimal"
    }
    
    private var bronchialProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) / 7.0 * 0.6 }
        return min(1.0, 0.6 + Double(days - 7) / 23.0 * 0.4)
    }
    
    private var ciliaProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.3 }
        if days < 60 { return 0.3 + Double(days - 14) / 46.0 * 0.5 }
        return min(1.0, 0.8 + Double(days - 60) / 30.0 * 0.2)
    }
    
    private var inflammationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 30 { return Double(days) / 30.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 30) / 60.0 * 0.5)
    }
}

struct LungHealingStage: View {
    let stage: String
    let progress: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(stage)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            Spacer()
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.textTertiary.opacity(0.2))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(width: 80, height: 6)
            
            Text("\(Int(progress * 100))%")
                .font(.labelSmall)
                .foregroundStyle(color)
                .frame(width: 35, alignment: .trailing)
        }
    }
}

struct OralAlternative: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accent)
            Text(label)
                .font(.labelSmall)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
