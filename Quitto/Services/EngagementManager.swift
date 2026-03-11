//
//  EngagementManager.swift
//  Quitto
//

import Foundation
import StoreKit
import UIKit

@MainActor
@Observable
final class EngagementManager {
    
    // MARK: - Published State (for driving alerts in SwiftUI)
    
    var showTikTokCTAForActions: Bool = false
    var showTikTokCTAForChurn: Bool = false
    
    // MARK: - Private Persistence Keys
    
    private enum Keys {
        static let totalSuccessfulActions = "engagement_total_successful_actions"
        static let hasShownReviewThisVersion = "engagement_review_shown_version"
        static let lastTikTokCTADate = "engagement_last_tiktok_cta_date"
        static let hasEverShownTikTokCTA = "engagement_has_shown_tiktok_cta"
        static let sessionActionsAtLastReview = "engagement_actions_at_last_review"
        static let sessionActionsAtLastTikTok = "engagement_actions_at_last_tiktok"
    }
    
    // MARK: - Thresholds (randomized within range at init for natural feel)
    
    private let reviewThreshold: Int
    private let tiktokThreshold: Int
    private let churnDelay: TimeInterval
    
    // MARK: - Churn Timer
    
    private var churnTimer: Task<Void, Never>?
    
    // MARK: - Init
    
    init() {
        self.reviewThreshold = Int.random(in: 1...AppConstants.Engagement.reviewActionThreshold)
        self.tiktokThreshold = Int.random(in: 2...AppConstants.Engagement.tiktokActionThreshold)
        self.churnDelay = TimeInterval.random(
            in: AppConstants.Engagement.paywallChurnDelayMin...AppConstants.Engagement.paywallChurnDelayMax
        )
    }
    
    // MARK: - Successful Action Tracking
    
    /// Call this after every successful user action (craving logged without relapse, journal entry, AI message, milestone unlocked).
    func recordSuccessfulAction() {
        let defaults = UserDefaults.standard
        let totalActions = defaults.integer(forKey: Keys.totalSuccessfulActions) + 1
        defaults.set(totalActions, forKey: Keys.totalSuccessfulActions)
        
        checkReviewTrigger(totalActions: totalActions)
        checkTikTokActionTrigger(totalActions: totalActions)
    }
    
    // MARK: - SKStoreReview Logic
    
    /// Fires after 1-2 successful actions. Respects Apple's built-in throttling but we also guard on our side.
    private func checkReviewTrigger(totalActions: Int) {
        let defaults = UserDefaults.standard
        let actionsAtLastReview = defaults.integer(forKey: Keys.sessionActionsAtLastReview)
        
        let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let reviewedVersion = defaults.string(forKey: Keys.hasShownReviewThisVersion) ?? ""
        
        let actionsSinceLastReview = totalActions - actionsAtLastReview
        
        let isFirstReview = actionsAtLastReview == 0
        let isNewVersion = reviewedVersion != currentAppVersion
        let reachedRepeatThreshold = actionsSinceLastReview >= 15
        
        if isFirstReview && totalActions >= reviewThreshold {
            requestStoreReview()
            defaults.set(totalActions, forKey: Keys.sessionActionsAtLastReview)
            defaults.set(currentAppVersion, forKey: Keys.hasShownReviewThisVersion)
        } else if isNewVersion && actionsSinceLastReview >= 5 {
            requestStoreReview()
            defaults.set(totalActions, forKey: Keys.sessionActionsAtLastReview)
            defaults.set(currentAppVersion, forKey: Keys.hasShownReviewThisVersion)
        } else if reachedRepeatThreshold {
            requestStoreReview()
            defaults.set(totalActions, forKey: Keys.sessionActionsAtLastReview)
            defaults.set(currentAppVersion, forKey: Keys.hasShownReviewThisVersion)
        }
    }
    
    private func requestStoreReview() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
        else { return }
        
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    // MARK: - TikTok CTA After Successful Actions
    
    private func checkTikTokActionTrigger(totalActions: Int) {
        let defaults = UserDefaults.standard
        let actionsAtLastCTA = defaults.integer(forKey: Keys.sessionActionsAtLastTikTok)
        
        guard canShowTikTokCTA() else { return }
        
        let actionsSinceLastCTA = totalActions - actionsAtLastCTA
        let isFirstTime = !defaults.bool(forKey: Keys.hasEverShownTikTokCTA)
        
        if isFirstTime && totalActions >= tiktokThreshold {
            showTikTokCTAForActions = true
            markTikTokCTAShown(totalActions: totalActions)
        } else if actionsSinceLastCTA >= 20 {
            showTikTokCTAForActions = true
            markTikTokCTAShown(totalActions: totalActions)
        }
    }
    
    private func markTikTokCTAShown(totalActions: Int) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Keys.hasEverShownTikTokCTA)
        defaults.set(Date(), forKey: Keys.lastTikTokCTADate)
        defaults.set(totalActions, forKey: Keys.sessionActionsAtLastTikTok)
    }
    
    /// Respects the cooldown period so we don't spam the user.
    private func canShowTikTokCTA() -> Bool {
        let defaults = UserDefaults.standard
        guard let lastDate = defaults.object(forKey: Keys.lastTikTokCTADate) as? Date else {
            return true
        }
        let daysSince = Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day ?? 0
        return daysSince >= AppConstants.Engagement.tiktokCTACooldownDays
    }
    
    // MARK: - Paywall Churn Detection
    
    /// Call when the user lands on the paywall. Starts a timer; if they don't subscribe within `churnDelay`, fires the TikTok CTA.
    func startPaywallChurnTimer() {
        cancelPaywallChurnTimer()
        
        guard canShowTikTokCTA() else { return }
        
        churnTimer = Task { [churnDelay] in
            try? await Task.sleep(for: .seconds(churnDelay))
            
            guard !Task.isCancelled else { return }
            
            showTikTokCTAForChurn = true
            
            let defaults = UserDefaults.standard
            let totalActions = defaults.integer(forKey: Keys.totalSuccessfulActions)
            markTikTokCTAShown(totalActions: totalActions)
        }
    }
    
    /// Call when the user subscribes or leaves the paywall.
    func cancelPaywallChurnTimer() {
        churnTimer?.cancel()
        churnTimer = nil
    }
    
    // MARK: - Open TikTok
    
    func openTikTok() {
        guard let url = URL(string: AppConstants.Social.tiktokURL) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Settings: direct trigger (always available, no cooldown)
    
    func showTikTokFromSettings() {
        openTikTok()
    }
}
