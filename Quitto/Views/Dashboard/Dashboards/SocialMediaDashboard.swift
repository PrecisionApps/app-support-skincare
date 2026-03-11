//
//  SocialMediaDashboard.swift
//  Quitto
//
//  Dashboard for social media detox - screen time, focus, real connections
//

import SwiftUI

struct SocialMediaDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .socialMedia)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                timeReclaimedCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                attentionRecoveryCard
                
                RecoveryPhaseCard(habit: habit)
                
                realConnectionsCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                mindfulnessCard
                
                QuickActionsBar(
                    habitType: .socialMedia,
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
            EmergencyInterventionSheet(habitType: .socialMedia)
        }
    }
    
    private var timeReclaimedCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Time Reclaimed")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
            }
            
            HStack(spacing: Theme.Spacing.xl) {
                VStack {
                    Text("\(timeReclaimedHours)")
                        .font(.displayMedium)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("Hours")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
                
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("That's equivalent to:")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textSecondary)
                    
                    ForEach(timeEquivalents.prefix(3), id: \.self) { equiv in
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10))
                                .foregroundStyle(theme.glowColor)
                            Text(equiv)
                                .font(.labelSmall)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
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
                metric: .focusSessions,
                value: focusSessionsValue,
                progress: focusProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .productivity,
                value: productivityValue,
                progress: productivityProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .realConnections,
                value: realConnectionsValue,
                progress: realConnectionsProgress,
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
    
    private var attentionRecoveryCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "scope")
                    .foregroundStyle(theme.glowColor)
                Text("Attention Span Recovery")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
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
                        .frame(width: geo.size.width * attentionSpanProgress, height: 12)
                }
            }
            .frame(height: 12)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Focus Duration")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text(focusDuration)
                        .font(.bodyMedium)
                        .foregroundStyle(theme.glowColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Deep Work Capacity")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    Text(deepWorkCapacity)
                        .font(.bodyMedium)
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
    
    private var realConnectionsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Real Connections")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text("Track meaningful interactions you've had instead of scrolling:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.md) {
                ConnectionType(icon: "phone.fill", label: "Calls", color: theme.glowColor)
                ConnectionType(icon: "person.2.fill", label: "Meetups", color: theme.glowColor)
                ConnectionType(icon: "envelope.fill", label: "Letters", color: theme.glowColor)
                ConnectionType(icon: "heart.fill", label: "Quality Time", color: theme.glowColor)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var mindfulnessCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Mindfulness Moment")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("Before reaching for your phone, pause and ask:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                MindfulQuestion(question: "What am I trying to avoid?")
                MindfulQuestion(question: "What do I actually need right now?")
                MindfulQuestion(question: "Will this scrolling add value?")
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
    
    private var timeReclaimedHours: Int {
        habit.timeSavedMinutes / 60
    }
    
    private var timeEquivalents: [String] {
        let hours = timeReclaimedHours
        var equivalents: [String] = []
        
        if hours >= 2 { equivalents.append("\(hours / 2) movies watched") }
        if hours >= 10 { equivalents.append("\(hours / 10) books read") }
        if hours >= 1 { equivalents.append("\(hours) workouts completed") }
        if hours >= 5 { equivalents.append("\(hours / 5) skills learned") }
        
        return equivalents.isEmpty ? ["Building up your time bank!"] : equivalents
    }
    
    private var focusProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) * 0.1 }
        if days < 30 { return 0.7 + Double(days - 7) * 0.01 }
        return min(1.0, 0.93 + Double(days - 30) * 0.001)
    }
    
    private var focusSessionsValue: String {
        if focusProgress < 0.4 { return "Building" }
        if focusProgress < 0.7 { return "Growing" }
        if focusProgress < 0.9 { return "Strong" }
        return "Mastery"
    }
    
    private var productivityProgress: Double {
        let days = habit.daysSinceQuit
        return min(1.0, Double(days) / 60.0)
    }
    
    private var productivityValue: String {
        if productivityProgress < 0.3 { return "+20%" }
        if productivityProgress < 0.6 { return "+40%" }
        if productivityProgress < 0.9 { return "+60%" }
        return "+80%"
    }
    
    private var realConnectionsProgress: Double {
        let days = habit.daysSinceQuit
        return min(1.0, Double(days) / 90.0)
    }
    
    private var realConnectionsValue: String {
        if realConnectionsProgress < 0.3 { return "Growing" }
        if realConnectionsProgress < 0.6 { return "Deeper" }
        if realConnectionsProgress < 0.9 { return "Strong" }
        return "Thriving"
    }
    
    private var mentalClarityProgress: Double {
        let days = habit.daysSinceQuit
        if days < 7 { return Double(days) * 0.08 }
        return min(1.0, 0.56 + Double(days - 7) * 0.006)
    }
    
    private var mentalClarityValue: String {
        if mentalClarityProgress < 0.4 { return "Clearing" }
        if mentalClarityProgress < 0.7 { return "Clearer" }
        if mentalClarityProgress < 0.9 { return "Clear" }
        return "Crystal"
    }
    
    private var attentionSpanProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.5 }
        if days < 60 { return 0.5 + Double(days - 14) / 46.0 * 0.35 }
        return min(1.0, 0.85 + Double(days - 60) / 30.0 * 0.15)
    }
    
    private var focusDuration: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "~15 min" }
        if days < 14 { return "~25 min" }
        if days < 30 { return "~45 min" }
        if days < 60 { return "~60 min" }
        return "90+ min"
    }
    
    private var deepWorkCapacity: String {
        let days = habit.daysSinceQuit
        if days < 7 { return "Low" }
        if days < 14 { return "Building" }
        if days < 30 { return "Moderate" }
        if days < 60 { return "Good" }
        return "Excellent"
    }
}

struct ConnectionType: View {
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

struct MindfulQuestion: View {
    let question: String
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "questionmark.circle")
                .foregroundStyle(Color.textTertiary)
            Text(question)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
                .italic()
        }
    }
}
