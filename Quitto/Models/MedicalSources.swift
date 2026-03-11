//
//  MedicalSources.swift
//  Quitto
//
//  Central citation database for all health/medical information.
//  Apple Guideline 1.4.1 compliance.
//

import Foundation

struct MedicalSource: Identifiable {
    let id = UUID()
    let shortName: String
    let fullTitle: String
    let url: String
    let organization: String
    var displayLabel: String { "Source: \(shortName)" }
}

enum MedicalSources {
    
    // MARK: - General
    static let apa = MedicalSource(shortName: "APA", fullTitle: "Understanding Addiction", url: "https://www.apa.org/topics/substance-use-abuse-addiction", organization: "American Psychological Association")
    static let nida = MedicalSource(shortName: "NIDA", fullTitle: "Science of Drug Use and Addiction", url: "https://nida.nih.gov/publications/media-guide/science-drug-use-addiction-basics", organization: "National Institute on Drug Abuse")
    static let who = MedicalSource(shortName: "WHO", fullTitle: "Management of Substance Abuse", url: "https://www.who.int/health-topics/drugs-psychoactive-substances", organization: "World Health Organization")
    static let harvard = MedicalSource(shortName: "Harvard Health", fullTitle: "Neuroplasticity and Habit Change", url: "https://www.health.harvard.edu/mind-and-mood/tips-for-a-better-brain", organization: "Harvard Medical School")
    
    // MARK: - Smoking
    static let aha = MedicalSource(shortName: "AHA", fullTitle: "Benefits of Quitting Smoking Over Time", url: "https://www.heart.org/en/healthy-living/healthy-lifestyle/quit-smoking-tobacco/the-benefits-of-quitting-smoking-now", organization: "American Heart Association")
    static let cdcSmoking = MedicalSource(shortName: "CDC", fullTitle: "Health Benefits of Quitting Smoking", url: "https://www.cdc.gov/tobacco/quit-smoking/reasons-to-quit/health-benefits.html", organization: "Centers for Disease Control and Prevention")
    static let surgeonGeneral = MedicalSource(shortName: "Surgeon General", fullTitle: "The Health Consequences of Smoking", url: "https://www.ncbi.nlm.nih.gov/books/NBK294310/", organization: "U.S. Surgeon General")
    static let ala = MedicalSource(shortName: "ALA", fullTitle: "Benefits of Quitting Smoking", url: "https://www.lung.org/quit-smoking/i-want-to-quit/benefits-of-quitting", organization: "American Lung Association")
    
    // MARK: - Alcohol
    static let niaaa = MedicalSource(shortName: "NIAAA", fullTitle: "Understanding Alcohol Use Disorder", url: "https://www.niaaa.nih.gov/publications/brochures-and-fact-sheets/understanding-alcohol-use-disorder", organization: "National Institute on Alcohol Abuse and Alcoholism")
    static let nhs = MedicalSource(shortName: "NHS", fullTitle: "Alcohol Recovery Timeline", url: "https://www.nhs.uk/live-well/alcohol-advice/the-risks-of-drinking-too-much/", organization: "National Health Service (UK)")
    static let hepatology = MedicalSource(shortName: "Hepatology", fullTitle: "Liver Recovery After Alcohol Cessation", url: "https://journals.lww.com/hep/pages/default.aspx", organization: "AASLD")
    
    // MARK: - Cannabis
    static let nidaCannabis = MedicalSource(shortName: "NIDA", fullTitle: "Cannabis (Marijuana) DrugFacts", url: "https://nida.nih.gov/publications/drugfacts/cannabis-marijuana", organization: "National Institute on Drug Abuse")
    static let samhsa = MedicalSource(shortName: "SAMHSA", fullTitle: "Know the Risks of Marijuana", url: "https://www.samhsa.gov/marijuana", organization: "SAMHSA")
    
    // MARK: - Caffeine
    static let fda = MedicalSource(shortName: "FDA", fullTitle: "How Much Caffeine is Too Much?", url: "https://www.fda.gov/consumers/consumer-updates/spilling-beans-how-much-caffeine-too-much", organization: "U.S. Food and Drug Administration")
    static let hopkins = MedicalSource(shortName: "Johns Hopkins", fullTitle: "Caffeine and Your Body", url: "https://www.hopkinsmedicine.org/health/wellness-and-prevention/caffeine-and-your-body", organization: "Johns Hopkins Medicine")
    
    // MARK: - Vaping
    static let cdcVaping = MedicalSource(shortName: "CDC", fullTitle: "About E-Cigarettes", url: "https://www.cdc.gov/tobacco/basic_information/e-cigarettes/about-e-cigarettes.html", organization: "CDC")
    static let alaVaping = MedicalSource(shortName: "ALA", fullTitle: "Impact of E-Cigarettes on the Lung", url: "https://www.lung.org/quit-smoking/e-cigarettes-vaping", organization: "American Lung Association")
    
    // MARK: - Sugar
    static let ahasugar = MedicalSource(shortName: "AHA", fullTitle: "Added Sugars and Health", url: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sugar/added-sugars", organization: "American Heart Association")
    static let mayoSugar = MedicalSource(shortName: "Mayo Clinic", fullTitle: "Added Sugar: What You Need to Know", url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/added-sugar/art-20045328", organization: "Mayo Clinic")
    
    // MARK: - Gambling
    static let ncpg = MedicalSource(shortName: "NCPG", fullTitle: "Problem Gambling Resources", url: "https://www.ncpgambling.org/help-treatment/", organization: "National Council on Problem Gambling")
    static let apagambling = MedicalSource(shortName: "APA", fullTitle: "Gambling Disorder", url: "https://www.psychiatry.org/patients-families/gambling-disorder", organization: "American Psychiatric Association")
    
    // MARK: - Behavioral (Porn, Social Media, Gaming)
    static let apaScreenTime = MedicalSource(shortName: "APA", fullTitle: "Digital Media and Mental Health", url: "https://www.apa.org/topics/social-media-internet/health-advisory-adolescent-social-media-use", organization: "American Psychological Association")
    static let whoGaming = MedicalSource(shortName: "WHO", fullTitle: "Gaming Disorder", url: "https://www.who.int/news-room/questions-and-answers/item/addictive-behaviours-gaming-disorder", organization: "World Health Organization")
    static let cambridgePorn = MedicalSource(shortName: "Cambridge", fullTitle: "Neuroscience of Internet Pornography Addiction", url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4600144/", organization: "Cambridge University Press / NCBI")
    
    // MARK: - Grouped by Habit
    
    static func sources(for habitType: String) -> [MedicalSource] {
        switch habitType {
        case "Smoking": return [aha, cdcSmoking, surgeonGeneral, ala]
        case "Alcohol": return [niaaa, nhs, hepatology]
        case "Porn": return [cambridgePorn, apa, harvard]
        case "Social Media": return [apaScreenTime, harvard]
        case "Gambling": return [ncpg, apagambling]
        case "Sugar": return [ahasugar, mayoSugar]
        case "Cannabis": return [nidaCannabis, samhsa]
        case "Caffeine": return [fda, hopkins]
        case "Vaping": return [cdcVaping, alaVaping, ala]
        case "Gaming": return [whoGaming, apaScreenTime]
        default: return [apa, nida, who, harvard]
        }
    }
    
    static var allSources: [MedicalSource] {
        [aha, cdcSmoking, surgeonGeneral, ala, niaaa, nhs, hepatology,
         nidaCannabis, samhsa, fda, hopkins, cdcVaping, alaVaping,
         ahasugar, mayoSugar, ncpg, apagambling, apaScreenTime,
         whoGaming, cambridgePorn, apa, nida, who, harvard]
    }
    
    static let generalDisclaimer = "The health information in this app is for educational purposes only and is not a substitute for professional medical advice. Always consult a qualified healthcare provider before making health decisions. If you are experiencing a medical emergency, call your local emergency number immediately."
    
    static let coachDisclaimer = "AI Coach responses are for general wellness support only and do not constitute medical advice. Sources are provided for reference. Consult a healthcare professional for personalized guidance."
}
