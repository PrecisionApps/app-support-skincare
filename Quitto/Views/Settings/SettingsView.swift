//
//  SettingsView.swift
//  Quitto
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppStore.self) private var store
    
    @Query private var profiles: [UserProfile]
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    @State private var notificationsEnabled = true
    @State private var morningReminder = true
    @State private var eveningReminder = true
    @State private var showDeleteConfirmation = false
    @State private var showResetConfirmation = false
    
    private var profile: UserProfile? { profiles.first }
    private var currentHabit: Habit? { habits.first }
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    if let profile {
                        HStack(spacing: Theme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient.accentGradient)
                                    .frame(width: 56, height: 56)
                                
                                Text(profile.name.prefix(1).uppercased())
                                    .font(.titleLarge)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(profile.name)
                                    .font(.titleSmall)
                                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                
                                Text("Member since \(profile.joinedDate.formatted(.dateTime.month().year()))")
                                    .font(.bodySmall)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                        .padding(.vertical, Theme.Spacing.xs)
                    }
                } header: {
                    Text("Profile")
                }
                
                // Current Habit Section
                if let habit = currentHabit {
                    Section {
                        HStack {
                            Image(systemName: habit.habitType.icon)
                                .foregroundStyle(habit.habitType.color)
                            
                            Text(habit.name)
                            
                            Spacer()
                            
                            Text("\(habit.daysSinceQuit) days")
                                .foregroundStyle(Color.textSecondary)
                        }
                        
                        HStack {
                            Text("Quit Date")
                            Spacer()
                            Text(habit.quitDate.formatted(.dateTime.month().day().year()))
                                .foregroundStyle(Color.textSecondary)
                        }
                        
                        HStack {
                            Text("Daily Amount")
                            Spacer()
                            Text("\(habit.dailyAmount) \(habit.habitType.unitName)s")
                                .foregroundStyle(Color.textSecondary)
                        }
                        
                        HStack {
                            Text("Est. Daily Savings")
                            Spacer()
                            let breakdown = habit.habitType.savingsBreakdown(dailyAmount: habit.dailyAmount)
                            Text("$\(String(format: "%.0f", breakdown.totalDaily))")
                                .foregroundStyle(Color.textSecondary)
                        }
                    } header: {
                        Text("Current Habit")
                    }
                }
                
                // Premium Section
                if !store.isPremiumUnlocked {
                    Section {
                        Button {
                            store.showPaywall = true
                            dismiss()
                        } label: {
                            HStack(spacing: Theme.Spacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient.accentGradient)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Upgrade to Premium")
                                        .font(.bodyMedium)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                    
                                    Text("Unlock AI Coach, Journal, Craving Tracker & more")
                                        .font(.labelSmall)
                                        .foregroundStyle(Color.textSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.textTertiary)
                            }
                        }
                        
                        Button {
                            Task {
                                await store.restorePurchases()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Restore Purchases")
                            }
                            .foregroundStyle(Color.accent)
                        }
                    } header: {
                        Text("Subscription")
                    } footer: {
                        Text("Free tier includes basic dashboard and milestones. Upgrade for full access to all features.")
                    }
                }
                
                // Notifications Section
                Section {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .tint(Color.accent)
                    
                    if notificationsEnabled {
                        Toggle("Morning Motivation", isOn: $morningReminder)
                            .tint(Color.accent)
                        
                        Toggle("Evening Reflection", isOn: $eveningReminder)
                            .tint(Color.accent)
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("We'll send you supportive messages to help you stay on track.")
                }
                
                // Data Section
                Section {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Progress")
                        }
                    }
                    
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete All Data")
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    Text("Resetting progress will start your streak over. Deleting data removes everything and takes you back to onboarding.")
                }
                
                // Community Section
                Section {
                    Button {
                        store.engagementManager.openTikTok()
                    } label: {
                        HStack(spacing: Theme.Spacing.md) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.0, green: 0.96, blue: 0.88),
                                                Color(red: 1.0, green: 0.0, blue: 0.32),
                                                Color(red: 0.27, green: 0.53, blue: 1.0)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "play.rectangle.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Follow on TikTok")
                                    .font(.bodyMedium)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                                
                                Text("Request features & get updates")
                                    .font(.labelSmall)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                } header: {
                    Text("Community")
                } footer: {
                    Text("Follow us to request features, report bugs, and stay updated with development.")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Link(destination: URL(string: "https://precisionapps.github.io/Quitto/privacy.html")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://precisionapps.github.io/Quitto/terms.html")!) {
                        HStack {
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                    
                    NavigationLink {
                        SourcesSheetView(habitName: currentHabit?.habitType.displayName ?? "General")
                    } label: {
                        HStack {
                            Text("Sources & Citations")
                            Spacer()
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                } header: {
                    Text("About")
                } footer: {
                    Text("Health information in this app is for educational purposes only and is not a substitute for professional medical advice.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveSettings()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accent)
                }
            }
            .confirmationDialog(
                "Reset Progress",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset", role: .destructive) {
                    resetProgress()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset your quit date to today. Your journal entries and milestones will be preserved.")
            }
            .confirmationDialog(
                "Delete All Data",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Everything", role: .destructive) {
                    deleteAllData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This cannot be undone. All your habits, journal entries, milestones, and chat history will be permanently deleted.")
            }
        }
        .onAppear {
            loadSettings()
        }
    }
    
    private func loadSettings() {
        if let profile {
            notificationsEnabled = profile.notificationsEnabled
        }
    }
    
    private func saveSettings() {
        if let profile {
            profile.notificationsEnabled = notificationsEnabled
            try? modelContext.save()
        }
    }
    
    private func resetProgress() {
        if let habit = currentHabit {
            habit.quitDate = Date()
            
            // Reset milestones
            for milestone in habit.milestones {
                milestone.isUnlocked = false
                milestone.achievedDate = nil
                milestone.celebrationShown = false
            }
            
            try? modelContext.save()
        }
    }
    
    private func deleteAllData() {
        // Delete all data
        try? modelContext.delete(model: Habit.self)
        try? modelContext.delete(model: UserProfile.self)
        try? modelContext.delete(model: JournalEntry.self)
        try? modelContext.delete(model: CravingLog.self)
        try? modelContext.delete(model: Milestone.self)
        try? modelContext.delete(model: CoachMessage.self)
        
        try? modelContext.save()
        
        // Clear widget data
        Task {
            await store.widgetService.clearWidgetData()
        }
        
        // Reset in-memory state and trigger onboarding
        store.currentHabit = nil
        store.aiMessages = []
        store.showOnboarding = true
        
        dismiss()
    }
}

#Preview {
    SettingsView()
        .environment(AppStore())
        .modelContainer(for: [UserProfile.self, Habit.self], inMemory: true)
}
