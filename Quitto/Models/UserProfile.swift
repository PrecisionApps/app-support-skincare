//
//  UserProfile.swift
//  Quitto
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var hasCompletedOnboarding: Bool
    var isPremium: Bool
    var joinedDate: Date
    var notificationsEnabled: Bool
    var dailyReminderTime: Date?
    var prefersDarkMode: Bool?
    var aiCoachEnabled: Bool
    var openAIKey: String?
    var aiProxyURL: String?
    var lastActiveDate: Date
    var totalDaysTracked: Int
    var longestStreak: Int
    
    init(name: String = "") {
        self.id = UUID()
        self.name = name
        self.hasCompletedOnboarding = false
        self.isPremium = false
        self.joinedDate = Date()
        self.notificationsEnabled = true
        self.dailyReminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())
        self.prefersDarkMode = nil
        self.aiCoachEnabled = true
        self.openAIKey = nil
        self.aiProxyURL = nil
        self.lastActiveDate = Date()
        self.totalDaysTracked = 0
        self.longestStreak = 0
    }
    
    func updateActivity() {
        lastActiveDate = Date()
        totalDaysTracked += 1
    }
}

// MARK: - AI Coach Message

@Model
final class CoachMessage {
    var id: UUID
    var content: String
    var isFromUser: Bool
    var timestamp: Date
    var habitId: UUID?
    
    init(content: String, isFromUser: Bool, habitId: UUID? = nil) {
        self.id = UUID()
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = Date()
        self.habitId = habitId
    }
}

// MARK: - Notification Settings

struct NotificationPreferences: Codable {
    var morningMotivation: Bool = true
    var morningTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    
    var eveningReflection: Bool = true
    var eveningTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
    
    var milestoneAlerts: Bool = true
    var cravingSupport: Bool = true
    var weeklyProgress: Bool = true
}
