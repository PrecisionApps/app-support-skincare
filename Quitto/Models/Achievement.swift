//
//  Achievement.swift
//  Quitto
//
//  Achievement and badge system with habit-specific achievements for all 10 habit types
//

import SwiftUI

// MARK: - Achievement Model

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let requirement: AchievementRequirement
    let tier: AchievementTier
    let habitType: HabitType?
    
    var isUniversal: Bool { habitType == nil }
    
    func isUnlocked(for habit: Habit) -> Bool {
        switch requirement {
        case .days(let count):
            return habit.daysSinceQuit >= count
        case .streak(let count):
            return habit.streakDays >= count
        case .moneySaved(let amount):
            return habit.moneySaved >= amount
        case .unitsAvoided(let count):
            return habit.unitsAvoided >= count
        case .cravingsLogged(let count):
            return habit.cravingLogs.count >= count
        case .journalEntries(let count):
            return habit.journalEntries.count >= count
        case .milestones(let count):
            return habit.milestones.filter { $0.isUnlocked }.count >= count
        }
    }
}

enum AchievementRequirement {
    case days(Int)
    case streak(Int)
    case moneySaved(Double)
    case unitsAvoided(Int)
    case cravingsLogged(Int)
    case journalEntries(Int)
    case milestones(Int)
}

enum AchievementTier: String, CaseIterable {
    case bronze
    case silver
    case gold
    case platinum
    case diamond
    
    var color: Color {
        switch self {
        case .bronze: return Color(hue: 30, saturation: 70, lightness: 45)
        case .silver: return Color(hue: 220, saturation: 15, lightness: 65)
        case .gold: return Color(hue: 45, saturation: 90, lightness: 50)
        case .platinum: return Color(hue: 200, saturation: 30, lightness: 75)
        case .diamond: return Color(hue: 195, saturation: 80, lightness: 60)
        }
    }
}

// MARK: - Achievement Provider

struct AchievementProvider {
    
    static func achievements(for type: HabitType) -> [Achievement] {
        let universal = universalAchievements
        let specific = specificAchievements(for: type)
        return universal + specific
    }
    
    // MARK: - Universal Achievements
    
    private static let universalAchievements: [Achievement] = [
        // Time-based
        Achievement(title: "First Step", description: "Complete your first day", icon: "foot.fill", requirement: .days(1), tier: .bronze, habitType: nil),
        Achievement(title: "Week Warrior", description: "7 days clean", icon: "7.circle.fill", requirement: .days(7), tier: .bronze, habitType: nil),
        Achievement(title: "Fortnight Fighter", description: "14 days clean", icon: "calendar", requirement: .days(14), tier: .silver, habitType: nil),
        Achievement(title: "Monthly Master", description: "30 days clean", icon: "moon.fill", requirement: .days(30), tier: .silver, habitType: nil),
        Achievement(title: "Quarter Champion", description: "90 days clean", icon: "trophy.fill", requirement: .days(90), tier: .gold, habitType: nil),
        Achievement(title: "Half Year Hero", description: "180 days clean", icon: "star.fill", requirement: .days(180), tier: .platinum, habitType: nil),
        Achievement(title: "Year of Freedom", description: "365 days clean", icon: "crown.fill", requirement: .days(365), tier: .diamond, habitType: nil),
        
        // Streak achievements
        Achievement(title: "Streak Starter", description: "3 day streak", icon: "flame.fill", requirement: .streak(3), tier: .bronze, habitType: nil),
        Achievement(title: "Streak Builder", description: "14 day streak", icon: "flame.fill", requirement: .streak(14), tier: .silver, habitType: nil),
        Achievement(title: "Streak Master", description: "30 day streak", icon: "flame.fill", requirement: .streak(30), tier: .gold, habitType: nil),
        Achievement(title: "Unstoppable", description: "100 day streak", icon: "flame.fill", requirement: .streak(100), tier: .diamond, habitType: nil),
        
        // Engagement achievements
        Achievement(title: "Self-Aware", description: "Log 10 cravings", icon: "chart.line.uptrend.xyaxis", requirement: .cravingsLogged(10), tier: .bronze, habitType: nil),
        Achievement(title: "Introspective", description: "Write 10 journal entries", icon: "book.fill", requirement: .journalEntries(10), tier: .bronze, habitType: nil),
        Achievement(title: "Milestone Collector", description: "Unlock 5 milestones", icon: "flag.fill", requirement: .milestones(5), tier: .silver, habitType: nil)
    ]
    
    // MARK: - Habit Specific Achievements
    
    private static func specificAchievements(for type: HabitType) -> [Achievement] {
        switch type {
        case .smoking:
            return [
                Achievement(title: "Lungs Healing", description: "24 hours smoke-free", icon: "lungs.fill", requirement: .days(1), tier: .bronze, habitType: .smoking),
                Achievement(title: "Taste Restored", description: "48 hours—taste buds recovering", icon: "nose.fill", requirement: .days(2), tier: .bronze, habitType: .smoking),
                Achievement(title: "Pack Avoider", description: "Avoid 20 cigarettes", icon: "nosign", requirement: .unitsAvoided(20), tier: .bronze, habitType: .smoking),
                Achievement(title: "Carton Crusher", description: "Avoid 200 cigarettes", icon: "xmark.circle.fill", requirement: .unitsAvoided(200), tier: .silver, habitType: .smoking),
                Achievement(title: "$100 Saved", description: "Save $100 from not smoking", icon: "dollarsign.circle.fill", requirement: .moneySaved(100), tier: .silver, habitType: .smoking),
                Achievement(title: "$500 Saved", description: "Save $500 from not smoking", icon: "banknote.fill", requirement: .moneySaved(500), tier: .gold, habitType: .smoking),
                Achievement(title: "Heart Health", description: "Heart disease risk dropping", icon: "heart.fill", requirement: .days(365), tier: .diamond, habitType: .smoking)
            ]
            
        case .alcohol:
            return [
                Achievement(title: "Sober Day", description: "24 hours alcohol-free", icon: "drop.fill", requirement: .days(1), tier: .bronze, habitType: .alcohol),
                Achievement(title: "Clear Headed", description: "1 week sober", icon: "brain.head.profile", requirement: .days(7), tier: .silver, habitType: .alcohol),
                Achievement(title: "Liver Healer", description: "30 days—liver fat reducing", icon: "cross.fill", requirement: .days(30), tier: .gold, habitType: .alcohol),
                Achievement(title: "Drink Dodger", description: "Avoid 50 drinks", icon: "wineglass.fill", requirement: .unitsAvoided(50), tier: .silver, habitType: .alcohol),
                Achievement(title: "$200 Saved", description: "Save $200 from not drinking", icon: "dollarsign.circle.fill", requirement: .moneySaved(200), tier: .silver, habitType: .alcohol),
                Achievement(title: "Sleep Champion", description: "REM sleep restored", icon: "moon.fill", requirement: .days(14), tier: .silver, habitType: .alcohol)
            ]
            
        case .porn:
            return [
                Achievement(title: "Day 1", description: "First day of your reboot", icon: "sparkles", requirement: .days(1), tier: .bronze, habitType: .porn),
                Achievement(title: "Week Strong", description: "7 days—dopamine resetting", icon: "brain.head.profile", requirement: .days(7), tier: .bronze, habitType: .porn),
                Achievement(title: "Focus Returning", description: "14 days—brain fog lifting", icon: "scope", requirement: .days(14), tier: .silver, habitType: .porn),
                Achievement(title: "30 Day Warrior", description: "Major neural pathway changes", icon: "bolt.fill", requirement: .days(30), tier: .silver, habitType: .porn),
                Achievement(title: "60 Day Fighter", description: "Emotional regulation improving", icon: "heart.fill", requirement: .days(60), tier: .gold, habitType: .porn),
                Achievement(title: "90 Day Reboot", description: "Classic reboot milestone!", icon: "brain", requirement: .days(90), tier: .gold, habitType: .porn),
                Achievement(title: "Complete Rewire", description: "6 months—new baseline", icon: "crown.fill", requirement: .days(180), tier: .platinum, habitType: .porn)
            ]
            
        case .socialMedia:
            return [
                Achievement(title: "Notification Free", description: "24 hours unplugged", icon: "bell.slash.fill", requirement: .days(1), tier: .bronze, habitType: .socialMedia),
                Achievement(title: "Present Moment", description: "7 days of real presence", icon: "eye.fill", requirement: .days(7), tier: .silver, habitType: .socialMedia),
                Achievement(title: "Deep Worker", description: "Focus span recovering", icon: "scope", requirement: .days(14), tier: .silver, habitType: .socialMedia),
                Achievement(title: "100 Hours Free", description: "Reclaim 100 hours", icon: "clock.fill", requirement: .unitsAvoided(100), tier: .gold, habitType: .socialMedia),
                Achievement(title: "Self Worth", description: "Identity not tied to likes", icon: "heart.fill", requirement: .days(90), tier: .gold, habitType: .socialMedia),
                Achievement(title: "Attention Sovereign", description: "Complete digital freedom", icon: "crown.fill", requirement: .days(365), tier: .diamond, habitType: .socialMedia)
            ]
            
        case .gambling:
            return [
                Achievement(title: "House Loses", description: "First day gamble-free", icon: "dice.fill", requirement: .days(1), tier: .bronze, habitType: .gambling),
                Achievement(title: "$100 Saved", description: "Money NOT lost gambling", icon: "dollarsign.circle.fill", requirement: .moneySaved(100), tier: .bronze, habitType: .gambling),
                Achievement(title: "$500 Saved", description: "Significant savings", icon: "banknote.fill", requirement: .moneySaved(500), tier: .silver, habitType: .gambling),
                Achievement(title: "$1,000 Winner", description: "Real winning!", icon: "trophy.fill", requirement: .moneySaved(1000), tier: .gold, habitType: .gambling),
                Achievement(title: "Impulse Master", description: "30 days of control", icon: "bolt.slash.fill", requirement: .days(30), tier: .gold, habitType: .gambling),
                Achievement(title: "Financial Freedom", description: "90 days—trust rebuilding", icon: "building.columns.fill", requirement: .days(90), tier: .platinum, habitType: .gambling)
            ]
            
        case .sugar:
            return [
                Achievement(title: "Sugar Free", description: "24 hours no added sugar", icon: "leaf.fill", requirement: .days(1), tier: .bronze, habitType: .sugar),
                Achievement(title: "Craving Crusher", description: "Past peak cravings", icon: "bolt.fill", requirement: .days(3), tier: .bronze, habitType: .sugar),
                Achievement(title: "Taste Reset", description: "Taste buds normalizing", icon: "mouth.fill", requirement: .days(7), tier: .silver, habitType: .sugar),
                Achievement(title: "Energy Stable", description: "No more crashes", icon: "battery.100", requirement: .days(14), tier: .silver, habitType: .sugar),
                Achievement(title: "Inflammation Down", description: "Body healing", icon: "flame.fill", requirement: .days(30), tier: .gold, habitType: .sugar),
                Achievement(title: "Metabolic Reset", description: "Insulin sensitivity improved", icon: "heart.fill", requirement: .days(90), tier: .platinum, habitType: .sugar)
            ]
            
        case .cannabis:
            return [
                Achievement(title: "Clear Start", description: "First sober day", icon: "sun.max.fill", requirement: .days(1), tier: .bronze, habitType: .cannabis),
                Achievement(title: "Dreams Return", description: "REM sleep returning", icon: "moon.stars.fill", requirement: .days(7), tier: .silver, habitType: .cannabis),
                Achievement(title: "Memory Sharp", description: "Short-term memory improving", icon: "brain.head.profile", requirement: .days(14), tier: .silver, habitType: .cannabis),
                Achievement(title: "Clean System", description: "Could pass drug test", icon: "checkmark.circle.fill", requirement: .days(30), tier: .gold, habitType: .cannabis),
                Achievement(title: "Motivation Master", description: "Drive fully restored", icon: "flame.fill", requirement: .days(90), tier: .gold, habitType: .cannabis),
                Achievement(title: "Natural High", description: "Living fully present", icon: "sparkles", requirement: .days(180), tier: .platinum, habitType: .cannabis)
            ]
            
        case .caffeine:
            return [
                Achievement(title: "Withdrawal Warrior", description: "Through day 1 headache", icon: "bolt.fill", requirement: .days(1), tier: .bronze, habitType: .caffeine),
                Achievement(title: "Peak Passed", description: "Worst withdrawal over", icon: "sunrise.fill", requirement: .days(3), tier: .bronze, habitType: .caffeine),
                Achievement(title: "Natural Energy", description: "Adenosine normalized", icon: "battery.100", requirement: .days(7), tier: .silver, habitType: .caffeine),
                Achievement(title: "Sleep Champion", description: "Sleep quality optimal", icon: "moon.fill", requirement: .days(14), tier: .silver, habitType: .caffeine),
                Achievement(title: "Adrenal Healer", description: "Adrenal function recovered", icon: "heart.fill", requirement: .days(30), tier: .gold, habitType: .caffeine),
                Achievement(title: "True Energy", description: "Peak natural vitality", icon: "sparkles", requirement: .days(90), tier: .platinum, habitType: .caffeine)
            ]
            
        case .vaping:
            return [
                Achievement(title: "Clean Breath", description: "24 hours vape-free", icon: "wind", requirement: .days(1), tier: .bronze, habitType: .vaping),
                Achievement(title: "Nicotine Free", description: "Nicotine cleared from body", icon: "checkmark.circle.fill", requirement: .days(3), tier: .silver, habitType: .vaping),
                Achievement(title: "1000 Puffs Avoided", description: "Lungs thank you", icon: "lungs.fill", requirement: .unitsAvoided(1000), tier: .silver, habitType: .vaping),
                Achievement(title: "Cilia Growing", description: "Lungs healing", icon: "leaf.fill", requirement: .days(30), tier: .gold, habitType: .vaping),
                Achievement(title: "$100 Saved", description: "Pod money saved", icon: "dollarsign.circle.fill", requirement: .moneySaved(100), tier: .silver, habitType: .vaping),
                Achievement(title: "Breath of Freedom", description: "Respiratory risk halved", icon: "crown.fill", requirement: .days(365), tier: .diamond, habitType: .vaping)
            ]
            
        case .gaming:
            return [
                Achievement(title: "IRL Day 1", description: "First day unplugged", icon: "figure.walk", requirement: .days(1), tier: .bronze, habitType: .gaming),
                Achievement(title: "Week of Real Life", description: "7 days of real achievements", icon: "star.fill", requirement: .days(7), tier: .silver, habitType: .gaming),
                Achievement(title: "100 Hours Reclaimed", description: "Time for real life", icon: "clock.fill", requirement: .unitsAvoided(100), tier: .gold, habitType: .gaming),
                Achievement(title: "Real Social", description: "Building real connections", icon: "person.2.fill", requirement: .days(30), tier: .gold, habitType: .gaming),
                Achievement(title: "New Hobbies", description: "Developing real skills", icon: "paintbrush.fill", requirement: .days(60), tier: .gold, habitType: .gaming),
                Achievement(title: "Life Champion", description: "Real life is the ultimate game", icon: "crown.fill", requirement: .days(365), tier: .diamond, habitType: .gaming)
            ]
            
        case .other:
            return [
                Achievement(title: "Day One", description: "Your journey begins", icon: "sparkles", requirement: .days(1), tier: .bronze, habitType: .other),
                Achievement(title: "Week Strong", description: "7 days of commitment", icon: "7.circle.fill", requirement: .days(7), tier: .silver, habitType: .other),
                Achievement(title: "Habit Breaker", description: "14 days—patterns changing", icon: "arrow.triangle.2.circlepath", requirement: .days(14), tier: .silver, habitType: .other),
                Achievement(title: "Month Master", description: "30 days of transformation", icon: "moon.fill", requirement: .days(30), tier: .gold, habitType: .other),
                Achievement(title: "Quarter Champion", description: "90 days—new you emerging", icon: "trophy.fill", requirement: .days(90), tier: .gold, habitType: .other),
                Achievement(title: "Freedom Fighter", description: "180 days of freedom", icon: "star.fill", requirement: .days(180), tier: .platinum, habitType: .other),
                Achievement(title: "Year of Change", description: "365 days transformed", icon: "crown.fill", requirement: .days(365), tier: .diamond, habitType: .other)
            ]
        }
    }
}

// MARK: - Achievement Card View

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? achievement.tier.color.opacity(0.2) : Color.textTertiary.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isUnlocked ? achievement.tier.color : Color.textTertiary)
            }
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                HStack {
                    Text(achievement.title)
                        .font(.bodyMedium)
                        .fontWeight(.medium)
                        .foregroundStyle(
                            isUnlocked
                                ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                : Color.textTertiary
                        )
                    
                    if isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(achievement.tier.color)
                    }
                }
                
                Text(achievement.description)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(
                    isUnlocked
                        ? achievement.tier.color.opacity(0.1)
                        : (colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(isUnlocked ? achievement.tier.color.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
