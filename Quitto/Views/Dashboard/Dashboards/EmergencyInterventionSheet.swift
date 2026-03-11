//
//  EmergencyInterventionSheet.swift
//  Quitto
//
//  Emergency intervention screen for when users are struggling with cravings
//

import SwiftUI

struct EmergencyInterventionSheet: View {
    let habitType: HabitType
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var breathPhase: BreathPhase = .ready
    @State private var breathCount = 0
    @State private var showStrategies = false
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: habitType)
    }
    
    private var intervention: EmergencyIntervention {
        HabitSpecificData.emergencyMessage(for: habitType)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.xl) {
                    // Header
                    headerSection
                    
                    // Breathing exercise
                    breathingSection
                    
                    // Quick tips
                    quickTipsSection
                    
                    // Affirmation
                    affirmationSection
                    
                    // Coping strategies
                    if showStrategies {
                        copingStrategiesSection
                    }
                    
                    // Emergency contacts
                    emergencyContactsSection
                }
                .padding(Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xxxl)
            }
            .background(backgroundGradient)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(Theme.Animation.default) {
                    showStrategies = true
                }
            }
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                theme.glowColor.opacity(0.1),
                colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(theme.glowColor.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(theme.glowColor)
                    .symbolEffect(.pulse, options: .repeating)
            }
            
            Text(intervention.title)
                .font(.titleLarge)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            Text(intervention.subtitle)
                .font(.bodyMedium)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Breathing Section
    
    private var breathingSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("Breathe With Me")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ZStack {
                Circle()
                    .stroke(Color.textTertiary.opacity(0.2), lineWidth: 4)
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(theme.glowColor.opacity(breathPhase == .inhale ? 0.3 : 0.1))
                    .frame(width: breathPhase == .inhale ? 140 : 100, height: breathPhase == .inhale ? 140 : 100)
                    .animation(.easeInOut(duration: breathPhase == .inhale ? 4 : 4), value: breathPhase)
                
                VStack {
                    Text(breathPhase.instruction)
                        .font(.titleMedium)
                        .foregroundStyle(theme.glowColor)
                    
                    if breathPhase != .ready {
                        Text("\(breathCount)/5")
                            .font(.labelSmall)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
            
            if breathPhase == .ready {
                Button {
                    startBreathingExercise()
                } label: {
                    Text("Start Breathing Exercise")
                        .font(.bodyMedium)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.vertical, Theme.Spacing.md)
                        .background(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle())
            }
            
            Text(intervention.breathingExercise)
                .font(.labelSmall)
                .foregroundStyle(Color.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.md))
    }
    
    // MARK: - Quick Tips
    
    private var quickTipsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Do This NOW")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ForEach(intervention.quickTips, id: \.self) { tip in
                HStack(spacing: Theme.Spacing.md) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(theme.glowColor)
                    
                    Text(tip)
                        .font(.bodyMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
    }
    
    // MARK: - Affirmation
    
    private var affirmationSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "quote.opening")
                .font(.system(size: 24))
                .foregroundStyle(theme.glowColor.opacity(0.5))
            
            Text(intervention.affirmation)
                .font(.bodyLarge)
                .italic()
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                .multilineTextAlignment(.center)
            
            Image(systemName: "quote.closing")
                .font(.system(size: 24))
                .foregroundStyle(theme.glowColor.opacity(0.5))
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(theme.glowColor.opacity(0.1))
        )
    }
    
    // MARK: - Coping Strategies
    
    private var copingStrategiesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Coping Strategies")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ForEach(HabitSpecificData.copingStrategies(for: habitType).prefix(4)) { strategy in
                CopingStrategyCard(strategy: strategy, habitColor: theme.glowColor)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    // MARK: - Emergency Contacts
    
    private var emergencyContactsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Need More Help?")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            VStack(spacing: Theme.Spacing.sm) {
                if habitType == .gambling {
                    EmergencyContactRow(
                        name: "National Problem Gambling Helpline",
                        number: "1-800-522-4700",
                        icon: "phone.fill"
                    )
                }
                
                if habitType == .alcohol {
                    EmergencyContactRow(
                        name: "AA Hotline",
                        number: "1-800-839-1686",
                        icon: "phone.fill"
                    )
                }
                
                EmergencyContactRow(
                    name: "Crisis Text Line",
                    number: "Text HOME to 741741",
                    icon: "message.fill"
                )
                
                EmergencyContactRow(
                    name: "SAMHSA Helpline",
                    number: "1-800-662-4357",
                    icon: "phone.fill"
                )
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
    }
    
    // MARK: - Breathing Exercise Logic
    
    private func startBreathingExercise() {
        breathCount = 1
        breathPhase = .inhale
        runBreathCycle()
    }
    
    private func runBreathCycle() {
        guard breathCount <= 5 else {
            breathPhase = .ready
            breathCount = 0
            return
        }
        
        // Inhale for 4 seconds
        withAnimation {
            breathPhase = .inhale
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            // Hold for 4 seconds (or 7 for 4-7-8)
            withAnimation {
                breathPhase = .hold
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                // Exhale for 4 seconds (or 8 for 4-7-8)
                withAnimation {
                    breathPhase = .exhale
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    breathCount += 1
                    if breathCount <= 5 {
                        runBreathCycle()
                    } else {
                        withAnimation {
                            breathPhase = .ready
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Types

enum BreathPhase {
    case ready
    case inhale
    case hold
    case exhale
    
    var instruction: String {
        switch self {
        case .ready: return "Tap to Start"
        case .inhale: return "Inhale..."
        case .hold: return "Hold..."
        case .exhale: return "Exhale..."
        }
    }
}

struct EmergencyContactRow: View {
    let name: String
    let number: String
    let icon: String
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .foregroundStyle(Color.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.bodySmall)
                    .foregroundStyle(Color.textPrimary)
                Text(number)
                    .font(.labelMedium)
                    .foregroundStyle(Color.accent)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.textTertiary)
        }
        .padding(Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(Color.accent.opacity(0.1))
        )
    }
}

#Preview {
    EmergencyInterventionSheet(habitType: .smoking)
}
