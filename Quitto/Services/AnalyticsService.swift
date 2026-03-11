//
//  AnalyticsService.swift
//  Quitto
//

import Foundation

actor AnalyticsService {
    
    // MARK: - Craving Analysis
    
    func analyzeCravingPatterns(from logs: [CravingLog]) -> CravingInsights {
        guard !logs.isEmpty else {
            return CravingInsights(
                mostCommonTrigger: nil,
                peakHour: nil,
                averageIntensity: 0,
                weeklyTrend: .stable,
                successRate: 0
            )
        }
        
        // Find most common trigger
        let triggerCounts = Dictionary(grouping: logs) { $0.trigger }
            .mapValues { $0.count }
        let mostCommonTrigger = triggerCounts.max(by: { $0.value < $1.value })?.key
        
        // Find peak craving hour
        let hourCounts = Dictionary(grouping: logs) { 
            Calendar.current.component(.hour, from: $0.date)
        }.mapValues { $0.count }
        let peakHour = hourCounts.max(by: { $0.value < $1.value })?.key
        
        // Average intensity
        let totalIntensity = logs.reduce(0) { $0 + $1.intensity }
        let averageIntensity = Double(totalIntensity) / Double(logs.count)
        
        // Weekly trend
        let recentLogs = logs.filter { 
            $0.date > Date().addingTimeInterval(-7 * 24 * 3600) 
        }
        let olderLogs = logs.filter { 
            $0.date <= Date().addingTimeInterval(-7 * 24 * 3600) &&
            $0.date > Date().addingTimeInterval(-14 * 24 * 3600)
        }
        
        let recentAvg = recentLogs.isEmpty ? 0 : Double(recentLogs.count) / 7.0
        let olderAvg = olderLogs.isEmpty ? 0 : Double(olderLogs.count) / 7.0
        
        let weeklyTrend: CravingTrend
        if olderAvg == 0 {
            weeklyTrend = .stable
        } else if recentAvg < olderAvg * 0.7 {
            weeklyTrend = .decreasing
        } else if recentAvg > olderAvg * 1.3 {
            weeklyTrend = .increasing
        } else {
            weeklyTrend = .stable
        }
        
        // Success rate (cravings overcome without relapse)
        let successCount = logs.filter { !$0.didRelapse }.count
        let successRate = Double(successCount) / Double(logs.count) * 100
        
        return CravingInsights(
            mostCommonTrigger: mostCommonTrigger,
            peakHour: peakHour,
            averageIntensity: averageIntensity,
            weeklyTrend: weeklyTrend,
            successRate: successRate
        )
    }
    
    // MARK: - Mood Analysis
    
    func analyzeMoodPatterns(from entries: [JournalEntry]) -> MoodInsights {
        guard !entries.isEmpty else {
            return MoodInsights(
                averageMood: 3,
                moodTrend: .stable,
                bestDay: nil,
                worstDay: nil,
                moodByDayOfWeek: [:]
            )
        }
        
        // Average mood
        let totalMood = entries.reduce(0) { $0 + $1.mood.value }
        let averageMood = Double(totalMood) / Double(entries.count)
        
        // Trend over last 14 days
        let recentEntries = entries.filter {
            $0.date > Date().addingTimeInterval(-7 * 24 * 3600)
        }
        let olderEntries = entries.filter {
            $0.date <= Date().addingTimeInterval(-7 * 24 * 3600) &&
            $0.date > Date().addingTimeInterval(-14 * 24 * 3600)
        }
        
        let recentAvg = recentEntries.isEmpty ? averageMood :
            Double(recentEntries.reduce(0) { $0 + $1.mood.value }) / Double(recentEntries.count)
        let olderAvg = olderEntries.isEmpty ? averageMood :
            Double(olderEntries.reduce(0) { $0 + $1.mood.value }) / Double(olderEntries.count)
        
        let moodTrend: MoodTrend
        if recentAvg > olderAvg + 0.5 {
            moodTrend = .improving
        } else if recentAvg < olderAvg - 0.5 {
            moodTrend = .declining
        } else {
            moodTrend = .stable
        }
        
        // Best and worst entries
        let bestEntry = entries.max(by: { $0.mood.value < $1.mood.value })
        let worstEntry = entries.min(by: { $0.mood.value < $1.mood.value })
        
        // Mood by day of week
        var moodByDay: [Int: [Int]] = [:]
        for entry in entries {
            let weekday = Calendar.current.component(.weekday, from: entry.date)
            moodByDay[weekday, default: []].append(entry.mood.value)
        }
        
        let averageMoodByDay = moodByDay.mapValues { moods in
            Double(moods.reduce(0, +)) / Double(moods.count)
        }
        
        return MoodInsights(
            averageMood: averageMood,
            moodTrend: moodTrend,
            bestDay: bestEntry?.date,
            worstDay: worstEntry?.date,
            moodByDayOfWeek: averageMoodByDay
        )
    }
    
    // MARK: - Progress Prediction
    
    func predictCravingRisk(for habit: Habit, at date: Date) -> CravingRisk {
        let logs = habit.cravingLogs
        
        // Base risk on time of day
        let hour = Calendar.current.component(.hour, from: date)
        let hourLogs = logs.filter {
            Calendar.current.component(.hour, from: $0.date) == hour
        }
        
        let hourRisk = min(1.0, Double(hourLogs.count) / 10.0)
        
        // Day of week risk
        let weekday = Calendar.current.component(.weekday, from: date)
        let weekdayLogs = logs.filter {
            Calendar.current.component(.weekday, from: $0.date) == weekday
        }
        
        let weekdayRisk = min(1.0, Double(weekdayLogs.count) / 5.0)
        
        // Recent craving momentum
        let recentLogs = logs.filter {
            $0.date > Date().addingTimeInterval(-24 * 3600)
        }
        let momentumRisk = min(1.0, Double(recentLogs.count) / 3.0)
        
        // Combined risk
        let combinedRisk = (hourRisk * 0.4 + weekdayRisk * 0.3 + momentumRisk * 0.3)
        
        let level: RiskLevel
        switch combinedRisk {
        case 0..<0.3: level = .low
        case 0.3..<0.6: level = .medium
        default: level = .high
        }
        
        // Generate recommendations
        var recommendations: [String] = []
        
        if hourRisk > 0.5 {
            recommendations.append("This time of day is historically challenging. Have coping strategies ready.")
        }
        
        if momentumRisk > 0.5 {
            recommendations.append("You've had recent cravings. Consider extra self-care today.")
        }
        
        if recommendations.isEmpty {
            recommendations.append("You're doing great! Keep up the positive momentum.")
        }
        
        return CravingRisk(
            level: level,
            score: combinedRisk,
            recommendations: recommendations
        )
    }
}

// MARK: - Insight Types

struct CravingInsights {
    let mostCommonTrigger: CravingTrigger?
    let peakHour: Int?
    let averageIntensity: Double
    let weeklyTrend: CravingTrend
    let successRate: Double
}

enum CravingTrend {
    case increasing
    case stable
    case decreasing
    
    var description: String {
        switch self {
        case .increasing: return "Cravings are increasing"
        case .stable: return "Cravings are stable"
        case .decreasing: return "Cravings are decreasing"
        }
    }
    
    var icon: String {
        switch self {
        case .increasing: return "arrow.up.right"
        case .stable: return "arrow.right"
        case .decreasing: return "arrow.down.right"
        }
    }
}

struct MoodInsights {
    let averageMood: Double
    let moodTrend: MoodTrend
    let bestDay: Date?
    let worstDay: Date?
    let moodByDayOfWeek: [Int: Double]
}

enum MoodTrend {
    case improving
    case stable
    case declining
    
    var description: String {
        switch self {
        case .improving: return "Your mood is improving"
        case .stable: return "Your mood is stable"
        case .declining: return "Your mood has dipped"
        }
    }
}

struct CravingRisk {
    let level: RiskLevel
    let score: Double
    let recommendations: [String]
}

enum RiskLevel {
    case low
    case medium
    case high
    
    var description: String {
        switch self {
        case .low: return "Low risk"
        case .medium: return "Moderate risk"
        case .high: return "Higher risk"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}
