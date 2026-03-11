# PROJECT STATE

## Phase 1: Setup & Config
- [x] SwiftData schema (Habit, CravingLog, Milestone, JournalEntry, UserProfile, CoachMessage)
- [x] ModelContainer configuration in QuittoApp.swift
- [x] App Group (group.com.quitto.shared) for widget data sharing
- [x] HealthKit entitlement + Info.plist privacy description
- [x] Push notification entitlement (aps-environment: production)
- [x] URL scheme (quitto://) for deep linking
- [x] RevenueCat SDK integration with PurchaseService actor
- [x] AppConstants centralized configuration

## Phase 2: Core Data Models
- [x] Habit model with computed properties (daysSinceQuit, moneySaved, streakDays, etc.)
- [x] HabitType enum with 11 habit categories + display properties + financial tracking
- [x] CravingLog model with triggers, intensity, coping strategies
- [x] Milestone model with templates + BadgeView
- [x] JournalEntry model with mood tracking + journal prompts
- [x] UserProfile model with settings + CoachMessage model
- [x] RecoveryPhase system (smoking, alcohol, general phases)
- [x] Recovery timeline data (RecoveryTimeline.swift)
- [x] HabitSpecificData with motivational facts
- [x] Achievement system (Achievement.swift)
- [x] HabitCoachContent with notification message templates

## Phase 3: Onboarding & Paywall
- [x] 6-step onboarding flow (Welcome -> Name -> Habit Selection -> Details -> Motivation -> Paywall)
- [x] Enhanced habit type cards with mode-aware theming
- [x] Motivation multi-select with custom "Other" option
- [x] PaywallView with social proof, testimonials, dynamic plan cards
- [x] RevenueCat package display with savings %, trial text, monthly price
- [x] Tappable Terms & Privacy links on paywall (Apple requirement)
- [x] Paywall error display via store.paywallError
- [x] Robust purchase error handling (cancellation silencing)
- [x] Restore purchases with premium verification
- [x] Continue Free flow
- [x] Paywall churn timer -> TikTok CTA

## Phase 4: AI Coach (GPT-5.2 Streaming)
- [x] AICoachService actor with real OpenAI GPT-5.2 integration
- [x] Chunked SSE streaming via URLSession.bytes(for:)
- [x] AsyncStream<AIStreamEvent> for token-by-token delivery
- [x] No maxTokens or temperature parameters (per GPT-5.2 API)
- [x] stream: true in request body
- [x] SSE parsing (data: prefix, [DONE] termination, delta.content extraction)
- [x] Local fallback responses for offline/no-API-key scenarios
- [x] AppStore.sendAIMessage() with live streaming UI updates
- [x] AppStore.sendAIMessageBackground() for non-streaming auto-messages
- [x] CoachView with real-time streaming text display
- [x] MessageBubble with overrideContent for streaming
- [x] Graceful markdown parsing during partial streaming
- [x] Typing indicator -> streaming text transition
- [x] Input disabled during streaming
- [x] Quick action menu (craving, progress, motivation, stress)
- [x] System prompt with user context (habit type, days, streak, money, motivation, phase)

## Phase 5: Dashboard & Views
- [x] MainTabView with 4 tabs (Dashboard, Coach, Journal, Milestones)
- [x] DashboardView with habit-specific dashboards (11 types)
- [x] InsightsView with craving analysis
- [x] JournalView + NewJournalEntrySheet
- [x] MilestonesView with badge system
- [x] SettingsView with profile, notifications, AI config, data management, community
- [x] Emergency intervention sheet with breathing exercises

## Phase 6: Services
- [x] AICoachService - OpenAI GPT-5.2 streaming
- [x] AnalyticsService - craving/mood analysis, risk prediction
- [x] EngagementManager - SKStoreReview + TikTok CTA system
- [x] HealthKitService - heart rate + blood oxygen from Apple Health
- [x] NotificationService - morning/evening/milestone/craving notifications
- [x] PurchaseService - RevenueCat integration
- [x] WidgetService - shared UserDefaults -> WidgetKit

## Phase 7: Widget
- [x] QuittoWidget with small/medium/large sizes
- [x] Timeline provider reading from shared UserDefaults
- [x] Real-time days calculation from stored quit date
- [x] Dynamic money saved calculation
- [x] App Group entitlements on widget target

## Phase 8: Siri & Shortcuts
- [x] CheckProgressIntent with real data from shared defaults
- [x] LogCravingIntent with trigger entity
- [x] GetMotivationIntent with randomized messages
- [x] QuittoShortcuts provider with phrases

## Phase 9: Engagement & Monetization
- [x] SKStoreReview after 1-2 actions, then every 15 or on new version after 5
- [x] TikTok CTA after 2-3 actions, then every 20 with 7-day cooldown
- [x] Paywall churn timer (10-15s) -> TikTok CTA
- [x] Settings community section with TikTok follow button
- [x] 3 different alert framings for different contexts

## Phase 10: Premium Feature Gating (Monetization Fix)
- [x] AppStore: showPaywall navigation state for in-app paywall triggering
- [x] AppStore: purchasePackage() / restorePurchases() centralized methods
- [x] AppStore: isPurchaseInProgress flag for CTA loading state
- [x] PremiumGateView: reusable upgrade prompt with feature-specific icons, descriptions, highlights
- [x] PremiumFeature enum: .aiCoach, .journal, .cravingTracker, .insights
- [x] CoachView: entire tab gated behind isPremiumUnlocked → PremiumGateView
- [x] JournalView: entire tab gated behind isPremiumUnlocked → PremiumGateView
- [x] DashboardView: craving sheet gated via .onChange → redirect to paywall
- [x] DashboardView: journal sheet gated via .onChange → redirect to paywall
- [x] MainTabView: store.showJournalSheet gated via .onChange → redirect to paywall
- [x] MainTabView: paywall sheet with in-app purchase handling + interactiveDismissDisabled
- [x] MainTabView: load offerings on appear so packages ready for in-app paywall
- [x] SettingsView: "Upgrade to Premium" section with crown icon + Restore Purchases (free users only)
- [x] PaywallView: isOnboarding parameter (default true) for context-aware behavior
- [x] PaywallView: "Continue Free" (onboarding) vs "Not Now" (in-app) button text
- [x] PaywallView: churn timer only starts during onboarding
- [x] PaywallView: uses store.isPurchaseInProgress instead of local state (fixes cancel stuck bug)
- [x] OnboardingView: purchase/restore handlers set isPurchaseInProgress + clear paywallError
- [x] All 11 habit-specific dashboards gated via DashboardView binding chain
- [x] Deep linking to gated tabs shows PremiumGateView (view-level gating)
- [x] Free tier: Dashboard (basic stats), Milestones, Emergency SOS
- [x] Premium tier: AI Coach, Journal, Craving Tracker, Insights

## Phase 11: Production Readiness
- [x] aps-environment: production (was development)
- [x] Dummy API key removed from AppConstants
- [x] All defaultAPIKey references cleaned up
- [x] Privacy/Terms URLs updated (precisionapps.github.io/Quitto/*)
- [x] PaywallView Terms/Privacy as tappable links
- [x] Settings version string dynamic from bundle
- [x] Delete All Data -> clears widgets + triggers onboarding
- [x] AI Coach settings footer updated for production
- [x] No print/debugPrint/NSLog statements
- [x] No example.com or localhost references
- [x] RevenueCat test key marked with production replacement warning
- [x] PurchaseService log level: .warn (production-appropriate)
- [x] Robust purchase error handling with cancellation detection
- [x] Restore flow verifies premium status before completing onboarding

## Phase 11: App Store Connect Metadata
- [x] App name, subtitle, promotional text
- [x] Full description (no emojis, no special characters)
- [x] Keywords (100 chars)
- [x] Support/Marketing/Privacy URLs
- [x] Category: Health & Fitness / Lifestyle
- [x] Age rating: 17+
- [x] What's New text for 1.0.0

## Phase 12: Medical Citations & Guideline 1.4.1 Compliance
- [x] MedicalSources.swift — central citation database (24 sources: AHA, CDC, NIDA, NIAAA, WHO, APA, ALA, FDA, etc.)
- [x] HealthMilestone struct — added `source: String` property + citations for all 19 milestones
- [x] RecoveryMilestone struct — added `sources: [String]` property + citations for all ~90 milestones (11 habit types)
- [x] MotivationalFact struct — added `source: String` property + citations for all 79 facts (11 habit types)
- [x] AICoachService.buildSystemPrompt — citation requirement + disclaimer instruction
- [x] AICoachService local fallback responses — inline citations (NIDA, Harvard Health, APA)
- [x] HabitCoachContent.systemPrompt — citation requirement + disclaimer for all habit-specific prompts
- [x] MedicalDisclaimerBanner — reusable compact/full disclaimer component
- [x] SourceAttributionLabel — inline source label component
- [x] SourcesFooterLink — tappable "View Sources" button with sheet
- [x] SourcesSheetView — full sources display with disclaimer, per-habit sources, general sources, tappable URLs
- [x] CoachView — medical disclaimer banner at top of chat + book icon sources button in toolbar
- [x] InsightsView — "View Sources" link in health timeline header + MedicalDisclaimerBanner below timeline
- [x] HealthMilestoneRow — SourceAttributionLabel per milestone
- [x] DashboardComponents MilestoneRow — source attribution + MedicalDisclaimerBanner below health benefits
- [x] MotivationalFactCard — SourceAttributionLabel per fact
- [x] SettingsView — "Sources & Citations" NavigationLink in About section + medical footer disclaimer
- [x] SettingsView/PaywallView URLs — updated to precisionapps.github.io/Quitto/privacy.html and /terms.html
- [x] MainTabView — tab bar hidden when Coach tab selected with .easeInOut animation
- [x] PrivacyPolicy.md — comprehensive Quitto privacy policy with health disclaimer
- [x] TermsOfUse.md — comprehensive terms with medical disclaimers, AI Coach disclaimer, assumption of risk
- [x] app-support-template/index.html — full rewrite for Quitto with sources section, FAQ, crisis resources
- [x] app-support-template/privacy.html — full rewrite for Quitto
- [x] app-support-template/terms.html — full rewrite for Quitto
- [x] app-support-template/404.html — updated for Quitto branding
- [x] app-support-template/sitemap.xml — updated URLs to precisionapps.github.io/Quitto
- [x] app-support-template/README.md — updated for Quitto

---

## CURRENT CONTEXT
* Last file touched: project_status.md
* Current Status: Production-Ready (Guideline 1.4.1 citations integrated)
* Next immediate action: Build verification in Xcode, then host support pages at precisionapps.github.io/Quitto

## PRE-SUBMISSION CHECKLIST (Manual Steps)
- [ ] Replace RevenueCat test API key with production Apple API key in AppConstants.swift
- [ ] Host privacy policy at https://precisionapps.github.io/Quitto/privacy.html
- [ ] Host terms of service at https://precisionapps.github.io/Quitto/terms.html
- [ ] Host support page at https://precisionapps.github.io/Quitto/
- [ ] Configure RevenueCat products/offerings in dashboard
- [ ] Set up App Store Connect with metadata from AppStoreDescription.md
- [ ] Add screenshots for all required device sizes
- [ ] Enable HealthKit capability in Xcode signing
- [ ] Enable Push Notifications capability in Xcode signing
- [ ] Enable App Groups capability in Xcode signing
- [ ] Archive and upload to App Store Connect
- [ ] Submit for review
