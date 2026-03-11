//
//  CravingLog.swift
//  Quitto
//

import Foundation
import SwiftData

@Model
final class CravingLog {
    var id: UUID
    var date: Date
    var intensity: Int
    var triggerRaw: String
    var note: String
    var didRelapse: Bool
    var durationSeconds: Int
    var copingStrategyUsed: String
    
    var habit: Habit?
    
    var trigger: CravingTrigger {
        get { CravingTrigger(rawValue: triggerRaw) ?? .unknown }
        set { triggerRaw = newValue.rawValue }
    }
    
    init(
        intensity: Int,
        trigger: CravingTrigger,
        note: String = "",
        didRelapse: Bool = false,
        durationSeconds: Int = 0,
        copingStrategyUsed: String = ""
    ) {
        self.id = UUID()
        self.date = Date()
        self.intensity = min(10, max(1, intensity))
        self.triggerRaw = trigger.rawValue
        self.note = note
        self.didRelapse = didRelapse
        self.durationSeconds = durationSeconds
        self.copingStrategyUsed = copingStrategyUsed
    }
}

// MARK: - Craving Trigger

enum CravingTrigger: String, Codable, CaseIterable, Identifiable {
    case stress
    case boredom
    case social
    case emotion
    case routine
    case celebration
    case tiredness
    case hunger
    case anxiety
    case unknown
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .stress: return "Stress"
        case .boredom: return "Boredom"
        case .social: return "Social Situation"
        case .emotion: return "Strong Emotion"
        case .routine: return "Daily Routine"
        case .celebration: return "Celebration"
        case .tiredness: return "Tiredness"
        case .hunger: return "Hunger"
        case .anxiety: return "Anxiety"
        case .unknown: return "Unknown"
        }
    }
    
    var icon: String {
        switch self {
        case .stress: return "bolt.fill"
        case .boredom: return "moon.zzz.fill"
        case .social: return "person.3.fill"
        case .emotion: return "heart.fill"
        case .routine: return "clock.fill"
        case .celebration: return "party.popper.fill"
        case .tiredness: return "bed.double.fill"
        case .hunger: return "fork.knife"
        case .anxiety: return "exclamationmark.triangle.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
    
    var copingStrategies: [String] {
        switch self {
        case .stress:
            return [
                "Take 5 deep breaths",
                "Go for a short walk",
                "Try progressive muscle relaxation",
                "Write down what's stressing you"
            ]
        case .boredom:
            return [
                "Start a quick task you've been putting off",
                "Call a friend",
                "Do 10 push-ups or jumping jacks",
                "Learn something new for 5 minutes"
            ]
        case .social:
            return [
                "Hold a non-alcoholic drink",
                "Step outside for fresh air",
                "Find another non-user to talk to",
                "Focus on conversations, not substances"
            ]
        case .emotion:
            return [
                "Name the emotion you're feeling",
                "Write in your journal",
                "Talk to someone you trust",
                "Practice self-compassion"
            ]
        case .routine:
            return [
                "Replace the habit with something healthy",
                "Change your environment",
                "Break the routine with a new activity",
                "Delay for 10 minutes"
            ]
        case .celebration:
            return [
                "Celebrate with something healthy instead",
                "Remember why you quit",
                "Visualize waking up tomorrow guilt-free",
                "Reward yourself differently"
            ]
        case .tiredness:
            return [
                "Take a power nap",
                "Get some fresh air",
                "Have a healthy snack",
                "Drink water or caffeine-free tea"
            ]
        case .hunger:
            return [
                "Eat a healthy snack",
                "Drink a glass of water",
                "Prepare a proper meal",
                "Distract yourself for 10 minutes"
            ]
        case .anxiety:
            return [
                "Practice box breathing (4-4-4-4)",
                "Ground yourself: 5 things you see, 4 you hear...",
                "Remember: this feeling will pass",
                "Use a calming app or music"
            ]
        case .unknown:
            return [
                "Wait 10 minutes before acting",
                "Drink a glass of water",
                "Do something with your hands",
                "Remind yourself of your reasons"
            ]
        }
    }
}
