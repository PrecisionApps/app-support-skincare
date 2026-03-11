//
//  SmokingDashboard.swift
//  Quitto
//
//  Dashboard for smoking cessation - lung health, CO levels, circulation
//

import SwiftUI

struct SmokingDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppStore.self) private var store
    
    private var facts: [MotivationalFact] {
        HabitSpecificData.motivationalFacts(for: .smoking)
    }
    
    private var strategies: [CopingStrategy] {
        HabitSpecificData.copingStrategies(for: .smoking)
    }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .smoking)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                // Hero Timer with mode illustration
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                // Mode-specific motivational banner
                ModeMotivationalBanner(habit: habit)
                
                // Mode stats header (units, money, time)
                ModeStatsHeader(habit: habit)
                
                // Key Metrics Grid
                metricsGrid
                
                // Daily insight card with mode quotes
                ModeDailyInsightCard(habit: habit)
                
                // Savings
                SavingsCard(habit: habit, showMoney: true, showTime: true)
                
                // Units Avoided
                UnitsAvoidedCard(habit: habit)
                
                // Body Recovery Section
                bodyRecoverySection
                
                // Current Phase
                RecoveryPhaseCard(habit: habit)
                
                // Lung Capacity Visualization
                lungCapacityCard
                
                // Milestones
                MilestoneTimeline(habit: habit, showAll: false)
                
                // Coping Strategies
                copingSection
                
                // Quick Actions
                QuickActionsBar(
                    habitType: .smoking,
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
        .task {
            await store.healthKitService.requestAuthorization()
        }
        .sheet(isPresented: $showEmergency) {
            EmergencyInterventionSheet(habitType: .smoking)
        }
    }
    
    // MARK: - Metrics Grid
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            MetricCard(
                metric: .lungCapacity,
                value: lungCapacityValue,
                progress: lungCapacityProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .oxygenLevel,
                value: oxygenValue,
                progress: oxygenProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .heartRate,
                value: heartRateValue,
                progress: heartRateProgress,
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
    
    // MARK: - Body Recovery Section
    
    private var bodyRecoverySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Body Recovery")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                Image(systemName: "figure.arms.open")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.glowColor.opacity(0.6))
            }
            
            // Visual body indicator
            HStack(spacing: Theme.Spacing.lg) {
                // Lungs
                VStack(spacing: Theme.Spacing.xs) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [lungHealthColor.opacity(0.25), lungHealthColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "lungs.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [lungHealthColor, lungHealthColor.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    Text("Lungs")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textSecondary)
                    Text(lungHealthStatus)
                        .font(.labelMedium)
                        .foregroundStyle(lungHealthColor)
                }
                
                // Heart
                VStack(spacing: Theme.Spacing.xs) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [heartHealthColor.opacity(0.25), heartHealthColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [heartHealthColor, heartHealthColor.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    Text("Heart")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textSecondary)
                    Text(heartHealthStatus)
                        .font(.labelMedium)
                        .foregroundStyle(heartHealthColor)
                }
                
                // Blood
                VStack(spacing: Theme.Spacing.xs) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [bloodHealthColor.opacity(0.25), bloodHealthColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "drop.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [bloodHealthColor, bloodHealthColor.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    Text("Blood")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textSecondary)
                    Text(bloodHealthStatus)
                        .font(.labelMedium)
                        .foregroundStyle(bloodHealthColor)
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
    
    // MARK: - Lung Capacity Card
    
    private var lungCapacityCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Lung Capacity Recovery")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Spacer()
                
                Text("\(Int(lungCapacityProgress * 100))%")
                    .font(.titleMedium)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            // Progress bar with mode gradient
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
                        .frame(width: geo.size.width * lungCapacityProgress, height: 12)
                }
            }
            .frame(height: 12)
            
            Text(lungCapacityDescription)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
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
    
    // MARK: - Coping Section
    
    private var copingSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Coping Strategies")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                Image(systemName: "shield.checkered")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.glowColor.opacity(0.6))
            }
            
            ForEach(strategies.prefix(3)) { strategy in
                CopingStrategyCard(strategy: strategy, habitColor: theme.glowColor)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var lungCapacityProgress: Double {
        let days = habit.daysSinceQuit
        switch days {
        case 0: return 0.0
        case 1...7: return 0.1 + Double(days) * 0.02
        case 8...30: return 0.24 + Double(days - 7) * 0.01
        case 31...90: return 0.47 + Double(days - 30) * 0.005
        case 91...180: return 0.77 + Double(days - 90) * 0.002
        default: return min(1.0, 0.95 + Double(days - 180) * 0.0003)
        }
    }
    
    private var lungCapacityValue: String {
        "\(Int(lungCapacityProgress * 100))%"
    }
    
    private var lungCapacityDescription: String {
        let days = habit.daysSinceQuit
        if days < 3 { return "Cilia in your lungs are beginning to recover." }
        if days < 14 { return "Your lungs are clearing mucus and debris." }
        if days < 30 { return "Lung function improving, breathing easier." }
        if days < 90 { return "Significant lung capacity gains achieved." }
        return "Your lungs have healed remarkably. Keep going!"
    }
    
    private var oxygenProgress: Double {
        // Use real SpO2 data from HealthKit if available
        if let spo2 = store.healthKitService.latestOxygenSaturation {
            // Map SpO2 (90-100%) to a 0-1 progress range
            return min(1.0, max(0.0, (spo2 - 90.0) / 10.0))
        }
        // Fallback: recovery-based estimate (no numeric value shown)
        let hours = habit.hoursSinceQuit
        if hours < 12 { return 0.5 + Double(hours) / 24.0 }
        return min(1.0, 0.85 + Double(habit.daysSinceQuit) * 0.01)
    }
    
    private var oxygenValue: String {
        // Real data from HealthKit, or dash if unavailable
        store.healthKitService.oxygenSaturationDisplay
    }
    
    private var heartRateProgress: Double {
        // Use real heart rate from HealthKit if available
        if let hr = store.healthKitService.latestHeartRate {
            // Map heart rate: lower is better for recovery
            // 100+ bpm = 0.0, 60 bpm = 1.0
            return min(1.0, max(0.0, (100.0 - hr) / 40.0))
        }
        // Fallback: recovery-based estimate (no numeric value shown)
        let minutes = habit.minutesSinceQuit
        if minutes < 20 { return Double(minutes) / 20.0 * 0.3 }
        return min(1.0, 0.3 + Double(habit.daysSinceQuit) * 0.02)
    }
    
    private var heartRateValue: String {
        // Real data from HealthKit, or dash if unavailable
        store.healthKitService.heartRateDisplay
    }
    
    private var circulationProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.5 }
        return min(1.0, 0.5 + Double(days - 14) / 76.0 * 0.5)
    }
    
    private var circulationValue: String {
        if circulationProgress < 0.3 { return "Improving" }
        if circulationProgress < 0.6 { return "Better" }
        if circulationProgress < 0.9 { return "Great" }
        return "Excellent"
    }
    
    private var lungHealthColor: Color {
        if lungCapacityProgress < 0.3 { return .alert }
        if lungCapacityProgress < 0.6 { return .warmth }
        return .accent
    }
    
    private var lungHealthStatus: String {
        if lungCapacityProgress < 0.3 { return "Healing" }
        if lungCapacityProgress < 0.6 { return "Improving" }
        if lungCapacityProgress < 0.9 { return "Healthy" }
        return "Optimal"
    }
    
    private var heartHealthColor: Color {
        if heartRateProgress < 0.3 { return .alert }
        if heartRateProgress < 0.6 { return .warmth }
        return .accent
    }
    
    private var heartHealthStatus: String {
        if heartRateProgress < 0.3 { return "Adjusting" }
        if heartRateProgress < 0.6 { return "Improving" }
        return "Strong"
    }
    
    private var bloodHealthColor: Color {
        let hours = habit.hoursSinceQuit
        if hours < 12 { return .alert }
        if hours < 48 { return .warmth }
        return .accent
    }
    
    private var bloodHealthStatus: String {
        let hours = habit.hoursSinceQuit
        if hours < 12 { return "Clearing CO" }
        if hours < 24 { return "CO Normal" }
        return "Clean"
    }
}
