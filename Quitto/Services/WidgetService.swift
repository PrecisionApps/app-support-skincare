//
//  WidgetService.swift
//  Quitto
//

import Foundation
import WidgetKit

actor WidgetService {
    
    typealias Keys = AppConstants.WidgetKeys
    
    func updateWidget(with habit: Habit) {
        guard let defaults = UserDefaults.shared else { return }
        
        defaults.set(habit.daysSinceQuit, forKey: Keys.daysSinceQuit)
        defaults.set(habit.name, forKey: Keys.habitName)
        defaults.set(habit.habitType.icon, forKey: Keys.habitIcon)
        defaults.set(habit.habitType.rawValue, forKey: Keys.habitTypeRaw)
        defaults.set(habit.moneySaved, forKey: Keys.moneySaved)
        defaults.set(habit.streakDays, forKey: Keys.streakDays)
        defaults.set(habit.progressToNextMilestone, forKey: Keys.progressToNextMilestone)
        defaults.set(habit.unitsAvoided, forKey: Keys.unitsAvoided)
        defaults.set(habit.quitDate.timeIntervalSince1970, forKey: Keys.quitDate)
        defaults.set(habit.dailyAmount, forKey: Keys.dailyAmount)
        defaults.set(habit.costPerUnit, forKey: Keys.costPerUnit)
        defaults.set(Date().timeIntervalSince1970, forKey: Keys.lastUpdated)
        
        // Get next milestone name
        if let nextMilestone = habit.milestones
            .filter({ !$0.isUnlocked })
            .sorted(by: { $0.daysRequired < $1.daysRequired })
            .first {
            defaults.set(nextMilestone.title, forKey: Keys.nextMilestoneName)
        }
        
        defaults.synchronize()
        
        // Trigger widget reload
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func clearWidgetData() {
        guard let defaults = UserDefaults.shared else { return }
        
        defaults.removeObject(forKey: Keys.daysSinceQuit)
        defaults.removeObject(forKey: Keys.habitName)
        defaults.removeObject(forKey: Keys.habitIcon)
        defaults.removeObject(forKey: Keys.habitTypeRaw)
        defaults.removeObject(forKey: Keys.moneySaved)
        defaults.removeObject(forKey: Keys.streakDays)
        defaults.removeObject(forKey: Keys.progressToNextMilestone)
        defaults.removeObject(forKey: Keys.nextMilestoneName)
        defaults.removeObject(forKey: Keys.unitsAvoided)
        defaults.removeObject(forKey: Keys.quitDate)
        defaults.removeObject(forKey: Keys.dailyAmount)
        defaults.removeObject(forKey: Keys.costPerUnit)
        defaults.removeObject(forKey: Keys.lastUpdated)
        
        defaults.synchronize()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
