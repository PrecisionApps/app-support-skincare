//
//  NotificationService.swift
//  Quitto
//

import Foundation
import UserNotifications

actor NotificationService {
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - Permission
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            return false
        }
    }
    
    // MARK: - Schedule Initial Notifications
    
    func scheduleInitialNotifications(for habit: Habit) async {
        guard await requestPermission() else { return }
        
        await scheduleMorningMotivation(for: habit)
        await scheduleEveningReflection(for: habit)
        await scheduleMilestoneReminders(for: habit)
    }
    
    // MARK: - Morning Motivation
    
    private func scheduleMorningMotivation(for habit: Habit) async {
        let messages = [
            "Good morning! 🌅 Another day of freedom awaits. You've got this.",
            "Rise and shine! ☀️ Today is day \(habit.daysSinceQuit + 1) of your new life.",
            "New day, same strength 💪 Keep moving forward.",
            "Your future self thanks you for staying strong. Let's make today count!",
            "Each morning you wake up free is a victory. Celebrate it!"
        ]
        
        let content = UNMutableNotificationContent()
        content.title = "Good Morning"
        content.body = messages.randomElement()!
        content.sound = .default
        content.categoryIdentifier = "MORNING_MOTIVATION"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_motivation", content: content, trigger: trigger)
        
        try? await center.add(request)
    }
    
    // MARK: - Evening Reflection
    
    private func scheduleEveningReflection(for habit: Habit) async {
        let content = UNMutableNotificationContent()
        content.title = "Evening Reflection"
        content.body = "How was your day? Take a moment to journal your thoughts and celebrate your progress. 📝"
        content.sound = .default
        content.categoryIdentifier = "EVENING_REFLECTION"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "evening_reflection", content: content, trigger: trigger)
        
        try? await center.add(request)
    }
    
    // MARK: - Milestone Reminders
    
    private func scheduleMilestoneReminders(for habit: Habit) async {
        let upcomingMilestones = habit.milestones
            .filter { !$0.isUnlocked }
            .sorted { $0.daysRequired < $1.daysRequired }
            .prefix(3)
        
        for milestone in upcomingMilestones {
            let daysUntil = milestone.daysRequired - habit.daysSinceQuit
            guard daysUntil > 0 else { continue }
            
            let content = UNMutableNotificationContent()
            content.title = "Milestone Approaching! 🎯"
            content.body = "You're \(daysUntil) days away from '\(milestone.title)'. Keep going!"
            content.sound = .default
            
            // Schedule for 1 day before milestone
            if daysUntil > 1 {
                let fireDate = Calendar.current.date(byAdding: .day, value: daysUntil - 1, to: Date())!
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: fireDate)
                dateComponents.hour = 10
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "milestone_\(milestone.daysRequired)_reminder",
                    content: content,
                    trigger: trigger
                )
                
                try? await center.add(request)
            }
        }
    }
    
    // MARK: - Milestone Achievement
    
    func sendMilestoneNotification(_ milestone: Milestone, for habit: Habit) async {
        let content = UNMutableNotificationContent()
        content.title = "🎉 Milestone Achieved!"
        content.body = "\(milestone.title): \(milestone.descriptionText)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("celebration.wav"))
        content.categoryIdentifier = "MILESTONE_ACHIEVED"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "milestone_\(milestone.id)", content: content, trigger: trigger)
        
        try? await center.add(request)
    }
    
    // MARK: - Craving Support
    
    func sendCravingSupport(trigger: CravingTrigger) async {
        let strategies = trigger.copingStrategies
        guard let strategy = strategies.randomElement() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "You've Got This 💪"
        content.body = strategy
        content.sound = .default
        content.categoryIdentifier = "CRAVING_SUPPORT"
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false) // 5 min reminder
        let request = UNNotificationRequest(identifier: "craving_support_\(UUID())", content: content, trigger: notifTrigger)
        
        try? await center.add(request)
    }
    
    // MARK: - Cancel Notifications
    
    func cancelAllNotifications() async {
        center.removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(identifier: String) async {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // MARK: - Setup Categories
    
    func setupCategories() {
        let openAction = UNNotificationAction(
            identifier: "OPEN_ACTION",
            title: "Open App",
            options: [.foreground]
        )
        
        let journalAction = UNNotificationAction(
            identifier: "JOURNAL_ACTION",
            title: "Write Journal Entry",
            options: [.foreground]
        )
        
        let coachAction = UNNotificationAction(
            identifier: "COACH_ACTION",
            title: "Talk to Coach",
            options: [.foreground]
        )
        
        let morningCategory = UNNotificationCategory(
            identifier: "MORNING_MOTIVATION",
            actions: [openAction],
            intentIdentifiers: []
        )
        
        let eveningCategory = UNNotificationCategory(
            identifier: "EVENING_REFLECTION",
            actions: [journalAction, openAction],
            intentIdentifiers: []
        )
        
        let milestoneCategory = UNNotificationCategory(
            identifier: "MILESTONE_ACHIEVED",
            actions: [openAction],
            intentIdentifiers: []
        )
        
        let cravingCategory = UNNotificationCategory(
            identifier: "CRAVING_SUPPORT",
            actions: [coachAction, openAction],
            intentIdentifiers: []
        )
        
        center.setNotificationCategories([
            morningCategory,
            eveningCategory,
            milestoneCategory,
            cravingCategory
        ])
    }
}
