//
//  PaywallView.swift
//  Quitto
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    let userName: String
    let habitType: HabitType?
    let packages: [Package]
    let onPurchase: (Package) -> Void
    let onRestore: () -> Void
    let onContinueFree: () -> Void
    var isOnboarding: Bool = true
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppStore.self) private var store
    @State private var selectedPackageID: String = ""
    @State private var showChurnTikTokAlert = false
    
    var body: some View {
        ZStack {
            backgroundLayer
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    headerSection
                        .padding(.top, Theme.Spacing.xl)
                    
                    socialProofSection
                    
                    plansSection
                    
                    featuresSection
                    
                    Spacer(minLength: 140)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            VStack {
                Spacer()
                ctaSection
            }
        }
        .onAppear {
            if isOnboarding {
                store.engagementManager.startPaywallChurnTimer()
            }
        }
        .onDisappear {
            store.engagementManager.cancelPaywallChurnTimer()
        }
        .alert(
            "You're Not Alone \u{1F49C}",
            isPresented: $showChurnTikTokAlert
        ) {
            Button("Follow on TikTok") {
                store.engagementManager.openTikTok()
            }
            Button("Not Now", role: .cancel) { }
        } message: {
            Text("Thousands are quitting together. Get daily motivation, real stories, and tips from our community on TikTok!")
        }
        .onChange(of: store.engagementManager.showTikTokCTAForChurn) { _, newValue in
            if newValue {
                showChurnTikTokAlert = true
                store.engagementManager.showTikTokCTAForChurn = false
            }
        }
    }
    
    // MARK: - Background
    
    private var backgroundLayer: some View {
        ZStack {
            if colorScheme == .dark {
                Color.surfaceDark
            } else {
                LinearGradient(
                    colors: [
                        Color(hue: 160, saturation: 15, lightness: 96),
                        Color(hue: 165, saturation: 20, lightness: 92)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Decorative accent orbs
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.accent.opacity(0.25),
                            Color.accent.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: -100, y: -150)
                .blur(radius: 40)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.warmth.opacity(0.15),
                            Color.warmth.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: 150, y: 200)
                .blur(radius: 30)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(LinearGradient.accentGradient)
                
                Text("Quitto")
                    .font(.displaySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text("Join thousands who already quit for good")
                .font(.bodyMedium)
                .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Social Proof
    
    private var socialProofSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            // Star rating bar
            VStack(spacing: Theme.Spacing.xs) {
                HStack(spacing: 4) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.warmth)
                    }
                }
                
                Text("4.9 average from 2,400+ ratings")
                    .font(.labelMedium)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(.vertical, Theme.Spacing.sm)
            
            // Testimonial cards
            VStack(spacing: Theme.Spacing.sm) {
                TestimonialCard(
                    quote: "47 days smoke-free. The craving tracker actually helped me understand my triggers.",
                    name: "Marcus T.",
                    detail: "Quit smoking",
                    colorScheme: colorScheme
                )
                
                TestimonialCard(
                    quote: "The AI coach talked me out of relapsing at 2am. Worth every penny.",
                    name: "Sarah K.",
                    detail: "Quit alcohol",
                    colorScheme: colorScheme
                )
                
                TestimonialCard(
                    quote: "Seeing my body actually healing day by day kept me going.",
                    name: "David R.",
                    detail: "Quit vaping",
                    colorScheme: colorScheme
                )
            }
            
            // User count pill
            HStack(spacing: Theme.Spacing.sm) {
                HStack(spacing: -6) {
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(
                                [Color.accent, Color.warmth, Color.calm, Color(hue: 280, saturation: 30, lightness: 52)][i]
                            )
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle().stroke(colorScheme == .dark ? Color.surfaceDark : Color.surfaceElevated, lineWidth: 2)
                            )
                    }
                }
                
                Text("12,000+ people quitting right now")
                    .font(.labelMedium)
                    .fontWeight(.medium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            .padding(.vertical, Theme.Spacing.sm)
        }
    }
    
    // MARK: - Features
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Everything you get")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                .padding(.horizontal, Theme.Spacing.sm)
            
            VStack(spacing: Theme.Spacing.sm) {
                PaywallFeatureRow(
                    icon: "brain.head.profile",
                    title: "AI Recovery Coach",
                    description: "24/7 personal coach that learns your triggers",
                    color: Color.accent
                )
                
                PaywallFeatureRow(
                    icon: "heart.text.clipboard",
                    title: "Body Recovery Timeline",
                    description: "Watch your body heal with science-backed milestones",
                    color: Color.calm
                )
                
                PaywallFeatureRow(
                    icon: "waveform.path.ecg",
                    title: "Craving Tracker & Analysis",
                    description: "Log triggers, see patterns, beat cravings faster",
                    color: Color.warmth
                )
                
                PaywallFeatureRow(
                    icon: "book.closed.fill",
                    title: "Recovery Journal",
                    description: "Mood tracking and guided reflection prompts",
                    color: Color(hue: 280, saturation: 30, lightness: 52)
                )
                
                PaywallFeatureRow(
                    icon: "exclamationmark.shield.fill",
                    title: "Emergency SOS Mode",
                    description: "Breathing exercises and coping tools when cravings hit",
                    color: Color(hue: 0, saturation: 30, lightness: 52)
                )
                
                PaywallFeatureRow(
                    icon: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90",
                    title: "Money & Time Saved",
                    description: "See exactly what quitting is saving you",
                    color: Color(hue: 140, saturation: 30, lightness: 48)
                )
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary.opacity(0.5) : Color.surfaceElevated.opacity(0.6))
        )
    }
    
    // MARK: - Plans
    
    private var plansSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            if packages.isEmpty {
                VStack(spacing: Theme.Spacing.sm) {
                    ProgressView()
                        .tint(Color.accent)
                    Text("Loading plans...")
                        .font(.bodySmall)
                        .foregroundStyle(Color.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.xl)
            } else {
                ForEach(packages, id: \.identifier) { package in
                    DynamicPlanCard(
                        package: package,
                        allPackages: packages,
                        isSelected: selectedPackageID == package.identifier,
                        onSelect: { selectedPackageID = package.identifier }
                    )
                }
            }
        }
        .task(id: packages.count) {
            autoSelectBestPackage()
        }
    }
    
    // MARK: - Helper Methods
    
    private var selectedPackage: Package? {
        packages.first { $0.identifier == selectedPackageID }
    }
    
    private var ctaButtonTitle: String {
        if store.isPurchaseInProgress { return "Processing..." }
        if let pkg = selectedPackage,
           pkg.storeProduct.introductoryDiscount?.paymentMode == .freeTrial {
            return "Start Free Trial"
        }
        return "Subscribe"
    }
    
    private func autoSelectBestPackage() {
        if selectedPackageID.isEmpty || !packages.contains(where: { $0.identifier == selectedPackageID }) {
            selectedPackageID = packages.first?.identifier ?? ""
        }
    }
    
    // MARK: - CTA Section
    
    private var ctaSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            PrimaryButton(
                ctaButtonTitle,
                icon: store.isPurchaseInProgress ? nil : "sparkles",
                isLoading: store.isPurchaseInProgress
            ) {
                guard let pkg = selectedPackage else { return }
                guard !store.isPurchaseInProgress else { return }
                store.engagementManager.cancelPaywallChurnTimer()
                onPurchase(pkg)
            }
            
            HStack(spacing: Theme.Spacing.lg) {
                Button {
                    store.engagementManager.cancelPaywallChurnTimer()
                    onContinueFree()
                } label: {
                    Text(isOnboarding ? "Continue Free" : "Not Now")
                        .font(.bodySmall)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textSecondary)
                }
                
                Button {
                    store.engagementManager.cancelPaywallChurnTimer()
                    onRestore()
                } label: {
                    Text("Restore Purchases")
                        .font(.bodySmall)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            //WHY THE FUCK DID YOU EVEN PUT IT HERE
//            if let error = store.paywallError {
//                Text(error)
//                    .font(.labelMedium)
//                    .foregroundStyle(Color.alert)
//                    .multilineTextAlignment(.center)
//            }
            
            HStack(spacing: 4) {
                Text("Cancel anytime.")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                
                Link("Terms", destination: URL(string: "https://precisionapps.github.io/Quitto/terms.html")!)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
                
                Text("&")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                
                Link("Privacy", destination: URL(string: "https://precisionapps.github.io/Quitto/privacy.html")!)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.horizontal, Theme.Spacing.xl)
        .padding(.top, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.lg)
        .background(
            ctaBackground
        )
        .padding(.bottom, Theme.Spacing.lg)
    }
    
    private var ctaBackground: some View {
        Group {
            if #available(iOS 26, *) {
                Rectangle()
                    .fill(.clear)
                    .glassEffect()
                    .ignoresSafeArea(edges: .bottom)
            } else {
                LinearGradient(
                    colors: [
                        (colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary).opacity(0),
                        (colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

// MARK: - Feature Row

struct PaywallFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color.accent)
        }
    }
}

// MARK: - Testimonial Card

struct TestimonialCard: View {
    let quote: String
    let name: String
    let detail: String
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("\"\(quote)\"")
                .font(.bodySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                .italic()
                .lineSpacing(2)
            
            HStack(spacing: Theme.Spacing.sm) {
                Circle()
                    .fill(Color.accent.opacity(0.2))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Text(String(name.prefix(1)))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.accent)
                    )
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(name)
                        .font(.labelMedium)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text(detail)
                        .font(.system(size: 10))
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(Color.warmth)
                    }
                }
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
    }
}

// MARK: - Dynamic Plan Card

struct DynamicPlanCard: View {
    let package: Package
    let allPackages: [Package]
    let isSelected: Bool
    let onSelect: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Theme.Spacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: Theme.Spacing.sm) {
                        Text(package.displayTitle)
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        if let savings = package.savingsPercentage(comparedTo: allPackages) {
                            Text("SAVE \(savings)%")
                                .font(.labelSmall)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Theme.Spacing.sm)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(LinearGradient.warmthGradient)
                                )
                        }
                    }
                    
                    if let trial = package.trialText {
                        Text(trial)
                            .font(.bodySmall)
                            .foregroundStyle(Color.accent)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(package.storeProduct.localizedPriceString)
                        .font(.titleMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text(package.formattedMonthlyPrice)
                        .font(.labelSmall)
                        .foregroundStyle(Color.textSecondary)
                }
                
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? Color.accent : Color.textTertiary.opacity(0.5),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                            .stroke(
                                isSelected ? Color.accent : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .modifier(Theme.shadow(isSelected ? .md : .sm))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Package Display Helpers

extension Package {
    
    /// Human-readable title derived from the package type (e.g., "Yearly", "Monthly")
    var displayTitle: String {
        switch packageType {
        case .lifetime: return "Lifetime"
        case .annual: return "Yearly"
        case .sixMonth: return "6 Months"
        case .threeMonth: return "3 Months"
        case .twoMonth: return "2 Months"
        case .monthly: return "Monthly"
        case .weekly: return "Weekly"
        default: return storeProduct.localizedTitle
        }
    }
    
    /// The number of months this subscription covers (used for per-month price calculation)
    var monthsInPeriod: Double {
        guard let period = storeProduct.subscriptionPeriod else { return 0 }
        switch period.unit {
        case .year: return Double(period.value) * 12.0
        case .month: return Double(period.value)
        case .week: return Double(period.value) / 4.33
        case .day: return Double(period.value) / 30.0
        @unknown default: return 1.0
        }
    }
    
    /// Localized per-month price string (e.g., "$2.50/mo"), or "one-time" for lifetime
    var formattedMonthlyPrice: String {
        if packageType == .lifetime || storeProduct.subscriptionPeriod == nil {
            return "one-time payment"
        }
        
        let months = monthsInPeriod
        guard months > 0 else { return storeProduct.localizedPriceString }
        
        // For monthly (or shorter) subscriptions, just show the raw price per period
        if months <= 1.0 + 0.1 {
            if packageType == .weekly {
                return "\(storeProduct.localizedPriceString)/wk"
            }
            return "\(storeProduct.localizedPriceString)/mo"
        }
        
        // For multi-month subscriptions, calculate the monthly equivalent
        let total = NSDecimalNumber(decimal: storeProduct.price).doubleValue
        let monthlyPrice = total / months
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = storeProduct.currencyCode ?? "USD"
        formatter.maximumFractionDigits = 2
        let formatted = formatter.string(from: NSNumber(value: monthlyPrice)) ?? storeProduct.localizedPriceString
        return "\(formatted)/mo"
    }
    
    /// Free trial or intro offer description derived from the product's introductory discount
    var trialText: String? {
        guard let intro = storeProduct.introductoryDiscount else { return nil }
        let period = intro.subscriptionPeriod
        let value = period.value
        
        let unitStr: String
        switch period.unit {
        case .day: unitStr = value == 1 ? "1-day" : "\(value)-day"
        case .week: unitStr = value == 1 ? "1-week" : "\(value)-week"
        case .month: unitStr = value == 1 ? "1-month" : "\(value)-month"
        case .year: unitStr = value == 1 ? "1-year" : "\(value)-year"
        @unknown default: unitStr = ""
        }
        
        switch intro.paymentMode {
        case .freeTrial:
            return "\(unitStr) free trial"
        case .payAsYouGo, .payUpFront:
            return "\(intro.localizedPriceString) for first \(unitStr)"
        @unknown default:
            return nil
        }
    }
    
    /// Calculates the savings percentage compared to the most expensive per-month package
    func savingsPercentage(comparedTo packages: [Package]) -> Int? {
        guard packages.count > 1 else { return nil }
        let months = monthsInPeriod
        guard months > 0 else { return nil }
        
        let myMonthly = NSDecimalNumber(decimal: storeProduct.price).doubleValue / months
        
        let monthlyPrices: [Double] = packages.compactMap { pkg in
            let m = pkg.monthsInPeriod
            guard m > 0 else { return nil }
            return NSDecimalNumber(decimal: pkg.storeProduct.price).doubleValue / m
        }
        
        guard let maxMonthly = monthlyPrices.max(), myMonthly < maxMonthly else { return nil }
        
        let savings = Int(((maxMonthly - myMonthly) / maxMonthly) * 100)
        return savings >= 5 ? savings : nil
    }
}

// MARK: - PackageType Sort Order

extension PackageType {
    /// Sort order for displaying packages (best value first: lifetime -> annual -> monthly -> weekly)
    var sortOrder: Int {
        switch self {
        case .lifetime: return 0
        case .annual: return 1
        case .sixMonth: return 2
        case .threeMonth: return 3
        case .twoMonth: return 4
        case .monthly: return 5
        case .weekly: return 6
        default: return 7
        }
    }
}
