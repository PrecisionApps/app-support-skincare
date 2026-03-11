//
//  ModeDailyInsightCard.swift
//  Quitto
//
//  Rotating daily quotes, tips, and facts unique per mode.
//  Shows a mode-themed card with the daily insight, rotating based on day of year.
//

import SwiftUI

// MARK: - Mode Daily Insight Card

struct ModeDailyInsightCard: View {
    let habit: Habit
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var showFullQuote = false
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    private var dailyFact: MotivationalFact? {
        let facts = HabitSpecificData.motivationalFacts(for: habit.habitType)
        let days = habit.daysSinceQuit
        // Show the most relevant fact based on current progress
        return facts.last(where: { timeframeToApproxDays($0.timeframe) <= days })
            ?? facts.first
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Mode identity header
            modeHeader
            
            // Daily quote
            dailyQuoteSection
            
            // Recovery fact (if applicable)
            if let fact = dailyFact {
                recoveryFactSection(fact)
            }
            
            // Phase-specific tip
            phaseSpecificTip
        }
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            theme.glowColor.opacity(0.3),
                            theme.glowColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .modifier(Theme.shadow(.md))
    }
    
    // MARK: - Mode Header
    
    private var modeHeader: some View {
        HStack(spacing: Theme.Spacing.sm) {
            // Mode badge
            ZStack {
                Circle()
                    .fill(theme.glowColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: theme.heroSymbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(theme.glowColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(theme.modeTitle)
                    .font(.labelLarge)
                    .foregroundStyle(theme.glowColor)
                
                Text(theme.modeSubtitle)
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
            }
            
            Spacer()
            
            // Day indicator
            VStack(alignment: .trailing, spacing: 2) {
                Text("Day \(habit.daysSinceQuit)")
                    .font(.labelLarge)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text(theme.modeSpecificTerms.streakLabel)
                    .font(.labelSmall)
                    .foregroundStyle(theme.glowColor.opacity(0.7))
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm + 4)
        .background(
            LinearGradient(
                colors: [
                    theme.glowColor.opacity(colorScheme == .dark ? 0.1 : 0.06),
                    theme.glowColor.opacity(0.02)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    // MARK: - Daily Quote
    
    private var dailyQuoteSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 18))
                    .foregroundStyle(theme.neonAccent.opacity(0.4))
                
                Text(theme.dailyQuote)
                    .font(.bodyMedium)
                    .italic()
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    .lineLimit(showFullQuote ? nil : 3)
                    .animation(Theme.Animation.default, value: showFullQuote)
            }
            
            HStack {
                Text("Daily Insight")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
                
                Spacer()
                
                if theme.dailyQuote.count > 100 {
                    Button {
                        withAnimation(Theme.Animation.default) {
                            showFullQuote.toggle()
                        }
                    } label: {
                        Text(showFullQuote ? "Less" : "More")
                            .font(.labelSmall)
                            .foregroundStyle(theme.glowColor)
                    }
                }
            }
        }
        .padding(Theme.Spacing.md)
    }
    
    // MARK: - Recovery Fact
    
    private func recoveryFactSection(_ fact: MotivationalFact) -> some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(theme.glowColor.opacity(0.1))
            
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                        .fill(theme.glowColor.opacity(0.12))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: fact.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(theme.glowColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("At \(fact.timeframe)")
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor)
                    
                    Text(fact.fact)
                        .font(.bodySmall)
                        .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(theme.glowColor.opacity(0.5))
            }
            .padding(Theme.Spacing.md)
        }
    }
    
    // MARK: - Phase Tip
    
    private var phaseSpecificTip: some View {
        let phase = habit.currentPhase
        let tip = phase.tips.first ?? "Keep going—you're doing great."
        
        return VStack(spacing: 0) {
            Divider()
                .overlay(theme.glowColor.opacity(0.1))
            
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.neonAccent)
                
                Text(tip)
                    .font(.bodySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm + 2)
            .background(
                theme.neonAccent.opacity(colorScheme == .dark ? 0.05 : 0.03)
            )
        }
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: Theme.Radius.xl,
                bottomTrailingRadius: Theme.Radius.xl,
                topTrailingRadius: 0
            )
        )
    }
    
    // MARK: - Helpers
    
    private func timeframeToApproxDays(_ timeframe: String) -> Int {
        let lower = timeframe.lowercased()
        if lower.contains("minute") { return 0 }
        if lower.contains("hour") {
            let num = extractNumber(from: lower)
            return num < 24 ? 0 : 1
        }
        if lower.contains("day") {
            return extractNumber(from: lower)
        }
        if lower.contains("week") {
            return extractNumber(from: lower) * 7
        }
        if lower.contains("month") {
            return extractNumber(from: lower) * 30
        }
        if lower.contains("year") {
            return extractNumber(from: lower) * 365
        }
        return 0
    }
    
    private func extractNumber(from string: String) -> Int {
        let digits = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(digits) ?? 1
    }
}

// MARK: - Mode Identity Badge

struct ModeIdentityBadge: View {
    let habitType: HabitType
    let style: BadgeStyle
    
    @Environment(\.colorScheme) private var colorScheme
    
    enum BadgeStyle {
        case compact    // Small pill badge
        case standard   // Medium badge with icon + label
        case hero       // Large badge with full mode info
    }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    var body: some View {
        switch style {
        case .compact:
            compactBadge
        case .standard:
            standardBadge
        case .hero:
            heroBadge
        }
    }
    
    // MARK: - Compact
    
    private var compactBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: theme.heroSymbol)
                .font(.system(size: 10, weight: .semibold))
            
            Text(theme.modeTitle.replacingOccurrences(of: " Mode", with: ""))
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundStyle(theme.glowColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(theme.glowColor.opacity(colorScheme == .dark ? 0.15 : 0.1))
        )
    }
    
    // MARK: - Standard
    
    private var standardBadge: some View {
        HStack(spacing: Theme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(theme.glowColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: theme.heroSymbol)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(theme.glowColor)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(theme.modeTitle)
                    .font(.labelMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text(theme.modeSpecificTerms.heroLabel)
                    .font(.labelSmall)
                    .foregroundStyle(theme.glowColor.opacity(0.7))
            }
        }
        .padding(.horizontal, Theme.Spacing.sm + 4)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            Capsule()
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .overlay(
            Capsule()
                .stroke(theme.glowColor.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Hero
    
    private var heroBadge: some View {
        VStack(spacing: Theme.Spacing.md) {
            // Mode illustration
            ModeHeroIllustration(habitType: habitType, size: 100)
            
            // Title
            VStack(spacing: Theme.Spacing.xs) {
                Text(theme.modeTitle)
                    .font(.titleMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                
                Text(theme.modeSubtitle)
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
                
                // Hero label pill
                Text(theme.modeSpecificTerms.heroLabel)
                    .font(.labelSmall)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, 4)
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
                    .padding(.top, Theme.Spacing.xs)
            }
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            theme.glowColor.opacity(0.3),
                            theme.glowColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Mode Motivational Banner

struct ModeMotivationalBanner: View {
    let habit: Habit
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentIndex = 0
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    private var bannerContent: (icon: String, text: String, color: Color) {
        let days = habit.daysSinceQuit
        
        if days == 0 {
            return ("flame.fill", "Your journey begins NOW. The first 24 hours are the hardest—every minute counts.", theme.neonAccent)
        } else if days <= 3 {
            return ("bolt.fill", "Peak withdrawal zone. Your body is \(theme.modeSpecificTerms.progressVerb). Push through—it gets easier from here.", theme.glowColor)
        } else if days <= 7 {
            return ("chart.line.uptrend.xyaxis", "One week territory! The worst is behind you. \(theme.modeSpecificTerms.victoryPhrase).", theme.neonAccent)
        } else if days <= 14 {
            return ("sparkles", "Two weeks strong! Neural pathways are rewiring. You're becoming someone new.", theme.glowColor)
        } else if days <= 30 {
            return ("star.fill", "Nearly a month! \(theme.modeSpecificTerms.victoryPhrase). The new you is emerging.", theme.neonAccent)
        } else if days <= 90 {
            return ("trophy.fill", "You're in the transformation zone. Most people never make it this far.", theme.glowColor)
        } else if days <= 180 {
            return ("crown.fill", "You're a \(theme.modeSpecificTerms.heroLabel). This is who you are now.", theme.neonAccent)
        } else {
            return ("shield.fill", "Living proof that change is possible. You inspire others just by existing.", theme.glowColor)
        }
    }
    
    var body: some View {
        let content = bannerContent
        
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: content.icon)
                .font(.system(size: 22))
                .foregroundStyle(content.color)
                .frame(width: 36)
            
            Text(content.text)
                .font(.bodySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                .lineLimit(3)
            
            Spacer(minLength: 0)
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(content.color.opacity(colorScheme == .dark ? 0.1 : 0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(content.color.opacity(0.15), lineWidth: 1)
        )
        .modeAccentLine(color: content.color, position: .leading)
    }
}

// MARK: - Mode Stats Header

struct ModeStatsHeader: View {
    let habit: Habit
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habit.habitType)
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            statPill(
                icon: "xmark.circle.fill",
                value: "\(habit.unitsAvoided)",
                label: theme.modeSpecificTerms.unitLabel,
                color: theme.glowColor
            )
            
            if habit.moneySaved > 0 {
                statPill(
                    icon: "dollarsign.circle.fill",
                    value: "$\(Int(habit.moneySaved))",
                    label: "saved",
                    color: theme.neonAccent
                )
            }
            
            statPill(
                icon: "clock.fill",
                value: formatTime(habit.timeSavedMinutes),
                label: "reclaimed",
                color: theme.ambientColors.first ?? theme.glowColor
            )
        }
    }
    
    private func statPill(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            
            Text(value)
                .font(.titleSmall)
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(Color.textTertiary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm + 2)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .fill(color.opacity(colorScheme == .dark ? 0.08 : 0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .stroke(color.opacity(0.1), lineWidth: 0.5)
        )
    }
    
    private func formatTime(_ minutes: Int) -> String {
        if minutes >= 1440 {
            return "\(minutes / 1440)d"
        } else if minutes >= 60 {
            return "\(minutes / 60)h"
        }
        return "\(minutes)m"
    }
}
