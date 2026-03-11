//
//  PremiumGateView.swift
//  Quitto
//

import SwiftUI

struct PremiumGateView: View {
    let feature: PremiumFeature
    
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [feature.color.opacity(0.2), feature.color.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [feature.color, feature.color.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            // Title & Description
            VStack(spacing: Theme.Spacing.md) {
                Text(feature.title)
                    .font(.displaySmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(feature.description)
                    .font(.bodyLarge)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }
            
            // Feature highlights
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                ForEach(feature.highlights, id: \.self) { highlight in
                    HStack(spacing: Theme.Spacing.md) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.accent)
                        
                        Text(highlight)
                            .font(.bodyMedium)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        Spacer()
                    }
                }
            }
            .padding(Theme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary.opacity(0.6) : Color.surfaceElevated.opacity(0.8))
            )
            .padding(.horizontal, Theme.Spacing.xl)
            
            Spacer()
            
            // CTA
            VStack(spacing: Theme.Spacing.md) {
                PrimaryButton("Unlock Premium", icon: "lock.open.fill") {
                    store.showPaywall = true
                }
                .padding(.horizontal, Theme.Spacing.xl)
                
                Button {
                    Task {
                        await store.restorePurchases()
                    }
                } label: {
                    Text("Restore Purchases")
                        .font(.bodySmall)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .padding(.bottom, Theme.Spacing.xxxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
    }
}

// MARK: - Premium Feature Definitions

enum PremiumFeature {
    case aiCoach
    case journal
    case cravingTracker
    case insights
    
    var icon: String {
        switch self {
        case .aiCoach: return "brain.head.profile"
        case .journal: return "book.fill"
        case .cravingTracker: return "waveform.path.ecg"
        case .insights: return "chart.xyaxis.line"
        }
    }
    
    var title: String {
        switch self {
        case .aiCoach: return "AI Recovery Coach"
        case .journal: return "Recovery Journal"
        case .cravingTracker: return "Craving Tracker"
        case .insights: return "Advanced Insights"
        }
    }
    
    var description: String {
        switch self {
        case .aiCoach: return "Get 24/7 personalized coaching powered by AI that learns your triggers and helps you stay on track."
        case .journal: return "Reflect on your recovery journey with mood tracking and guided prompts."
        case .cravingTracker: return "Log and analyze your cravings to understand patterns and beat them faster."
        case .insights: return "Unlock deep analytics about your recovery progress and craving patterns."
        }
    }
    
    var highlights: [String] {
        switch self {
        case .aiCoach:
            return [
                "Personalized recovery strategies",
                "24/7 instant support when cravings hit",
                "Learns your triggers over time",
                "Science-backed coping techniques"
            ]
        case .journal:
            return [
                "Daily guided reflection prompts",
                "Mood tracking with visual trends",
                "Private and secure entries",
                "Track emotional progress over time"
            ]
        case .cravingTracker:
            return [
                "Log triggers and intensity",
                "Pattern analysis over time",
                "Coping strategy suggestions",
                "See your craving frequency decrease"
            ]
        case .insights:
            return [
                "Craving pattern analysis",
                "Risk prediction algorithms",
                "Health recovery milestones",
                "Detailed progress statistics"
            ]
        }
    }
    
    var color: Color {
        switch self {
        case .aiCoach: return Color.accent
        case .journal: return Color.calm
        case .cravingTracker: return Color.warmth
        case .insights: return Color(hue: 280, saturation: 30, lightness: 52)
        }
    }
}
