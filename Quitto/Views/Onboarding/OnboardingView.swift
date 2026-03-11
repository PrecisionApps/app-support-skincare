//
//  OnboardingView.swift
//  Quitto
//

import SwiftUI
import RevenueCat

struct OnboardingView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var currentStep: OnboardingStep = .welcome
    @State private var userName: String = ""
    @State private var selectedHabitType: HabitType?
    @State private var customHabitName: String = ""
    @State private var dailyAmount: Int = 10
    @State private var motivation: String = ""
    @State private var selectedMotivations: Set<String> = []
    @State private var customMotivation: String = ""
    @State private var quitDate: Date = Date()
    @State private var isCompletingOnboarding = false
    
    @FocusState private var focusedField: OnboardingField?
    
    enum OnboardingField {
        case name, customHabit, otherMotivation
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .onTapGesture {
                    focusedField = nil
                }
            
            VStack(spacing: 0) {
                progressIndicator
                    .padding(.top, Theme.Spacing.lg)
                
                TabView(selection: $currentStep) {
                    welcomeStep
                        .tag(OnboardingStep.welcome)
                    
                    nameStep
                        .tag(OnboardingStep.name)
                    
                    habitSelectionStep
                        .tag(OnboardingStep.habitSelection)
                    
                    detailsStep
                        .tag(OnboardingStep.details)
                    
                    motivationStep
                        .tag(OnboardingStep.motivation)
                    
                    paywallStep
                        .tag(OnboardingStep.paywall)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(Theme.Animation.default, value: currentStep)
            }
        }
        .ignoresSafeArea()
        .onChange(of: currentStep) { _, _ in
            focusedField = nil
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        ZStack {
            if colorScheme == .dark {
                Color.surfaceDark
            } else {
                LinearGradient(
                    colors: [
                        Color(hue: 160, saturation: 30, lightness: 95),
                        Color(hue: 170, saturation: 25, lightness: 92)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Decorative circles
            Circle()
                .fill(Color.accent.opacity(0.08))
                .frame(width: 400, height: 400)
                .offset(x: -150, y: -200)
                .blur(radius: 60)
            
            Circle()
                .fill(Color.warmth.opacity(0.08))
                .frame(width: 300, height: 300)
                .offset(x: 150, y: 300)
                .blur(radius: 50)
        }
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        HStack(spacing: Theme.Spacing.sm) {
            ForEach(OnboardingStep.allCases, id: \.self) { step in
                Capsule()
                    .fill(
                        step.rawValue <= currentStep.rawValue
                            ? Color.accent
                            : Color.textTertiary.opacity(0.3)
                    )
                    .frame(width: step == currentStep ? 24 : 8, height: 8)
                    .animation(Theme.Animation.bouncy, value: currentStep)
            }
        }
        .padding(.horizontal, Theme.Spacing.xl)
    }
    
    // MARK: - Welcome Step
    
    private var welcomeStep: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(LinearGradient.accentGradient)
                    .frame(width: 140, height: 140)
                    .modifier(Theme.shadow(.glow))
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: Theme.Spacing.md) {
                Text("Welcome to Quitto")
                    .font(.displayMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text("Your personal companion for breaking free from harmful habits. Let's start your journey together.")
                    .font(.bodyLarge)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }
            
            Spacer()
            
            PrimaryButton("Let's Begin", icon: "arrow.right") {
                withAnimation {
                    currentStep = .name
                }
            }
            .padding(.horizontal, Theme.Spacing.xl)
            .padding(.bottom, Theme.Spacing.xxxl)
        }
    }
    
    // MARK: - Name Step
    
    private var nameStep: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            VStack(spacing: Theme.Spacing.lg) {
                Image(systemName: "person.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(LinearGradient.accentGradient)
                
                Text("What should I call you?")
                    .font(.displaySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                TextField("", text: $userName, prompt: Text("Your name").foregroundStyle(Color.textTertiary))
                    .font(.titleLarge)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    )
                    .padding(.horizontal, Theme.Spacing.xl)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.continue)
                    .onSubmit {
                        if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
                            focusedField = nil
                            withAnimation {
                                currentStep = .habitSelection
                            }
                        }
                    }
            }
            
            Spacer()
            
            VStack(spacing: Theme.Spacing.md) {
                PrimaryButton("Continue", icon: "arrow.right") {
                    focusedField = nil
                    withAnimation {
                        currentStep = .habitSelection
                    }
                }
                .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)
                
                GhostButton("Skip") {
                    focusedField = nil
                    userName = "Friend"
                    withAnimation {
                        currentStep = .habitSelection
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.xl)
            .padding(.bottom, Theme.Spacing.xxxl)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .name
            }
        }
    }
    
    // MARK: - Habit Selection Step
    
    private var habitSelectionStep: some View {
        VStack(spacing: Theme.Spacing.lg) {
            VStack(spacing: Theme.Spacing.sm) {
                Text("What do you want to quit?")
                    .font(.displaySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text("Each mode has a specialized recovery experience")
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
            }
            .padding(.top, Theme.Spacing.xl)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
                    ForEach(HabitType.allCases) { type in
                        EnhancedHabitTypeCard(
                            type: type,
                            isSelected: selectedHabitType == type
                        ) {
                            withAnimation(Theme.Animation.snappy) {
                                selectedHabitType = type
                                customHabitName = type.displayName
                                dailyAmount = type.defaultDailyAmount
                                HapticFeedback.impact(.medium)
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xl)
            }
            
            // Selected habit mode preview card
            if let type = selectedHabitType {
                let theme = HabitModeTheme.theme(for: type)
                
                HStack(spacing: Theme.Spacing.md) {
                    ModeHeroIllustration(habitType: type, size: 56)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(theme.modeTitle)
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        Text(theme.modeSubtitle)
                            .font(.labelSmall)
                            .foregroundStyle(theme.glowColor)
                        
                        Text(theme.modeSpecificTerms.heroLabel)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [theme.neonAccent, theme.glowColor],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    
                    Spacer()
                }
                .padding(Theme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .fill(theme.glowColor.opacity(colorScheme == .dark ? 0.1 : 0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [theme.glowColor.opacity(0.4), theme.glowColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .padding(.horizontal, Theme.Spacing.xl)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            
            PrimaryButton("Continue") {
                focusedField = nil
                if let type = selectedHabitType {
                    customHabitName = type.displayName
                    dailyAmount = type.defaultDailyAmount
                }
                withAnimation {
                    currentStep = .details
                }
            }
            .disabled(selectedHabitType == nil)
            .padding(.horizontal, Theme.Spacing.xl)
            .padding(.bottom, Theme.Spacing.xxxl)
        }
    }
    
    // MARK: - Details Step
    
    private var detailsStep: some View {
        VStack(spacing: 0) {
            VStack(spacing: Theme.Spacing.xs) {
                Text("Your \(selectedHabitType?.displayName ?? "Habit") Profile")
                    .font(.displaySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text("We calculate your savings automatically")
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
            }
            .padding(.top, Theme.Spacing.xl)
            .padding(.bottom, Theme.Spacing.md)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    detailsDailyAmountCard
                    
                    detailsQuitDateCard
                    
                    if let type = selectedHabitType {
                        detailsSavingsPreview(for: type)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.horizontal, Theme.Spacing.xl)
                .padding(.bottom, Theme.Spacing.md)
            }
            
            PrimaryButton("Continue") {
                focusedField = nil
                withAnimation {
                    currentStep = .motivation
                }
            }
            .padding(.horizontal, Theme.Spacing.xl)
            .padding(.bottom, Theme.Spacing.xxxl)
        }
    }
    
    // MARK: - Details Sub-Views
    
    private var detailsDailyAmountCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.xs) {
                Image(systemName: selectedHabitType?.icon ?? "number")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.accent)
                
                Text(detailsAmountLabel)
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            HStack {
                Button {
                    if dailyAmount > 1 {
                        dailyAmount -= 1
                        HapticFeedback.impact(.light)
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color.accent)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("\(dailyAmount)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        .contentTransition(.numericText(value: Double(dailyAmount)))
                        .animation(Theme.Animation.snappy, value: dailyAmount)
                    
                    Text("\(selectedHabitType?.unitNamePlural ?? "units") per day")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
                
                Button {
                    dailyAmount += 1
                    HapticFeedback.impact(.light)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color.accent)
                }
            }
            .padding(.vertical, Theme.Spacing.md)
            .padding(.horizontal, Theme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
            )
        }
    }
    
    private var detailsAmountLabel: String {
        guard let type = selectedHabitType else { return "How many per day?" }
        switch type {
        case .smoking: return "Cigarettes per day"
        case .vaping: return "Puffs per day"
        case .alcohol: return "Drinks per day"
        case .cannabis: return "Times per day"
        case .caffeine: return "Cups per day"
        case .sugar: return "Sugary items per day"
        case .gambling: return "Bets per day"
        case .porn: return "Sessions per day"
        case .socialMedia: return "Hours per day"
        case .gaming: return "Hours per day"
        case .other: return "Times per day"
        }
    }
    
    private var detailsQuitDateCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.xs) {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.accent)
                
                Text("When did you quit?")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            DatePicker(
                "",
                selection: $quitDate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
            )
        }
    }
    
    private func detailsSavingsPreview(for type: HabitType) -> some View {
        let breakdown = type.savingsBreakdown(dailyAmount: dailyAmount)
        let theme = HabitModeTheme.theme(for: type)
        
        return VStack(spacing: 0) {
            // Header: yearly total
            VStack(spacing: Theme.Spacing.xs) {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(theme.glowColor)
                    
                    Text("Your estimated savings")
                        .font(.labelMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    
                    Spacer()
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("$\(Int(breakdown.totalYearly))")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .contentTransition(.numericText(value: breakdown.totalYearly))
                        .animation(Theme.Animation.snappy, value: dailyAmount)
                    
                    Text("/ year")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textTertiary)
                    
                    Spacer()
                }
                
                // Time horizon pills
                HStack(spacing: Theme.Spacing.sm) {
                    savingsTimePill(label: "Daily", amount: breakdown.totalDaily, color: theme.glowColor)
                    savingsTimePill(label: "Weekly", amount: breakdown.totalWeekly, color: theme.glowColor)
                    savingsTimePill(label: "Monthly", amount: breakdown.totalMonthly, color: theme.glowColor)
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.glowColor.opacity(colorScheme == .dark ? 0.12 : 0.06),
                                theme.neonAccent.opacity(colorScheme == .dark ? 0.06 : 0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .stroke(theme.glowColor.opacity(0.15), lineWidth: 1)
            )
            
            // Category breakdown rows
            VStack(spacing: 0) {
                ForEach(Array(breakdown.categories.enumerated()), id: \.element.id) { index, category in
                    savingsCategoryRow(category: category, color: theme.glowColor, isLast: index == breakdown.categories.count - 1)
                }
            }
            .padding(.top, Theme.Spacing.sm)
            
            // Source attribution
            Text("Based on US national averages (CDC, NIH, BLS 2024)")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(Color.textTertiary.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, Theme.Spacing.sm)
        }
    }
    
    private func savingsTimePill(label: String, amount: Double, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("$\(Int(amount))")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                .contentTransition(.numericText(value: amount))
                .animation(Theme.Animation.snappy, value: dailyAmount)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
    }
    
    private func savingsCategoryRow(category: SavingsCategory, color: Color, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.08))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(category.label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text(category.explanation)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text("$\(Int(category.yearlyAmount))")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        .contentTransition(.numericText(value: category.yearlyAmount))
                        .animation(Theme.Animation.snappy, value: dailyAmount)
                    
                    Text("/yr")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.textTertiary)
                }
            }
            .padding(.vertical, Theme.Spacing.sm + 2)
            
            if !isLast {
                Divider()
                    .overlay(Color.textTertiary.opacity(0.15))
            }
        }
    }
    
    // MARK: - Motivation Step
    
    private var motivationStep: some View {
        VStack(spacing: Theme.Spacing.lg) {
            VStack(spacing: Theme.Spacing.sm) {
                Text("Why are you quitting?")
                    .font(.displaySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text("Select all that apply")
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
            }
            .padding(.top, Theme.Spacing.xl)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(motivationOptions, id: \.self) { option in
                        MotivationOptionRow(
                            title: option,
                            isSelected: selectedMotivations.contains(option),
                            colorScheme: colorScheme
                        ) {
                            withAnimation(Theme.Animation.snappy) {
                                if selectedMotivations.contains(option) {
                                    selectedMotivations.remove(option)
                                } else {
                                    selectedMotivations.insert(option)
                                }
                                syncMotivationString()
                                HapticFeedback.impact(.light)
                            }
                        }
                    }
                    
                    // "Other" row with inline text field
                    VStack(spacing: 0) {
                        MotivationOptionRow(
                            title: "Other",
                            isSelected: selectedMotivations.contains("__other__"),
                            colorScheme: colorScheme
                        ) {
                            withAnimation(Theme.Animation.snappy) {
                                if selectedMotivations.contains("__other__") {
                                    selectedMotivations.remove("__other__")
                                    customMotivation = ""
                                    focusedField = nil
                                } else {
                                    selectedMotivations.insert("__other__")
                                    focusedField = .otherMotivation
                                }
                                syncMotivationString()
                                HapticFeedback.impact(.light)
                            }
                        }
                        
                        if selectedMotivations.contains("__other__") {
                            TextField("", text: $customMotivation, prompt: Text("Tell us your reason...").foregroundStyle(Color.textTertiary))
                                .font(.bodyMedium)
                                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                .padding(.horizontal, Theme.Spacing.lg)
                                .padding(.vertical, Theme.Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: Theme.Radius.md)
                                        .fill(colorScheme == .dark ? Color.surfaceDarkTertiary : Color.surfaceSecondary)
                                )
                                .padding(.horizontal, Theme.Spacing.xl)
                                .padding(.top, Theme.Spacing.xs)
                                .focused($focusedField, equals: .otherMotivation)
                                .submitLabel(.done)
                                .onSubmit {
                                    focusedField = nil
                                    syncMotivationString()
                                }
                                .onChange(of: customMotivation) { _, _ in
                                    syncMotivationString()
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.xl)
                .padding(.bottom, Theme.Spacing.md)
            }
            
            VStack(spacing: Theme.Spacing.md) {
                PrimaryButton("Continue") {
                    focusedField = nil
                    withAnimation {
                        currentStep = .paywall
                    }
                }
                .disabled(selectedMotivations.isEmpty)
                
                GhostButton("Skip for now") {
                    focusedField = nil
                    withAnimation {
                        currentStep = .paywall
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.xl)
            .padding(.bottom, Theme.Spacing.xxxl)
        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private var motivationOptions: [String] {
        [
            "For my health",
            "For my family",
            "To save money",
            "To feel in control",
            "To be more productive",
            "To improve my mental health",
            "To be a better parent",
            "For my future self"
        ]
    }
    
    private func syncMotivationString() {
        var parts: [String] = []
        for option in motivationOptions where selectedMotivations.contains(option) {
            parts.append(option)
        }
        if selectedMotivations.contains("__other__"), !customMotivation.trimmingCharacters(in: .whitespaces).isEmpty {
            parts.append(customMotivation.trimmingCharacters(in: .whitespaces))
        }
        motivation = parts.joined(separator: ", ")
    }
    
    // MARK: - Paywall Step
    
    private var paywallStep: some View {
        PaywallView(
            userName: userName,
            habitType: selectedHabitType,
            packages: store.onboardingPackages,
            onPurchase: { package in
                Task {
                    store.isPurchaseInProgress = true
                    defer { store.isPurchaseInProgress = false }
                    do {
                        store.paywallError = nil
                        let result = try await store.purchaseService.purchase(package: package)
                        guard !result.userCancelled else { return }
                        try await store.refreshCustomerInfo()
                        completeOnboarding()
                    } catch {
                        store.paywallError = error.localizedDescription
                    }
                }
            },
            onRestore: {
                Task {
                    store.isPurchaseInProgress = true
                    defer { store.isPurchaseInProgress = false }
                    do {
                        store.paywallError = nil
                        _ = try await store.purchaseService.restore()
                        try await store.refreshCustomerInfo()
                        if store.isPremiumUnlocked {
                            completeOnboarding()
                        } else {
                            store.paywallError = "No active subscription found. Please purchase a plan."
                        }
                    } catch {
                        store.paywallError = error.localizedDescription
                    }
                }
            },
            onContinueFree: {
                completeOnboarding()
            }
        )
    }
    
    // MARK: - Actions
    
    private func completeOnboarding() {
        guard !isCompletingOnboarding else { return }
        guard let habitType = selectedHabitType else { return }
        isCompletingOnboarding = true
        
        let habit = Habit(
            name: habitType == .other ? customHabitName : habitType.displayName,
            type: habitType,
            quitDate: quitDate,
            dailyAmount: dailyAmount,
            costPerUnit: habitType.intelligentCostPerUnit(dailyAmount: dailyAmount),
            motivation: motivation
        )
        
        store.completeOnboarding(name: userName, habit: habit)
    }
}

// MARK: - Onboarding Step

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case name = 1
    case habitSelection = 2
    case details = 3
    case motivation = 4
    case paywall = 5
}

// MARK: - Motivation Option Row

struct MotivationOptionRow: View {
    let title: String
    let isSelected: Bool
    let colorScheme: ColorScheme
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                Text(title)
                    .font(.bodyLarge)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(
                        isSelected
                            ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            : (colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    )
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? Color.accent : Color.textTertiary.opacity(0.4),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.vertical, Theme.Spacing.md + 2)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                            .stroke(
                                isSelected ? Color.accent.opacity(0.4) : Color.clear,
                                lineWidth: 1.5
                            )
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Habit Type Card

struct HabitTypeCard: View {
    let type: HabitType
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                                ? type.color.opacity(0.2)
                                : (colorScheme == .dark ? Color.surfaceDarkTertiary : Color.surfaceSecondary)
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: type.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(isSelected ? type.color : Color.textSecondary)
                }
                
                Text(type.displayName)
                    .font(.bodySmall)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(
                        isSelected
                            ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            : Color.textSecondary
                    )
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                            .stroke(isSelected ? type.color : Color.clear, lineWidth: 2)
                    )
            )
            .modifier(Theme.shadow(isSelected ? .md : .sm))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Enhanced Habit Type Card (Mode-Aware)

struct EnhancedHabitTypeCard: View {
    let type: HabitType
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: type)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.sm) {
                ZStack {
                    // Background circle with mode-specific gradient
                    Circle()
                        .fill(
                            isSelected
                                ? LinearGradient(
                                    colors: [theme.glowColor.opacity(0.25), theme.neonAccent.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [
                                        colorScheme == .dark ? Color.surfaceDarkTertiary : Color.surfaceSecondary,
                                        colorScheme == .dark ? Color.surfaceDarkTertiary : Color.surfaceSecondary
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 56, height: 56)
                    
                    // Mode hero symbol
                    Image(systemName: isSelected ? theme.heroSymbol : type.icon)
                        .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(
                            isSelected
                                ? AnyShapeStyle(LinearGradient(
                                    colors: [theme.neonAccent, theme.glowColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                : AnyShapeStyle(Color.textSecondary)
                        )
                        .symbolEffect(.bounce, value: isSelected)
                }
                
                VStack(spacing: 2) {
                    Text(type.displayName)
                        .font(.bodySmall)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundStyle(
                            isSelected
                                ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                : Color.textSecondary
                        )
                        .lineLimit(1)
                    
                    // Show mode subtitle when selected
                    if isSelected {
                        Text(theme.modeTitle.replacingOccurrences(of: " Mode", with: ""))
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(theme.glowColor)
                            .lineLimit(1)
                            .transition(.opacity.combined(with: .scale(scale: 0.8)))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .stroke(
                        isSelected
                            ? LinearGradient(
                                colors: [theme.glowColor.opacity(0.6), theme.neonAccent.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(colors: [Color.clear, Color.clear], startPoint: .top, endPoint: .bottom),
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .modifier(Theme.shadow(isSelected ? .md : .sm))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    OnboardingView()
        .environment(AppStore())
}
