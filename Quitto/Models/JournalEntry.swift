//
//  JournalEntry.swift
//  Quitto
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var date: Date
    var content: String
    var moodRaw: String
    var promptUsed: String
    var isAIGenerated: Bool
    
    var habit: Habit?
    
    var mood: JournalMood {
        get { JournalMood(rawValue: moodRaw) ?? .neutral }
        set { moodRaw = newValue.rawValue }
    }
    
    init(
        content: String,
        mood: JournalMood = .neutral,
        promptUsed: String = "",
        isAIGenerated: Bool = false
    ) {
        self.id = UUID()
        self.date = Date()
        self.content = content
        self.moodRaw = mood.rawValue
        self.promptUsed = promptUsed
        self.isAIGenerated = isAIGenerated
    }
}

// MARK: - Journal Mood

enum JournalMood: String, Codable, CaseIterable, Identifiable {
    case terrible
    case bad
    case neutral
    case good
    case excellent
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .terrible: return "Terrible"
        case .bad: return "Bad"
        case .neutral: return "Okay"
        case .good: return "Good"
        case .excellent: return "Excellent"
        }
    }
    
    var emoji: String {
        switch self {
        case .terrible: return "😢"
        case .bad: return "😔"
        case .neutral: return "😐"
        case .good: return "😊"
        case .excellent: return "🤩"
        }
    }
    
    var value: Int {
        switch self {
        case .terrible: return 1
        case .bad: return 2
        case .neutral: return 3
        case .good: return 4
        case .excellent: return 5
        }
    }
}

// MARK: - Journal Prompts

struct JournalPrompt {
    let question: String
    let category: PromptCategory
    
    enum PromptCategory: String, CaseIterable {
        case reflection
        case gratitude
        case challenge
        case progress
        case motivation
    }
    
    static let prompts: [JournalPrompt] = [
        // Reflection
        JournalPrompt(question: "What triggered any cravings today, and how did you handle them?", category: .reflection),
        JournalPrompt(question: "What would your future self thank you for doing today?", category: .reflection),
        JournalPrompt(question: "How has your energy level changed since quitting?", category: .reflection),
        JournalPrompt(question: "What patterns have you noticed in your cravings?", category: .reflection),
        
        // Gratitude
        JournalPrompt(question: "What are three things you're grateful for today?", category: .gratitude),
        JournalPrompt(question: "What's one thing your body can do now that you couldn't before?", category: .gratitude),
        JournalPrompt(question: "Who has supported you on this journey?", category: .gratitude),
        JournalPrompt(question: "What positive change are you most proud of?", category: .gratitude),
        
        // Challenge
        JournalPrompt(question: "What was the hardest moment today and how did you overcome it?", category: .challenge),
        JournalPrompt(question: "If you slipped, what can you learn from it?", category: .challenge),
        JournalPrompt(question: "What situations still feel triggering?", category: .challenge),
        JournalPrompt(question: "What's one thing you'd tell someone starting this journey?", category: .challenge),
        
        // Progress
        JournalPrompt(question: "What NSVs (non-scale victories) did you experience today?", category: .progress),
        JournalPrompt(question: "How do you feel compared to day one?", category: .progress),
        JournalPrompt(question: "What new healthy habit have you adopted?", category: .progress),
        JournalPrompt(question: "What has quitting made room for in your life?", category: .progress),
        
        // Motivation
        JournalPrompt(question: "Why did you start this journey?", category: .motivation),
        JournalPrompt(question: "Who are you doing this for?", category: .motivation),
        JournalPrompt(question: "What will your life look like in one year if you continue?", category: .motivation),
        JournalPrompt(question: "What's your #1 reason to never go back?", category: .motivation)
    ]
    
    static func randomPrompt(for category: PromptCategory? = nil) -> JournalPrompt {
        let filtered = category == nil ? prompts : prompts.filter { $0.category == category }
        return filtered.randomElement() ?? prompts[0]
    }
}
