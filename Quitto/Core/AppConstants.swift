//
//  AppConstants.swift
//  Quitto
//

import Foundation

enum AppConstants {
    /// App Group identifier for sharing data between main app and widgets
    static let appGroupIdentifier = "group.com.quitto.shared"
    
    /// AI Configuration
    /// IMPORTANT: Replace apiKey with your PRODUCTION OpenAI API key before App Store submission.
    /// For production, route through your own server proxy to avoid exposing the key in the binary.
    enum AI {
        static let baseURL = "https://aimind-main-f42e244.zuplo.app"
        static let apiKey = "sk-proj-dummykey"
        static let model = "gpt-5.2"
    }
    
    /// RevenueCat Configuration
    enum Purchases {
        /// IMPORTANT: Replace with your PRODUCTION Apple API Key from RevenueCat dashboard before App Store submission.
        /// Current value is a TEST key that only works in sandbox.
        static let apiKey = "appl_yPizTJjcTVIlgAbQuJueDGcGuYu"
        /// Primary entitlement that unlocks premium
        static let premiumEntitlement = "Quitto Pro"
        /// Offering identifier to display during onboarding
        static let onboardingOffering = "quitto_onboarding"
    }
    
    /// Social / Engagement
    enum Social {
        static let tiktokURL = "https://www.tiktok.com/@insaneappdev?_r=1&_t=ZS-93hjqTIoM11"
    }
    
    /// Engagement thresholds
    enum Engagement {
        static let reviewActionThreshold = 2
        static let tiktokActionThreshold = 3
        static let paywallChurnDelayMin: TimeInterval = 10
        static let paywallChurnDelayMax: TimeInterval = 15
        static let tiktokCTACooldownDays: Int = 7
    }
    
    /// UserDefaults keys for widget data
    enum WidgetKeys {
        static let daysSinceQuit = "widget_days_since_quit"
        static let habitName = "widget_habit_name"
        static let habitIcon = "widget_habit_icon"
        static let habitTypeRaw = "widget_habit_type"
        static let moneySaved = "widget_money_saved"
        static let streakDays = "widget_streak_days"
        static let progressToNextMilestone = "widget_progress"
        static let nextMilestoneName = "widget_next_milestone"
        static let unitsAvoided = "widget_units_avoided"
        static let quitDate = "widget_quit_date"
        static let dailyAmount = "widget_daily_amount"
        static let costPerUnit = "widget_cost_per_unit"
        static let lastUpdated = "widget_last_updated"
    }
}

// MARK: - Shared UserDefaults

extension UserDefaults {
    static var shared: UserDefaults? {
        UserDefaults(suiteName: AppConstants.appGroupIdentifier)
    }
}
