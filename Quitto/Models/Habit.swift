//
//  Habit.swift
//  Quitto
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var typeRaw: String
    var quitDate: Date
    var dailyAmount: Int
    var costPerUnit: Double
    var motivation: String
    var isActive: Bool
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \CravingLog.habit)
    var cravingLogs: [CravingLog]
    
    @Relationship(deleteRule: .cascade, inverse: \Milestone.habit)
    var milestones: [Milestone]
    
    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.habit)
    var journalEntries: [JournalEntry]
    
    var habitType: HabitType {
        get { HabitType(rawValue: typeRaw) ?? .other }
        set { typeRaw = newValue.rawValue }
    }
    
    init(
        name: String,
        type: HabitType,
        quitDate: Date = Date(),
        dailyAmount: Int = 1,
        costPerUnit: Double? = nil,
        motivation: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.typeRaw = type.rawValue
        self.quitDate = quitDate
        self.dailyAmount = dailyAmount
        self.costPerUnit = costPerUnit ?? type.defaultCostPerUnit
        self.motivation = motivation
        self.isActive = true
        self.createdAt = Date()
        self.cravingLogs = []
        self.milestones = []
        self.journalEntries = []
    }
    
    // MARK: - Computed Properties
    
    var secondsSinceQuit: TimeInterval {
        Date().timeIntervalSince(quitDate)
    }
    
    var daysSinceQuit: Int {
        max(0, Calendar.current.dateComponents([.day], from: quitDate, to: Date()).day ?? 0)
    }
    
    var hoursSinceQuit: Int {
        max(0, Int(secondsSinceQuit / 3600))
    }
    
    var minutesSinceQuit: Int {
        max(0, Int(secondsSinceQuit / 60))
    }
    
    var unitsAvoided: Int {
        daysSinceQuit * dailyAmount
    }
    
    var moneySaved: Double {
        Double(unitsAvoided) * costPerUnit
    }
    
    var timeSavedMinutes: Int {
        unitsAvoided * habitType.minutesPerUnit
    }
    
    var streakDays: Int {
        guard let lastRelapse = cravingLogs
            .filter({ $0.didRelapse })
            .sorted(by: { $0.date > $1.date })
            .first?.date else {
            return daysSinceQuit
        }
        return max(0, Calendar.current.dateComponents([.day], from: lastRelapse, to: Date()).day ?? 0)
    }
    
    var progressToNextMilestone: Double {
        let days = daysSinceQuit
        let milestoneThresholds = [1, 3, 7, 14, 30, 60, 90, 180, 365]
        
        guard let nextMilestone = milestoneThresholds.first(where: { $0 > days }) else {
            return 1.0
        }
        
        let previousMilestone = milestoneThresholds.last(where: { $0 <= days }) ?? 0
        let progress = Double(days - previousMilestone) / Double(nextMilestone - previousMilestone)
        return min(1.0, max(0.0, progress))
    }
    
    var nextMilestoneDay: Int {
        let days = daysSinceQuit
        let milestoneThresholds = [1, 3, 7, 14, 30, 60, 90, 180, 365]
        return milestoneThresholds.first(where: { $0 > days }) ?? 365
    }
    
    var currentPhase: RecoveryPhase {
        RecoveryPhase.phase(for: habitType, days: daysSinceQuit)
    }
    
    var cravingIntensityTrend: Double {
        let recentLogs = cravingLogs
            .filter { $0.date > Date().addingTimeInterval(-7 * 24 * 3600) }
            .sorted { $0.date < $1.date }
        
        guard recentLogs.count >= 2 else { return 0 }
        
        let firstHalf = recentLogs.prefix(recentLogs.count / 2)
        let secondHalf = recentLogs.suffix(recentLogs.count / 2)
        
        let firstAvg = firstHalf.map { Double($0.intensity) }.reduce(0, +) / Double(firstHalf.count)
        let secondAvg = secondHalf.map { Double($0.intensity) }.reduce(0, +) / Double(secondHalf.count)
        
        return secondAvg - firstAvg
    }
}

// MARK: - Recovery Phases

struct RecoveryPhase {
    let name: String
    let description: String
    let tips: [String]
    
    static func phase(for type: HabitType, days: Int) -> RecoveryPhase {
        switch type {
        case .smoking:
            return smokingPhase(days: days)
        case .alcohol:
            return alcoholPhase(days: days)
        default:
            return generalPhase(days: days)
        }
    }
    
    private static func smokingPhase(days: Int) -> RecoveryPhase {
        switch days {
        case 0:
            return RecoveryPhase(
                name: "The Beginning",
                description: "Nicotine is leaving your body. Cravings peak now.",
                tips: [
                    "Take deep breaths when cravings hit",
                    "Keep your hands busy",
                    "Drink plenty of water"
                ]
            )
        case 1...3:
            return RecoveryPhase(
                name: "Peak Withdrawal",
                description: "Your body is adjusting. This is the hardest part.",
                tips: [
                    "Remind yourself this is temporary",
                    "Use the 4 D's: Delay, Deep breathe, Drink water, Do something",
                    "Avoid triggers when possible"
                ]
            )
        case 4...14:
            return RecoveryPhase(
                name: "Breaking Free",
                description: "Physical withdrawal is fading. Habits are being rewired.",
                tips: [
                    "Replace smoking routines with healthy ones",
                    "Celebrate small wins",
                    "Notice how much better you feel"
                ]
            )
        case 15...30:
            return RecoveryPhase(
                name: "New Normal",
                description: "Your new identity as a non-smoker is forming.",
                tips: [
                    "Reflect on how far you've come",
                    "Share your success with others",
                    "Plan rewards for milestones"
                ]
            )
        default:
            return RecoveryPhase(
                name: "Freedom",
                description: "You're a non-smoker now. Keep building this new life.",
                tips: [
                    "Stay vigilant in triggering situations",
                    "Help others who want to quit",
                    "Never forget why you quit"
                ]
            )
        }
    }
    
    private static func alcoholPhase(days: Int) -> RecoveryPhase {
        switch days {
        case 0...7:
            return RecoveryPhase(
                name: "Detox",
                description: "Your body is clearing alcohol. Rest is essential.",
                tips: [
                    "Stay hydrated",
                    "Get plenty of sleep",
                    "Seek medical support if symptoms are severe"
                ]
            )
        case 8...30:
            return RecoveryPhase(
                name: "Early Recovery",
                description: "Sleep and energy are improving. New habits forming.",
                tips: [
                    "Find new social activities",
                    "Identify and avoid triggers",
                    "Build a support network"
                ]
            )
        default:
            return RecoveryPhase(
                name: "Sustained Recovery",
                description: "You're building a new relationship with life.",
                tips: [
                    "Continue working on underlying issues",
                    "Celebrate your progress",
                    "Stay connected to support"
                ]
            )
        }
    }
    
    private static func generalPhase(days: Int) -> RecoveryPhase {
        switch days {
        case 0...7:
            return RecoveryPhase(
                name: "Foundation",
                description: "Building new neural pathways. Every moment matters.",
                tips: [
                    "Focus on one day at a time",
                    "Remove temptations from environment",
                    "Replace the habit with something positive"
                ]
            )
        case 8...30:
            return RecoveryPhase(
                name: "Building Momentum",
                description: "Your new habits are taking root.",
                tips: [
                    "Track your progress",
                    "Reward yourself for milestones",
                    "Visualize your future self"
                ]
            )
        default:
            return RecoveryPhase(
                name: "Mastery",
                description: "You've proven you can do this. Keep going.",
                tips: [
                    "Share your experience with others",
                    "Continue building healthy habits",
                    "Stay mindful of triggers"
                ]
            )
        }
    }
}
