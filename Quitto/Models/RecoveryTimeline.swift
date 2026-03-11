//
//  RecoveryTimeline.swift
//  Quitto
//
//  Comprehensive recovery timelines for all 10 habit types
//

import SwiftUI

// MARK: - Recovery Timeline

struct RecoveryTimeline {
    let habitType: HabitType
    let milestones: [RecoveryMilestone]
    
    static func timeline(for type: HabitType) -> RecoveryTimeline {
        RecoveryTimeline(
            habitType: type,
            milestones: RecoveryMilestone.milestones(for: type)
        )
    }
    
    func currentMilestone(days: Int) -> RecoveryMilestone? {
        milestones.last { $0.dayThreshold <= days }
    }
    
    func nextMilestone(days: Int) -> RecoveryMilestone? {
        milestones.first { $0.dayThreshold > days }
    }
    
    func progress(days: Int) -> Double {
        guard let current = currentMilestone(days: days),
              let next = nextMilestone(days: days) else {
            return days > 0 ? 1.0 : 0.0
        }
        
        let range = Double(next.dayThreshold - current.dayThreshold)
        let progress = Double(days - current.dayThreshold)
        return min(1.0, max(0.0, progress / range))
    }
}

// MARK: - Recovery Milestone

struct RecoveryMilestone: Identifiable {
    let id = UUID()
    let dayThreshold: Int
    let title: String
    let description: String
    let healthBenefits: [String]
    let celebration: String
    let icon: String
    var sources: [String] = []
    
    var timeDescription: String {
        switch dayThreshold {
        case 0: return "Now"
        case 1: return "1 day"
        case 2...6: return "\(dayThreshold) days"
        case 7: return "1 week"
        case 8...13: return "\(dayThreshold) days"
        case 14: return "2 weeks"
        case 15...20: return "\(dayThreshold) days"
        case 21: return "3 weeks"
        case 22...29: return "\(dayThreshold) days"
        case 30: return "1 month"
        case 31...59: return "\(dayThreshold) days"
        case 60: return "2 months"
        case 61...89: return "\(dayThreshold) days"
        case 90: return "3 months"
        case 91...179: return "\(dayThreshold) days"
        case 180: return "6 months"
        case 181...364: return "\(dayThreshold) days"
        case 365: return "1 year"
        default: return "\(dayThreshold / 365) years"
        }
    }
    
    // MARK: - Habit-Specific Milestones
    
    static func milestones(for type: HabitType) -> [RecoveryMilestone] {
        switch type {
        case .smoking: return smokingMilestones
        case .alcohol: return alcoholMilestones
        case .porn: return pornMilestones
        case .socialMedia: return socialMediaMilestones
        case .gambling: return gamblingMilestones
        case .sugar: return sugarMilestones
        case .cannabis: return cannabisMilestones
        case .caffeine: return caffeineMilestones
        case .vaping: return vapingMilestones
        case .gaming: return gamingMilestones
        case .other: return otherMilestones
        }
    }
    
    // MARK: - Smoking Milestones
    
    static let smokingMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "The Beginning",
            description: "Your body starts healing the moment you stop.",
            healthBenefits: [
                "Heart rate begins to drop within 20 minutes",
                "Carbon monoxide levels start decreasing",
                "Blood oxygen levels begin normalizing"
            ],
            celebration: "You've taken the hardest step!",
            icon: "sparkles",
            sources: ["AHA", "CDC"]
        ),
        RecoveryMilestone(
            dayThreshold: 1,
            title: "24 Hours Clean",
            description: "Carbon monoxide is leaving your bloodstream.",
            healthBenefits: [
                "CO levels return to normal",
                "Oxygen delivery to heart improves",
                "Heart attack risk begins to drop"
            ],
            celebration: "One full day smoke-free! 🎉",
            icon: "heart.fill",
            sources: ["AHA", "CDC"]
        ),
        RecoveryMilestone(
            dayThreshold: 2,
            title: "Senses Awakening",
            description: "Nerve endings start regenerating.",
            healthBenefits: [
                "Taste buds begin recovering",
                "Sense of smell improves",
                "Nicotine leaves the body"
            ],
            celebration: "Food starts tasting better!",
            icon: "nose.fill",
            sources: ["ALA", "Surgeon General"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Breathing Easier",
            description: "Bronchial tubes begin to relax.",
            healthBenefits: [
                "Breathing becomes easier",
                "Lung capacity starts increasing",
                "Energy levels begin to rise"
            ],
            celebration: "Peak withdrawal is passing!",
            icon: "wind",
            sources: ["ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Strong",
            description: "You've survived the toughest week.",
            healthBenefits: [
                "Cilia in lungs start regrowing",
                "Mucus begins clearing",
                "Risk of relapse significantly decreases"
            ],
            celebration: "The first week is the hardest—you did it!",
            icon: "trophy.fill",
            sources: ["ALA", "CDC"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Free",
            description: "Circulation is noticeably improving.",
            healthBenefits: [
                "Walking becomes easier",
                "Circulation improved up to 30%",
                "Lung function increasing"
            ],
            celebration: "Two weeks of freedom!",
            icon: "figure.walk",
            sources: ["Surgeon General", "AHA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month Victory",
            description: "Your lungs are repairing themselves.",
            healthBenefits: [
                "Lung cilia fully regrown",
                "Infection risk decreased",
                "Overall energy significantly improved"
            ],
            celebration: "A whole month! You're unstoppable!",
            icon: "lungs.fill",
            sources: ["ALA", "CDC"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "Circulation and lung function greatly improved.",
            healthBenefits: [
                "Lung function improved up to 30%",
                "Heart attack risk dropping",
                "Chronic cough likely resolved"
            ],
            celebration: "90 days of choosing yourself!",
            icon: "heart.circle.fill",
            sources: ["ALA", "AHA"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "Stress, anxiety, and depression have decreased.",
            healthBenefits: [
                "Energy levels normalized",
                "Shortness of breath resolved",
                "Immune system strengthened"
            ],
            celebration: "Half a year—incredible journey!",
            icon: "star.fill",
            sources: ["CDC", "Surgeon General"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Free",
            description: "Heart disease risk is now half that of a smoker.",
            healthBenefits: [
                "Heart disease risk cut in half",
                "Stroke risk significantly reduced",
                "Overall mortality risk decreasing"
            ],
            celebration: "ONE YEAR! You've changed your life! 🏆",
            icon: "crown.fill",
            sources: ["AHA", "Surgeon General"]
        )
    ]
    
    // MARK: - Alcohol Milestones
    
    static let alcoholMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Sober Start",
            description: "Your liver begins its recovery process.",
            healthBenefits: [
                "Liver starts processing remaining alcohol",
                "Blood alcohol level decreasing",
                "Hydration recovery begins"
            ],
            celebration: "The journey to clarity begins!",
            icon: "drop.fill",
            sources: ["NIAAA", "NHS"]
        ),
        RecoveryMilestone(
            dayThreshold: 1,
            title: "First Sober Day",
            description: "Blood sugar levels stabilizing.",
            healthBenefits: [
                "Blood sugar normalizing",
                "Anxiety may peak (temporary)",
                "Dehydration recovering"
            ],
            celebration: "24 hours of strength!",
            icon: "sunrise.fill",
            sources: ["NIAAA"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Detox Progress",
            description: "Most acute withdrawal symptoms subsiding.",
            healthBenefits: [
                "Worst withdrawal symptoms passing",
                "Sleep starting to improve",
                "Appetite returning"
            ],
            celebration: "Through the hardest part!",
            icon: "moon.stars.fill",
            sources: ["NHS", "NIAAA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Sober",
            description: "Sleep quality dramatically improving.",
            healthBenefits: [
                "REM sleep returning to normal",
                "Hydration levels improved",
                "Skin starting to look healthier"
            ],
            celebration: "A week of choosing health!",
            icon: "bed.double.fill",
            sources: ["NIAAA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Clear",
            description: "Liver fat beginning to reduce.",
            healthBenefits: [
                "Liver fat reducing",
                "Stomach lining healing",
                "Blood pressure improving"
            ],
            celebration: "Two weeks of transformation!",
            icon: "cross.fill",
            sources: ["Hepatology", "NHS"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month Milestone",
            description: "Liver fat can reduce by up to 20%.",
            healthBenefits: [
                "Liver fat reduced significantly",
                "Cholesterol levels improving",
                "Mental clarity greatly enhanced"
            ],
            celebration: "30 days of freedom!",
            icon: "brain.head.profile",
            sources: ["Hepatology"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months Sober",
            description: "Significant improvements in overall health.",
            healthBenefits: [
                "Immune system strengthened",
                "Blood pressure normalized",
                "Risk of cancer decreasing"
            ],
            celebration: "90 days of new life!",
            icon: "shield.fill",
            sources: ["NIAAA", "NHS"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "Brain chemistry rebalancing.",
            healthBenefits: [
                "Dopamine receptors recovering",
                "Emotional regulation improved",
                "Relationships strengthening"
            ],
            celebration: "Half a year—remarkable!",
            icon: "sparkles",
            sources: ["NIAAA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Sober",
            description: "Risk of many diseases significantly reduced.",
            healthBenefits: [
                "Cancer risk significantly lowered",
                "Heart health greatly improved",
                "Life expectancy increasing"
            ],
            celebration: "365 days of courage! 🎊",
            icon: "crown.fill",
            sources: ["NIAAA", "NHS"]
        )
    ]
    
    // MARK: - Porn Milestones
    
    static let pornMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Reclaim Your Mind",
            description: "The brain begins rewiring from the first moment.",
            healthBenefits: [
                "Dopamine system reset begins",
                "Mental space clearing",
                "Self-awareness increasing"
            ],
            celebration: "You've chosen freedom!",
            icon: "brain.head.profile",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Free",
            description: "Initial dopamine recalibration happening.",
            healthBenefits: [
                "Urges becoming more manageable",
                "Sleep quality improving",
                "Energy levels stabilizing"
            ],
            celebration: "7 days of mental freedom!",
            icon: "sparkles",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Strong",
            description: "Brain fog starting to lift.",
            healthBenefits: [
                "Focus and concentration improving",
                "Motivation increasing",
                "Real attraction returning"
            ],
            celebration: "Two weeks of clarity!",
            icon: "scope",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "30 Day Warrior",
            description: "Significant neural pathway changes.",
            healthBenefits: [
                "Dopamine sensitivity improving",
                "Confidence building",
                "Social anxiety decreasing"
            ],
            celebration: "One month—new patterns forming!",
            icon: "bolt.fill",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 60,
            title: "Two Months Free",
            description: "Emotional regulation improving.",
            healthBenefits: [
                "Emotional depth returning",
                "Relationship quality improving",
                "Self-esteem rising"
            ],
            celebration: "60 days of transformation!",
            icon: "heart.fill",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "90 Day Reboot",
            description: "Major neuroplasticity milestone.",
            healthBenefits: [
                "Brain largely rewired",
                "Natural pleasure response restored",
                "Intimacy capacity improved"
            ],
            celebration: "The classic reboot milestone! 🧠",
            icon: "brain",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "New baseline of normal established.",
            healthBenefits: [
                "Healthy sexuality restored",
                "Deep emotional connections possible",
                "Full focus and drive unlocked"
            ],
            celebration: "Half a year of freedom!",
            icon: "person.2.fill",
            sources: ["Cambridge", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Clean",
            description: "Complete mental and emotional transformation.",
            healthBenefits: [
                "Porn no longer holds power",
                "Authentic relationships flourishing",
                "Full self-actualization path open"
            ],
            celebration: "365 days of choosing real life! 👑",
            icon: "crown.fill",
            sources: ["Cambridge", "APA"]
        )
    ]
    
    // MARK: - Social Media Milestones
    
    static let socialMediaMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Digital Detox Begins",
            description: "Breaking free from the notification loop.",
            healthBenefits: [
                "Immediate stress reduction",
                "Time awareness returning",
                "Present moment focus beginning"
            ],
            celebration: "You've taken back your attention!",
            icon: "bell.slash.fill",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 1,
            title: "24 Hours Unplugged",
            description: "FOMO starting to fade.",
            healthBenefits: [
                "Anxiety from notifications gone",
                "Boredom tolerance increasing",
                "In-person presence improving"
            ],
            celebration: "One day of real presence!",
            icon: "eye.fill",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Offline",
            description: "Attention span beginning to recover.",
            healthBenefits: [
                "Focus duration extending",
                "Sleep quality improving",
                "Real conversations deepening"
            ],
            celebration: "A week of real connections!",
            icon: "person.2.fill",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Free",
            description: "Comparison mindset fading.",
            healthBenefits: [
                "Self-esteem improving",
                "Comparison habit breaking",
                "Contentment increasing"
            ],
            celebration: "Two weeks of being yourself!",
            icon: "heart.fill",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month Mindful",
            description: "New healthy habits solidifying.",
            healthBenefits: [
                "Deep work capacity restored",
                "Creativity returning",
                "Mental clarity enhanced"
            ],
            celebration: "30 days of meaningful living!",
            icon: "brain.head.profile",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "Identity no longer tied to social validation.",
            healthBenefits: [
                "Self-worth internalized",
                "Productivity transformed",
                "Relationships deepened"
            ],
            celebration: "90 days of authentic life!",
            icon: "star.fill",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "Completely new relationship with technology.",
            healthBenefits: [
                "Tech serves you, not the reverse",
                "Mental health significantly improved",
                "Life goals being achieved"
            ],
            celebration: "Half a year of freedom!",
            icon: "trophy.fill",
            sources: ["APA", "Harvard Health"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Unplugged",
            description: "Social media no longer controls you.",
            healthBenefits: [
                "Complete attention sovereignty",
                "Authentic self fully expressed",
                "Real accomplishments accumulated"
            ],
            celebration: "A year of real life! 🌟",
            icon: "crown.fill",
            sources: ["APA", "Harvard Health"]
        )
    ]
    
    // MARK: - Gambling Milestones
    
    static let gamblingMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Breaking Free",
            description: "Taking control of your finances and future.",
            healthBenefits: [
                "No more money lost",
                "Stress from gambling stopping",
                "Decision-making returning"
            ],
            celebration: "The biggest bet you'll ever win!",
            icon: "banknote.fill",
            sources: ["NCPG", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Gamble-Free",
            description: "Financial bleeding has stopped.",
            healthBenefits: [
                "Money saved beginning to accumulate",
                "Sleep improving",
                "Anxiety decreasing"
            ],
            celebration: "7 days of winning!",
            icon: "dollarsign.circle.fill",
            sources: ["NCPG", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Strong",
            description: "Urges becoming more manageable.",
            healthBenefits: [
                "Impulse control strengthening",
                "Financial clarity returning",
                "Relationships beginning to heal"
            ],
            celebration: "Two weeks of real winning!",
            icon: "chart.line.uptrend.xyaxis",
            sources: ["NCPG", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month Victory",
            description: "New coping mechanisms forming.",
            healthBenefits: [
                "Significant money saved",
                "Mental health improving",
                "Trust being rebuilt"
            ],
            celebration: "30 days—the house never wins!",
            icon: "shield.fill",
            sources: ["NCPG", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "90 Days Clean",
            description: "Brain chemistry rebalancing.",
            healthBenefits: [
                "Dopamine system healing",
                "Financial stability growing",
                "Self-worth restored"
            ],
            celebration: "90 days of real rewards!",
            icon: "brain.head.profile",
            sources: ["NCPG", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "New identity as a non-gambler forming.",
            healthBenefits: [
                "Substantial savings accumulated",
                "Career may be improving",
                "Relationships repaired"
            ],
            celebration: "Half a year of true gains!",
            icon: "building.columns.fill",
            sources: ["NCPG", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Free",
            description: "Complete financial and emotional recovery.",
            healthBenefits: [
                "Financial goals being achieved",
                "Trust fully restored",
                "Future secured"
            ],
            celebration: "365 days—you're the real winner! 💰",
            icon: "crown.fill",
            sources: ["NCPG", "APA"]
        )
    ]
    
    // MARK: - Sugar Milestones
    
    static let sugarMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Sweet Freedom",
            description: "Breaking the sugar addiction cycle.",
            healthBenefits: [
                "Blood sugar stabilization begins",
                "Insulin response improving",
                "Inflammation starting to decrease"
            ],
            celebration: "You've chosen real energy!",
            icon: "bolt.fill",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Through the Cravings",
            description: "Sugar withdrawal peaking then fading.",
            healthBenefits: [
                "Worst cravings passing",
                "Blood sugar more stable",
                "Energy becoming more consistent"
            ],
            celebration: "The hardest days are behind!",
            icon: "sunrise.fill",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Sugar-Free",
            description: "Taste buds beginning to reset.",
            healthBenefits: [
                "Natural foods taste sweeter",
                "Energy crashes eliminated",
                "Mood becoming more stable"
            ],
            celebration: "7 days of natural sweetness!",
            icon: "leaf.fill",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Clean",
            description: "Skin and inflammation improving.",
            healthBenefits: [
                "Skin clearing up",
                "Bloating reduced",
                "Mental clarity improving"
            ],
            celebration: "Two weeks of true nourishment!",
            icon: "face.smiling.fill",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month",
            description: "Metabolic reset well underway.",
            healthBenefits: [
                "Weight stabilizing",
                "Cholesterol may improve",
                "Consistent energy throughout day"
            ],
            celebration: "30 days of fueling right!",
            icon: "flame.fill",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "New eating habits fully formed.",
            healthBenefits: [
                "Taste preferences changed",
                "Insulin sensitivity improved",
                "Risk of diabetes reduced"
            ],
            celebration: "90 days of choosing health!",
            icon: "heart.fill",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "Body composition transforming.",
            healthBenefits: [
                "Significant health markers improved",
                "Inflammation greatly reduced",
                "Energy levels optimal"
            ],
            celebration: "Half a year of real food!",
            icon: "figure.walk",
            sources: ["AHA", "Mayo Clinic"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Free",
            description: "Complete metabolic transformation.",
            healthBenefits: [
                "Disease risk significantly lowered",
                "Optimal health achieved",
                "Sugar no longer controls you"
            ],
            celebration: "365 days of sweet freedom! 🍎",
            icon: "crown.fill",
            sources: ["AHA", "Mayo Clinic"]
        )
    ]
    
    // MARK: - Cannabis Milestones
    
    static let cannabisMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Clear Path Forward",
            description: "THC elimination begins.",
            healthBenefits: [
                "Natural neurotransmitter production resuming",
                "REM sleep beginning to return",
                "Mental clarity starting"
            ],
            celebration: "The fog is lifting!",
            icon: "sun.max.fill",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Withdrawal Peak",
            description: "Most intense symptoms occurring now.",
            healthBenefits: [
                "Body adjusting to sobriety",
                "Sleep patterns resetting",
                "Appetite normalizing"
            ],
            celebration: "Stay strong—it gets easier!",
            icon: "bolt.fill",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Sober",
            description: "Physical withdrawal largely over.",
            healthBenefits: [
                "Dreams returning (vivid)",
                "Appetite stable",
                "Short-term memory improving"
            ],
            celebration: "7 days of clarity!",
            icon: "moon.stars.fill",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks Clear",
            description: "THC levels significantly reduced.",
            healthBenefits: [
                "Mental sharpness returning",
                "Motivation increasing",
                "Sleep quality improving"
            ],
            celebration: "Two weeks of natural high!",
            icon: "brain.head.profile",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month",
            description: "Most THC eliminated from fat cells.",
            healthBenefits: [
                "Could pass drug test",
                "Full REM sleep restored",
                "Cognitive function improved"
            ],
            celebration: "30 days of true presence!",
            icon: "sparkles",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "New neural pathways established.",
            healthBenefits: [
                "Memory fully sharp",
                "Motivation at new levels",
                "Emotional regulation improved"
            ],
            celebration: "90 days of natural living!",
            icon: "star.fill",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "Complete psychological reset.",
            healthBenefits: [
                "Full cognitive recovery",
                "Natural stress coping developed",
                "Life goals being achieved"
            ],
            celebration: "Half a year—naturally high!",
            icon: "trophy.fill",
            sources: ["NIDA", "SAMHSA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Sober",
            description: "Total transformation complete.",
            healthBenefits: [
                "Brain fully healed",
                "New identity formed",
                "Unlimited potential unlocked"
            ],
            celebration: "365 days of clarity! 🌿",
            icon: "crown.fill",
            sources: ["NIDA", "SAMHSA"]
        )
    ]
    
    // MARK: - Caffeine Milestones
    
    static let caffeineMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Breaking the Cycle",
            description: "Adenosine receptors beginning to normalize.",
            healthBenefits: [
                "No more artificial energy spikes",
                "Blood pressure normalizing",
                "Adrenal recovery starting"
            ],
            celebration: "True energy awaits!",
            icon: "bolt.slash.fill",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 1,
            title: "First Day",
            description: "Withdrawal headache likely peaking.",
            healthBenefits: [
                "Body adjusting",
                "Better hydration possible",
                "Natural tiredness signals returning"
            ],
            celebration: "Push through—it's worth it!",
            icon: "drop.fill",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Peak Withdrawal",
            description: "Worst symptoms typically now.",
            healthBenefits: [
                "Headaches beginning to fade",
                "Sleep quality improving",
                "Anxiety decreasing"
            ],
            celebration: "Almost through the hard part!",
            icon: "sunrise.fill",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Free",
            description: "Adenosine receptors normalizing.",
            healthBenefits: [
                "Natural energy returning",
                "Sleep dramatically improved",
                "Anxiety significantly reduced"
            ],
            celebration: "7 days of natural energy!",
            icon: "sun.max.fill",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks",
            description: "Energy levels stabilizing naturally.",
            healthBenefits: [
                "Consistent energy throughout day",
                "No afternoon crashes",
                "Better stress response"
            ],
            celebration: "Two weeks of balance!",
            icon: "battery.100",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month",
            description: "Adrenal function improving.",
            healthBenefits: [
                "Stress hormones normalized",
                "Sleep cycles optimal",
                "True energy baseline established"
            ],
            celebration: "30 days of natural vitality!",
            icon: "bolt.fill",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "Complete reset of energy systems.",
            healthBenefits: [
                "Peak natural energy achieved",
                "Cortisol patterns normalized",
                "Optimal sleep achieved"
            ],
            celebration: "90 days caffeine-free!",
            icon: "sparkles",
            sources: ["FDA", "Johns Hopkins"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "New baseline of natural energy.",
            healthBenefits: [
                "Energy no longer thought about",
                "Perfect sleep routine",
                "Maximum mental clarity"
            ],
            celebration: "Half a year of real energy! ⚡",
            icon: "crown.fill",
            sources: ["FDA", "Johns Hopkins"]
        )
    ]
    
    // MARK: - Vaping Milestones
    
    static let vapingMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Breath of Freedom",
            description: "Your lungs begin clearing immediately.",
            healthBenefits: [
                "No more chemical inhalation",
                "Heart rate beginning to drop",
                "Lung healing starting"
            ],
            celebration: "Every breath is now healing!",
            icon: "wind",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 1,
            title: "24 Hours Free",
            description: "Nicotine levels dropping rapidly.",
            healthBenefits: [
                "Blood pressure improving",
                "Oxygen levels increasing",
                "Circulation improving"
            ],
            celebration: "One day vape-free!",
            icon: "heart.fill",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Nicotine Gone",
            description: "Nicotine fully eliminated from body.",
            healthBenefits: [
                "Peak withdrawal passing",
                "Taste/smell improving",
                "Lung irritation decreasing"
            ],
            celebration: "Nicotine-free body!",
            icon: "checkmark.circle.fill",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Clean",
            description: "Bronchial tubes relaxing.",
            healthBenefits: [
                "Breathing easier",
                "Coughing may increase (healing)",
                "Energy improving"
            ],
            celebration: "7 days of clean air!",
            icon: "lungs.fill",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks",
            description: "Circulation significantly improved.",
            healthBenefits: [
                "Exercise easier",
                "Lung capacity increasing",
                "Skin health improving"
            ],
            celebration: "Two weeks breathing free!",
            icon: "figure.run",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month",
            description: "Lung cilia regenerating.",
            healthBenefits: [
                "Mucus clearing effectively",
                "Infection risk dropping",
                "Athletic performance improving"
            ],
            celebration: "30 days of lung healing!",
            icon: "trophy.fill",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "Major lung recovery milestone.",
            healthBenefits: [
                "Lung function significantly improved",
                "Immune system stronger",
                "Cardiovascular health better"
            ],
            celebration: "90 days—lungs transforming!",
            icon: "star.fill",
            sources: ["CDC", "ALA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Free",
            description: "Risk of respiratory illness halved.",
            healthBenefits: [
                "Lung disease risk greatly reduced",
                "Heart health optimized",
                "Full athletic capacity restored"
            ],
            celebration: "One year of fresh air! 🌬️",
            icon: "crown.fill",
            sources: ["CDC", "ALA"]
        )
    ]
    
    // MARK: - Gaming Milestones
    
    static let gamingMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "Level Up IRL",
            description: "Reclaiming your time and potential.",
            healthBenefits: [
                "Immediate time freed",
                "Real world engaging",
                "Dopamine reset beginning"
            ],
            celebration: "The real adventure begins!",
            icon: "figure.walk",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Achievement",
            description: "New activities filling the void.",
            healthBenefits: [
                "Sleep schedule improving",
                "Physical activity increasing",
                "Real social connections forming"
            ],
            celebration: "7 days of real life XP!",
            icon: "person.2.fill",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Week Streak",
            description: "Boredom tolerance increasing.",
            healthBenefits: [
                "Creativity returning",
                "Attention span lengthening",
                "Real hobbies developing"
            ],
            celebration: "Two weeks of real wins!",
            icon: "paintbrush.fill",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month",
            description: "New identity forming.",
            healthBenefits: [
                "Significant life improvements",
                "Better grades/work performance",
                "Stronger relationships"
            ],
            celebration: "30 days of actual achievements!",
            icon: "trophy.fill",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 60,
            title: "Two Months",
            description: "Gaming urges significantly reduced.",
            healthBenefits: [
                "New habits solidified",
                "Career/school advancing",
                "Health greatly improved"
            ],
            celebration: "60 days of leveling up IRL!",
            icon: "chart.line.uptrend.xyaxis",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "90 Day Boss Battle",
            description: "Complete lifestyle transformation.",
            healthBenefits: [
                "Physical fitness improved",
                "Mental clarity enhanced",
                "Real accomplishments mounting"
            ],
            celebration: "90 days—boss defeated!",
            icon: "star.fill",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "New passions and skills developed.",
            healthBenefits: [
                "Mastery in real skills",
                "Life satisfaction up",
                "Future looking bright"
            ],
            celebration: "Half a year of real quests!",
            icon: "mountain.2.fill",
            sources: ["WHO", "APA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Champion",
            description: "Complete life transformation achieved.",
            healthBenefits: [
                "Real achievements unlocked",
                "Authentic relationships built",
                "Full potential realized"
            ],
            celebration: "365 days—LEGENDARY! 🎮➡️🏆",
            icon: "crown.fill",
            sources: ["WHO", "APA"]
        )
    ]
    
    // MARK: - Other/Generic Milestones
    
    static let otherMilestones: [RecoveryMilestone] = [
        RecoveryMilestone(
            dayThreshold: 0,
            title: "A New Beginning",
            description: "Every journey starts with a single step.",
            healthBenefits: [
                "Decision made—that's the hardest part",
                "Self-awareness increasing",
                "Change is beginning"
            ],
            celebration: "You've chosen change!",
            icon: "sparkles",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 1,
            title: "First Day Complete",
            description: "You proved you can do this.",
            healthBenefits: [
                "Willpower exercised",
                "New neural pathways forming",
                "Self-trust building"
            ],
            celebration: "24 hours of strength!",
            icon: "sun.max.fill",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 3,
            title: "Three Days Strong",
            description: "Building momentum now.",
            healthBenefits: [
                "Habit loop disrupted",
                "Cravings becoming manageable",
                "Confidence growing"
            ],
            celebration: "You're creating new patterns!",
            icon: "bolt.fill",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 7,
            title: "One Week Free",
            description: "A full week of freedom.",
            healthBenefits: [
                "New routine establishing",
                "Triggers identified",
                "Coping skills improving"
            ],
            celebration: "7 days of growth!",
            icon: "trophy.fill",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 14,
            title: "Two Weeks",
            description: "Habits are being rewired.",
            healthBenefits: [
                "Old patterns fading",
                "New behaviors strengthening",
                "Energy improving"
            ],
            celebration: "Two weeks of transformation!",
            icon: "figure.walk",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 30,
            title: "One Month",
            description: "A true milestone achieved.",
            healthBenefits: [
                "Brain chemistry rebalancing",
                "Self-control strengthened",
                "New identity forming"
            ],
            celebration: "30 days of freedom!",
            icon: "star.fill",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 90,
            title: "Three Months",
            description: "Major transformation complete.",
            healthBenefits: [
                "New habits automatic",
                "Willpower reservoir full",
                "Life quality improved"
            ],
            celebration: "90 days—you're unstoppable!",
            icon: "shield.fill",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 180,
            title: "Six Months",
            description: "Half a year of growth.",
            healthBenefits: [
                "Permanent change achieved",
                "New lifestyle established",
                "Full potential emerging"
            ],
            celebration: "Half a year of victory!",
            icon: "heart.fill",
            sources: ["APA", "NIDA"]
        ),
        RecoveryMilestone(
            dayThreshold: 365,
            title: "One Year Champion",
            description: "A full year of freedom.",
            healthBenefits: [
                "Complete transformation",
                "Mastery achieved",
                "New you fully realized"
            ],
            celebration: "365 days—YOU DID IT! 🏆",
            icon: "crown.fill",
            sources: ["APA", "NIDA"]
        )
    ]
}
