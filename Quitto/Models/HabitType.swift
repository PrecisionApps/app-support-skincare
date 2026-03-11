//
//  HabitType.swift
//  Quitto
//

import SwiftUI

// MARK: - Main Habit Types (10 Major App Store Categories)

enum HabitType: String, Codable, CaseIterable, Identifiable {
    case smoking
    case alcohol
    case porn
    case socialMedia
    case gambling
    case sugar
    case cannabis
    case caffeine
    case vaping
    case gaming
    case other
    
    var id: String { rawValue }
    
    // MARK: - Display Properties
    
    var displayName: String {
        switch self {
        case .smoking: return "Smoking"
        case .alcohol: return "Alcohol"
        case .porn: return "Porn"
        case .socialMedia: return "Social Media"
        case .gambling: return "Gambling"
        case .sugar: return "Sugar"
        case .cannabis: return "Cannabis"
        case .caffeine: return "Caffeine"
        case .vaping: return "Vaping"
        case .gaming: return "Gaming"
        case .other: return "Other"
        }
    }
    
    var tagline: String {
        switch self {
        case .smoking: return "Breathe free again"
        case .alcohol: return "Clear mind, full life"
        case .porn: return "Rewire your brain"
        case .socialMedia: return "Reclaim your time"
        case .gambling: return "Take back control"
        case .sugar: return "Fuel your body right"
        case .cannabis: return "Find natural clarity"
        case .caffeine: return "Natural energy awaits"
        case .vaping: return "Break the cycle"
        case .gaming: return "Level up in real life"
        case .other: return "Break free today"
        }
    }
    
    var icon: String {
        switch self {
        case .smoking: return "smoke.fill"
        case .alcohol: return "wineglass.fill"
        case .porn: return "eye.slash.fill"
        case .socialMedia: return "iphone.gen3"
        case .gambling: return "dice.fill"
        case .sugar: return "cup.and.saucer.fill"
        case .cannabis: return "leaf.fill"
        case .caffeine: return "mug.fill"
        case .vaping: return "cloud.fill"
        case .gaming: return "gamecontroller.fill"
        case .other: return "star.fill"
        }
    }
    
    var heroIcon: String {
        switch self {
        case .smoking: return "lungs.fill"
        case .alcohol: return "drop.fill"
        case .porn: return "brain.head.profile"
        case .socialMedia: return "person.2.fill"
        case .gambling: return "banknote.fill"
        case .sugar: return "heart.fill"
        case .cannabis: return "sparkles"
        case .caffeine: return "bolt.fill"
        case .vaping: return "wind"
        case .gaming: return "figure.walk"
        case .other: return "sparkles"
        }
    }
    
    // MARK: - Color System
    
    var primaryColor: Color {
        switch self {
        case .smoking: return Color(hue: 12, saturation: 75, lightness: 52)
        case .alcohol: return Color(hue: 280, saturation: 60, lightness: 50)
        case .porn: return Color(hue: 340, saturation: 70, lightness: 45)
        case .socialMedia: return Color(hue: 210, saturation: 85, lightness: 55)
        case .gambling: return Color(hue: 145, saturation: 70, lightness: 40)
        case .sugar: return Color(hue: 35, saturation: 90, lightness: 55)
        case .cannabis: return Color(hue: 140, saturation: 65, lightness: 45)
        case .caffeine: return Color(hue: 25, saturation: 75, lightness: 45)
        case .vaping: return Color(hue: 195, saturation: 80, lightness: 50)
        case .gaming: return Color(hue: 270, saturation: 70, lightness: 55)
        case .other: return Color(hue: 180, saturation: 60, lightness: 45)
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .smoking: return Color(hue: 20, saturation: 65, lightness: 62)
        case .alcohol: return Color(hue: 290, saturation: 50, lightness: 60)
        case .porn: return Color(hue: 350, saturation: 60, lightness: 55)
        case .socialMedia: return Color(hue: 220, saturation: 75, lightness: 65)
        case .gambling: return Color(hue: 155, saturation: 60, lightness: 50)
        case .sugar: return Color(hue: 45, saturation: 80, lightness: 65)
        case .cannabis: return Color(hue: 150, saturation: 55, lightness: 55)
        case .caffeine: return Color(hue: 35, saturation: 65, lightness: 55)
        case .vaping: return Color(hue: 205, saturation: 70, lightness: 60)
        case .gaming: return Color(hue: 280, saturation: 60, lightness: 65)
        case .other: return Color(hue: 190, saturation: 50, lightness: 55)
        }
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [secondaryColor, primaryColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var color: Color { primaryColor }
    
    // MARK: - Financial Tracking
    
    var defaultCostPerUnit: Double {
        switch self {
        case .smoking: return 0.55
        case .alcohol: return 10.0
        case .porn: return 15.0 // Premium subscriptions
        case .socialMedia: return 0.0
        case .gambling: return 50.0
        case .sugar: return 4.0
        case .cannabis: return 15.0
        case .caffeine: return 5.50
        case .vaping: return 0.35
        case .gaming: return 0.0
        case .other: return 0.0
        }
    }
    
    var unitName: String {
        switch self {
        case .smoking: return "cigarette"
        case .alcohol: return "drink"
        case .porn: return "session"
        case .socialMedia: return "hour"
        case .gambling: return "bet"
        case .sugar: return "serving"
        case .cannabis: return "use"
        case .caffeine: return "cup"
        case .vaping: return "puff"
        case .gaming: return "hour"
        case .other: return "time"
        }
    }
    
    var unitNamePlural: String {
        switch self {
        case .smoking: return "cigarettes"
        case .alcohol: return "drinks"
        case .porn: return "sessions"
        case .socialMedia: return "hours"
        case .gambling: return "bets"
        case .sugar: return "servings"
        case .cannabis: return "uses"
        case .caffeine: return "cups"
        case .vaping: return "puffs"
        case .gaming: return "hours"
        case .other: return "times"
        }
    }
    
    var defaultDailyAmount: Int {
        switch self {
        case .smoking: return 15
        case .alcohol: return 3
        case .porn: return 2
        case .socialMedia: return 4
        case .gambling: return 5
        case .sugar: return 6
        case .cannabis: return 3
        case .caffeine: return 4
        case .vaping: return 200
        case .gaming: return 5
        case .other: return 1
        }
    }
    
    // MARK: - Time Impact
    
    var minutesPerUnit: Int {
        switch self {
        case .smoking: return 7
        case .alcohol: return 45
        case .porn: return 25
        case .socialMedia: return 60
        case .gambling: return 30
        case .sugar: return 5
        case .cannabis: return 90
        case .caffeine: return 10
        case .vaping: return 1
        case .gaming: return 60
        case .other: return 30
        }
    }
    
    // MARK: - Recovery Timeline Categories
    
    var recoveryCategory: RecoveryCategory {
        switch self {
        case .smoking, .vaping: return .nicotine
        case .alcohol: return .alcohol
        case .porn, .socialMedia, .gambling, .gaming, .other: return .behavioral
        case .sugar, .caffeine: return .dietary
        case .cannabis: return .cannabis
        }
    }
    
    // MARK: - Dashboard Metrics
    
    var primaryMetrics: [DashboardMetric] {
        switch self {
        case .smoking:
            return [.lungCapacity, .oxygenLevel, .heartRate, .bloodPressure]
        case .alcohol:
            return [.liverHealth, .sleepQuality, .hydration, .mentalClarity]
        case .porn:
            return [.dopamineBalance, .focusLevel, .relationshipHealth, .selfControl]
        case .socialMedia:
            return [.screenTime, .focusSessions, .realConnections, .productivity]
        case .gambling:
            return [.moneySaved, .impulseControl, .financialHealth, .stressLevel]
        case .sugar:
            return [.bloodSugar, .energyLevel, .weightProgress, .cravingIntensity]
        case .cannabis:
            return [.memoryClarity, .motivation, .sleepPattern, .anxietyLevel]
        case .caffeine:
            return [.naturalEnergy, .sleepQuality, .anxietyLevel, .hydration]
        case .vaping:
            return [.lungCapacity, .nicotineLevel, .breathQuality, .circulation]
        case .gaming:
            return [.productiveHours, .realAchievements, .socialEngagement, .physicalActivity]
        case .other:
            return [.selfControl, .motivation, .energyLevel, .focusLevel]
        }
    }
}

// MARK: - Recovery Categories

enum RecoveryCategory: String, Codable {
    case nicotine
    case alcohol
    case behavioral
    case dietary
    case cannabis
    
    var withdrawalPeakDays: ClosedRange<Int> {
        switch self {
        case .nicotine: return 2...4
        case .alcohol: return 1...3
        case .behavioral: return 7...21
        case .dietary: return 3...7
        case .cannabis: return 7...14
        }
    }
}

// MARK: - Dashboard Metrics

enum DashboardMetric: String, Codable, CaseIterable {
    // Physical
    case lungCapacity
    case oxygenLevel
    case heartRate
    case bloodPressure
    case liverHealth
    case hydration
    case circulation
    case breathQuality
    case nicotineLevel
    case bloodSugar
    case weightProgress
    case physicalActivity
    
    // Mental
    case mentalClarity
    case focusLevel
    case dopamineBalance
    case selfControl
    case impulseControl
    case memoryClarity
    case motivation
    case anxietyLevel
    case stressLevel
    case naturalEnergy
    case energyLevel
    
    // Behavioral
    case sleepQuality
    case sleepPattern
    case screenTime
    case focusSessions
    case realConnections
    case productivity
    case productiveHours
    case socialEngagement
    case realAchievements
    case relationshipHealth
    
    // Financial
    case moneySaved
    case financialHealth
    case cravingIntensity
    
    var displayName: String {
        switch self {
        case .lungCapacity: return "Lung Capacity"
        case .oxygenLevel: return "Oxygen Level"
        case .heartRate: return "Heart Rate"
        case .bloodPressure: return "Blood Pressure"
        case .liverHealth: return "Liver Health"
        case .hydration: return "Hydration"
        case .circulation: return "Circulation"
        case .breathQuality: return "Breath Quality"
        case .nicotineLevel: return "Nicotine Level"
        case .bloodSugar: return "Blood Sugar"
        case .weightProgress: return "Weight Progress"
        case .physicalActivity: return "Physical Activity"
        case .mentalClarity: return "Mental Clarity"
        case .focusLevel: return "Focus Level"
        case .dopamineBalance: return "Dopamine Balance"
        case .selfControl: return "Self Control"
        case .impulseControl: return "Impulse Control"
        case .memoryClarity: return "Memory Clarity"
        case .motivation: return "Motivation"
        case .anxietyLevel: return "Anxiety Level"
        case .stressLevel: return "Stress Level"
        case .naturalEnergy: return "Natural Energy"
        case .energyLevel: return "Energy Level"
        case .sleepQuality: return "Sleep Quality"
        case .sleepPattern: return "Sleep Pattern"
        case .screenTime: return "Screen Time"
        case .focusSessions: return "Focus Sessions"
        case .realConnections: return "Real Connections"
        case .productivity: return "Productivity"
        case .productiveHours: return "Productive Hours"
        case .socialEngagement: return "Social Engagement"
        case .realAchievements: return "Real Achievements"
        case .relationshipHealth: return "Relationship Health"
        case .moneySaved: return "Money Saved"
        case .financialHealth: return "Financial Health"
        case .cravingIntensity: return "Craving Intensity"
        }
    }
    
    var icon: String {
        switch self {
        case .lungCapacity: return "lungs.fill"
        case .oxygenLevel: return "o.circle.fill"
        case .heartRate: return "heart.fill"
        case .bloodPressure: return "waveform.path.ecg"
        case .liverHealth: return "cross.fill"
        case .hydration: return "drop.fill"
        case .circulation: return "arrow.triangle.2.circlepath"
        case .breathQuality: return "wind"
        case .nicotineLevel: return "chart.line.downtrend.xyaxis"
        case .bloodSugar: return "chart.xyaxis.line"
        case .weightProgress: return "scalemass.fill"
        case .physicalActivity: return "figure.walk"
        case .mentalClarity: return "brain.head.profile"
        case .focusLevel: return "scope"
        case .dopamineBalance: return "sparkles"
        case .selfControl: return "hand.raised.fill"
        case .impulseControl: return "bolt.slash.fill"
        case .memoryClarity: return "memorychip.fill"
        case .motivation: return "flame.fill"
        case .anxietyLevel: return "heart.slash.fill"
        case .stressLevel: return "waveform"
        case .naturalEnergy: return "bolt.fill"
        case .energyLevel: return "battery.100"
        case .sleepQuality: return "moon.fill"
        case .sleepPattern: return "bed.double.fill"
        case .screenTime: return "iphone.gen3"
        case .focusSessions: return "timer"
        case .realConnections: return "person.2.fill"
        case .productivity: return "chart.bar.fill"
        case .productiveHours: return "clock.fill"
        case .socialEngagement: return "bubble.left.and.bubble.right.fill"
        case .realAchievements: return "trophy.fill"
        case .relationshipHealth: return "heart.circle.fill"
        case .moneySaved: return "dollarsign.circle.fill"
        case .financialHealth: return "banknote.fill"
        case .cravingIntensity: return "thermometer.medium"
        }
    }
    
    var improvementDirection: ImprovementDirection {
        switch self {
        case .nicotineLevel, .anxietyLevel, .stressLevel, .screenTime, .cravingIntensity:
            return .decrease
        default:
            return .increase
        }
    }
}

enum ImprovementDirection {
    case increase
    case decrease
}

// MARK: - HabitType Motivational Facts Extension

extension HabitType {
    var motivationalFacts: [String] {
        HabitSpecificData.motivationalFacts(for: self).map { $0.fact }
    }
}

// MARK: - Intelligent Savings Breakdown

struct SavingsCategory: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let dailyAmount: Double
    let explanation: String
    
    var weeklyAmount: Double { dailyAmount * 7 }
    var monthlyAmount: Double { dailyAmount * 30.44 }
    var yearlyAmount: Double { dailyAmount * 365 }
}

struct SavingsBreakdown {
    let categories: [SavingsCategory]
    
    var totalDaily: Double { categories.reduce(0) { $0 + $1.dailyAmount } }
    var totalWeekly: Double { totalDaily * 7 }
    var totalMonthly: Double { totalDaily * 30.44 }
    var totalYearly: Double { totalDaily * 365 }
    
    var costPerUnitEquivalent: Double {
        guard let first = categories.first else { return 0 }
        return first.dailyAmount
    }
}

extension HabitType {
    
    /// Intelligent, research-based savings breakdown that auto-calculates from daily usage.
    /// Sources: CDC, NIAAA, NIH, BLS averages (US 2024).
    func savingsBreakdown(dailyAmount: Int) -> SavingsBreakdown {
        let amount = Double(max(1, dailyAmount))
        
        switch self {
        case .smoking:
            // US avg pack price: $9.17 (2024 CDC). 20 cigs per pack.
            let packFraction = amount / 20.0
            let cigCost = packFraction * 9.17
            // Smokers pay ~$2,000+/yr more in healthcare (CDC).
            let healthDaily = 2200.0 / 365.0
            // Life insurance: smokers pay ~$1,500/yr more.
            let insuranceDaily = 1500.0 / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "flame.fill", label: "Cigarette Costs", dailyAmount: cigCost,
                                explanation: "\(Int(amount)) cigs/day at $9.17/pack"),
                SavingsCategory(icon: "cross.case.fill", label: "Healthcare Savings", dailyAmount: healthDaily,
                                explanation: "Avg smoker medical costs"),
                SavingsCategory(icon: "shield.checkered", label: "Insurance Savings", dailyAmount: insuranceDaily,
                                explanation: "Lower life & health premiums")
            ])
            
        case .vaping:
            // Avg pod/cart: $4.99, lasts ~200 puffs. Disposable: ~$8, ~600 puffs.
            // Blended avg: ~$0.022/puff
            let vapeCost = amount * 0.022
            // Healthcare: ~$800/yr for vaping-related
            let healthDaily = 800.0 / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "cloud.fill", label: "Vape Costs", dailyAmount: vapeCost,
                                explanation: "\(Int(amount)) puffs/day avg"),
                SavingsCategory(icon: "cross.case.fill", label: "Healthcare Savings", dailyAmount: healthDaily,
                                explanation: "Reduced respiratory risk")
            ])
            
        case .alcohol:
            // Avg drink: $8.50 (blended bar + home). BLS data.
            let drinkCost = amount * 8.50
            // Rideshare savings: ~$15/drinking occasion, ~60% of days for daily drinkers
            let rideCost = amount > 0 ? 15.0 * 0.4 : 0
            // Healthcare: heavy drinkers ~$3,000/yr more
            let healthDaily = (amount >= 3 ? 3000.0 : 1500.0) / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "wineglass.fill", label: "Drink Costs", dailyAmount: drinkCost,
                                explanation: "\(Int(amount)) drinks/day at $8.50 avg"),
                SavingsCategory(icon: "car.fill", label: "Rideshare Savings", dailyAmount: rideCost,
                                explanation: "Fewer taxi/Uber rides"),
                SavingsCategory(icon: "cross.case.fill", label: "Healthcare Savings", dailyAmount: healthDaily,
                                explanation: "Liver, heart, immune system")
            ])
            
        case .cannabis:
            // Avg use: ~$12/session (1g at $10-14/g national avg)
            let productCost = amount * 12.0
            // Munchies: ~$5 extra food spending per session
            let munchiesCost = amount * 5.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "leaf.fill", label: "Product Costs", dailyAmount: productCost,
                                explanation: "\(Int(amount)) uses/day at ~$12 avg"),
                SavingsCategory(icon: "fork.knife", label: "Extra Food Spending", dailyAmount: munchiesCost,
                                explanation: "Munchies & impulse eating")
            ])
            
        case .caffeine:
            // Avg coffee shop drink: $5.50 (NCA 2024). Home brew: ~$0.75.
            // Blended avg for tracking: $4.80/cup (most people buy out)
            let coffeeCost = amount * 4.80
            // Sleep aids that caffeine users often buy: ~$200/yr
            let sleepAidDaily = 200.0 / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "mug.fill", label: "Drink Costs", dailyAmount: coffeeCost,
                                explanation: "\(Int(amount)) cups/day at $4.80 avg"),
                SavingsCategory(icon: "moon.fill", label: "Sleep Aid Savings", dailyAmount: sleepAidDaily,
                                explanation: "Melatonin, supplements, etc.")
            ])
            
        case .sugar:
            // Avg sugary item: $3.50 (soda, candy bar, pastry, etc.)
            let sugarCost = amount * 3.50
            // Dental costs: sugar consumers avg $600+/yr more
            let dentalDaily = 600.0 / 365.0
            // Weight/health: obesity-related costs ~$1,800/yr
            let healthDaily = 1200.0 / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "cup.and.saucer.fill", label: "Snack & Drink Costs", dailyAmount: sugarCost,
                                explanation: "\(Int(amount)) servings/day at $3.50 avg"),
                SavingsCategory(icon: "mouth.fill", label: "Dental Savings", dailyAmount: dentalDaily,
                                explanation: "Fewer cavities & procedures"),
                SavingsCategory(icon: "heart.fill", label: "Health Savings", dailyAmount: healthDaily,
                                explanation: "Diabetes & weight-related costs")
            ])
            
        case .gambling:
            // Avg bet: $35 (blended sports/casino/online). Most lose long-term.
            // House edge means avg loss ~15% of wagered amount.
            let gamblingLoss = amount * 35.0 * 0.85
            // Stress-related health: problem gamblers ~$2,500/yr
            let healthDaily = 2500.0 / 365.0
            // Interest on gambling debt: avg problem gambler $8,000 in debt
            let interestDaily = (8000.0 * 0.22) / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "dice.fill", label: "Gambling Losses", dailyAmount: gamblingLoss,
                                explanation: "\(Int(amount)) bets/day, avg net loss"),
                SavingsCategory(icon: "creditcard.fill", label: "Debt Interest", dailyAmount: interestDaily,
                                explanation: "Avg gambling debt interest"),
                SavingsCategory(icon: "brain.head.profile", label: "Stress-Related Health", dailyAmount: healthDaily,
                                explanation: "Anxiety, sleep, cortisol damage")
            ])
            
        case .porn:
            // Subscriptions: avg $20-30/month across sites (not per session)
            // This is a flat monthly cost, not scaled by sessions
            let subscriptionDaily = 25.0 / 30.44
            // Productivity: avg 25 min/session wasted. At $30/hr productivity value.
            let productivityCost = amount * 25.0 / 60.0 * 30.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "creditcard.fill", label: "Subscription Costs", dailyAmount: subscriptionDaily,
                                explanation: "Premium site subscriptions"),
                SavingsCategory(icon: "clock.fill", label: "Productivity Value", dailyAmount: productivityCost,
                                explanation: "\(Int(amount * 25)) min/day reclaimed")
            ])
            
        case .socialMedia:
            // No direct cost. Opportunity cost: $28/hr avg US wage (BLS 2024)
            let opportunityCost = amount * 28.0
            // Mental health: therapy costs for anxiety/depression ~$150/session
            // Avg social media-linked therapy: ~$1,800/yr
            let mentalHealthDaily = 1800.0 / 365.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "clock.fill", label: "Time Value", dailyAmount: opportunityCost,
                                explanation: "\(Int(amount))h/day at $28/hr avg wage"),
                SavingsCategory(icon: "brain.head.profile", label: "Mental Health Value", dailyAmount: mentalHealthDaily,
                                explanation: "Anxiety & comparison costs")
            ])
            
        case .gaming:
            // Subscriptions + microtransactions: avg $40/month for gamers
            let subscriptionDaily = 40.0 / 30.44
            // Opportunity cost: $25/hr conservative
            let opportunityCost = amount * 25.0
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "gamecontroller.fill", label: "Subscriptions & In-App", dailyAmount: subscriptionDaily,
                                explanation: "Game Pass, skins, loot boxes"),
                SavingsCategory(icon: "clock.fill", label: "Time Value", dailyAmount: opportunityCost,
                                explanation: "\(Int(amount))h/day at $25/hr value")
            ])
            
        case .other:
            // Generic: use the default cost per unit as baseline
            let baseCost = amount * defaultCostPerUnit
            
            return SavingsBreakdown(categories: [
                SavingsCategory(icon: "dollarsign.circle.fill", label: "Estimated Costs", dailyAmount: baseCost,
                                explanation: "\(Int(amount)) per day")
            ])
        }
    }
    
    /// Intelligent cost per unit derived from research data (replaces user input).
    /// This is what gets stored on the Habit model for moneySaved calculations.
    func intelligentCostPerUnit(dailyAmount: Int) -> Double {
        let breakdown = savingsBreakdown(dailyAmount: dailyAmount)
        let amount = Double(max(1, dailyAmount))
        return breakdown.totalDaily / amount
    }
}
