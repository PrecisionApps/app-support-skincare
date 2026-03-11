//
//  HabitSpecificOnboarding.swift
//  Quitto
//
//  Habit-specific onboarding questions and flows for each of the 10 habit types
//

import SwiftUI

// MARK: - Habit Specific Questions Protocol

protocol HabitOnboardingQuestions {
    var habitType: HabitType { get }
    var questions: [OnboardingQuestion] { get }
}

// MARK: - Onboarding Question Model

struct OnboardingQuestion: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let type: QuestionType
    let key: String
    
    enum QuestionType {
        case slider(min: Int, max: Int, unit: String, defaultValue: Int)
        case picker(options: [String])
        case multiSelect(options: [String])
        case yesNo
        case text(placeholder: String)
        case currency(defaultValue: Double)
        case timeOfDay
        case duration
    }
}

// MARK: - Habit Questions Provider

struct HabitQuestionsProvider {
    
    static func questions(for type: HabitType) -> [OnboardingQuestion] {
        switch type {
        case .smoking: return smokingQuestions
        case .alcohol: return alcoholQuestions
        case .porn: return pornQuestions
        case .socialMedia: return socialMediaQuestions
        case .gambling: return gamblingQuestions
        case .sugar: return sugarQuestions
        case .cannabis: return cannabisQuestions
        case .caffeine: return caffeineQuestions
        case .vaping: return vapingQuestions
        case .gaming: return gamingQuestions
        case .other: return otherQuestions
        }
    }
    
    // MARK: - Smoking Questions
    
    private static let smokingQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many cigarettes do you smoke per day?",
            subtitle: "On average, be honest with yourself",
            type: .slider(min: 1, max: 60, unit: "cigarettes", defaultValue: 15),
            key: "dailyAmount"
        ),
        OnboardingQuestion(
            title: "How long have you been smoking?",
            subtitle: nil,
            type: .picker(options: ["Less than 1 year", "1-5 years", "5-10 years", "10-20 years", "20+ years"]),
            key: "yearsSmoked"
        ),
        OnboardingQuestion(
            title: "What are your main triggers?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Stress", "After meals", "With coffee", "Social situations", "Driving", "Boredom", "Alcohol", "Morning routine"]),
            key: "triggers"
        ),
        OnboardingQuestion(
            title: "Have you tried to quit before?",
            subtitle: nil,
            type: .yesNo,
            key: "previousAttempts"
        )
    ]
    
    // MARK: - Alcohol Questions
    
    private static let alcoholQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many drinks do you have per week?",
            subtitle: "1 drink = 1 beer, glass of wine, or shot",
            type: .slider(min: 1, max: 50, unit: "drinks", defaultValue: 14),
            key: "weeklyDrinks"
        ),
        OnboardingQuestion(
            title: "What do you typically drink?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Beer", "Wine", "Spirits/Liquor", "Cocktails", "Hard Seltzer"]),
            key: "drinkTypes"
        ),
        OnboardingQuestion(
            title: "When do you usually drink?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["After work", "At dinner", "Social events", "Weekends only", "Daily", "When stressed"]),
            key: "drinkingTimes"
        ),
        OnboardingQuestion(
            title: "Do you drink alone?",
            subtitle: nil,
            type: .picker(options: ["Never", "Sometimes", "Often", "Usually"]),
            key: "drinkAlone"
        )
    ]
    
    // MARK: - Porn Questions
    
    private static let pornQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How often do you watch?",
            subtitle: "Be honest—this helps us help you",
            type: .picker(options: ["Multiple times daily", "Once daily", "Several times a week", "A few times a week", "Weekly"]),
            key: "frequency"
        ),
        OnboardingQuestion(
            title: "Average session length?",
            subtitle: nil,
            type: .picker(options: ["5-10 minutes", "15-30 minutes", "30-60 minutes", "1-2 hours", "2+ hours"]),
            key: "sessionLength"
        ),
        OnboardingQuestion(
            title: "When do you typically watch?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Morning", "During work/breaks", "Evening", "Late night", "When bored", "When stressed"]),
            key: "watchTimes"
        ),
        OnboardingQuestion(
            title: "Has it affected your relationships?",
            subtitle: nil,
            type: .picker(options: ["Not at all", "Slightly", "Moderately", "Significantly", "Severely"]),
            key: "relationshipImpact"
        ),
        OnboardingQuestion(
            title: "What's your goal?",
            subtitle: nil,
            type: .picker(options: ["Complete elimination", "Significant reduction", "Healthier relationship", "90-day reboot"]),
            key: "goal"
        )
    ]
    
    // MARK: - Social Media Questions
    
    private static let socialMediaQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many hours per day on social media?",
            subtitle: "Check your screen time for accurate data",
            type: .slider(min: 1, max: 12, unit: "hours", defaultValue: 4),
            key: "dailyHours"
        ),
        OnboardingQuestion(
            title: "Which platforms do you use most?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Instagram", "TikTok", "Twitter/X", "Facebook", "YouTube", "Reddit", "Snapchat", "LinkedIn"]),
            key: "platforms"
        ),
        OnboardingQuestion(
            title: "When do you scroll most?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["First thing morning", "During work", "At meals", "Evening", "Before bed", "When bored"]),
            key: "scrollTimes"
        ),
        OnboardingQuestion(
            title: "How does social media affect your mood?",
            subtitle: nil,
            type: .picker(options: ["Positive", "Mostly positive", "Neutral", "Mostly negative", "Negative"]),
            key: "moodImpact"
        ),
        OnboardingQuestion(
            title: "What's your goal?",
            subtitle: nil,
            type: .picker(options: ["Complete detox", "Reduce to 1 hour/day", "Reduce to 30 min/day", "Mindful use only"]),
            key: "goal"
        )
    ]
    
    // MARK: - Gambling Questions
    
    private static let gamblingQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "What type of gambling do you do?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Sports betting", "Casino", "Online slots", "Poker", "Lottery", "Horse racing", "Crypto trading", "Stock day-trading"]),
            key: "gamblingTypes"
        ),
        OnboardingQuestion(
            title: "How often do you gamble?",
            subtitle: nil,
            type: .picker(options: ["Multiple times daily", "Daily", "Several times a week", "Weekly", "Monthly"]),
            key: "frequency"
        ),
        OnboardingQuestion(
            title: "Total lifetime gambling losses?",
            subtitle: "Approximate—this motivates savings",
            type: .picker(options: ["Under $1,000", "$1,000-$5,000", "$5,000-$20,000", "$20,000-$50,000", "$50,000-$100,000", "Over $100,000"]),
            key: "lifetimeLosses"
        ),
        OnboardingQuestion(
            title: "Has gambling caused financial problems?",
            subtitle: nil,
            type: .picker(options: ["No", "Minor", "Moderate", "Significant", "Severe"]),
            key: "financialImpact"
        )
    ]
    
    // MARK: - Sugar Questions
    
    private static let sugarQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many sugary items per day?",
            subtitle: "Sodas, candy, desserts, sweetened drinks",
            type: .slider(min: 1, max: 15, unit: "servings", defaultValue: 6),
            key: "dailyServings"
        ),
        OnboardingQuestion(
            title: "What are your main sugar sources?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Soda/soft drinks", "Candy/chocolate", "Baked goods", "Ice cream", "Sweetened coffee/tea", "Energy drinks", "Cereal", "Hidden sugars"]),
            key: "sugarSources"
        ),
        OnboardingQuestion(
            title: "When do cravings hit hardest?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["After meals", "Afternoon slump", "Evening", "When stressed", "When bored", "Social situations"]),
            key: "cravingTimes"
        ),
        OnboardingQuestion(
            title: "Any health conditions related to sugar?",
            subtitle: "Select if applicable",
            type: .multiSelect(options: ["Pre-diabetes", "Diabetes", "Weight concerns", "Energy issues", "Skin issues", "None"]),
            key: "healthConditions"
        ),
        OnboardingQuestion(
            title: "What's your goal?",
            subtitle: nil,
            type: .picker(options: ["Eliminate added sugar", "Reduce significantly", "Only natural sugars", "Occasional treats only"]),
            key: "goal"
        )
    ]
    
    // MARK: - Cannabis Questions
    
    private static let cannabisQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How often do you use?",
            subtitle: nil,
            type: .picker(options: ["Multiple times daily", "Once daily", "Several times a week", "Weekly", "Occasionally"]),
            key: "frequency"
        ),
        OnboardingQuestion(
            title: "How do you typically consume?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Smoking", "Vaping", "Edibles", "Concentrates", "Tinctures"]),
            key: "consumptionMethod"
        ),
        OnboardingQuestion(
            title: "Why do you use cannabis?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Relaxation", "Sleep", "Anxiety", "Pain", "Social", "Boredom", "Creativity", "Habit"]),
            key: "reasonsForUse"
        ),
        OnboardingQuestion(
            title: "Has it affected your motivation?",
            subtitle: nil,
            type: .picker(options: ["Not at all", "Slightly", "Moderately", "Significantly"]),
            key: "motivationImpact"
        )
    ]
    
    // MARK: - Caffeine Questions
    
    private static let caffeineQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many caffeinated drinks per day?",
            subtitle: "Coffee, tea, energy drinks, soda",
            type: .slider(min: 1, max: 12, unit: "cups", defaultValue: 4),
            key: "dailyCups"
        ),
        OnboardingQuestion(
            title: "What are your caffeine sources?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Coffee", "Espresso drinks", "Tea", "Energy drinks", "Pre-workout", "Soda", "Caffeine pills"]),
            key: "caffeineSources"
        ),
        OnboardingQuestion(
            title: "What time is your last caffeine?",
            subtitle: nil,
            type: .picker(options: ["Before noon", "Early afternoon", "Late afternoon", "Evening", "Night"]),
            key: "lastCaffeineTime"
        ),
        OnboardingQuestion(
            title: "Do you experience withdrawal headaches?",
            subtitle: "When you miss your usual caffeine",
            type: .picker(options: ["Never", "Sometimes", "Often", "Always"]),
            key: "withdrawalHeadaches"
        ),
    ]
    
    // MARK: - Vaping Questions
    
    private static let vapingQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many puffs per day?",
            subtitle: "Estimate—most vapers don't count",
            type: .slider(min: 50, max: 500, unit: "puffs", defaultValue: 200),
            key: "dailyPuffs"
        ),
        OnboardingQuestion(
            title: "What nicotine strength?",
            subtitle: nil,
            type: .picker(options: ["0mg (no nicotine)", "3mg", "6mg", "12mg", "20mg+", "50mg/Salt nic"]),
            key: "nicotineStrength"
        ),
        OnboardingQuestion(
            title: "What device do you use?",
            subtitle: nil,
            type: .picker(options: ["Disposable", "Pod system", "Mod/tank", "Pen style"]),
            key: "deviceType"
        ),
        OnboardingQuestion(
            title: "Did you smoke before vaping?",
            subtitle: nil,
            type: .picker(options: ["Yes, switched fully", "Yes, still smoke sometimes", "No, started with vaping"]),
            key: "smokingHistory"
        )
    ]
    
    // MARK: - Gaming Questions
    
    private static let gamingQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How many hours per day do you game?",
            subtitle: "On average, be honest",
            type: .slider(min: 1, max: 16, unit: "hours", defaultValue: 5),
            key: "dailyHours"
        ),
        OnboardingQuestion(
            title: "What type of games do you play?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["MMOs", "Competitive/ranked", "Mobile games", "Single player", "Gacha/loot box", "Battle royale", "Streaming games"]),
            key: "gameTypes"
        ),
        OnboardingQuestion(
            title: "When do you typically game?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Morning", "During work/school", "Evening", "Late night/all night", "Weekends mainly"]),
            key: "gamingTimes"
        ),
        OnboardingQuestion(
            title: "Has gaming affected your responsibilities?",
            subtitle: "Work, school, relationships",
            type: .picker(options: ["Not at all", "Slightly", "Moderately", "Significantly", "Severely"]),
            key: "responsibilityImpact"
        ),
        OnboardingQuestion(
            title: "What's your goal?",
            subtitle: nil,
            type: .picker(options: ["Complete quit", "Weekends only", "1 hour/day max", "Better balance"]),
            key: "goal"
        )
    ]
    
    // MARK: - Other/Custom Habit Questions
    
    private static let otherQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            title: "How often do you engage in this habit?",
            subtitle: "Times per day on average",
            type: .slider(min: 1, max: 20, unit: "times", defaultValue: 3),
            key: "dailyAmount"
        ),
        OnboardingQuestion(
            title: "How long have you had this habit?",
            subtitle: nil,
            type: .picker(options: ["Less than 1 month", "1-6 months", "6-12 months", "1-5 years", "5+ years"]),
            key: "habitDuration"
        ),
        OnboardingQuestion(
            title: "What are your main triggers?",
            subtitle: "Select all that apply",
            type: .multiSelect(options: ["Stress", "Boredom", "Emotions", "Social situations", "Routine", "Tiredness", "Celebration"]),
            key: "triggers"
        ),
        OnboardingQuestion(
            title: "Have you tried to quit before?",
            subtitle: nil,
            type: .yesNo,
            key: "previousAttempts"
        ),
        OnboardingQuestion(
            title: "What's your main motivation?",
            subtitle: nil,
            type: .text(placeholder: "Enter your motivation..."),
            key: "motivation"
        )
    ]
}

// MARK: - Habit Specific Onboarding View

struct HabitSpecificOnboardingView: View {
    let habitType: HabitType
    @Binding var dailyAmount: Int
    @Binding var responses: [String: Any]
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    private var questions: [OnboardingQuestion] {
        HabitQuestionsProvider.questions(for: habitType)
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            ForEach(questions) { question in
                questionView(for: question)
            }
        }
    }
    
    @ViewBuilder
    private func questionView(for question: OnboardingQuestion) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(question.title)
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                if let subtitle = question.subtitle {
                    Text(subtitle)
                        .font(.bodySmall)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            
            switch question.type {
            case .slider(let min, let max, let unit, let defaultValue):
                sliderQuestion(question: question, min: min, max: max, unit: unit, defaultValue: defaultValue)
                
            case .picker(let options):
                pickerQuestion(question: question, options: options)
                
            case .multiSelect(let options):
                multiSelectQuestion(question: question, options: options)
                
            case .yesNo:
                yesNoQuestion(question: question)
                
            case .text(let placeholder):
                textQuestion(question: question, placeholder: placeholder)
                
            case .currency(let defaultValue):
                currencyQuestion(question: question, defaultValue: defaultValue)
                
            case .timeOfDay:
                timeOfDayQuestion(question: question)
                
            case .duration:
                durationQuestion(question: question)
            }
        }
    }
    
    // MARK: - Question Type Views
    
    private func sliderQuestion(question: OnboardingQuestion, min: Int, max: Int, unit: String, defaultValue: Int) -> some View {
        let binding = Binding<Double>(
            get: { Double(responses[question.key] as? Int ?? defaultValue) },
            set: {
                responses[question.key] = Int($0)
                if question.key == "dailyAmount" || question.key == "dailyPuffs" || question.key == "dailyCups" || question.key == "dailyHours" || question.key == "dailyServings" {
                    dailyAmount = Int($0)
                }
            }
        )
        
        return VStack(spacing: Theme.Spacing.sm) {
            HStack {
                Text("\(min)")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                
                Slider(value: binding, in: Double(min)...Double(max), step: 1)
                    .tint(theme.glowColor)
                
                Text("\(max)")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
            }
            
            Text("\(Int(binding.wrappedValue)) \(unit)")
                .font(.titleMedium)
                .foregroundStyle(theme.glowColor)
        }
    }
    
    private func pickerQuestion(question: OnboardingQuestion, options: [String]) -> some View {
        let selectedOption = responses[question.key] as? String ?? options.first ?? ""
        
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(options, id: \.self) { option in
                    Button {
                        responses[question.key] = option
                    } label: {
                        Text(option)
                            .font(.bodySmall)
                            .foregroundStyle(
                                selectedOption == option
                                    ? .white
                                    : (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            )
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(
                                        selectedOption == option
                                            ? theme.glowColor
                                            : (colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                                    )
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    private func multiSelectQuestion(question: OnboardingQuestion, options: [String]) -> some View {
        let selected = Set(responses[question.key] as? [String] ?? [])
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.sm) {
            ForEach(options, id: \.self) { option in
                Button {
                    var current = responses[question.key] as? [String] ?? []
                    if current.contains(option) {
                        current.removeAll { $0 == option }
                    } else {
                        current.append(option)
                    }
                    responses[question.key] = current
                } label: {
                    HStack(spacing: Theme.Spacing.xs) {
                        Image(systemName: selected.contains(option) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(selected.contains(option) ? theme.glowColor : Color.textTertiary)
                        
                        Text(option)
                            .font(.bodySmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Theme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                            .fill(
                                selected.contains(option)
                                    ? theme.glowColor.opacity(0.15)
                                    : (colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                            )
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
    
    private func yesNoQuestion(question: OnboardingQuestion) -> some View {
        let selected = responses[question.key] as? Bool
        
        return HStack(spacing: Theme.Spacing.md) {
            Button {
                responses[question.key] = true
            } label: {
                Text("Yes")
                    .font(.bodyMedium)
                    .foregroundStyle(selected == true ? .white : theme.glowColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .fill(selected == true ? theme.glowColor : theme.glowColor.opacity(0.15))
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            
            Button {
                responses[question.key] = false
            } label: {
                Text("No")
                    .font(.bodyMedium)
                    .foregroundStyle(selected == false ? .white : theme.glowColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .fill(selected == false ? theme.glowColor : theme.glowColor.opacity(0.15))
                    )
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    
    private func textQuestion(question: OnboardingQuestion, placeholder: String) -> some View {
        let binding = Binding<String>(
            get: { responses[question.key] as? String ?? "" },
            set: { responses[question.key] = $0 }
        )
        
        return TextField(placeholder, text: binding)
            .font(.bodyMedium)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
            )
    }
    
    private func currencyQuestion(question: OnboardingQuestion, defaultValue: Double) -> some View {
        let binding = Binding<Double>(
            get: { responses[question.key] as? Double ?? defaultValue },
            set: {
                responses[question.key] = $0
            }
        )
        
        return HStack {
            Text("$")
                .font(.titleLarge)
                .foregroundStyle(theme.glowColor)
            
            TextField("0.00", value: binding, format: .number.precision(.fractionLength(2)))
                .font(.titleLarge)
                .keyboardType(.decimalPad)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
        )
    }
    
    private func timeOfDayQuestion(question: OnboardingQuestion) -> some View {
        Text("Time of day picker - implement if needed")
            .foregroundStyle(Color.textTertiary)
    }
    
    private func durationQuestion(question: OnboardingQuestion) -> some View {
        Text("Duration picker - implement if needed")
            .foregroundStyle(Color.textTertiary)
    }
}
