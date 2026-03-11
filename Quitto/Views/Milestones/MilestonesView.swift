//
//  MilestonesView.swift
//  Quitto
//

import SwiftUI
import SwiftData

struct MilestonesView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    @State private var selectedMilestone: Milestone?
    @State private var showCelebration = false
    
    private var currentHabit: Habit? { habits.first }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: currentHabit?.habitType ?? .smoking)
    }
    
    private var sortedMilestones: [Milestone] {
        currentHabit?.milestones.sorted { $0.daysRequired < $1.daysRequired } ?? []
    }
    
    private var unlockedCount: Int {
        sortedMilestones.filter { $0.isUnlocked }.count
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
                    .ignoresSafeArea()
                
                if currentHabit == nil {
                    EmptyStateView(
                        icon: "trophy.fill",
                        title: "No Milestones Yet",
                        message: "Start tracking a habit to unlock achievements.",
                        actionTitle: nil
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: Theme.Spacing.lg) {
                            // Header stats
                            headerStats
                            
                            // Progress path
                            progressPath
                            
                            // Milestones grid
                            milestonesGrid
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.bottom, 100)
                    }
                }
                
                // Celebration overlay
                if showCelebration {
                    celebrationOverlay
                }
            }
            .navigationTitle("Milestones")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $selectedMilestone) { milestone in
            MilestoneDetailSheet(milestone: milestone)
                .presentationDetents([.medium])
        }
    }
    
    // MARK: - Header Stats
    
    private var headerStats: some View {
        HStack(spacing: Theme.Spacing.md) {
            VStack(spacing: Theme.Spacing.xs) {
                Text("\(unlockedCount)")
                    .font(.displayMedium)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.neonAccent, theme.glowColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Unlocked")
                    .font(.labelMedium)
                    .foregroundStyle(Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
            )
            
            VStack(spacing: Theme.Spacing.xs) {
                Text("\(sortedMilestones.count - unlockedCount)")
                    .font(.displayMedium)
                    .foregroundStyle(Color.textTertiary)
                
                Text("Remaining")
                    .font(.labelMedium)
                    .foregroundStyle(Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
            )
            
            if let habit = currentHabit {
                VStack(spacing: Theme.Spacing.xs) {
                    Text("\(habit.nextMilestoneDay - habit.daysSinceQuit)")
                        .font(.displayMedium)
                        .foregroundStyle(Color.warmth)
                    
                    Text("Days to Next")
                        .font(.labelMedium)
                        .foregroundStyle(Color.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                )
            }
        }
    }
    
    // MARK: - Progress Path
    
    private var progressPath: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Your Journey")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(Color.textTertiary.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress fill
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [theme.neonAccent, theme.glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progressPercentage, height: 8)
                    
                    // Milestone markers
                    ForEach(sortedMilestones) { milestone in
                        let position = milestonePosition(milestone, in: geo.size.width)
                        
                        Circle()
                            .fill(milestone.isUnlocked ? theme.glowColor : Color.textTertiary.opacity(0.5))
                            .frame(width: 16, height: 16)
                            .overlay(
                                Circle()
                                    .stroke(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary, lineWidth: 3)
                            )
                            .offset(x: position - 8)
                    }
                }
            }
            .frame(height: 20)
            
            // Current position label
            if let habit = currentHabit {
                HStack {
                    Text("Day \(habit.daysSinceQuit)")
                        .font(.labelMedium)
                        .foregroundStyle(theme.glowColor)
                    
                    Spacer()
                    
                    Text("Day 365")
                        .font(.labelMedium)
                        .foregroundStyle(Color.textTertiary)
                }
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
    }
    
    private var progressPercentage: CGFloat {
        guard let habit = currentHabit else { return 0 }
        return min(1.0, CGFloat(habit.daysSinceQuit) / 365.0)
    }
    
    private func milestonePosition(_ milestone: Milestone, in width: CGFloat) -> CGFloat {
        let percentage = CGFloat(milestone.daysRequired) / 365.0
        return width * min(1.0, percentage)
    }
    
    // MARK: - Milestones Grid
    
    private var milestonesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            ForEach(sortedMilestones) { milestone in
                MilestoneCard(milestone: milestone) {
                    selectedMilestone = milestone
                }
            }
        }
    }
    
    // MARK: - Celebration Overlay
    
    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showCelebration = false
                    }
                }
            
            // Sparkle overlay for celebration
            SparkleOverlayView(color: theme.glowColor, particleCount: 30)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            VStack(spacing: Theme.Spacing.xl) {
                CelebrationView()
                
                if let milestone = store.recentMilestone {
                    BadgeView(milestone, size: 120)
                    
                    Text(milestone.title)
                        .font(.displaySmall)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, theme.glowColor.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    Text(milestone.descriptionText)
                        .font(.bodyMedium)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.xl)
                }
                
                PrimaryButton("Continue") {
                    withAnimation {
                        showCelebration = false
                    }
                }
                .frame(width: 200)
            }
        }
    }
}

// MARK: - Milestone Card

struct MilestoneCard: View {
    let milestone: Milestone
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: milestone.habit?.habitType ?? .smoking)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.sm) {
                BadgeView(milestone, size: 60)
                
                Text(milestone.title)
                    .font(.labelMedium)
                    .foregroundStyle(
                        milestone.isUnlocked
                            ? (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            : Color.textTertiary
                    )
                    .lineLimit(1)
                
                Text("\(milestone.daysRequired)d")
                    .font(.labelSmall)
                    .foregroundStyle(milestone.isUnlocked ? theme.glowColor.opacity(0.7) : Color.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    if milestone.isUnlocked {
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [theme.glowColor.opacity(colorScheme == .dark ? 0.06 : 0.03), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .overlay(
                Group {
                    if milestone.isUnlocked {
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .stroke(theme.glowColor.opacity(0.15), lineWidth: 0.5)
                    }
                }
            )
            .modifier(Theme.shadow(.sm))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Milestone Detail Sheet

struct MilestoneDetailSheet: View {
    let milestone: Milestone
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: milestone.habit?.habitType ?? .smoking)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.xl) {
                BadgeView(milestone, size: 100)
                
                VStack(spacing: Theme.Spacing.sm) {
                    Text(milestone.title)
                        .font(.displaySmall)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text("\(milestone.daysRequired) days")
                        .font(.titleSmall)
                        .foregroundStyle(milestone.isUnlocked ? theme.glowColor : Color.textSecondary)
                }
                
                Text(milestone.descriptionText)
                    .font(.bodyLarge)
                    .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
                
                if milestone.isUnlocked, let date = milestone.achievedDate {
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.neonAccent, theme.glowColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Achieved on \(date.formatted(.dateTime.month().day().year()))")
                            .font(.bodyMedium)
                            .foregroundStyle(theme.glowColor)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(
                        Capsule()
                            .fill(theme.glowColor.opacity(0.1))
                    )
                    .overlay(
                        Capsule()
                            .stroke(theme.glowColor.opacity(0.15), lineWidth: 0.5)
                    )
                } else {
                    Text("Keep going—you'll get there!")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
            }
            .padding(.top, Theme.Spacing.xl)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
        }
    }
}

#Preview {
    MilestonesView()
        .environment(AppStore())
        .modelContainer(for: [Habit.self, Milestone.self], inMemory: true)
}
