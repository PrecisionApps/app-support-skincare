//
//  AppStore.swift
//  Quitto
//

import Foundation
import SwiftUI
import SwiftData
import RevenueCat

@MainActor
@Observable
final class AppStore {
    // MARK: - Navigation State
    var selectedTab: AppTab = .dashboard
    var showOnboarding: Bool = false
    var showCravingSheet: Bool = false
    var showJournalSheet: Bool = false
    var showMilestoneAlert: Bool = false
    var showSettings: Bool = false
    var showPaywall: Bool = false
    
    // MARK: - Data State
    var currentHabit: Habit?
    var recentMilestone: Milestone?
    var isLoading: Bool = false
    
    // MARK: - AI State
    var aiMessages: [CoachMessage] = []
    var isAITyping: Bool = false
    
    // MARK: - Model Context
    private var modelContext: ModelContext?
    
    // MARK: - Services
    let aiService: AICoachService
    let notificationService: NotificationService
    let widgetService: WidgetService
    let purchaseService: PurchaseService
    let engagementManager: EngagementManager
    let healthKitService: HealthKitService
    
    // MARK: - Purchases state
    private(set) var isPremiumUnlocked: Bool = false
    private(set) var offerings: Offerings?
    var paywallError: String?
    var isPurchaseInProgress: Bool = false
    
    var onboardingPackages: [Package] {
        let packages: [Package]
        if let offering = offerings?.offering(identifier: AppConstants.Purchases.onboardingOffering) {
            packages = offering.availablePackages
        } else {
            packages = offerings?.current?.availablePackages ?? []
        }
        return packages.sorted { lhs, rhs in
            lhs.packageType.sortOrder < rhs.packageType.sortOrder
        }
    }
    
    init() {
        self.aiService = AICoachService()
        self.notificationService = NotificationService()
        self.widgetService = WidgetService()
        self.purchaseService = PurchaseService()
        self.engagementManager = EngagementManager()
        self.healthKitService = HealthKitService()
    }
    
    func configure(with context: ModelContext) {
        self.modelContext = context
        Task {
            await checkOnboardingStatus()
            await configurePurchases()
        }
    }
    
    private func configurePurchases() async {
        do {
            try await refreshCustomerInfo()
            offerings = try await purchaseService.fetchOfferings()
        } catch {
            paywallError = error.localizedDescription
        }
    }
    
    func refreshCustomerInfo() async throws {
        let customerInfo = try await purchaseService.currentCustomerInfo()
        isPremiumUnlocked = customerInfo.entitlements[AppConstants.Purchases.premiumEntitlement]?.isActive == true
    }
    
    func loadOfferingsIfNeeded(force: Bool = false) async {
        guard force || offerings == nil else { return }
        do {
            offerings = try await purchaseService.fetchOfferings()
        } catch {
            paywallError = error.localizedDescription
        }
    }
    
    func package(for identifier: String) -> Package? {
        onboardingPackages.first { $0.identifier == identifier }
    }
    
    // MARK: - In-App Purchase Actions
    
    func purchasePackage(_ package: Package) async {
        isPurchaseInProgress = true
        defer { isPurchaseInProgress = false }
        do {
            paywallError = nil
            let result = try await purchaseService.purchase(package: package)
            guard !result.userCancelled else { return }
            try await refreshCustomerInfo()
            if isPremiumUnlocked {
                showPaywall = false
                // Update persisted profile
                if let context = modelContext {
                    let descriptor = FetchDescriptor<UserProfile>()
                    if let profile = try? context.fetch(descriptor).first {
                        profile.isPremium = true
                        try? context.save()
                    }
                }
            }
        } catch {
            paywallError = error.localizedDescription
        }
    }
    
    func restorePurchases() async {
        isPurchaseInProgress = true
        defer { isPurchaseInProgress = false }
        do {
            paywallError = nil
            _ = try await purchaseService.restore()
            try await refreshCustomerInfo()
            if isPremiumUnlocked {
                showPaywall = false
                if let context = modelContext {
                    let descriptor = FetchDescriptor<UserProfile>()
                    if let profile = try? context.fetch(descriptor).first {
                        profile.isPremium = true
                        try? context.save()
                    }
                }
            } else {
                paywallError = "No active subscription found. Please purchase a plan."
            }
        } catch {
            paywallError = error.localizedDescription
        }
    }
    
    
    func syncWidgetData() {
        guard let habit = currentHabit else { return }
        Task {
            await widgetService.updateWidget(with: habit)
        }
    }
    
    // MARK: - Onboarding
    
    private func checkOnboardingStatus() async {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<UserProfile>()
        if let profile = try? context.fetch(descriptor).first {
            showOnboarding = !profile.hasCompletedOnboarding
        } else {
            showOnboarding = true
        }
    }
    
    func completeOnboarding(name: String, habit: Habit) {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<UserProfile>()
        let existingProfile = try? modelContext?.fetch(descriptor).first
        let profile = existingProfile ?? UserProfile(name: name)
        profile.name = name
        profile.hasCompletedOnboarding = true
        profile.isPremium = isPremiumUnlocked
        if existingProfile == nil {
            context.insert(profile)
        }
        
        // Add default milestones to habit
        let milestones = MilestoneTemplate.generateMilestones()
        for milestone in milestones {
            milestone.habit = habit
            context.insert(milestone)
        }
        
        context.insert(habit)
        currentHabit = habit
        
        try? context.save()
        
        showOnboarding = false
        
        // Schedule notifications and sync widget
        Task {
            await notificationService.scheduleInitialNotifications(for: habit)
            await widgetService.updateWidget(with: habit)
        }
    }
    
    // MARK: - Habit Actions
    
    func fetchCurrentHabit() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<Habit>(
            predicate: #Predicate { $0.isActive },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        currentHabit = try? context.fetch(descriptor).first
        
        // Sync widget with current habit
        if let habit = currentHabit {
            Task {
                await widgetService.updateWidget(with: habit)
            }
        }
    }
    
    func addHabit(_ habit: Habit) {
        guard let context = modelContext else { return }
        
        // Add milestones
        let milestones = MilestoneTemplate.generateMilestones()
        for milestone in milestones {
            milestone.habit = habit
            context.insert(milestone)
        }
        
        context.insert(habit)
        currentHabit = habit
        
        try? context.save()
        
        // Sync widget
        Task {
            await widgetService.updateWidget(with: habit)
        }
    }
    
    // MARK: - Craving Actions
    
    func logCraving(
        intensity: Int,
        trigger: CravingTrigger,
        note: String = "",
        didRelapse: Bool = false
    ) {
        guard let context = modelContext, let habit = currentHabit else { return }
        
        let log = CravingLog(
            intensity: intensity,
            trigger: trigger,
            note: note,
            didRelapse: didRelapse
        )
        log.habit = habit
        context.insert(log)
        
        try? context.save()
        
        // Provide immediate support via AI
        if !didRelapse {
            engagementManager.recordSuccessfulAction()
            Task {
                await sendAIMessageBackground("I'm having a craving right now. The trigger is \(trigger.displayName.lowercased()) and intensity is \(intensity)/10.", forHabit: habit)
            }
        }
        
        showCravingSheet = false
    }
    
    // MARK: - Journal Actions
    
    func addJournalEntry(content: String, mood: JournalMood, prompt: String = "") {
        guard let context = modelContext, let habit = currentHabit else { return }
        
        let entry = JournalEntry(
            content: content,
            mood: mood,
            promptUsed: prompt
        )
        entry.habit = habit
        context.insert(entry)
        
        try? context.save()
        engagementManager.recordSuccessfulAction()
        showJournalSheet = false
    }
    
    // MARK: - Milestone Actions
    
    func checkMilestones() {
        guard let habit = currentHabit else { return }
        
        let days = habit.daysSinceQuit
        
        for milestone in habit.milestones where !milestone.isUnlocked {
            if days >= milestone.daysRequired {
                milestone.unlock()
                recentMilestone = milestone
                showMilestoneAlert = true
                engagementManager.recordSuccessfulAction()
                
                // Trigger celebration notification
                Task {
                    await notificationService.sendMilestoneNotification(milestone, for: habit)
                }
                
                break
            }
        }
    }
    
    // MARK: - AI Coach Actions
    
    /// The content being streamed for the current AI response (updated token by token).
    var streamingContent: String = ""
    
    /// Send a user message and stream the AI response token by token.
    func sendAIMessage(_ message: String, forHabit habit: Habit? = nil) async {
        guard let context = modelContext else { return }
        
        let targetHabit = habit ?? currentHabit
        
        let userMessage = CoachMessage(
            content: message,
            isFromUser: true,
            habitId: targetHabit?.id
        )
        context.insert(userMessage)
        aiMessages.append(userMessage)
        
        isAITyping = true
        streamingContent = ""
        
        // Get the stream from the AI service
        let stream = await aiService.streamResponse(
            for: message,
            habit: targetHabit,
            conversationHistory: aiMessages
        )
        
        // Create the AI message shell immediately so the view can show streaming text
        let aiMessage = CoachMessage(
            content: "",
            isFromUser: false,
            habitId: targetHabit?.id
        )
        context.insert(aiMessage)
        aiMessages.append(aiMessage)
        
        // Switch from typing indicator to streaming mode
        isAITyping = false
        
        var fullContent = ""
        
        for await event in stream {
            switch event {
            case .token(let token):
                fullContent += token
                streamingContent = fullContent
                // Update the persisted message content periodically
                aiMessage.content = fullContent
            case .done:
                break
            case .error:
                break
            }
        }
        
        // Finalize
        aiMessage.content = fullContent
        streamingContent = ""
        
        try? context.save()
        engagementManager.recordSuccessfulAction()
    }
    
    /// Send a message in the background without streaming UI (e.g. auto craving messages).
    func sendAIMessageBackground(_ message: String, forHabit habit: Habit? = nil) async {
        guard let context = modelContext else { return }
        
        let targetHabit = habit ?? currentHabit
        
        let userMessage = CoachMessage(
            content: message,
            isFromUser: true,
            habitId: targetHabit?.id
        )
        context.insert(userMessage)
        aiMessages.append(userMessage)
        
        isAITyping = true
        
        let response = await aiService.getResponse(
            for: message,
            habit: targetHabit,
            conversationHistory: aiMessages
        )
        
        let aiMessage = CoachMessage(
            content: response,
            isFromUser: false,
            habitId: targetHabit?.id
        )
        context.insert(aiMessage)
        aiMessages.append(aiMessage)
        
        try? context.save()
        isAITyping = false
        engagementManager.recordSuccessfulAction()
    }
    
    func loadAIMessages() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<CoachMessage>(
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        
        aiMessages = (try? context.fetch(descriptor)) ?? []
    }
    
    func clearAIMessages() {
        guard let context = modelContext else { return }
        
        for message in aiMessages {
            context.delete(message)
        }
        aiMessages = []
        try? context.save()
    }
    
    // MARK: - Deep Linking
    
    /// Pending message to auto-send when CoachView appears (set by `quitto://coach?message=X`).
    var pendingCoachMessage: String?
    
    /// Pending event fired via `quitto://event?name=X&key=value`.
    /// Views can observe this and react accordingly.
    var pendingEvent: (name: String, params: [String: String])?
    
    func handleDeepLink(_ url: URL) {
        guard let route = DeepLinkRoute.from(url) else { return }
        
        // Don't process navigation deep links during onboarding
        if showOnboarding {
            switch route {
            case .paywall, .event:
                break // allow these during onboarding
            default:
                return // block tab/sheet navigation during onboarding
            }
        }
        
        // Dismiss any open sheets first to avoid presentation conflicts
        dismissAllSheets()
        
        switch route {
        case .tab(let tab):
            selectedTab = tab
            
        case .coach(let message):
            selectedTab = .coach
            if let message, !message.isEmpty {
                pendingCoachMessage = message
            }
            
        case .craving:
            selectedTab = .dashboard
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showCravingSheet = true
            }
            
        case .newJournal:
            selectedTab = .journal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showJournalSheet = true
            }
            
        case .settings:
            showSettings = true
            
        case .paywall:
            showPaywall = true
            
        case .event(let name, let params):
            pendingEvent = (name: name, params: params)
            handleEvent(name: name, params: params)
            
        case .unknown:
            break
        }
    }
    
    private func dismissAllSheets() {
        showCravingSheet = false
        showJournalSheet = false
        showSettings = false
        // Don't dismiss paywall — that's intentional
    }
    
    /// Handle known named events. Add new event handlers here as needed.
    private func handleEvent(name: String, params: [String: String]) {
        switch name {
        case "show_paywall":
            showPaywall = true
            
        case "log_craving":
            selectedTab = .dashboard
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showCravingSheet = true
            }
            
        case "new_journal":
            selectedTab = .journal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showJournalSheet = true
            }
            
        case "open_coach":
            selectedTab = .coach
            if let message = params["message"], !message.isEmpty {
                pendingCoachMessage = message
            }
            
        case "open_settings":
            showSettings = true
            
        default:
            // Unknown event — pendingEvent is already set, views can observe it
            break
        }
    }
}

// MARK: - App Tab

enum AppTab: String, CaseIterable, Identifiable {
    case dashboard
    case coach
    case journal
    case milestones
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .coach: return "Coach"
        case .journal: return "Journal"
        case .milestones: return "Milestones"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .coach: return "brain.head.profile"
        case .journal: return "book.fill"
        case .milestones: return "trophy.fill"
        }
    }
}
