//
//  HabitModeTheme.swift
//  Quitto
//
//  Comprehensive per-mode theming engine with MeshGradients, particle configs,
//  daily quotes, visual metaphors, and ambient color palettes per habit type.
//

import SwiftUI

// MARK: - Mode Theme Data

struct HabitModeTheme {
    let habitType: HabitType
    let modeTitle: String
    let modeSubtitle: String
    let heroSymbol: String
    let heroSymbolSecondary: String
    let particleSymbols: [String]
    let ambientColors: [Color]
    let meshColors: [Color]
    let glowColor: Color
    let neonAccent: Color
    let dailyQuotes: [String]
    let modeSpecificTerms: ModeTerminology
    let visualMetaphor: VisualMetaphor
    let soundscape: String
    
    // MARK: - Mode Terminology
    
    struct ModeTerminology {
        let progressVerb: String       // "healing" / "rewiring" / "detoxing"
        let unitLabel: String           // "cigarettes crushed" / "drinks dodged"
        let streakLabel: String         // "smoke-free" / "sober" / "clear-headed"
        let heroLabel: String           // "Warrior" / "Fighter" / "Champion"
        let emergencyTitle: String      // "Craving Alert" / "Urge Surfing"
        let victoryPhrase: String       // "Lungs are healing" / "Brain is rewiring"
    }
    
    // MARK: - Visual Metaphor
    
    enum VisualMetaphor {
        case risingSmoke          // Smoking - wisps rising and dissipating
        case clearWater           // Alcohol - water ripples, clarity
        case neuralNetwork        // Porn - brain neurons firing
        case sunriseHorizon       // Social Media - present moment, real world
        case shieldFortress       // Gambling - financial fortress
        case naturalGrowth        // Sugar - plant/leaf growth
        case mountainClarity      // Cannabis - mountain peak clarity
        case energyWave           // Caffeine - natural energy wave
        case cleanBreeze          // Vaping - clean air/breeze
        case realWorldQuest       // Gaming - real life achievements
        case starConstellation    // Other - star pattern growth
    }
    
    // MARK: - Theme Provider
    
    static func theme(for type: HabitType) -> HabitModeTheme {
        switch type {
        case .smoking: return smokingTheme
        case .alcohol: return alcoholTheme
        case .porn: return pornTheme
        case .socialMedia: return socialMediaTheme
        case .gambling: return gamblingTheme
        case .sugar: return sugarTheme
        case .cannabis: return cannabisTheme
        case .caffeine: return caffeineTheme
        case .vaping: return vapingTheme
        case .gaming: return gamingTheme
        case .other: return otherTheme
        }
    }
    
    // MARK: - Mesh Gradient Helper
    
    var meshGradient: some View {
        MeshGradientBackground(colors: meshColors, ambientColors: ambientColors)
    }
    
    var dailyQuote: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return dailyQuotes[dayOfYear % dailyQuotes.count]
    }
}

// MARK: - Mesh Gradient Background

struct MeshGradientBackground: View {
    let colors: [Color]
    let ambientColors: [Color]
    
    @State private var phase: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        if #available(iOS 18.0, *) {
            TimelineView(.animation(minimumInterval: 1.0 / 8.0)) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: meshPoints(time: t),
                    colors: adjustedColors
                )
                .opacity(colorScheme == .dark ? 0.35 : 0.25)
                .ignoresSafeArea()
            }
        } else {
            LinearGradient(
                colors: colors.map { $0.opacity(colorScheme == .dark ? 0.3 : 0.2) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
    
    private var adjustedColors: [Color] {
        let base = colors + ambientColors
        let needed = 9
        var result: [Color] = []
        for i in 0..<needed {
            result.append(base[i % base.count].opacity(colorScheme == .dark ? 0.6 : 0.4))
        }
        return result
    }
    
    private func meshPoints(time: Double) -> [SIMD2<Float>] {
        let slow = Float(time * 0.15)
        return [
            SIMD2(0.0, 0.0),
            SIMD2(0.5 + 0.1 * sin(slow), 0.0),
            SIMD2(1.0, 0.0),
            SIMD2(0.0, 0.5 + 0.08 * cos(slow * 1.3)),
            SIMD2(0.5 + 0.12 * cos(slow * 0.7), 0.5 + 0.12 * sin(slow * 0.9)),
            SIMD2(1.0, 0.5 + 0.08 * sin(slow * 1.1)),
            SIMD2(0.0, 1.0),
            SIMD2(0.5 + 0.1 * cos(slow * 0.8), 1.0),
            SIMD2(1.0, 1.0)
        ]
    }
}

// MARK: - Smoking Theme

private let smokingTheme = HabitModeTheme(
    habitType: .smoking,
    modeTitle: "Clean Lungs Mode",
    modeSubtitle: "Every breath is healing",
    heroSymbol: "lungs.fill",
    heroSymbolSecondary: "wind",
    particleSymbols: ["smoke.fill", "wind", "leaf.fill", "sparkle"],
    ambientColors: [
        Color(hue: 10, saturation: 30, lightness: 48),
        Color(hue: 18, saturation: 25, lightness: 55),
        Color(hue: 25, saturation: 22, lightness: 60),
        Color(hue: 5, saturation: 28, lightness: 44)
    ],
    meshColors: [
        Color(hue: 8, saturation: 32, lightness: 50),
        Color(hue: 15, saturation: 26, lightness: 56),
        Color(hue: 20, saturation: 22, lightness: 62),
        Color(hue: 12, saturation: 30, lightness: 46),
        Color(hue: 5, saturation: 28, lightness: 52),
        Color(hue: 22, saturation: 24, lightness: 58)
    ],
    glowColor: Color(hue: 12, saturation: 36, lightness: 50),
    neonAccent: Color(hue: 18, saturation: 30, lightness: 56),
    dailyQuotes: [
        "Your lungs are regenerating with every smoke-free breath.",
        "20 minutes after quitting, your heart rate begins to drop.",
        "Carbon monoxide is leaving your blood right now.",
        "Each craving you resist makes the next one weaker.",
        "Your sense of taste and smell are sharpening.",
        "Lung cilia are regrowing—you're literally healing.",
        "In 1 year, your heart disease risk drops by 50%.",
        "Your circulation is improving this very second.",
        "Every cigarette not smoked is a gift to your future self.",
        "You are breaking chains that millions wish they could.",
        "Your body started healing the moment you stopped.",
        "Ex-smokers live on average 10 years longer.",
        "You are NOT a smoker who is trying to quit. You ARE a non-smoker.",
        "The craving will pass whether you smoke or not."
    ],
    modeSpecificTerms: .init(
        progressVerb: "healing",
        unitLabel: "cigarettes crushed",
        streakLabel: "smoke-free",
        heroLabel: "Lung Warrior",
        emergencyTitle: "Craving Alert 🚨",
        victoryPhrase: "Your lungs are rebuilding"
    ),
    visualMetaphor: .risingSmoke,
    soundscape: "clean_breath"
)

// MARK: - Alcohol Theme

private let alcoholTheme = HabitModeTheme(
    habitType: .alcohol,
    modeTitle: "Crystal Clear Mode",
    modeSubtitle: "Clarity is your superpower",
    heroSymbol: "drop.fill",
    heroSymbolSecondary: "brain.head.profile",
    particleSymbols: ["drop.fill", "sparkle", "moon.stars.fill", "heart.fill"],
    ambientColors: [
        Color(hue: 275, saturation: 28, lightness: 48),
        Color(hue: 285, saturation: 22, lightness: 55),
        Color(hue: 268, saturation: 30, lightness: 44),
        Color(hue: 290, saturation: 20, lightness: 58)
    ],
    meshColors: [
        Color(hue: 270, saturation: 30, lightness: 50),
        Color(hue: 280, saturation: 24, lightness: 55),
        Color(hue: 290, saturation: 20, lightness: 60),
        Color(hue: 265, saturation: 28, lightness: 46),
        Color(hue: 275, saturation: 22, lightness: 52),
        Color(hue: 285, saturation: 18, lightness: 56)
    ],
    glowColor: Color(hue: 278, saturation: 32, lightness: 52),
    neonAccent: Color(hue: 282, saturation: 26, lightness: 58),
    dailyQuotes: [
        "Sobriety isn't the absence of alcohol—it's the presence of everything.",
        "Your liver is healing. Every sober day counts.",
        "Sleep quality improves dramatically without alcohol.",
        "You're not missing out. You're opting in to a better life.",
        "HALT: Hungry, Angry, Lonely, Tired—address the real need.",
        "One day at a time. That's all you ever need to handle.",
        "Your relationships are getting stronger every sober day.",
        "Alcohol borrows happiness from tomorrow. You're investing instead.",
        "Sobriety gave you your mornings back. Protect them.",
        "You're writing a comeback story, and it's beautiful.",
        "Clear head, full heart, can't lose.",
        "Your brain chemistry is rebalancing right now.",
        "You chose freedom. That takes real strength.",
        "Sober is not boring. Sober is awake."
    ],
    modeSpecificTerms: .init(
        progressVerb: "recovering",
        unitLabel: "drinks dodged",
        streakLabel: "sober",
        heroLabel: "Sobriety Champion",
        emergencyTitle: "Urge Alert 🛡️",
        victoryPhrase: "Your body is detoxing beautifully"
    ),
    visualMetaphor: .clearWater,
    soundscape: "calm_water"
)

// MARK: - Porn Theme

private let pornTheme = HabitModeTheme(
    habitType: .porn,
    modeTitle: "Brain Reboot Mode",
    modeSubtitle: "Rewiring for real connection",
    heroSymbol: "brain.head.profile",
    heroSymbolSecondary: "bolt.fill",
    particleSymbols: ["brain", "sparkle", "bolt.fill", "heart.fill"],
    ambientColors: [
        Color(hue: 335, saturation: 28, lightness: 46),
        Color(hue: 345, saturation: 24, lightness: 52),
        Color(hue: 350, saturation: 20, lightness: 56),
        Color(hue: 330, saturation: 26, lightness: 42)
    ],
    meshColors: [
        Color(hue: 338, saturation: 32, lightness: 48),
        Color(hue: 345, saturation: 26, lightness: 52),
        Color(hue: 352, saturation: 22, lightness: 56),
        Color(hue: 332, saturation: 30, lightness: 44),
        Color(hue: 340, saturation: 24, lightness: 50),
        Color(hue: 348, saturation: 20, lightness: 54)
    ],
    glowColor: Color(hue: 340, saturation: 34, lightness: 48),
    neonAccent: Color(hue: 346, saturation: 26, lightness: 54),
    dailyQuotes: [
        "Your dopamine receptors are recovering right now.",
        "Real connection > artificial stimulation. Always.",
        "The 90-day reboot is backed by neuroscience.",
        "Brain fog lifts. Focus returns. You're on your way.",
        "Every urge you resist physically rewires your brain.",
        "You're reclaiming your attention and your life.",
        "Neural pathways weaken when they're not used. Keep going.",
        "Your brain is learning to find pleasure in real life again.",
        "Emotional depth is returning. This is what healing feels like.",
        "You're not depriving yourself—you're upgrading yourself.",
        "Self-control is a muscle. You're getting stronger.",
        "Freedom from compulsion is true freedom.",
        "Your relationships deserve your full presence.",
        "Shame keeps you stuck. Self-compassion sets you free."
    ],
    modeSpecificTerms: .init(
        progressVerb: "rewiring",
        unitLabel: "urges conquered",
        streakLabel: "clean",
        heroLabel: "Reboot Warrior",
        emergencyTitle: "Urge Surfing 🧠",
        victoryPhrase: "Neural pathways are reshaping"
    ),
    visualMetaphor: .neuralNetwork,
    soundscape: "focus_clarity"
)

// MARK: - Social Media Theme

private let socialMediaTheme = HabitModeTheme(
    habitType: .socialMedia,
    modeTitle: "Present Moment Mode",
    modeSubtitle: "Real life is the main feed",
    heroSymbol: "person.2.fill",
    heroSymbolSecondary: "sun.max.fill",
    particleSymbols: ["sun.max.fill", "leaf.fill", "sparkle", "eye.fill"],
    ambientColors: [
        Color(hue: 205, saturation: 30, lightness: 50),
        Color(hue: 215, saturation: 25, lightness: 56),
        Color(hue: 195, saturation: 28, lightness: 48),
        Color(hue: 225, saturation: 22, lightness: 60)
    ],
    meshColors: [
        Color(hue: 200, saturation: 32, lightness: 50),
        Color(hue: 210, saturation: 26, lightness: 56),
        Color(hue: 220, saturation: 22, lightness: 60),
        Color(hue: 195, saturation: 30, lightness: 46),
        Color(hue: 205, saturation: 24, lightness: 52),
        Color(hue: 215, saturation: 20, lightness: 58)
    ],
    glowColor: Color(hue: 210, saturation: 35, lightness: 52),
    neonAccent: Color(hue: 216, saturation: 28, lightness: 58),
    dailyQuotes: [
        "Your attention span is recovering one offline hour at a time.",
        "The best moments aren't documented—they're lived.",
        "Comparison is the thief of joy. You're taking it back.",
        "Deep work becomes possible when the feed stops calling.",
        "Real likes come from real people who know the real you.",
        "Your self-worth was never supposed to be measured in likes.",
        "FOMO is a lie. JOMO (Joy of Missing Out) is real.",
        "You're not anti-social. You're pro-real-connection.",
        "Focus is the new superpower. You're building it.",
        "The algorithm served you content. Now you serve yourself.",
        "Your creativity flourishes in the silence.",
        "Present moment awareness is the greatest luxury.",
        "Screen time down, life quality up. Simple math.",
        "Digital minimalism isn't about less—it's about more of what matters."
    ],
    modeSpecificTerms: .init(
        progressVerb: "unplugging",
        unitLabel: "hours reclaimed",
        streakLabel: "unplugged",
        heroLabel: "Attention Sovereign",
        emergencyTitle: "Scroll Urge 📵",
        victoryPhrase: "Your focus span is expanding"
    ),
    visualMetaphor: .sunriseHorizon,
    soundscape: "morning_nature"
)

// MARK: - Gambling Theme

private let gamblingTheme = HabitModeTheme(
    habitType: .gambling,
    modeTitle: "Financial Fortress Mode",
    modeSubtitle: "The only winning move is not to play",
    heroSymbol: "banknote.fill",
    heroSymbolSecondary: "shield.fill",
    particleSymbols: ["dollarsign.circle.fill", "shield.fill", "sparkle", "lock.fill"],
    ambientColors: [
        Color(hue: 142, saturation: 28, lightness: 42),
        Color(hue: 150, saturation: 24, lightness: 50),
        Color(hue: 135, saturation: 26, lightness: 44),
        Color(hue: 155, saturation: 20, lightness: 52)
    ],
    meshColors: [
        Color(hue: 140, saturation: 30, lightness: 44),
        Color(hue: 148, saturation: 24, lightness: 50),
        Color(hue: 155, saturation: 20, lightness: 54),
        Color(hue: 135, saturation: 28, lightness: 40),
        Color(hue: 143, saturation: 22, lightness: 46),
        Color(hue: 150, saturation: 18, lightness: 52)
    ],
    glowColor: Color(hue: 145, saturation: 32, lightness: 44),
    neonAccent: Color(hue: 150, saturation: 26, lightness: 50),
    dailyQuotes: [
        "The house always wins. But YOU won by walking away.",
        "Every dollar not gambled is a dollar earned.",
        "You cannot gamble your way out of a gambling problem.",
        "Financial freedom starts with a single sober bet: zero.",
        "The thrill fades. The debt doesn't. You chose wisely.",
        "Trust is rebuilt one honest day at a time.",
        "Your family's security grows every day you don't bet.",
        "The best odds in life are the ones you don't take.",
        "Impulse control is your new superpower.",
        "Recovery is the jackpot that actually pays out.",
        "You're not losing by not playing. You're winning at life.",
        "Financial healing is possible. You're living proof.",
        "The rush of real achievement beats any bet.",
        "Your net worth rises when you stop gambling. Guaranteed."
    ],
    modeSpecificTerms: .init(
        progressVerb: "fortifying",
        unitLabel: "bets refused",
        streakLabel: "gamble-free",
        heroLabel: "Financial Guardian",
        emergencyTitle: "Bet Urge 🛑",
        victoryPhrase: "Your wealth is growing"
    ),
    visualMetaphor: .shieldFortress,
    soundscape: "steady_strength"
)

// MARK: - Sugar Theme

private let sugarTheme = HabitModeTheme(
    habitType: .sugar,
    modeTitle: "Clean Fuel Mode",
    modeSubtitle: "Your body deserves real energy",
    heroSymbol: "heart.fill",
    heroSymbolSecondary: "leaf.fill",
    particleSymbols: ["leaf.fill", "carrot.fill", "sparkle", "bolt.fill"],
    ambientColors: [
        Color(hue: 32, saturation: 34, lightness: 50),
        Color(hue: 40, saturation: 28, lightness: 56),
        Color(hue: 25, saturation: 32, lightness: 48),
        Color(hue: 45, saturation: 24, lightness: 60)
    ],
    meshColors: [
        Color(hue: 30, saturation: 36, lightness: 52),
        Color(hue: 38, saturation: 30, lightness: 58),
        Color(hue: 45, saturation: 24, lightness: 62),
        Color(hue: 25, saturation: 34, lightness: 48),
        Color(hue: 33, saturation: 28, lightness: 54),
        Color(hue: 40, saturation: 22, lightness: 58)
    ],
    glowColor: Color(hue: 35, saturation: 38, lightness: 52),
    neonAccent: Color(hue: 40, saturation: 30, lightness: 58),
    dailyQuotes: [
        "Your blood sugar is stabilizing. Energy crashes are fading.",
        "Taste buds reset after 2 weeks—fruit will taste like candy.",
        "Inflammation is dropping throughout your body.",
        "Your gut microbiome is thanking you right now.",
        "Sugar addiction uses the same brain pathways as drugs.",
        "Stable energy all day beats a sugar rush any time.",
        "Your skin is clearing up. Sugar ages you from the inside.",
        "Insulin sensitivity is improving with every sugar-free day.",
        "You're not on a diet. You're breaking free from a drug.",
        "Real food tastes amazing when sugar isn't hijacking your palate.",
        "Your pancreas is recovering. You're preventing disease.",
        "Mental clarity improves dramatically without sugar crashes.",
        "Cravings peak at day 3 and fade by week 2. You've got this.",
        "Every cell in your body works better without excess sugar."
    ],
    modeSpecificTerms: .init(
        progressVerb: "cleansing",
        unitLabel: "servings skipped",
        streakLabel: "sugar-free",
        heroLabel: "Clean Fuel Champion",
        emergencyTitle: "Sugar Craving 🍬",
        victoryPhrase: "Your metabolism is resetting"
    ),
    visualMetaphor: .naturalGrowth,
    soundscape: "natural_vitality"
)

// MARK: - Cannabis Theme

private let cannabisTheme = HabitModeTheme(
    habitType: .cannabis,
    modeTitle: "Natural Clarity Mode",
    modeSubtitle: "The clearest high is sobriety",
    heroSymbol: "sparkles",
    heroSymbolSecondary: "mountain.2.fill",
    particleSymbols: ["sparkle", "sun.max.fill", "brain.head.profile", "mountain.2.fill"],
    ambientColors: [
        Color(hue: 138, saturation: 26, lightness: 44),
        Color(hue: 148, saturation: 22, lightness: 52),
        Color(hue: 130, saturation: 24, lightness: 42),
        Color(hue: 155, saturation: 18, lightness: 54)
    ],
    meshColors: [
        Color(hue: 135, saturation: 28, lightness: 46),
        Color(hue: 145, saturation: 22, lightness: 52),
        Color(hue: 152, saturation: 18, lightness: 56),
        Color(hue: 128, saturation: 26, lightness: 42),
        Color(hue: 140, saturation: 22, lightness: 48),
        Color(hue: 148, saturation: 16, lightness: 54)
    ],
    glowColor: Color(hue: 140, saturation: 30, lightness: 46),
    neonAccent: Color(hue: 148, saturation: 24, lightness: 52),
    dailyQuotes: [
        "REM sleep is returning. Dreams are your brain rebooting.",
        "Natural clarity beats any high. You'll see.",
        "Motivation is returning. THC dulled your drive—you're waking up.",
        "Short-term memory sharpens every sober day.",
        "Your endocannabinoid system is recalibrating naturally.",
        "Boredom is temporary. The life you're building isn't.",
        "Anxiety management improves as your brain heals.",
        "30 days clean: THC is leaving your fat cells.",
        "Real emotions are returning. That's healing, not weakness.",
        "Your lungs are clearing. Cannabis smoke has carcinogens too.",
        "Productivity soars without the fog. You'll be amazed.",
        "Social confidence grows when it's authentic.",
        "You don't need to be high to enjoy life. You ARE life.",
        "Every sober day deposits clarity into your future."
    ],
    modeSpecificTerms: .init(
        progressVerb: "clearing",
        unitLabel: "sessions skipped",
        streakLabel: "sober",
        heroLabel: "Clarity Seeker",
        emergencyTitle: "Craving Wave 🌊",
        victoryPhrase: "Your mind is clearing"
    ),
    visualMetaphor: .mountainClarity,
    soundscape: "mountain_breeze"
)

// MARK: - Caffeine Theme

private let caffeineTheme = HabitModeTheme(
    habitType: .caffeine,
    modeTitle: "Natural Energy Mode",
    modeSubtitle: "Your body makes its own fuel",
    heroSymbol: "bolt.fill",
    heroSymbolSecondary: "sunrise.fill",
    particleSymbols: ["bolt.fill", "sunrise.fill", "sparkle", "battery.100"],
    ambientColors: [
        Color(hue: 22, saturation: 30, lightness: 46),
        Color(hue: 30, saturation: 24, lightness: 52),
        Color(hue: 18, saturation: 28, lightness: 42),
        Color(hue: 35, saturation: 22, lightness: 55)
    ],
    meshColors: [
        Color(hue: 20, saturation: 32, lightness: 48),
        Color(hue: 28, saturation: 26, lightness: 52),
        Color(hue: 35, saturation: 22, lightness: 56),
        Color(hue: 15, saturation: 30, lightness: 44),
        Color(hue: 25, saturation: 24, lightness: 50),
        Color(hue: 32, saturation: 20, lightness: 54)
    ],
    glowColor: Color(hue: 25, saturation: 36, lightness: 48),
    neonAccent: Color(hue: 30, saturation: 28, lightness: 54),
    dailyQuotes: [
        "Headaches peak at day 1-2, then fade. You're almost through.",
        "Adenosine receptors are normalizing. Natural sleepiness returns.",
        "Your adrenal glands are recovering from years of overstimulation.",
        "Natural energy > artificial spikes. Your body knows the way.",
        "Sleep quality skyrockets without caffeine interference.",
        "Anxiety drops significantly when cortisol isn't spiked daily.",
        "Morning energy will return naturally. Give it 2 weeks.",
        "You're breaking free from the need for a substance to function.",
        "Hydration improves when you're not drinking diuretics all day.",
        "The afternoon slump disappears when your energy is real.",
        "Blood pressure normalizes without daily caffeine.",
        "Your circadian rhythm is healing. Real sleep awaits.",
        "True vitality doesn't come from a cup. It comes from you.",
        "Week 2: Most people feel MORE energy than when on caffeine."
    ],
    modeSpecificTerms: .init(
        progressVerb: "energizing",
        unitLabel: "cups skipped",
        streakLabel: "caffeine-free",
        heroLabel: "Energy Naturalist",
        emergencyTitle: "Energy Dip ⚡",
        victoryPhrase: "Natural vitality is building"
    ),
    visualMetaphor: .energyWave,
    soundscape: "morning_energy"
)

// MARK: - Vaping Theme

private let vapingTheme = HabitModeTheme(
    habitType: .vaping,
    modeTitle: "Clean Air Mode",
    modeSubtitle: "Breathe free, live free",
    heroSymbol: "wind",
    heroSymbolSecondary: "lungs.fill",
    particleSymbols: ["wind", "leaf.fill", "sparkle", "cloud.fill"],
    ambientColors: [
        Color(hue: 192, saturation: 30, lightness: 48),
        Color(hue: 200, saturation: 24, lightness: 54),
        Color(hue: 185, saturation: 28, lightness: 46),
        Color(hue: 208, saturation: 22, lightness: 58)
    ],
    meshColors: [
        Color(hue: 190, saturation: 32, lightness: 50),
        Color(hue: 198, saturation: 26, lightness: 56),
        Color(hue: 205, saturation: 22, lightness: 60),
        Color(hue: 185, saturation: 30, lightness: 46),
        Color(hue: 195, saturation: 24, lightness: 52),
        Color(hue: 202, saturation: 20, lightness: 58)
    ],
    glowColor: Color(hue: 195, saturation: 34, lightness: 50),
    neonAccent: Color(hue: 200, saturation: 26, lightness: 56),
    dailyQuotes: [
        "Nicotine is leaving your bloodstream right now.",
        "Lung cilia are regrowing—your lungs are self-cleaning.",
        "3 days clean: nicotine is completely out of your system.",
        "Your taste and smell are returning to normal.",
        "Vaping delivered MORE nicotine than cigarettes. You broke free.",
        "Every breath of clean air is medicine for your lungs.",
        "The hand-to-mouth habit weakens every day you resist.",
        "EVALI risk drops to zero. Your lungs are safe.",
        "You're saving money AND your health. Double win.",
        "Circulation improves dramatically in the first 2 weeks.",
        "Your teeth and gums are healing without vape chemicals.",
        "Brain development needs clean air. You chose wisely.",
        "The urge to vape lasts 3-5 minutes. You can outlast it.",
        "One year vape-free: respiratory illness risk drops 50%."
    ],
    modeSpecificTerms: .init(
        progressVerb: "purifying",
        unitLabel: "puffs avoided",
        streakLabel: "vape-free",
        heroLabel: "Clean Air Warrior",
        emergencyTitle: "Puff Craving 💨",
        victoryPhrase: "Your airways are clearing"
    ),
    visualMetaphor: .cleanBreeze,
    soundscape: "fresh_air"
)

// MARK: - Gaming Theme

private let gamingTheme = HabitModeTheme(
    habitType: .gaming,
    modeTitle: "Real Life Quest Mode",
    modeSubtitle: "The ultimate game is your life",
    heroSymbol: "figure.walk",
    heroSymbolSecondary: "trophy.fill",
    particleSymbols: ["star.fill", "figure.run", "sparkle", "trophy.fill"],
    ambientColors: [
        Color(hue: 268, saturation: 28, lightness: 50),
        Color(hue: 278, saturation: 22, lightness: 56),
        Color(hue: 260, saturation: 26, lightness: 48),
        Color(hue: 285, saturation: 20, lightness: 60)
    ],
    meshColors: [
        Color(hue: 265, saturation: 30, lightness: 52),
        Color(hue: 275, saturation: 24, lightness: 58),
        Color(hue: 282, saturation: 20, lightness: 62),
        Color(hue: 258, saturation: 28, lightness: 48),
        Color(hue: 270, saturation: 22, lightness: 54),
        Color(hue: 278, saturation: 18, lightness: 60)
    ],
    glowColor: Color(hue: 270, saturation: 32, lightness: 52),
    neonAccent: Color(hue: 276, saturation: 26, lightness: 58),
    dailyQuotes: [
        "Real achievements have no respawn timer. Make them count.",
        "XP in real life compounds. Level up where it matters.",
        "Social skills built offline are the ultimate power-up.",
        "Your dopamine system is recalibrating for real rewards.",
        "Time invested in yourself has the best ROI.",
        "The boss battle is against your habits. You're winning.",
        "Real friendships > online guilds. Build your party IRL.",
        "Productivity is the cheat code for real life.",
        "Physical fitness is the ultimate stat boost.",
        "No loot box will ever match a real accomplishment.",
        "Your attention span is recovering. Deep focus unlocked.",
        "Sleep improves without blue light and adrenaline spikes.",
        "The real world has better graphics. Go explore it.",
        "You're speedrunning personal growth now."
    ],
    modeSpecificTerms: .init(
        progressVerb: "leveling up",
        unitLabel: "hours reclaimed",
        streakLabel: "unplugged",
        heroLabel: "Life Champion",
        emergencyTitle: "Game Urge 🎮",
        victoryPhrase: "Real life stats are rising"
    ),
    visualMetaphor: .realWorldQuest,
    soundscape: "adventure_irl"
)

// MARK: - Other Theme

private let otherTheme = HabitModeTheme(
    habitType: .other,
    modeTitle: "Freedom Mode",
    modeSubtitle: "Breaking chains, building futures",
    heroSymbol: "sparkles",
    heroSymbolSecondary: "star.fill",
    particleSymbols: ["sparkle", "star.fill", "heart.fill", "flame.fill"],
    ambientColors: [
        Color(hue: 178, saturation: 26, lightness: 44),
        Color(hue: 188, saturation: 20, lightness: 52),
        Color(hue: 170, saturation: 24, lightness: 42),
        Color(hue: 195, saturation: 18, lightness: 54)
    ],
    meshColors: [
        Color(hue: 175, saturation: 28, lightness: 46),
        Color(hue: 185, saturation: 22, lightness: 52),
        Color(hue: 192, saturation: 18, lightness: 56),
        Color(hue: 168, saturation: 26, lightness: 42),
        Color(hue: 180, saturation: 20, lightness: 48),
        Color(hue: 188, saturation: 16, lightness: 54)
    ],
    glowColor: Color(hue: 180, saturation: 30, lightness: 46),
    neonAccent: Color(hue: 186, saturation: 24, lightness: 52),
    dailyQuotes: [
        "Every day you resist is a day you grow stronger.",
        "Habits are just neural pathways. You're building new ones.",
        "The cue-routine-reward loop can be reprogrammed. You're doing it.",
        "Your environment shapes behavior. You're reshaping both.",
        "Willpower is a muscle. Every rep makes it stronger.",
        "Neuroplasticity means your brain can change at any age.",
        "Replace, don't just remove. Fill the void with purpose.",
        "Self-compassion is not weakness—it's the foundation of change.",
        "Track your triggers. Knowledge is your greatest weapon.",
        "One percent better every day = 37x better in one year.",
        "The discomfort of change is temporary. The reward is permanent.",
        "You are not your habit. You are the person choosing to break it.",
        "Community accelerates recovery. You're not alone.",
        "The best time to start was yesterday. The second best is now."
    ],
    modeSpecificTerms: .init(
        progressVerb: "transforming",
        unitLabel: "times resisted",
        streakLabel: "free",
        heroLabel: "Freedom Fighter",
        emergencyTitle: "Urge Alert 🌟",
        victoryPhrase: "New neural pathways are forming"
    ),
    visualMetaphor: .starConstellation,
    soundscape: "ambient_calm"
)
