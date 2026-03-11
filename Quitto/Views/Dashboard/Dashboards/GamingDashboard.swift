//
//  GamingDashboard.swift
//  Quitto
//
//  Dashboard for gaming addiction recovery - productive hours, real achievements, social engagement
//

import SwiftUI

struct GamingDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: .gaming)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                realLifeXPCard
                
                metricsGrid
                
                ModeDailyInsightCard(habit: habit)
                
                timeReclaimedCard
                
                RecoveryPhaseCard(habit: habit)
                
                realAchievementsCard
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                alternativeActivitiesCard
                
                QuickActionsBar(
                    habitType: .gaming,
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
            EmergencyInterventionSheet(habitType: .gaming)
        }
    }
    
    private var realLifeXPCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Real Life XP")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                Text("Level \(realLifeLevel)")
                    .font(.labelMedium)
                    .foregroundStyle(theme.glowColor)
            }
            
            // XP bar
            VStack(spacing: Theme.Spacing.xs) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.textTertiary.opacity(0.2))
                            .frame(height: 24)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [theme.neonAccent, theme.glowColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * xpProgress, height: 24)
                        
                        Text("\(xpEarned) / \(xpForNextLevel) XP")
                            .font(.labelSmall)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 24)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(hoursReclaimed)h")
                        .font(.titleLarge)
                        .foregroundStyle(theme.glowColor)
                    Text("Hours for real life")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(achievementsUnlocked)")
                        .font(.titleLarge)
                        .foregroundStyle(theme.glowColor)
                    Text("Real achievements")
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
                metric: .productiveHours,
                value: productiveHoursValue,
                progress: productiveHoursProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .socialEngagement,
                value: socialEngagementValue,
                progress: socialEngagementProgress,
                habitColor: theme.glowColor
            )
            
            MetricCard(
                metric: .physicalActivity,
                value: physicalActivityValue,
                progress: physicalActivityProgress,
                habitColor: theme.neonAccent
            )
            
            MetricCard(
                metric: .realAchievements,
                value: realAchievementsValue,
                progress: realAchievementsProgress,
                habitColor: theme.neonAccent
            )
        }
    }
    
    private var timeReclaimedCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(theme.glowColor)
                Text("Time Reclaimed")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text("What you could do with \(hoursReclaimed) hours:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            VStack(spacing: Theme.Spacing.sm) {
                TimeEquivalent(activity: "Learn a new language", hours: 100, currentHours: hoursReclaimed, icon: "globe")
                TimeEquivalent(activity: "Read 10 books", hours: 50, currentHours: hoursReclaimed, icon: "book.fill")
                TimeEquivalent(activity: "Get fit", hours: 30, currentHours: hoursReclaimed, icon: "figure.run")
                TimeEquivalent(activity: "Build meaningful relationships", hours: 20, currentHours: hoursReclaimed, icon: "heart.fill")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var realAchievementsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Real Achievements Unlocked")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            VStack(spacing: Theme.Spacing.sm) {
                RealAchievement(title: "First Week Champion", description: "7 days gaming-free", unlocked: habit.daysSinceQuit >= 7, icon: "medal.fill")
                RealAchievement(title: "Social Butterfly", description: "Reconnecting with real people", unlocked: habit.daysSinceQuit >= 14, icon: "person.2.fill")
                RealAchievement(title: "Habit Breaker", description: "30 days of new patterns", unlocked: habit.daysSinceQuit >= 30, icon: "bolt.slash.fill")
                RealAchievement(title: "Life Leveler", description: "90 days of real growth", unlocked: habit.daysSinceQuit >= 90, icon: "crown.fill")
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var alternativeActivitiesCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Level Up IRL")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text("Replace gaming dopamine with real achievements:")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            HStack(spacing: Theme.Spacing.sm) {
                ActivityOption(icon: "figure.run", label: "Exercise", xp: "+50 XP")
                ActivityOption(icon: "book.fill", label: "Learn", xp: "+30 XP")
                ActivityOption(icon: "person.2.fill", label: "Socialize", xp: "+40 XP")
                ActivityOption(icon: "hammer.fill", label: "Create", xp: "+60 XP")
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
    
    private var realLifeLevel: Int {
        let days = habit.daysSinceQuit
        if days < 7 { return 1 }
        if days < 14 { return 2 }
        if days < 30 { return 3 }
        if days < 60 { return 4 }
        if days < 90 { return 5 }
        return min(99, 5 + (days - 90) / 30)
    }
    
    private var xpProgress: Double {
        let days = habit.daysSinceQuit
        let levelDays = [0, 7, 14, 30, 60, 90]
        
        for i in 0..<levelDays.count - 1 {
            if days >= levelDays[i] && days < levelDays[i + 1] {
                let progress = Double(days - levelDays[i]) / Double(levelDays[i + 1] - levelDays[i])
                return progress
            }
        }
        return Double(days % 30) / 30.0
    }
    
    private var xpEarned: Int {
        habit.daysSinceQuit * 100
    }
    
    private var xpForNextLevel: Int {
        let nextLevelDays = [7, 14, 30, 60, 90, 120, 150, 180]
        let days = habit.daysSinceQuit
        
        for milestone in nextLevelDays {
            if days < milestone {
                return milestone * 100
            }
        }
        return ((days / 30) + 1) * 30 * 100
    }
    
    private var hoursReclaimed: Int {
        habit.timeSavedMinutes / 60
    }
    
    private var achievementsUnlocked: Int {
        var count = 0
        if habit.daysSinceQuit >= 1 { count += 1 }
        if habit.daysSinceQuit >= 7 { count += 1 }
        if habit.daysSinceQuit >= 14 { count += 1 }
        if habit.daysSinceQuit >= 30 { count += 1 }
        if habit.daysSinceQuit >= 60 { count += 1 }
        if habit.daysSinceQuit >= 90 { count += 1 }
        return count
    }
    
    private var productiveHoursProgress: Double {
        min(1.0, Double(habit.daysSinceQuit) / 90.0)
    }
    
    private var productiveHoursValue: String {
        "\(hoursReclaimed)h+"
    }
    
    private var socialEngagementProgress: Double {
        let days = habit.daysSinceQuit
        if days < 14 { return Double(days) / 14.0 * 0.4 }
        return min(1.0, 0.4 + Double(days - 14) / 76.0 * 0.6)
    }
    
    private var socialEngagementValue: String {
        if socialEngagementProgress < 0.3 { return "Starting" }
        if socialEngagementProgress < 0.6 { return "Growing" }
        if socialEngagementProgress < 0.9 { return "Active" }
        return "Thriving"
    }
    
    private var physicalActivityProgress: Double {
        let days = habit.daysSinceQuit
        return min(1.0, Double(days) / 60.0)
    }
    
    private var physicalActivityValue: String {
        if physicalActivityProgress < 0.3 { return "Starting" }
        if physicalActivityProgress < 0.6 { return "Regular" }
        if physicalActivityProgress < 0.9 { return "Active" }
        return "Fit"
    }
    
    private var realAchievementsProgress: Double {
        Double(achievementsUnlocked) / 6.0
    }
    
    private var realAchievementsValue: String {
        "\(achievementsUnlocked)/6"
    }
}

struct TimeEquivalent: View {
    let activity: String
    let hours: Int
    let currentHours: Int
    let icon: String
    
    var progress: Double {
        min(1.0, Double(currentHours) / Double(hours))
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(progress >= 1.0 ? Color.accent : Color.textTertiary)
                .frame(width: 24)
            
            Text(activity)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
            
            Spacer()
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.textTertiary.opacity(0.2))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.accent)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(width: 60, height: 6)
            
            Text("\(hours)h")
                .font(.labelSmall)
                .foregroundStyle(Color.textTertiary)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct RealAchievement: View {
    let title: String
    let description: String
    let unlocked: Bool
    let icon: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(unlocked ? Color.warmth.opacity(0.2) : Color.textTertiary.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(unlocked ? Color.warmth : Color.textTertiary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodySmall)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        unlocked
                            ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            : Color.textTertiary
                    )
                Text(description)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
            
            if unlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Color.accent)
            }
        }
    }
}

struct ActivityOption: View {
    let icon: String
    let label: String
    let xp: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.accent)
            Text(label)
                .font(.labelSmall)
                .foregroundStyle(Color.textPrimary)
            Text(xp)
                .font(.labelSmall)
                .foregroundStyle(Color.warmth)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
    }
}
