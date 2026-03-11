//
//  HabitSpecificData.swift
//  Quitto
//
//  Comprehensive habit-specific triggers, coping strategies, and motivational content
//

import SwiftUI

// MARK: - Habit Specific Data Provider

struct HabitSpecificData {
    
    // MARK: - Triggers
    
    static func triggers(for type: HabitType) -> [HabitTrigger] {
        switch type {
        case .smoking: return smokingTriggers
        case .alcohol: return alcoholTriggers
        case .porn: return pornTriggers
        case .socialMedia: return socialMediaTriggers
        case .gambling: return gamblingTriggers
        case .sugar: return sugarTriggers
        case .cannabis: return cannabisTriggers
        case .caffeine: return caffeineTriggers
        case .vaping: return vapingTriggers
        case .gaming: return gamingTriggers
        case .other: return otherTriggers
        }
    }
    
    // MARK: - Coping Strategies
    
    static func copingStrategies(for type: HabitType) -> [CopingStrategy] {
        switch type {
        case .smoking: return smokingCoping
        case .alcohol: return alcoholCoping
        case .porn: return pornCoping
        case .socialMedia: return socialMediaCoping
        case .gambling: return gamblingCoping
        case .sugar: return sugarCoping
        case .cannabis: return cannabisCoping
        case .caffeine: return caffeineCoping
        case .vaping: return vapingCoping
        case .gaming: return gamingCoping
        case .other: return otherCoping
        }
    }
    
    // MARK: - Motivational Facts
    
    static func motivationalFacts(for type: HabitType) -> [MotivationalFact] {
        switch type {
        case .smoking: return smokingFacts
        case .alcohol: return alcoholFacts
        case .porn: return pornFacts
        case .socialMedia: return socialMediaFacts
        case .gambling: return gamblingFacts
        case .sugar: return sugarFacts
        case .cannabis: return cannabisFacts
        case .caffeine: return caffeineFacts
        case .vaping: return vapingFacts
        case .gaming: return gamingFacts
        case .other: return otherFacts
        }
    }
    
    // MARK: - Emergency Messages
    
    static func emergencyMessage(for type: HabitType) -> EmergencyIntervention {
        switch type {
        case .smoking:
            return EmergencyIntervention(
                title: "Craving a cigarette?",
                subtitle: "This urge will pass in 3-5 minutes",
                breathingExercise: "4-7-8 breathing: Inhale 4s, hold 7s, exhale 8s",
                quickTips: ["Drink cold water", "Chew gum", "Take a short walk", "Text a friend"],
                affirmation: "You are stronger than any craving. Your lungs are healing right now."
            )
        case .alcohol:
            return EmergencyIntervention(
                title: "Feeling the urge?",
                subtitle: "Play the tape forward—remember why you stopped",
                breathingExercise: "Box breathing: 4s inhale, 4s hold, 4s exhale, 4s hold",
                quickTips: ["Call your sponsor", "Grab a mocktail", "Leave the situation", "HALT: Hungry, Angry, Lonely, Tired?"],
                affirmation: "Sobriety is freedom. Every sober moment is a victory."
            )
        case .porn:
            return EmergencyIntervention(
                title: "Urge surfing time",
                subtitle: "This urge is temporary—your goals are permanent",
                breathingExercise: "Deep diaphragmatic breathing for 2 minutes",
                quickTips: ["Do 20 pushups NOW", "Cold shower", "Call someone", "Go outside immediately"],
                affirmation: "You are rewiring your brain for real connection and authentic pleasure."
            )
        case .socialMedia:
            return EmergencyIntervention(
                title: "Reaching for your phone?",
                subtitle: "Ask yourself: What am I avoiding?",
                breathingExercise: "5 deep breaths while looking around the room",
                quickTips: ["Put phone in another room", "Journal for 5 minutes", "Make a real call", "Go for a walk"],
                affirmation: "Real life is happening now. Be present for it."
            )
        case .gambling:
            return EmergencyIntervention(
                title: "Urge to bet?",
                subtitle: "The house ALWAYS wins. But YOU can win by not playing.",
                breathingExercise: "Grounding: 5 things you see, 4 you hear, 3 you touch",
                quickTips: ["Call gambling helpline", "Hand over your cards", "Calculate what you'd lose", "Remember rock bottom"],
                affirmation: "You cannot win at gambling. You already won by stopping."
            )
        case .sugar:
            return EmergencyIntervention(
                title: "Sugar craving hitting?",
                subtitle: "Your body is adjusting—this will pass",
                breathingExercise: "Slow breathing while drinking water",
                quickTips: ["Eat some protein", "Drink water—often it's thirst", "Eat berries instead", "Brush your teeth"],
                affirmation: "You're breaking free from sugar's grip. Energy stability awaits."
            )
        case .cannabis:
            return EmergencyIntervention(
                title: "Wanting to smoke?",
                subtitle: "The clarity you seek is on the other side",
                breathingExercise: "4-4-4-4 box breathing for 3 minutes",
                quickTips: ["Exercise for 10 minutes", "Take a shower", "Call a sober friend", "Journal your feelings"],
                affirmation: "Natural clarity is your superpower. Your brain is healing."
            )
        case .caffeine:
            return EmergencyIntervention(
                title: "Energy crashing?",
                subtitle: "This is temporary—natural energy is building",
                breathingExercise: "Energizing breath: Quick inhales, slow exhales",
                quickTips: ["Take a brisk 5-min walk", "Splash cold water on face", "Eat an apple", "Do jumping jacks"],
                affirmation: "Your natural energy will exceed anything caffeine provided."
            )
        case .vaping:
            return EmergencyIntervention(
                title: "Craving a hit?",
                subtitle: "Your lungs are healing—don't stop now",
                breathingExercise: "Deep breathing: Fill lungs completely 5 times",
                quickTips: ["Chew sugar-free gum", "Use a straw to breathe", "Drink cold water", "Step outside"],
                affirmation: "Every breath without vaping is a breath of healing."
            )
        case .gaming:
            return EmergencyIntervention(
                title: "Want to game?",
                subtitle: "Real achievements are waiting for you",
                breathingExercise: "Mindful breathing while stretching",
                quickTips: ["Text a real friend", "Go for a walk", "Work on a real skill", "Set a timer and wait"],
                affirmation: "Your life is the ultimate game. Level up for real."
            )
        case .other:
            return EmergencyIntervention(
                title: "Feeling the urge?",
                subtitle: "This moment will pass—your goals are permanent",
                breathingExercise: "Box breathing: 4s inhale, 4s hold, 4s exhale, 4s hold",
                quickTips: ["Take 5 deep breaths", "Go for a short walk", "Call a friend", "Write in your journal"],
                affirmation: "You are stronger than any urge. Every moment of resistance builds your future."
            )
        }
    }
}

// MARK: - Supporting Types

struct HabitTrigger: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    let description: String
    let copingTip: String
    
    init(name: String, icon: String, description: String, copingTip: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.description = description
        self.copingTip = copingTip
    }
}

struct CopingStrategy: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: String
    let icon: String
    let category: CopingCategory
}

enum CopingCategory: String, Codable {
    case immediate
    case shortTerm
    case longTerm
    case physical
    case mental
    case social
}

struct MotivationalFact: Identifiable {
    let id = UUID()
    let timeframe: String
    let fact: String
    let icon: String
    var source: String = ""
}

struct EmergencyIntervention {
    let title: String
    let subtitle: String
    let breathingExercise: String
    let quickTips: [String]
    let affirmation: String
}

// MARK: - Smoking Data

private let smokingTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Stress", icon: "bolt.fill", description: "Work pressure, arguments, or anxiety", copingTip: "Try 4-7-8 breathing instead"),
    HabitTrigger(name: "After meals", icon: "fork.knife", description: "Post-eating habit", copingTip: "Take a short walk or brush teeth immediately"),
    HabitTrigger(name: "With coffee", icon: "cup.and.saucer.fill", description: "Morning or break time routine", copingTip: "Switch to tea or change your spot"),
    HabitTrigger(name: "Social situations", icon: "person.3.fill", description: "Parties, bars, with other smokers", copingTip: "Stay with non-smokers, keep hands busy"),
    HabitTrigger(name: "Driving", icon: "car.fill", description: "Commute habit", copingTip: "Listen to podcasts, keep snacks handy"),
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Nothing to do", copingTip: "Have a go-to activity list ready"),
    HabitTrigger(name: "Alcohol", icon: "wineglass.fill", description: "Drinking lowers inhibitions", copingTip: "Avoid alcohol early in quit, or limit it"),
    HabitTrigger(name: "Waking up", icon: "sunrise.fill", description: "First thing morning craving", copingTip: "Change morning routine entirely")
]

private let smokingCoping: [CopingStrategy] = [
    CopingStrategy(title: "Deep Breathing", description: "4-7-8 technique: Inhale 4 seconds, hold 7, exhale 8", duration: "2 min", icon: "wind", category: .immediate),
    CopingStrategy(title: "Drink Cold Water", description: "Sip ice water slowly to occupy hands and mouth", duration: "5 min", icon: "drop.fill", category: .immediate),
    CopingStrategy(title: "Chew Gum", description: "Sugar-free gum satisfies oral fixation", duration: "10 min", icon: "mouth.fill", category: .immediate),
    CopingStrategy(title: "Quick Walk", description: "Change environment and get blood flowing", duration: "10 min", icon: "figure.walk", category: .physical),
    CopingStrategy(title: "Text a Friend", description: "Reach out for support in the moment", duration: "5 min", icon: "message.fill", category: .social),
    CopingStrategy(title: "Squeeze Stress Ball", description: "Keep hands busy with physical activity", duration: "5 min", icon: "hand.raised.fill", category: .physical)
]

private let smokingFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "20 minutes", fact: "Your heart rate and blood pressure drop", icon: "heart.fill", source: "AHA"),
    MotivationalFact(timeframe: "12 hours", fact: "Carbon monoxide in blood drops to normal", icon: "lungs.fill", source: "AHA"),
    MotivationalFact(timeframe: "2-3 weeks", fact: "Circulation improves, lung function increases up to 30%", icon: "figure.run", source: "AHA"),
    MotivationalFact(timeframe: "1-9 months", fact: "Coughing and shortness of breath decrease", icon: "wind", source: "AHA"),
    MotivationalFact(timeframe: "1 year", fact: "Heart disease risk is half that of a smoker", icon: "heart.circle.fill", source: "AHA"),
    MotivationalFact(timeframe: "5 years", fact: "Stroke risk reduced to that of a non-smoker", icon: "brain.head.profile", source: "AHA"),
    MotivationalFact(timeframe: "10 years", fact: "Lung cancer death rate is half that of a smoker", icon: "shield.fill", source: "AHA"),
    MotivationalFact(timeframe: "15 years", fact: "Heart disease risk equals that of a non-smoker", icon: "sparkles", source: "AHA")
]

// MARK: - Alcohol Data

private let alcoholTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Stress", icon: "bolt.fill", description: "Wanting to unwind after hard day", copingTip: "Exercise or meditation instead"),
    HabitTrigger(name: "Social pressure", icon: "person.3.fill", description: "Friends drinking, peer pressure", copingTip: "Have a mocktail ready, tell friends"),
    HabitTrigger(name: "Celebration", icon: "party.popper.fill", description: "Good news, achievements", copingTip: "Celebrate with special non-alcoholic treats"),
    HabitTrigger(name: "Loneliness", icon: "person.fill.questionmark", description: "Drinking alone to cope", copingTip: "Call someone, attend a meeting"),
    HabitTrigger(name: "HALT", icon: "exclamationmark.triangle.fill", description: "Hungry, Angry, Lonely, Tired", copingTip: "Address the underlying need first"),
    HabitTrigger(name: "Routine times", icon: "clock.fill", description: "Happy hour, evening wind-down", copingTip: "Create new evening rituals"),
    HabitTrigger(name: "Restaurants/bars", icon: "fork.knife", description: "Environmental triggers", copingTip: "Choose different venues early on"),
    HabitTrigger(name: "Anxiety", icon: "heart.slash.fill", description: "Social anxiety, general worry", copingTip: "Therapy, breathing exercises, support groups")
]

private let alcoholCoping: [CopingStrategy] = [
    CopingStrategy(title: "Call Your Sponsor", description: "Reach out to your support network immediately", duration: "10 min", icon: "phone.fill", category: .social),
    CopingStrategy(title: "Play the Tape Forward", description: "Visualize the consequences if you drink", duration: "5 min", icon: "film.fill", category: .mental),
    CopingStrategy(title: "HALT Check", description: "Address Hunger, Anger, Loneliness, or Tiredness", duration: "10 min", icon: "checkmark.circle.fill", category: .immediate),
    CopingStrategy(title: "Attend a Meeting", description: "AA, SMART Recovery, or other support group", duration: "1 hour", icon: "person.3.fill", category: .social),
    CopingStrategy(title: "Exercise", description: "Burn off stress with physical activity", duration: "30 min", icon: "figure.run", category: .physical),
    CopingStrategy(title: "Mocktail", description: "Enjoy a fancy non-alcoholic drink", duration: "15 min", icon: "wineglass.fill", category: .immediate)
]

private let alcoholFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 hour", fact: "Liver begins processing the last alcohol", icon: "cross.fill", source: "NIAAA"),
    MotivationalFact(timeframe: "24 hours", fact: "Blood sugar levels normalize", icon: "chart.xyaxis.line", source: "NIAAA"),
    MotivationalFact(timeframe: "1 week", fact: "Sleep quality significantly improves", icon: "moon.fill", source: "NIAAA"),
    MotivationalFact(timeframe: "2 weeks", fact: "Liver fat begins reducing", icon: "cross.fill", source: "NIAAA"),
    MotivationalFact(timeframe: "1 month", fact: "Liver fat can reduce by up to 20%", icon: "sparkles", source: "NIAAA"),
    MotivationalFact(timeframe: "3 months", fact: "Blood pressure normalizes", icon: "heart.fill", source: "NIAAA"),
    MotivationalFact(timeframe: "1 year", fact: "Risk of cardiovascular disease significantly drops", icon: "heart.circle.fill", source: "NIAAA")
]

// MARK: - Porn Data

private let pornTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Nothing to do, mindless browsing", copingTip: "Have a list of go-to activities ready"),
    HabitTrigger(name: "Stress", icon: "bolt.fill", description: "Using as escape or self-medication", copingTip: "Exercise, journal, or call someone"),
    HabitTrigger(name: "Loneliness", icon: "person.fill.questionmark", description: "Seeking connection through screen", copingTip: "Reach out to real people"),
    HabitTrigger(name: "Late night", icon: "moon.fill", description: "Alone at night, tired judgment", copingTip: "Keep phone out of bedroom"),
    HabitTrigger(name: "After drinking", icon: "wineglass.fill", description: "Lowered inhibitions", copingTip: "Avoid alcohol in early recovery"),
    HabitTrigger(name: "Rejection", icon: "heart.slash.fill", description: "Feeling unwanted, seeking validation", copingTip: "Journal feelings, self-compassion"),
    HabitTrigger(name: "Private time", icon: "house.fill", description: "Home alone, no accountability", copingTip: "Use content blockers, stay in public spaces"),
    HabitTrigger(name: "Procrastination", icon: "clock.badge.exclamationmark.fill", description: "Avoiding work or responsibilities", copingTip: "Use Pomodoro technique, work in public")
]

private let pornCoping: [CopingStrategy] = [
    CopingStrategy(title: "Physical Exercise", description: "Do pushups, run, or intense activity NOW", duration: "10 min", icon: "figure.run", category: .physical),
    CopingStrategy(title: "Cold Shower", description: "Shock your system out of the urge", duration: "5 min", icon: "drop.fill", category: .physical),
    CopingStrategy(title: "Urge Surfing", description: "Observe the urge without acting, it will pass", duration: "15 min", icon: "water.waves", category: .mental),
    CopingStrategy(title: "Call a Friend", description: "Connection is what you really want", duration: "10 min", icon: "phone.fill", category: .social),
    CopingStrategy(title: "Leave the Room", description: "Change your environment immediately", duration: "5 min", icon: "arrow.right.circle.fill", category: .immediate),
    CopingStrategy(title: "Journal", description: "Write out what you're feeling and why", duration: "10 min", icon: "book.fill", category: .mental)
]

private let pornFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 week", fact: "Dopamine receptors begin recovering", icon: "brain.head.profile", source: "Cambridge/NCBI"),
    MotivationalFact(timeframe: "2 weeks", fact: "Brain fog starts to lift, focus improves", icon: "scope", source: "Cambridge/NCBI"),
    MotivationalFact(timeframe: "30 days", fact: "Significant neural pathway changes occur", icon: "sparkles", source: "Cambridge/NCBI"),
    MotivationalFact(timeframe: "60 days", fact: "Emotional depth and connection capacity return", icon: "heart.fill", source: "Cambridge/NCBI"),
    MotivationalFact(timeframe: "90 days", fact: "Classic reboot milestone—major brain rewiring complete", icon: "brain", source: "Cambridge/NCBI"),
    MotivationalFact(timeframe: "6 months", fact: "Natural pleasure response fully restored", icon: "star.fill", source: "Cambridge/NCBI"),
    MotivationalFact(timeframe: "1 year", fact: "Complete transformation of relationship with sexuality", icon: "crown.fill", source: "Cambridge/NCBI")
]

// MARK: - Social Media Data

private let socialMediaTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Filling empty moments", copingTip: "Keep a book or puzzle handy"),
    HabitTrigger(name: "FOMO", icon: "eye.fill", description: "Fear of missing out", copingTip: "Remember: curated highlights, not reality"),
    HabitTrigger(name: "Notifications", icon: "bell.fill", description: "Pulled back by alerts", copingTip: "Turn ALL notifications off"),
    HabitTrigger(name: "Waiting", icon: "hourglass", description: "In lines, waiting rooms", copingTip: "People watch, read, or just be present"),
    HabitTrigger(name: "Morning routine", icon: "sunrise.fill", description: "First thing checking", copingTip: "Don't touch phone for first hour"),
    HabitTrigger(name: "Before bed", icon: "moon.fill", description: "Scrolling in bed", copingTip: "Phone charges outside bedroom"),
    HabitTrigger(name: "Procrastination", icon: "clock.badge.exclamationmark.fill", description: "Avoiding tasks", copingTip: "Use app blockers during work"),
    HabitTrigger(name: "Loneliness", icon: "person.fill.questionmark", description: "Seeking connection", copingTip: "Call someone instead")
]

private let socialMediaCoping: [CopingStrategy] = [
    CopingStrategy(title: "Phone in Another Room", description: "Physical separation breaks the habit loop", duration: "Ongoing", icon: "iphone.slash", category: .immediate),
    CopingStrategy(title: "Real Conversation", description: "Call or text someone for actual connection", duration: "10 min", icon: "phone.fill", category: .social),
    CopingStrategy(title: "5 Minute Rule", description: "Wait 5 minutes before checking—urge often passes", duration: "5 min", icon: "timer", category: .immediate),
    CopingStrategy(title: "Go Outside", description: "Nature is the antidote to screens", duration: "15 min", icon: "leaf.fill", category: .physical),
    CopingStrategy(title: "Mindful Breathing", description: "Be present in your body, not the feed", duration: "5 min", icon: "wind", category: .mental),
    CopingStrategy(title: "Pick Up a Book", description: "Long-form content for attention recovery", duration: "20 min", icon: "book.fill", category: .mental)
]

private let socialMediaFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 day", fact: "Notification anxiety begins to fade", icon: "bell.slash.fill", source: "APA"),
    MotivationalFact(timeframe: "1 week", fact: "Attention span starts recovering", icon: "scope", source: "APA"),
    MotivationalFact(timeframe: "2 weeks", fact: "Comparison mindset weakening", icon: "heart.fill", source: "APA"),
    MotivationalFact(timeframe: "1 month", fact: "Deep work and creativity returning", icon: "brain.head.profile", source: "APA"),
    MotivationalFact(timeframe: "3 months", fact: "Self-worth no longer tied to likes", icon: "star.fill", source: "APA"),
    MotivationalFact(timeframe: "6 months", fact: "Relationships significantly deeper", icon: "person.2.fill", source: "APA"),
    MotivationalFact(timeframe: "1 year", fact: "Complete attention sovereignty achieved", icon: "crown.fill", source: "APA")
]

// MARK: - Gambling Data

private let gamblingTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Financial stress", icon: "dollarsign.circle.fill", description: "Ironic desire to 'win it back'", copingTip: "Remember: gambling caused the stress"),
    HabitTrigger(name: "Winning memories", icon: "trophy.fill", description: "Romanticizing past wins", copingTip: "Calculate total lifetime losses"),
    HabitTrigger(name: "Sports events", icon: "sportscourt.fill", description: "Games trigger betting urge", copingTip: "Watch with non-gamblers, no betting apps"),
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Seeking excitement", copingTip: "Find healthy thrills—exercise, hobbies"),
    HabitTrigger(name: "Advertising", icon: "megaphone.fill", description: "Betting ads everywhere", copingTip: "Use ad blockers, avoid triggers"),
    HabitTrigger(name: "Payday", icon: "banknote.fill", description: "Money in account", copingTip: "Auto-transfer savings immediately"),
    HabitTrigger(name: "Alcohol", icon: "wineglass.fill", description: "Lowered judgment", copingTip: "Don't drink, or give wallet to friend"),
    HabitTrigger(name: "Loneliness", icon: "person.fill.questionmark", description: "Casino social atmosphere", copingTip: "Join support groups for real community")
]

private let gamblingCoping: [CopingStrategy] = [
    CopingStrategy(title: "Call Helpline", description: "1-800-522-4700 National Problem Gambling Helpline", duration: "10 min", icon: "phone.fill", category: .immediate),
    CopingStrategy(title: "Self-Exclude", description: "Ban yourself from casinos and betting sites", duration: "30 min", icon: "hand.raised.fill", category: .longTerm),
    CopingStrategy(title: "Calculate Losses", description: "Add up lifetime gambling losses", duration: "15 min", icon: "chart.bar.fill", category: .mental),
    CopingStrategy(title: "Attend GA Meeting", description: "Gamblers Anonymous support", duration: "1 hour", icon: "person.3.fill", category: .social),
    CopingStrategy(title: "Hand Over Finances", description: "Let trusted person manage money temporarily", duration: "Ongoing", icon: "creditcard.fill", category: .longTerm),
    CopingStrategy(title: "Urge Delay", description: "Wait 24 hours before any gambling decision", duration: "24 hours", icon: "timer", category: .immediate)
]

private let gamblingFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "Day 1", fact: "You've stopped the financial bleeding", icon: "banknote.fill", source: "NCPG"),
    MotivationalFact(timeframe: "1 week", fact: "Money saved that would have been lost", icon: "dollarsign.circle.fill", source: "NCPG"),
    MotivationalFact(timeframe: "1 month", fact: "Dopamine system beginning to heal", icon: "brain.head.profile", source: "NCPG"),
    MotivationalFact(timeframe: "3 months", fact: "Trust with loved ones rebuilding", icon: "heart.fill", source: "NCPG"),
    MotivationalFact(timeframe: "6 months", fact: "Financial stability growing", icon: "chart.line.uptrend.xyaxis", source: "NCPG"),
    MotivationalFact(timeframe: "1 year", fact: "Substantial savings accumulated", icon: "building.columns.fill", source: "NCPG"),
    MotivationalFact(timeframe: "2 years", fact: "Complete financial and emotional recovery possible", icon: "crown.fill", source: "NCPG")
]

// MARK: - Sugar Data

private let sugarTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Afternoon slump", icon: "sun.haze.fill", description: "Energy crash seeking sugar fix", copingTip: "Take a walk, drink water, eat protein"),
    HabitTrigger(name: "Stress", icon: "bolt.fill", description: "Comfort eating for soothing", copingTip: "Exercise releases better endorphins"),
    HabitTrigger(name: "Social events", icon: "party.popper.fill", description: "Desserts at gatherings", copingTip: "Eat protein first, bring healthy treats"),
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Eating when not hungry", copingTip: "Ask: Am I hungry or just bored?"),
    HabitTrigger(name: "After meals", icon: "fork.knife", description: "Dessert habit", copingTip: "Brush teeth immediately after eating"),
    HabitTrigger(name: "Emotions", icon: "heart.fill", description: "Happy, sad, angry eating", copingTip: "Journal emotions instead"),
    HabitTrigger(name: "Visual cues", icon: "eye.fill", description: "Seeing candy, bakeries", copingTip: "Keep sweets out of sight/house"),
    HabitTrigger(name: "Reward mindset", icon: "gift.fill", description: "'I deserve this' thinking", copingTip: "Find non-food rewards")
]

private let sugarCoping: [CopingStrategy] = [
    CopingStrategy(title: "Drink Water", description: "Often thirst disguises as hunger", duration: "2 min", icon: "drop.fill", category: .immediate),
    CopingStrategy(title: "Eat Protein", description: "Protein stabilizes blood sugar", duration: "10 min", icon: "fork.knife", category: .immediate),
    CopingStrategy(title: "Brush Teeth", description: "Fresh mouth reduces cravings", duration: "3 min", icon: "mouth.fill", category: .immediate),
    CopingStrategy(title: "Wait 10 Minutes", description: "Cravings often pass", duration: "10 min", icon: "timer", category: .immediate),
    CopingStrategy(title: "Eat Berries", description: "Natural sweetness with fiber", duration: "5 min", icon: "leaf.fill", category: .immediate),
    CopingStrategy(title: "Short Walk", description: "Movement reduces cravings", duration: "10 min", icon: "figure.walk", category: .physical)
]

private let sugarFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 hour", fact: "Blood sugar spikes stabilize", icon: "chart.xyaxis.line", source: "AHA"),
    MotivationalFact(timeframe: "3 days", fact: "Cravings begin to diminish", icon: "flame.fill", source: "AHA"),
    MotivationalFact(timeframe: "1 week", fact: "Energy levels become more stable", icon: "bolt.fill", source: "AHA"),
    MotivationalFact(timeframe: "2 weeks", fact: "Taste buds reset—fruit tastes sweeter", icon: "leaf.fill", source: "AHA"),
    MotivationalFact(timeframe: "1 month", fact: "Skin often clears, inflammation down", icon: "face.smiling.fill", source: "AHA"),
    MotivationalFact(timeframe: "3 months", fact: "Insulin sensitivity improved", icon: "heart.fill", source: "AHA"),
    MotivationalFact(timeframe: "1 year", fact: "Risk of type 2 diabetes significantly reduced", icon: "shield.fill", source: "AHA")
]

// MARK: - Cannabis Data

private let cannabisTriggers: [HabitTrigger] = [
    HabitTrigger(name: "End of day", icon: "sunset.fill", description: "Wind-down routine", copingTip: "Create new evening ritual"),
    HabitTrigger(name: "Stress/anxiety", icon: "bolt.fill", description: "Self-medicating", copingTip: "Exercise, meditation, therapy"),
    HabitTrigger(name: "Social situations", icon: "person.3.fill", description: "Smoking with friends", copingTip: "Find sober activities, tell friends"),
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Getting high to pass time", copingTip: "Engage in active hobbies"),
    HabitTrigger(name: "Insomnia", icon: "moon.fill", description: "Using to sleep", copingTip: "Sleep hygiene, melatonin if needed"),
    HabitTrigger(name: "Creative work", icon: "paintbrush.fill", description: "Thinking it enhances creativity", copingTip: "Sober creativity is more sustainable"),
    HabitTrigger(name: "Pain", icon: "cross.fill", description: "Physical or emotional pain", copingTip: "Seek proper medical treatment"),
    HabitTrigger(name: "Environmental", icon: "house.fill", description: "Being in smoking spots", copingTip: "Avoid triggers, rearrange space")
]

private let cannabisCoping: [CopingStrategy] = [
    CopingStrategy(title: "Exercise", description: "Natural endorphins beat synthetic high", duration: "30 min", icon: "figure.run", category: .physical),
    CopingStrategy(title: "Mindfulness Meditation", description: "Learn to sit with discomfort", duration: "15 min", icon: "brain.head.profile", category: .mental),
    CopingStrategy(title: "Journal", description: "Process why you want to use", duration: "15 min", icon: "book.fill", category: .mental),
    CopingStrategy(title: "Call Sober Friend", description: "Connection and accountability", duration: "15 min", icon: "phone.fill", category: .social),
    CopingStrategy(title: "MA Meeting", description: "Marijuana Anonymous support", duration: "1 hour", icon: "person.3.fill", category: .social),
    CopingStrategy(title: "Change Environment", description: "Leave triggering situation", duration: "10 min", icon: "arrow.right.circle.fill", category: .immediate)
]

private let cannabisFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 week", fact: "REM sleep returning—vivid dreams common", icon: "moon.stars.fill", source: "NIDA"),
    MotivationalFact(timeframe: "2 weeks", fact: "Short-term memory improving", icon: "brain.head.profile", source: "NIDA"),
    MotivationalFact(timeframe: "1 month", fact: "Most THC eliminated, could pass drug test", icon: "checkmark.circle.fill", source: "NIDA"),
    MotivationalFact(timeframe: "3 months", fact: "Motivation and drive significantly improved", icon: "flame.fill", source: "NIDA"),
    MotivationalFact(timeframe: "6 months", fact: "Cognitive function fully restored", icon: "sparkles", source: "NIDA"),
    MotivationalFact(timeframe: "1 year", fact: "Complete psychological reset achieved", icon: "crown.fill", source: "NIDA")
]

// MARK: - Caffeine Data

private let caffeineTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Morning ritual", icon: "sunrise.fill", description: "Can't start day without it", copingTip: "Replace with herbal tea, water with lemon"),
    HabitTrigger(name: "Fatigue", icon: "battery.25", description: "Tired, need boost", copingTip: "10-min walk gives natural energy"),
    HabitTrigger(name: "Work breaks", icon: "cup.and.saucer.fill", description: "Coffee break culture", copingTip: "Take walking breaks instead"),
    HabitTrigger(name: "Social", icon: "person.2.fill", description: "Meeting at coffee shops", copingTip: "Order decaf or herbal tea"),
    HabitTrigger(name: "Headache", icon: "head.profile.arrow.forward.and.visionpro", description: "Withdrawal headache starting", copingTip: "Ibuprofen, hydrate, it will pass"),
    HabitTrigger(name: "Afternoon slump", icon: "sun.haze.fill", description: "Post-lunch energy drop", copingTip: "Take a short walk, cold water"),
    HabitTrigger(name: "Habit/ritual", icon: "clock.fill", description: "Automatic behavior", copingTip: "Replace the ritual, not just the drink"),
    HabitTrigger(name: "Focus needed", icon: "scope", description: "Important task ahead", copingTip: "Cold shower, exercise, proper sleep")
]

private let caffeineCoping: [CopingStrategy] = [
    CopingStrategy(title: "Drink Water", description: "Dehydration mimics fatigue", duration: "2 min", icon: "drop.fill", category: .immediate),
    CopingStrategy(title: "Brisk Walk", description: "Movement increases natural energy", duration: "10 min", icon: "figure.walk", category: .physical),
    CopingStrategy(title: "Cold Water on Face", description: "Activates alertness response", duration: "1 min", icon: "drop.fill", category: .immediate),
    CopingStrategy(title: "Eat an Apple", description: "Natural sugars wake you up", duration: "5 min", icon: "leaf.fill", category: .immediate),
    CopingStrategy(title: "Herbal Tea", description: "Warm drink ritual without caffeine", duration: "10 min", icon: "cup.and.saucer.fill", category: .immediate),
    CopingStrategy(title: "Power Nap", description: "20-minute nap beats caffeine", duration: "20 min", icon: "moon.fill", category: .physical)
]

private let caffeineFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "12-24 hours", fact: "Withdrawal headaches peak", icon: "exclamationmark.triangle.fill", source: "FDA"),
    MotivationalFact(timeframe: "3-4 days", fact: "Worst withdrawal symptoms passing", icon: "sunrise.fill", source: "FDA"),
    MotivationalFact(timeframe: "1 week", fact: "Sleep quality dramatically improves", icon: "moon.fill", source: "FDA"),
    MotivationalFact(timeframe: "2 weeks", fact: "Natural energy baseline establishing", icon: "bolt.fill", source: "FDA"),
    MotivationalFact(timeframe: "1 month", fact: "Adrenal function recovering", icon: "heart.fill", source: "FDA"),
    MotivationalFact(timeframe: "3 months", fact: "Peak natural energy achieved", icon: "sparkles", source: "FDA"),
    MotivationalFact(timeframe: "6 months", fact: "Complete reset—caffeine no longer needed", icon: "crown.fill", source: "FDA")
]

// MARK: - Vaping Data

private let vapingTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Stress", icon: "bolt.fill", description: "Quick hit for relief", copingTip: "Deep breathing gives same pause"),
    HabitTrigger(name: "Social", icon: "person.3.fill", description: "Vaping with friends", copingTip: "Tell friends you quit, avoid vape circles"),
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Something to do", copingTip: "Find hand fidget, keep busy"),
    HabitTrigger(name: "After eating", icon: "fork.knife", description: "Post-meal habit", copingTip: "Chew gum, brush teeth instead"),
    HabitTrigger(name: "Driving", icon: "car.fill", description: "Commute habit", copingTip: "Leave vape at home, sing along"),
    HabitTrigger(name: "Phone use", icon: "iphone.gen3", description: "Paired behavior", copingTip: "Be aware of triggers, break pairing"),
    HabitTrigger(name: "Waking up", icon: "sunrise.fill", description: "First thing craving", copingTip: "Morning routine without vape"),
    HabitTrigger(name: "Alcohol", icon: "wineglass.fill", description: "Drinking triggers vaping", copingTip: "Avoid alcohol initially")
]

private let vapingCoping: [CopingStrategy] = [
    CopingStrategy(title: "Deep Breathing", description: "Mimic the inhale without the vape", duration: "3 min", icon: "wind", category: .immediate),
    CopingStrategy(title: "Chew Gum", description: "Oral fixation substitute", duration: "10 min", icon: "mouth.fill", category: .immediate),
    CopingStrategy(title: "Use a Straw", description: "Hand-to-mouth action substitute", duration: "5 min", icon: "straw.fill", category: .immediate),
    CopingStrategy(title: "Drink Water", description: "Hydrate and keep mouth busy", duration: "5 min", icon: "drop.fill", category: .immediate),
    CopingStrategy(title: "Quick Exercise", description: "Burn off nervous energy", duration: "10 min", icon: "figure.run", category: .physical),
    CopingStrategy(title: "Text for Support", description: "Reach out in weak moments", duration: "5 min", icon: "message.fill", category: .social)
]

private let vapingFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "20 minutes", fact: "Heart rate begins to drop", icon: "heart.fill", source: "CDC"),
    MotivationalFact(timeframe: "24 hours", fact: "Nicotine levels dropping rapidly", icon: "chart.line.downtrend.xyaxis", source: "CDC"),
    MotivationalFact(timeframe: "3 days", fact: "Nicotine eliminated from body", icon: "checkmark.circle.fill", source: "CDC"),
    MotivationalFact(timeframe: "1 week", fact: "Taste and smell improving", icon: "nose.fill", source: "CDC"),
    MotivationalFact(timeframe: "2 weeks", fact: "Circulation significantly improved", icon: "figure.run", source: "CDC"),
    MotivationalFact(timeframe: "1 month", fact: "Lung cilia regenerating", icon: "lungs.fill", source: "CDC"),
    MotivationalFact(timeframe: "3 months", fact: "Lung function significantly improved", icon: "wind", source: "CDC"),
    MotivationalFact(timeframe: "1 year", fact: "Respiratory illness risk halved", icon: "shield.fill", source: "CDC")
]

// MARK: - Gaming Data

private let gamingTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Nothing else to do", copingTip: "Develop real-world hobbies"),
    HabitTrigger(name: "Stress escape", icon: "bolt.fill", description: "Avoiding real problems", copingTip: "Face problems, they won't go away"),
    HabitTrigger(name: "Social (online)", icon: "wifi", description: "Friends are online", copingTip: "Make real-world friends too"),
    HabitTrigger(name: "Achievement need", icon: "trophy.fill", description: "Wanting to level up", copingTip: "Set real-life goals to achieve"),
    HabitTrigger(name: "FOMO events", icon: "calendar", description: "Limited time game events", copingTip: "Remember: artificial scarcity tactic"),
    HabitTrigger(name: "End of day", icon: "sunset.fill", description: "Evening wind-down", copingTip: "New evening routine needed"),
    HabitTrigger(name: "Procrastination", icon: "clock.badge.exclamationmark.fill", description: "Avoiding responsibilities", copingTip: "Do the task first, game as reward (if at all)"),
    HabitTrigger(name: "Loneliness", icon: "person.fill.questionmark", description: "Online friends feel easier", copingTip: "Join real-world groups and clubs")
]

private let gamingCoping: [CopingStrategy] = [
    CopingStrategy(title: "Exercise", description: "Physical achievements > virtual ones", duration: "30 min", icon: "figure.run", category: .physical),
    CopingStrategy(title: "Learn a Skill", description: "Level up in real life", duration: "1 hour", icon: "book.fill", category: .longTerm),
    CopingStrategy(title: "Call a Friend", description: "Real social connection", duration: "15 min", icon: "phone.fill", category: .social),
    CopingStrategy(title: "Go Outside", description: "Nature is the original open world", duration: "30 min", icon: "leaf.fill", category: .physical),
    CopingStrategy(title: "Uninstall Games", description: "Remove the temptation entirely", duration: "10 min", icon: "trash.fill", category: .longTerm),
    CopingStrategy(title: "Set a Timer", description: "If gaming, strict time limits", duration: "Varies", icon: "timer", category: .immediate)
]

private let gamingFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 day", fact: "Hours reclaimed for real life", icon: "clock.fill", source: "WHO"),
    MotivationalFact(timeframe: "1 week", fact: "Sleep schedule improving", icon: "moon.fill", source: "WHO"),
    MotivationalFact(timeframe: "2 weeks", fact: "Real hobbies developing", icon: "paintbrush.fill", source: "WHO"),
    MotivationalFact(timeframe: "1 month", fact: "Relationships strengthening", icon: "person.2.fill", source: "WHO"),
    MotivationalFact(timeframe: "3 months", fact: "Real achievements accumulating", icon: "trophy.fill", source: "WHO"),
    MotivationalFact(timeframe: "6 months", fact: "New skills mastered", icon: "star.fill", source: "WHO"),
    MotivationalFact(timeframe: "1 year", fact: "Complete lifestyle transformation", icon: "crown.fill", source: "WHO")
]

// MARK: - Other/Generic Data

private let otherTriggers: [HabitTrigger] = [
    HabitTrigger(name: "Stress", icon: "bolt.fill", description: "Seeking relief from pressure", copingTip: "Try deep breathing or exercise instead"),
    HabitTrigger(name: "Boredom", icon: "clock.fill", description: "Looking for stimulation", copingTip: "Have a list of alternative activities ready"),
    HabitTrigger(name: "Emotional distress", icon: "heart.fill", description: "Using habit to cope with feelings", copingTip: "Journal your emotions or talk to someone"),
    HabitTrigger(name: "Social situations", icon: "person.3.fill", description: "Peer pressure or social cues", copingTip: "Plan ahead and have an exit strategy"),
    HabitTrigger(name: "Routine triggers", icon: "clock.badge.checkmark.fill", description: "Habitual time or place cues", copingTip: "Change your environment or routine"),
    HabitTrigger(name: "Tiredness", icon: "moon.fill", description: "Low energy seeking quick fix", copingTip: "Rest properly or take a short walk"),
    HabitTrigger(name: "Celebration", icon: "party.popper.fill", description: "Rewarding yourself", copingTip: "Find healthy ways to celebrate"),
    HabitTrigger(name: "Loneliness", icon: "person.fill.questionmark", description: "Seeking connection or comfort", copingTip: "Reach out to a real person")
]

private let otherCoping: [CopingStrategy] = [
    CopingStrategy(title: "Deep Breathing", description: "4-4-4-4 box breathing technique", duration: "3 min", icon: "wind", category: .immediate),
    CopingStrategy(title: "Take a Walk", description: "Change your environment and move", duration: "10 min", icon: "figure.walk", category: .physical),
    CopingStrategy(title: "Call Someone", description: "Human connection is powerful", duration: "10 min", icon: "phone.fill", category: .social),
    CopingStrategy(title: "Journal", description: "Write out your thoughts and feelings", duration: "10 min", icon: "book.fill", category: .mental),
    CopingStrategy(title: "Drink Water", description: "Stay hydrated, often helps urges", duration: "2 min", icon: "drop.fill", category: .immediate),
    CopingStrategy(title: "10 Minute Rule", description: "Wait 10 minutes—urges usually pass", duration: "10 min", icon: "timer", category: .immediate)
]

private let otherFacts: [MotivationalFact] = [
    MotivationalFact(timeframe: "1 day", fact: "You've proven you can resist", icon: "checkmark.circle.fill", source: "APA"),
    MotivationalFact(timeframe: "3 days", fact: "Initial withdrawal often peaks now", icon: "chart.line.uptrend.xyaxis", source: "APA"),
    MotivationalFact(timeframe: "1 week", fact: "New neural pathways are forming", icon: "brain.head.profile", source: "APA"),
    MotivationalFact(timeframe: "2 weeks", fact: "Habits typically take 14+ days to change", icon: "arrow.triangle.2.circlepath", source: "APA"),
    MotivationalFact(timeframe: "1 month", fact: "Major brain chemistry rebalancing", icon: "sparkles", source: "APA"),
    MotivationalFact(timeframe: "3 months", fact: "New behaviors becoming automatic", icon: "bolt.fill", source: "APA"),
    MotivationalFact(timeframe: "6 months", fact: "Permanent change is solidifying", icon: "shield.fill", source: "APA"),
    MotivationalFact(timeframe: "1 year", fact: "You've transformed your life", icon: "crown.fill", source: "APA")
]
