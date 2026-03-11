//
//  InsightsView.swift
//  Quitto
//

import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    private var currentHabit: Habit? { habits.first }
    
    @State private var cravingInsights: CravingInsights?
    @State private var moodInsights: MoodInsights?
    
    private let analyticsService = AnalyticsService()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    if let habit = currentHabit {
                        // Summary Cards
                        summarySection(for: habit)
                        
                        // Craving Analysis
                        if !habit.cravingLogs.isEmpty {
                            cravingAnalysisSection(for: habit)
                        }
                        
                        // Health Recovery Timeline
                        healthTimelineSection(for: habit)
                        
                        // Motivational Facts
                        motivationalFactsSection(for: habit)
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, 100)
            }
            .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await loadInsights()
        }
    }
    
    // MARK: - Summary Section
    
    private func summarySection(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Your Impact")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            HStack(spacing: Theme.Spacing.md) {
                ImpactCard(
                    title: "Life Regained",
                    value: formatLifeRegained(habit.timeSavedMinutes),
                    icon: "heart.fill",
                    color: .alert
                )
                
                if habit.moneySaved > 0 {
                    ImpactCard(
                        title: "Money Saved",
                        value: "$\(Int(habit.moneySaved))",
                        icon: "dollarsign.circle.fill",
                        color: .accent
                    )
                }
            }
            
            // Projection
            if habit.daysSinceQuit > 0 {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("At this rate, by next year you'll save:")
                        .font(.bodySmall)
                        .foregroundStyle(Color.textSecondary)
                    
                    let yearlyProjection = (habit.moneySaved / Double(max(1, habit.daysSinceQuit))) * 365
                    Text("$\(Int(yearlyProjection))")
                        .font(.displaySmall)
                        .foregroundStyle(Color.accent)
                }
                .padding(Theme.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .fill(Color.accent.opacity(0.1))
                )
            }
        }
    }
    
    private func formatLifeRegained(_ minutes: Int) -> String {
        if minutes >= 1440 {
            return "\(minutes / 1440) days"
        } else if minutes >= 60 {
            return "\(minutes / 60) hours"
        } else {
            return "\(minutes) min"
        }
    }
    
    // MARK: - Craving Analysis Section
    
    private func cravingAnalysisSection(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Craving Patterns")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            if let insights = cravingInsights {
                // Trigger breakdown
                if let trigger = insights.mostCommonTrigger {
                    HStack {
                        Image(systemName: trigger.icon)
                            .foregroundStyle(Color.warmth)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Top Trigger")
                                .font(.labelSmall)
                                .foregroundStyle(Color.textTertiary)
                            
                            Text(trigger.displayName)
                                .font(.bodyMedium)
                                .fontWeight(.medium)
                                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        }
                        
                        Spacer()
                    }
                    .padding(Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    )
                }
                
                // Stats row
                HStack(spacing: Theme.Spacing.md) {
                    InsightStatBox(
                        title: "Success Rate",
                        value: "\(Int(insights.successRate))%",
                        trend: insights.successRate > 80 ? .good : .neutral
                    )
                    
                    InsightStatBox(
                        title: "Avg Intensity",
                        value: String(format: "%.1f", insights.averageIntensity),
                        trend: insights.averageIntensity < 5 ? .good : .neutral
                    )
                    
                    if let hour = insights.peakHour {
                        InsightStatBox(
                            title: "Peak Time",
                            value: formatHour(hour),
                            trend: .neutral
                        )
                    }
                }
                
                // Trend indicator
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: insights.weeklyTrend.icon)
                        .foregroundStyle(trendColor(insights.weeklyTrend))
                    
                    Text(insights.weeklyTrend.description)
                        .font(.bodyMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                }
                .padding(Theme.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .fill(trendColor(insights.weeklyTrend).opacity(0.1))
                )
            }
        }
    }
    
    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
    
    private func trendColor(_ trend: CravingTrend) -> Color {
        switch trend {
        case .increasing: return .alert
        case .stable: return .warmth
        case .decreasing: return .accent
        }
    }
    
    // MARK: - Health Timeline Section
    
    private func healthTimelineSection(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Your Body is Healing")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                Spacer()
                SourcesFooterLink(habitName: habit.habitType.displayName)
            }
            
            VStack(spacing: 0) {
                ForEach(healthMilestones(for: habit), id: \.time) { milestone in
                    HealthMilestoneRow(
                        milestone: milestone,
                        isAchieved: habit.secondsSinceQuit >= milestone.seconds
                    )
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
            )
            
            MedicalDisclaimerBanner(compact: true)
        }
    }
    
    private func healthMilestones(for habit: Habit) -> [HealthMilestone] {
        switch habit.habitType {
        case .smoking:
            return [
                HealthMilestone(time: "20 min", seconds: 1200, description: "Heart rate returns to normal", source: "AHA"),
                HealthMilestone(time: "12 hours", seconds: 43200, description: "Carbon monoxide levels normalize", source: "CDC"),
                HealthMilestone(time: "24 hours", seconds: 86400, description: "Risk of heart attack begins to drop", source: "AHA"),
                HealthMilestone(time: "48 hours", seconds: 172800, description: "Nerve endings start regenerating", source: "ALA"),
                HealthMilestone(time: "72 hours", seconds: 259200, description: "Breathing becomes easier", source: "ALA"),
                HealthMilestone(time: "2 weeks", seconds: 1209600, description: "Circulation improves significantly", source: "Surgeon General"),
                HealthMilestone(time: "1 month", seconds: 2592000, description: "Lung function increases up to 30%", source: "ALA"),
                HealthMilestone(time: "3 months", seconds: 7776000, description: "Cilia regrow, reducing infection risk", source: "CDC"),
            ]
        case .alcohol:
            return [
                HealthMilestone(time: "24 hours", seconds: 86400, description: "Blood sugar levels stabilize", source: "NIAAA"),
                HealthMilestone(time: "3 days", seconds: 259200, description: "Alcohol fully leaves your system", source: "NHS"),
                HealthMilestone(time: "1 week", seconds: 604800, description: "Sleep quality improves", source: "NIAAA"),
                HealthMilestone(time: "2 weeks", seconds: 1209600, description: "Stomach lining begins healing", source: "NHS"),
                HealthMilestone(time: "1 month", seconds: 2592000, description: "Liver fat reduces significantly", source: "Hepatology"),
                HealthMilestone(time: "3 months", seconds: 7776000, description: "Blood pressure normalizes", source: "NIAAA"),
            ]
        default:
            return [
                HealthMilestone(time: "1 day", seconds: 86400, description: "First day of freedom complete", source: "APA"),
                HealthMilestone(time: "3 days", seconds: 259200, description: "Physical withdrawal peaks and fades", source: "NIDA"),
                HealthMilestone(time: "1 week", seconds: 604800, description: "New neural pathways forming", source: "Harvard Health"),
                HealthMilestone(time: "2 weeks", seconds: 1209600, description: "Habits are rewiring", source: "Harvard Health"),
                HealthMilestone(time: "1 month", seconds: 2592000, description: "New normal establishing", source: "APA"),
            ]
        }
    }
    
    // MARK: - Motivational Facts Section
    
    private func motivationalFactsSection(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Did You Know?")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            let facts = habit.habitType.motivationalFacts
            let factIndex = habit.daysSinceQuit % facts.count
            
            HStack(alignment: .top, spacing: Theme.Spacing.md) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.warmth)
                
                Text(facts[factIndex])
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
            }
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(Color.warmth.opacity(0.1))
            )
        }
    }
    
    // MARK: - Load Insights
    
    private func loadInsights() async {
        guard let habit = currentHabit else { return }
        
        cravingInsights = await analyticsService.analyzeCravingPatterns(from: habit.cravingLogs)
        moodInsights = await analyticsService.analyzeMoodPatterns(from: habit.journalEntries)
    }
}

// MARK: - Supporting Views

struct ImpactCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(.displaySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text(title)
                .font(.labelMedium)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
    }
}

struct InsightStatBox: View {
    let title: String
    let value: String
    let trend: InsightTrend
    
    @Environment(\.colorScheme) private var colorScheme
    
    enum InsightTrend {
        case good, neutral, bad
        
        var color: Color {
            switch self {
            case .good: return .accent
            case .neutral: return .textSecondary
            case .bad: return .alert
            }
        }
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(value)
                .font(.titleMedium)
                .foregroundStyle(trend.color)
            
            Text(title)
                .font(.labelSmall)
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
        )
    }
}

struct HealthMilestone {
    let time: String
    let seconds: Double
    let description: String
    let source: String
}

struct HealthMilestoneRow: View {
    let milestone: HealthMilestone
    let isAchieved: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(isAchieved ? Color.accent : Color.textTertiary.opacity(0.3))
                    .frame(width: 24, height: 24)
                
                if isAchieved {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(milestone.time)
                    .font(.labelMedium)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        isAchieved
                            ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            : Color.textTertiary
                    )
                
                Text(milestone.description)
                    .font(.bodySmall)
                    .foregroundStyle(
                        isAchieved
                            ? (colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                            : Color.textTertiary
                    )
                
                SourceAttributionLabel(source: milestone.source)
            }
            
            Spacer()
        }
        .padding(.vertical, Theme.Spacing.sm)
    }
}

#Preview {
    InsightsView()
        .modelContainer(for: [Habit.self], inMemory: true)
}
