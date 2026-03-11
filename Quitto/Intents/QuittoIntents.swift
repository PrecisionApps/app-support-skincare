//
//  QuittoIntents.swift
//  Quitto
//
//  App Intents for Siri and Shortcuts integration
//

import AppIntents
import SwiftUI
import SwiftData

// MARK: - Check Progress Intent

struct CheckProgressIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Quitto Progress"
    static var description = IntentDescription("Check how long you've been clean and your progress stats.")
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let defaults = UserDefaults(suiteName: "group.com.quitto.shared") else {
            return .result(dialog: "Open Quitto to start tracking your recovery journey!")
        }
        
        let habitName = defaults.string(forKey: "widget_habit_name") ?? ""
        guard !habitName.isEmpty else {
            return .result(dialog: "Open Quitto to start tracking your recovery journey!")
        }
        
        var daysSinceQuit = defaults.integer(forKey: "widget_days_since_quit")
        if let quitTimestamp = defaults.object(forKey: "widget_quit_date") as? Double {
            let quitDate = Date(timeIntervalSince1970: quitTimestamp)
            daysSinceQuit = max(0, Calendar.current.dateComponents([.day], from: quitDate, to: Date()).day ?? 0)
        }
        
        let dailyAmount = defaults.integer(forKey: "widget_daily_amount")
        let costPerUnit = defaults.double(forKey: "widget_cost_per_unit")
        let saved = Double(daysSinceQuit * dailyAmount) * costPerUnit
        
        if saved > 0 {
            return .result(
                dialog: "You've been clean from \(habitName) for \(daysSinceQuit) days and saved $\(Int(saved))! Keep going, you're doing amazing!"
            )
        } else {
            return .result(
                dialog: "You've been clean from \(habitName) for \(daysSinceQuit) days! Keep going, you're doing amazing!"
            )
        }
    }
}

// MARK: - Log Craving Intent

struct LogCravingIntent: AppIntent {
    static var title: LocalizedStringResource = "Log a Craving"
    static var description = IntentDescription("Quickly log a craving when you're feeling the urge.")
    
    @Parameter(title: "Intensity", default: 5)
    var intensity: Int
    
    @Parameter(title: "Trigger")
    var trigger: CravingTriggerEntity?
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // This would open the app to the craving log sheet
        return .result(
            dialog: "Opening Quitto to log your craving. Stay strong!"
        )
    }
}

// MARK: - Get Motivation Intent

struct GetMotivationIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Motivation"
    static var description = IntentDescription("Get an encouraging message from your AI coach.")
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let messages = [
            "Every craving you overcome makes the next one weaker. You're rewiring your brain right now!",
            "Remember why you started. Your future self is thanking you for this moment of strength.",
            "This feeling is temporary. Your freedom is permanent. You've got this!",
            "You're not just avoiding something bad—you're building something beautiful. A healthier, freer you.",
            "Each day clean is a victory. You're stacking wins, and that momentum is unstoppable."
        ]
        
        let randomMessage = messages.randomElement() ?? messages[0]
        
        return .result(dialog: "\(randomMessage)")
    }
}

// MARK: - Craving Trigger Entity

struct CravingTriggerEntity: AppEntity {
    var id: String
    var displayName: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Craving Trigger"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayName)")
    }
    
    static var defaultQuery = CravingTriggerQuery()
}

struct CravingTriggerQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [CravingTriggerEntity] {
        identifiers.compactMap { id in
            CravingTrigger(rawValue: id).map {
                CravingTriggerEntity(id: id, displayName: $0.displayName)
            }
        }
    }
    
    func suggestedEntities() async throws -> [CravingTriggerEntity] {
        CravingTrigger.allCases.map {
            CravingTriggerEntity(id: $0.rawValue, displayName: $0.displayName)
        }
    }
}

// MARK: - App Shortcuts Provider

struct QuittoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CheckProgressIntent(),
            phrases: [
                "Check my \(.applicationName) progress",
                "How am I doing in \(.applicationName)",
                "Show my \(.applicationName) stats"
            ],
            shortTitle: "Check Progress",
            systemImageName: "chart.bar.fill"
        )
        
        AppShortcut(
            intent: GetMotivationIntent(),
            phrases: [
                "I need motivation from \(.applicationName)",
                "Give me encouragement from \(.applicationName)",
                "Motivate me \(.applicationName)"
            ],
            shortTitle: "Get Motivated",
            systemImageName: "heart.fill"
        )
        
        AppShortcut(
            intent: LogCravingIntent(),
            phrases: [
                "Log a craving in \(.applicationName)",
                "I'm having a craving \(.applicationName)",
                "Record craving \(.applicationName)"
            ],
            shortTitle: "Log Craving",
            systemImageName: "exclamationmark.triangle.fill"
        )
    }
}
