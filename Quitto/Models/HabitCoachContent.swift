//
//  HabitCoachContent.swift
//  Quitto
//
//  AI coach prompts, notification messages, and sharing templates for each habit type
//

import Foundation

// MARK: - Habit Coach Content Provider

struct HabitCoachContent {
    
    // MARK: - AI Coach System Prompts
    
    static func systemPrompt(for type: HabitType) -> String {
        let base = """
        You are a compassionate, knowledgeable recovery coach specializing in helping people quit \(type.displayName.lowercased()). 
        You understand the science of addiction, behavioral psychology, and evidence-based recovery techniques.
        
        Your communication style is:
        - Warm and supportive, never judgmental
        - Evidence-based but accessible
        - Encouraging without being preachy
        - Focused on practical, actionable advice
        - Celebrating small wins while keeping long-term goals in view
        
        CITATION REQUIREMENT: When stating health facts, withdrawal timelines, or recovery benefits, include a brief source citation in parentheses, e.g. (AHA), (CDC), (NIDA), (WHO). Only cite recognized health organizations.
        
        DISCLAIMER: You are not a medical professional. When discussing health topics, remind users to consult a healthcare provider for personalized advice.
        
        """
        
        return base + specificContext(for: type)
    }
    
    private static func specificContext(for type: HabitType) -> String {
        switch type {
        case .smoking:
            return """
            Key knowledge areas for smoking cessation:
            - Nicotine withdrawal timeline and symptoms
            - Lung healing process and timeline
            - Cardiovascular benefits of quitting
            - Common triggers (stress, meals, coffee, alcohol, social situations)
            - Coping strategies: deep breathing, oral fixation alternatives, delay techniques
            - NRT options and how they work
            - The role of dopamine in nicotine addiction
            - Health milestones: 20 min, 12 hours, 2 weeks, 1 year, etc.
            """
            
        case .alcohol:
            return """
            Key knowledge areas for alcohol recovery:
            - Alcohol withdrawal symptoms and when to seek medical help
            - HALT check (Hungry, Angry, Lonely, Tired)
            - Liver recovery timeline
            - Sleep architecture and alcohol's impact
            - Social situations and peer pressure
            - AA, SMART Recovery, and other support options
            - The disease model vs. habit model of addiction
            - Mocktail alternatives and sober socializing
            """
            
        case .porn:
            return """
            Key knowledge areas for porn addiction recovery:
            - Dopamine and the reward system
            - The 90-day reboot concept and brain plasticity
            - PIED (porn-induced erectile dysfunction) and recovery
            - Urge surfing and mindfulness techniques
            - The role of shame and self-compassion in recovery
            - Building healthy sexuality and relationships
            - Digital boundaries and content blocking
            - The difference between healthy sexuality and compulsive use
            """
            
        case .socialMedia:
            return """
            Key knowledge areas for social media detox:
            - Attention span and deep work capacity
            - Dopamine hits and variable reward schedules
            - Comparison culture and mental health
            - FOMO and digital anxiety
            - Building real-world connections
            - Productivity and time management
            - Digital minimalism principles
            - Healthy boundaries with technology
            """
            
        case .gambling:
            return """
            Key knowledge areas for gambling addiction:
            - The gambler's fallacy and cognitive distortions
            - Financial recovery and budgeting
            - Self-exclusion programs
            - The role of dopamine in gambling addiction
            - Triggers: sports events, ads, financial stress
            - GA (Gamblers Anonymous) and support resources
            - Rebuilding trust and relationships
            - Finding healthy sources of excitement
            """
            
        case .sugar:
            return """
            Key knowledge areas for sugar addiction:
            - Blood sugar regulation and insulin
            - Sugar withdrawal symptoms and timeline
            - Hidden sugars in foods
            - Healthy alternatives and substitutes
            - Emotional eating vs. physical hunger
            - Gut microbiome and sugar cravings
            - Reading nutrition labels
            - Meal planning and prep strategies
            """
            
        case .cannabis:
            return """
            Key knowledge areas for cannabis recovery:
            - THC elimination timeline
            - REM rebound and vivid dreams
            - Memory and cognitive recovery
            - Motivation and amotivational syndrome
            - Natural alternatives for anxiety/sleep
            - The endocannabinoid system
            - CHS (Cannabinoid Hyperemesis Syndrome)
            - Building natural coping mechanisms
            """
            
        case .caffeine:
            return """
            Key knowledge areas for caffeine freedom:
            - Caffeine withdrawal timeline (headaches peak day 1-2)
            - Adenosine receptors and sleep
            - Natural energy alternatives
            - Cortisol and adrenal function
            - Sleep hygiene without caffeine
            - Gradual vs. cold turkey approaches
            - Hidden caffeine sources
            - Building natural morning energy routines
            """
            
        case .vaping:
            return """
            Key knowledge areas for vaping cessation:
            - Nicotine in vapes vs cigarettes
            - Lung health and EVALI concerns
            - Oral fixation and hand-to-mouth habit
            - Youth-specific concerns
            - Withdrawal timeline (similar to smoking)
            - The "stepping stone" myth
            - Alternatives for stress relief
            - Building a vape-free identity
            """
            
        case .gaming:
            return """
            Key knowledge areas for gaming addiction:
            - Dopamine and achievement systems
            - FOMO mechanics in games
            - Building real-world achievements
            - Social skills and real connections
            - Time management and productivity
            - Finding flow states in real life
            - Healthy gaming vs. problematic use
            - Alternative hobbies and activities
            """
            
        case .other:
            return """
            Key knowledge areas for habit change:
            - The habit loop: cue, routine, reward
            - Neuroplasticity and brain rewiring
            - Identifying triggers and patterns
            - Building replacement habits
            - The role of environment in behavior
            - Stress management and coping skills
            - Self-compassion in recovery
            - Building a support system
            """
        }
    }
    
    // MARK: - Notification Messages
    
    static func notificationMessages(for type: HabitType) -> NotificationMessageSet {
        switch type {
        case .smoking:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Your lungs are healing while you sleep. Keep going!",
                    "Day \(placeholders.days) smoke-free! Your oxygen levels are thanking you.",
                    "Rise and shine without a cigarette. You've got this!",
                    "Another morning, another victory. You're rewriting your story."
                ],
                cravingSupport: [
                    "Craving? It'll pass in 3-5 minutes. Take 5 deep breaths.",
                    "Your lungs have healed too much to go back. This craving is temporary.",
                    "Drink some cold water and remember why you started.",
                    "Every craving you beat makes the next one weaker."
                ],
                milestoneReached: [
                    "🎉 Amazing! \(placeholders.milestone) reached!",
                    "You just hit \(placeholders.milestone)! Your body is healing.",
                    "Milestone unlocked: \(placeholders.milestone)! Keep building!"
                ],
                eveningReflection: [
                    "Another smoke-free day complete. You saved \(placeholders.money) today!",
                    "As you wind down, remember: every day gets easier.",
                    "Great job today! \(placeholders.units) cigarettes NOT smoked."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks) complete! You've avoided \(placeholders.units) cigarettes.",
                    "Your circulation has improved significantly this week!",
                    "Keep it up! \(placeholders.money) saved and counting."
                ]
            )
            
        case .alcohol:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! No hangover, clear head. This is freedom.",
                    "Day \(placeholders.days) sober. Your liver is healing!",
                    "Waking up without regret. You're doing amazing.",
                    "Another sober morning. Your body thanks you."
                ],
                cravingSupport: [
                    "HALT check: Hungry? Angry? Lonely? Tired? Address the real need.",
                    "Play the tape forward. How would you feel tomorrow?",
                    "This urge will pass. Your sobriety won't if you give in.",
                    "Call someone. You don't have to face this alone."
                ],
                milestoneReached: [
                    "🎉 \(placeholders.milestone) of sobriety! You're rewriting your story.",
                    "Milestone: \(placeholders.milestone)! Your brain is healing.",
                    "Amazing progress! \(placeholders.milestone) achieved."
                ],
                eveningReflection: [
                    "Another sober day in the books. You're stronger than you know.",
                    "Your sleep quality is improving every night.",
                    "Reflect on today's wins. You chose yourself."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! Your liver fat has reduced significantly.",
                    "Incredible progress this week. Keep showing up for yourself.",
                    "\(placeholders.money) saved from not drinking. Invest in yourself!"
                ]
            )
            
        case .porn:
            return NotificationMessageSet(
                morningMotivation: [
                    "Day \(placeholders.days) of your reboot. Your brain is rewiring!",
                    "Good morning! Your dopamine receptors are healing.",
                    "Another day of freedom. You're becoming who you want to be.",
                    "Focus and energy are returning. Keep going!"
                ],
                cravingSupport: [
                    "Urge surfing: Watch this wave rise and fall without acting.",
                    "Do 20 pushups RIGHT NOW. Change your state.",
                    "This urge is your brain rewiring. It's working!",
                    "Call someone or go outside. Real connection is what you need."
                ],
                milestoneReached: [
                    "🧠 \(placeholders.milestone)! Major neural pathway changes happening.",
                    "\(placeholders.milestone) achieved! Your brain is thanking you.",
                    "Milestone: \(placeholders.milestone)! You're becoming free."
                ],
                eveningReflection: [
                    "Nighttime can be hard. Have a plan. You've got this.",
                    "Another day of healing. Your future self thanks you.",
                    "Keep your phone out of the bedroom. Protect your progress."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks) complete! Focus and clarity improving.",
                    "Your brain's reward system is recalibrating. Great work!",
                    "\(placeholders.weeks) weeks of freedom. Real connection awaits!"
                ]
            )
            
        case .socialMedia:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Start your day present, not scrolling.",
                    "Day \(placeholders.days) of digital freedom. Your attention is yours.",
                    "Real life is happening now. Be there for it.",
                    "Your focus is returning. Enjoy the clarity!"
                ],
                cravingSupport: [
                    "Reaching for your phone? What are you really looking for?",
                    "Put the phone in another room. Out of sight, out of mind.",
                    "Take 5 deep breaths and look around the real world.",
                    "Call someone instead of scrolling. Real connection wins."
                ],
                milestoneReached: [
                    "📱❌ \(placeholders.milestone) without social media!",
                    "\(placeholders.milestone) achieved! Your attention span is healing.",
                    "Milestone: \(placeholders.milestone)! You own your attention now."
                ],
                eveningReflection: [
                    "You reclaimed \(placeholders.units) hours today. How did you spend them?",
                    "No doom scrolling tonight. Sleep well!",
                    "Reflect on real conversations you had today."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! \(placeholders.units) hours reclaimed for real life.",
                    "Your deep work capacity is growing. Amazing progress!",
                    "Relationships deepen without the screen between you."
                ]
            )
            
        case .gambling:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Your money stayed in YOUR pocket last night.",
                    "Day \(placeholders.days) gamble-free. You're already winning.",
                    "No bets, no regrets. Keep building your freedom.",
                    "Financial peace is the real jackpot. You're on your way."
                ],
                cravingSupport: [
                    "The house ALWAYS wins. But you win by not playing.",
                    "Call 1-800-522-4700 if you need support right now.",
                    "Wait 24 hours before any gambling decision. Always.",
                    "Calculate what you'd lose. Is it worth it? Never."
                ],
                milestoneReached: [
                    "💰 \(placeholders.milestone)! You've saved \(placeholders.money)!",
                    "\(placeholders.milestone) gamble-free! Financial freedom growing.",
                    "Milestone: \(placeholders.milestone)! Your family trusts you more."
                ],
                eveningReflection: [
                    "Today's money is safe. Tomorrow's will be too.",
                    "Reflect on what really matters. Hint: it's not the bet.",
                    "Your self-worth isn't tied to winning. You already won."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! \(placeholders.money) saved from gambling.",
                    "Your impulse control is strengthening every day!",
                    "Financial stability is building. Keep protecting it."
                ]
            )
            
        case .sugar:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Stable blood sugar = stable energy today.",
                    "Day \(placeholders.days) sugar-free. Your taste buds are resetting!",
                    "No sugar crashes today. Enjoy steady energy!",
                    "Your body is learning to burn fat for fuel. Keep going!"
                ],
                cravingSupport: [
                    "Craving? Drink water first—often it's thirst, not hunger.",
                    "Eat some protein to stabilize blood sugar.",
                    "This craving will pass in 10 minutes. Distract yourself.",
                    "Grab some berries if you need sweetness."
                ],
                milestoneReached: [
                    "🍎 \(placeholders.milestone) sugar-free!",
                    "\(placeholders.milestone) achieved! Inflammation is dropping.",
                    "Milestone: \(placeholders.milestone)! Your energy is stabilizing."
                ],
                eveningReflection: [
                    "Great food choices today! Your body thanks you.",
                    "Notice how stable your energy was without sugar.",
                    "Sleep well knowing your blood sugar is balanced."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! Your taste buds have reset.",
                    "Insulin sensitivity is improving every day!",
                    "Your skin, energy, and mood are all benefiting."
                ]
            )
            
        case .cannabis:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Natural clarity is your superpower today.",
                    "Day \(placeholders.days) sober. Dreams returning yet?",
                    "Your motivation is rebuilding. Notice it!",
                    "Clear mind, unlimited potential. Let's go!"
                ],
                cravingSupport: [
                    "Exercise gives a better high. Go for a walk.",
                    "This urge is THC leaving your system. Let it go.",
                    "Natural coping is more sustainable. You can do this.",
                    "Call a sober friend. Connection beats isolation."
                ],
                milestoneReached: [
                    "🌿❌ \(placeholders.milestone) cannabis-free!",
                    "\(placeholders.milestone) achieved! Memory and focus improving.",
                    "Milestone: \(placeholders.milestone)! Motivation is returning."
                ],
                eveningReflection: [
                    "Natural sleep tonight. REM is returning!",
                    "Your natural coping skills are growing stronger.",
                    "Reflect on how clear your thinking was today."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! THC is clearing from your system.",
                    "Your cognitive function is measurably improving!",
                    "Dreams may be vivid—that's healing happening."
                ]
            )
            
        case .caffeine:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Your natural energy is building.",
                    "Day \(placeholders.days) caffeine-free. Adenosine normalizing!",
                    "No crash today—just steady, natural energy.",
                    "Your adrenals are thanking you. Keep going!"
                ],
                cravingSupport: [
                    "Energy dip? Take a 10-minute walk instead.",
                    "Splash cold water on your face for a natural boost.",
                    "Eat an apple—natural sugar wakes you up.",
                    "This fatigue is temporary. Natural energy is coming."
                ],
                milestoneReached: [
                    "☕❌ \(placeholders.milestone) caffeine-free!",
                    "\(placeholders.milestone) achieved! Sleep quality improving.",
                    "Milestone: \(placeholders.milestone)! Natural energy building."
                ],
                eveningReflection: [
                    "You'll sleep deeper tonight without caffeine.",
                    "Tomorrow's energy will be even better.",
                    "Your anxiety levels are normalizing."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! Natural energy exceeds caffeine's boost.",
                    "Your sleep architecture has transformed!",
                    "\(placeholders.money) saved on coffee. Invest in yourself!"
                ]
            )
            
        case .vaping:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Your lungs are healing while you sleep.",
                    "Day \(placeholders.days) vape-free. Breathing easier!",
                    "No clouds, just clear lungs. You're doing great!",
                    "Your circulation is improving every hour."
                ],
                cravingSupport: [
                    "Chew gum or use a straw for the oral fixation.",
                    "3-5 minutes and this craving passes. Breathe through it.",
                    "Drink cold water slowly. It helps!",
                    "Your lungs have healed too much to go back."
                ],
                milestoneReached: [
                    "💨❌ \(placeholders.milestone) vape-free!",
                    "\(placeholders.milestone) achieved! Lungs regenerating.",
                    "Milestone: \(placeholders.milestone)! Nicotine is gone from your body."
                ],
                eveningReflection: [
                    "Another vape-free day. Your breath is cleaner.",
                    "\(placeholders.units) puffs avoided today. Lungs thank you!",
                    "Sleep well breathing clean air."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! \(placeholders.units) puffs NOT taken.",
                    "Your lung cilia are regenerating beautifully!",
                    "\(placeholders.money) saved on pods. Invest in health!"
                ]
            )
            
        case .gaming:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Real achievements await today.",
                    "Day \(placeholders.days) gaming-free. Level up IRL!",
                    "Your time is yours. Spend it building real skills.",
                    "Real life is the ultimate open world. Explore it!"
                ],
                cravingSupport: [
                    "Want to game? What real skill could you learn instead?",
                    "Text a real friend. Real connections beat NPCs.",
                    "Go outside. Nature is the original open world.",
                    "Set a timer—if you still want to game in 30 min, journal why."
                ],
                milestoneReached: [
                    "🎮❌ \(placeholders.milestone) gaming-free!",
                    "\(placeholders.milestone) achieved! Real achievements unlocked.",
                    "Milestone: \(placeholders.milestone)! Social skills leveling up."
                ],
                eveningReflection: [
                    "What real achievement did you unlock today?",
                    "\(placeholders.units) hours reclaimed for real life!",
                    "Your relationships are strengthening. Great job!"
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks)! \(placeholders.units) hours for real life.",
                    "Your productivity and social skills are growing!",
                    "Real achievements are more satisfying than virtual ones."
                ]
            )
            
        case .other:
            return NotificationMessageSet(
                morningMotivation: [
                    "Good morning! Another day of growth awaits.",
                    "Day \(placeholders.days) of your journey. Keep going!",
                    "You're building a better version of yourself.",
                    "Every day you choose change, you get stronger."
                ],
                cravingSupport: [
                    "This urge will pass. Take 5 deep breaths.",
                    "Remember why you started this journey.",
                    "Distract yourself for 10 minutes. You've got this!",
                    "Call someone or write in your journal."
                ],
                milestoneReached: [
                    "🎉 \(placeholders.milestone) achieved!",
                    "\(placeholders.milestone)! You're transforming.",
                    "Milestone: \(placeholders.milestone)! Keep building!"
                ],
                eveningReflection: [
                    "Another day of progress. Reflect on your wins.",
                    "You showed up for yourself today. Be proud.",
                    "Rest well knowing you're on the right path."
                ],
                weeklyProgress: [
                    "Week \(placeholders.weeks) complete! Amazing progress.",
                    "Your willpower is growing stronger every day!",
                    "Keep showing up. Transformation takes time."
                ]
            )
        }
    }
    
    // MARK: - Sharing Templates
    
    static func sharingTemplates(for type: HabitType) -> [SharingTemplate] {
        let universal = [
            SharingTemplate(
                id: "milestone",
                title: "Milestone Share",
                template: "🎉 I just hit \(placeholders.milestone) \(type.displayName.lowercased())-free with Quitto!\n\n✅ \(placeholders.days) days\n💰 \(placeholders.money) saved\n💪 \(placeholders.units) \(type.unitNamePlural) avoided\n\nOne day at a time. 💚"
            ),
            SharingTemplate(
                id: "weekly",
                title: "Weekly Update",
                template: "Week \(placeholders.weeks) of my \(type.displayName.lowercased())-free journey! 🙌\n\n🗓️ \(placeholders.days) days strong\n💰 \(placeholders.money) saved\n🔥 \(placeholders.streak) day streak\n\nIf you're thinking about quitting, do it. You won't regret it."
            )
        ]
        
        return universal + specificTemplates(for: type)
    }
    
    private static func specificTemplates(for type: HabitType) -> [SharingTemplate] {
        switch type {
        case .smoking:
            return [
                SharingTemplate(id: "health", title: "Health Update", template: "My body after \(placeholders.days) days smoke-free:\n\n🫁 Lung function up 30%\n❤️ Heart rate normalized\n👃 Taste & smell restored\n💰 \(placeholders.money) saved\n\nBest decision ever. #QuitSmoking")
            ]
        case .alcohol:
            return [
                SharingTemplate(id: "sober", title: "Sobriety Celebration", template: "\(placeholders.days) days sober! 🎉\n\nClear head ✅\nNo hangovers ✅\nBetter sleep ✅\nSaved \(placeholders.money) ✅\n\nSobriety is freedom. #SoberLife")
            ]
        case .porn:
            return [
                SharingTemplate(id: "reboot", title: "Reboot Progress", template: "Day \(placeholders.days) of my reboot 🧠\n\nFocus: Improving\nEnergy: Up\nConfidence: Growing\n\nRewiring in progress. #NoFap")
            ]
        default:
            return []
        }
    }
}

// MARK: - Supporting Types

struct NotificationMessageSet {
    let morningMotivation: [String]
    let cravingSupport: [String]
    let milestoneReached: [String]
    let eveningReflection: [String]
    let weeklyProgress: [String]
    
    func random(for category: NotificationCategory) -> String {
        switch category {
        case .morning: return morningMotivation.randomElement() ?? ""
        case .craving: return cravingSupport.randomElement() ?? ""
        case .milestone: return milestoneReached.randomElement() ?? ""
        case .evening: return eveningReflection.randomElement() ?? ""
        case .weekly: return weeklyProgress.randomElement() ?? ""
        }
    }
}

enum NotificationCategory {
    case morning
    case craving
    case milestone
    case evening
    case weekly
}

struct SharingTemplate: Identifiable {
    let id: String
    let title: String
    let template: String
    
    func filled(days: Int, money: String, units: Int, streak: Int, milestone: String, weeks: Int) -> String {
        template
            .replacingOccurrences(of: placeholders.days, with: "\(days)")
            .replacingOccurrences(of: placeholders.money, with: money)
            .replacingOccurrences(of: placeholders.units, with: "\(units)")
            .replacingOccurrences(of: placeholders.streak, with: "\(streak)")
            .replacingOccurrences(of: placeholders.milestone, with: milestone)
            .replacingOccurrences(of: placeholders.weeks, with: "\(weeks)")
    }
}

// Placeholder tokens
private enum placeholders {
    static let days = "{DAYS}"
    static let money = "{MONEY}"
    static let units = "{UNITS}"
    static let streak = "{STREAK}"
    static let milestone = "{MILESTONE}"
    static let weeks = "{WEEKS}"
}
