//
//  DashboardView.swift
//  Quitto
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    @State private var showCravingSheet = false
    @State private var showJournalSheet = false
    @State private var selectedHabitIndex = 0
    @State private var animateProgress = false
    
    private var currentHabit: Habit? {
        guard !habits.isEmpty else { return nil }
        let index = min(selectedHabitIndex, habits.count - 1)
        return habits[index]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                if let habit = currentHabit {
                    // Mode-specific illustration overlay for extra ambient flair
                    ModeIllustrationOverlay(habitType: habit.habitType)
                        .opacity(0.6)
                        .allowsHitTesting(false)
                    
                    VStack(spacing: 0) {
                        // Habit selector for multiple habits
                        if habits.count > 1 {
                            habitSelector
                        }
                        
                        // Habit-specific dashboard
                        HabitDashboardRouter(
                            habit: habit,
                            showCravingSheet: $showCravingSheet,
                            showJournalSheet: $showJournalSheet
                        )
                    }
                } else {
                    EmptyStateView(
                        icon: "leaf.fill",
                        title: "No Active Habit",
                        message: "Start tracking a habit to see your progress here.",
                        actionTitle: "Add Habit"
                    ) {
                        store.showOnboarding = true
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            store.showOnboarding = true
                        } label: {
                            Label("Add New Habit", systemImage: "plus.circle")
                        }
                        
                        Button {
                            store.showSettings = true
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                    } label: {
                        HStack(spacing: Theme.Spacing.sm) {
                            if let habit = currentHabit {
                                let headerTheme = HabitModeTheme.theme(for: habit.habitType)
                                Image(systemName: habit.habitType.icon)
                                    .foregroundStyle(headerTheme.glowColor)
                            }
                            Text("Quitto")
                                .font(.titleLarge)
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
        .sheet(isPresented: $showCravingSheet) {
            CravingLogSheet()
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showJournalSheet) {
            JournalEntrySheet()
                .presentationDetents([.large])
        }
        .onAppear {
            store.checkMilestones()
        }
    }
    
    // MARK: - Habit Selector
    
    private var habitSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
                    Button {
                        withAnimation(Theme.Animation.snappy) {
                            selectedHabitIndex = index
                        }
                    } label: {
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: habit.habitType.icon)
                                .font(.system(size: 14))
                            Text(habit.name)
                                .font(.labelMedium)
                        }
                        .foregroundStyle(
                            selectedHabitIndex == index
                                ? .white
                                : (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        )
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(
                                    selectedHabitIndex == index
                                        ? AnyShapeStyle(LinearGradient(
                                            colors: [
                                                HabitModeTheme.theme(for: habit.habitType).neonAccent,
                                                HabitModeTheme.theme(for: habit.habitType).glowColor
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        : AnyShapeStyle(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.vertical, Theme.Spacing.sm)
        }
        .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        Group {
            if let habit = currentHabit {
                ModeAmbientBackground(habitType: habit.habitType, intensity: .subtle)
            } else {
                if colorScheme == .dark {
                    Color.surfaceDark
                        .ignoresSafeArea()
                } else {
                    LinearGradient.surfaceGradient(for: colorScheme)
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    // MARK: - Hero Card
    
    private func heroCard(for habit: Habit) -> some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Time display
            VStack(spacing: Theme.Spacing.xs) {
                Text(timeDisplay(for: habit))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient.accentGradient
                    )
                    .contentTransition(.numericText())
                
                Text(timeLabel(for: habit))
                    .font(.bodyMedium)
                    .foregroundStyle(Color.textSecondary)
            }
            
            // Progress Ring
            ZStack {
                ProgressRing(
                    progress: animateProgress ? habit.progressToNextMilestone : 0,
                    lineWidth: 12,
                    size: 180,
                    gradient: .accentGradient
                )
                
                VStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: habit.habitType.icon)
                        .font(.system(size: 32))
                        .foregroundStyle(habit.habitType.color)
                    
                    Text("\(Int(habit.progressToNextMilestone * 100))%")
                        .font(.titleMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text("to \(habit.nextMilestoneDay)d milestone")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
            }
            
            // Streak badge
            if habit.streakDays > 0 {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(Color.warmth)
                    
                    Text("\(habit.streakDays) day streak")
                        .font(.labelLarge)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .background(
                    Capsule()
                        .fill(Color.warmth.opacity(0.15))
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.md))
    }
    
    private func timeDisplay(for habit: Habit) -> String {
        let days = habit.daysSinceQuit
        if days > 0 {
            return "\(days)"
        } else {
            let hours = habit.hoursSinceQuit
            if hours > 0 {
                return "\(hours)"
            } else {
                return "\(habit.minutesSinceQuit)"
            }
        }
    }
    
    private func timeLabel(for habit: Habit) -> String {
        let days = habit.daysSinceQuit
        if days > 0 {
            return days == 1 ? "day clean" : "days clean"
        } else {
            let hours = habit.hoursSinceQuit
            if hours > 0 {
                return hours == 1 ? "hour clean" : "hours clean"
            } else {
                return "minutes clean"
            }
        }
    }
    
    // MARK: - Stats Grid
    
    private func statsGrid(for habit: Habit) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
            StatCard(
                title: "\(habit.habitType.unitName.capitalized)s Avoided",
                value: "\(habit.unitsAvoided)",
                icon: "xmark.circle.fill",
                color: .accent
            )
            
            if habit.moneySaved > 0 {
                StatCard(
                    title: "Money Saved",
                    value: "$\(Int(habit.moneySaved))",
                    icon: "dollarsign.circle.fill",
                    color: .warmth
                )
            } else {
                StatCard(
                    title: "Time Reclaimed",
                    value: formatTime(habit.timeSavedMinutes),
                    icon: "clock.fill",
                    color: .calm
                )
            }
            
            StatCard(
                title: "Cravings Logged",
                value: "\(habit.cravingLogs.count)",
                icon: "chart.line.uptrend.xyaxis",
                color: .calm
            )
            
            StatCard(
                title: "Milestones",
                value: "\(habit.milestones.filter { $0.isUnlocked }.count)/\(habit.milestones.count)",
                icon: "trophy.fill",
                color: Color(hue: 45, saturation: 80, lightness: 50)
            )
        }
    }
    
    private func formatTime(_ minutes: Int) -> String {
        if minutes >= 60 {
            let hours = minutes / 60
            return "\(hours)h"
        }
        return "\(minutes)m"
    }
    
    // MARK: - Phase Card
    
    private func phaseCard(for habit: Habit) -> some View {
        let phase = habit.currentPhase
        
        return VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Current Phase")
                        .font(.labelMedium)
                        .foregroundStyle(Color.textTertiary)
                    
                    Text(phase.name)
                        .font(.titleMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                }
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.accent)
            }
            
            Text(phase.description)
                .font(.bodyMedium)
                .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Tips for this phase:")
                    .font(.labelMedium)
                    .foregroundStyle(Color.textTertiary)
                
                ForEach(phase.tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.accent)
                        
                        Text(tip)
                            .font(.bodySmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                    }
                }
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    // MARK: - Motivation Card
    
    private func motivationCard(for habit: Habit) -> some View {
        Group {
            if !habit.motivation.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    HStack {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.accent.opacity(0.5))
                        Spacer()
                    }
                    
                    Text(habit.motivation)
                        .font(.bodyLarge)
                        .italic()
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text("— Your reason to quit")
                        .font(.labelMedium)
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(Theme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.accent.opacity(0.08),
                                    Color.accent.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActions: some View {
        HStack(spacing: Theme.Spacing.md) {
            Button {
                showCravingSheet = true
            } label: {
                Label("Log Craving", systemImage: "exclamationmark.triangle.fill")
                    .font(.labelLarge)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(
                        LinearGradient(
                            colors: [Color.alert.opacity(0.9), Color.alert],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
            .buttonStyle(ScaleButtonStyle())
            
            Button {
                store.showJournalSheet = true
            } label: {
                Label("Journal", systemImage: "pencil.line")
                    .font(.labelLarge)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(
                        LinearGradient(
                            colors: [Color.calm.opacity(0.9), Color.calm],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}

// MARK: - Craving Log Sheet

struct CravingLogSheet: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var intensity: Int = 5
    @State private var selectedTrigger: CravingTrigger = .unknown
    @State private var note: String = ""
    @State private var didRelapse: Bool = false
    @State private var showStrategies: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Intensity
                    VStack(spacing: Theme.Spacing.md) {
                        Text("How strong is the craving?")
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        HStack {
                            Text("1")
                                .font(.labelMedium)
                                .foregroundStyle(Color.textTertiary)
                            
                            Slider(value: Binding(
                                get: { Double(intensity) },
                                set: { intensity = Int($0) }
                            ), in: 1...10, step: 1)
                            .tint(intensityColor)
                            
                            Text("10")
                                .font(.labelMedium)
                                .foregroundStyle(Color.textTertiary)
                        }
                        
                        Text("\(intensity)")
                            .font(.displayMedium)
                            .foregroundStyle(intensityColor)
                    }
                    .padding(Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                    )
                    
                    // Trigger
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("What triggered this?")
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.sm) {
                            ForEach(CravingTrigger.allCases) { trigger in
                                Button {
                                    selectedTrigger = trigger
                                } label: {
                                    HStack(spacing: Theme.Spacing.sm) {
                                        Image(systemName: trigger.icon)
                                            .font(.system(size: 16))
                                        
                                        Text(trigger.displayName)
                                            .font(.labelMedium)
                                    }
                                    .foregroundStyle(
                                        selectedTrigger == trigger
                                            ? .white
                                            : (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Theme.Spacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                                            .fill(
                                                selectedTrigger == trigger
                                                    ? Color.accent
                                                    : (colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                                            )
                                    )
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                    }
                    
                    // Coping strategies
                    if showStrategies {
                        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                            Text("Try one of these:")
                                .font(.titleSmall)
                                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            
                            ForEach(selectedTrigger.copingStrategies, id: \.self) { strategy in
                                HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.warmth)
                                    
                                    Text(strategy)
                                        .font(.bodyMedium)
                                        .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                                }
                            }
                        }
                        .padding(Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .fill(Color.warmth.opacity(0.1))
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Note
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Any notes?")
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        TextField("What's on your mind...", text: $note, axis: .vertical)
                            .font(.bodyMedium)
                            .lineLimit(3...6)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                            )
                    }
                    
                    // Relapse toggle
                    Toggle(isOn: $didRelapse) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("I gave in to the craving")
                                .font(.bodyMedium)
                                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                            
                            Text("It's okay—this is part of the journey")
                                .font(.labelSmall)
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                    .tint(Color.alert)
                }
                .padding(Theme.Spacing.lg)
            }
            .navigationTitle("Log Craving")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.textSecondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard store.isPremiumUnlocked else {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                store.showPaywall = true
                            }
                            return
                        }
                        store.logCraving(
                            intensity: intensity,
                            trigger: selectedTrigger,
                            note: note,
                            didRelapse: didRelapse
                        )
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accent)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(Theme.Animation.default) {
                    showStrategies = true
                }
            }
        }
    }
    
    private var intensityColor: Color {
        switch intensity {
        case 1...3: return .accent
        case 4...6: return .warmth
        default: return .alert
        }
    }
}

#Preview {
    DashboardView()
        .environment(AppStore())
        .modelContainer(for: [Habit.self, UserProfile.self], inMemory: true)
}
