//
//  JournalView.swift
//  Quitto
//

import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    
    @State private var showNewEntry = false
    
    var body: some View {
        NavigationStack {
            journalContent
                .navigationTitle("Journal")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            attemptNewEntry()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.accent)
                        }
                    }
                }
        }
        .sheet(isPresented: $showNewEntry) {
            NewJournalEntrySheet()
                .presentationDetents([.large])
        }
    }
    
    /// Gate new entry creation: free users get redirected to the paywall.
    private func attemptNewEntry() {
        guard store.isPremiumUnlocked else {
            store.showPaywall = true
            return
        }
        showNewEntry = true
    }
    
    private var journalContent: some View {
        ZStack {
            (colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
                .ignoresSafeArea()
            
            if entries.isEmpty {
                EmptyStateView(
                    icon: "book.fill",
                    title: "Your Journal Awaits",
                    message: "Reflect on your journey. Writing helps process emotions and track growth.",
                    actionTitle: "Write First Entry"
                ) {
                    attemptNewEntry()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: Theme.Spacing.md) {
                        // Today's prompt card
                        TodayPromptCard {
                            attemptNewEntry()
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        
                        // Mood overview
                        if entries.count >= 3 {
                            MoodOverviewCard(entries: entries)
                                .padding(.horizontal, Theme.Spacing.lg)
                        }
                        
                        // Entries
                        ForEach(groupedEntries.keys.sorted(by: >), id: \.self) { date in
                            Section {
                                ForEach(groupedEntries[date] ?? []) { entry in
                                    JournalEntryCard(entry: entry)
                                        .padding(.horizontal, Theme.Spacing.lg)
                                }
                            } header: {
                                Text(formatSectionDate(date))
                                    .font(.labelMedium)
                                    .foregroundStyle(Color.textTertiary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, Theme.Spacing.lg)
                                    .padding(.top, Theme.Spacing.md)
                            }
                        }
                    }
                    .padding(.vertical, Theme.Spacing.md)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var groupedEntries: [Date: [JournalEntry]] {
        Dictionary(grouping: entries) { entry in
            Calendar.current.startOfDay(for: entry.date)
        }
    }
    
    private func formatSectionDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(.dateTime.month(.wide).day())
        }
    }
}

// MARK: - Today's Prompt Card

struct TodayPromptCard: View {
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var prompt = JournalPrompt.randomPrompt()
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.warmth)
                    
                    Text("Today's Prompt")
                        .font(.labelMedium)
                        .foregroundStyle(Color.warmth)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(Theme.Animation.snappy) {
                            prompt = JournalPrompt.randomPrompt()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                
                Text(prompt.question)
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("Tap to write")
                        .font(.labelMedium)
                        .foregroundStyle(Color.textTertiary)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textTertiary)
                }
            }
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.warmth.opacity(0.15),
                                Color.warmth.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Mood Overview Card

struct MoodOverviewCard: View {
    let entries: [JournalEntry]
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var recentEntries: [JournalEntry] {
        Array(entries.prefix(7))
    }
    
    private var averageMood: Double {
        guard !recentEntries.isEmpty else { return 3 }
        let sum = recentEntries.reduce(0) { $0 + $1.mood.value }
        return Double(sum) / Double(recentEntries.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Mood This Week")
                .font(.labelMedium)
                .foregroundStyle(Color.textTertiary)
            
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(recentEntries.reversed()) { entry in
                    VStack(spacing: Theme.Spacing.xs) {
                        Text(entry.mood.emoji)
                            .font(.system(size: 24))
                        
                        Text(entry.date, format: .dateTime.weekday(.narrow))
                            .font(.labelSmall)
                            .foregroundStyle(Color.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            HStack {
                Text("Average:")
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
                
                Text(moodDescription)
                    .font(.bodySmall)
                    .fontWeight(.medium)
                    .foregroundStyle(moodColor)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
        )
        .modifier(Theme.shadow(.sm))
    }
    
    private var moodDescription: String {
        switch averageMood {
        case 0..<2: return "Struggling"
        case 2..<3: return "Getting There"
        case 3..<4: return "Stable"
        case 4..<5: return "Doing Well"
        default: return "Thriving!"
        }
    }
    
    private var moodColor: Color {
        switch averageMood {
        case 0..<2: return .alert
        case 2..<3: return .warmth
        case 3..<4: return .textSecondary
        default: return .accent
        }
    }
}

// MARK: - Journal Entry Card

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text(entry.mood.emoji)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.date, format: .dateTime.hour().minute())
                        .font(.labelMedium)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    if !entry.promptUsed.isEmpty {
                        Text("Prompted")
                            .font(.labelSmall)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation(Theme.Animation.default) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.textTertiary)
                }
            }
            
            Text(entry.content)
                .font(.bodyMedium)
                .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                .lineLimit(isExpanded ? nil : 3)
            
            if isExpanded && !entry.promptUsed.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Prompt:")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                    
                    Text(entry.promptUsed)
                        .font(.bodySmall)
                        .italic()
                        .foregroundStyle(Color.textSecondary)
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
}

// MARK: - New Journal Entry Sheet

struct NewJournalEntrySheet: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var content: String = ""
    @State private var selectedMood: JournalMood = .neutral
    @State private var currentPrompt: JournalPrompt? = nil
    
    @FocusState private var isTextFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Mood selector
                    VStack(spacing: Theme.Spacing.md) {
                        Text("How are you feeling?")
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        HStack(spacing: Theme.Spacing.md) {
                            ForEach(JournalMood.allCases) { mood in
                                Button {
                                    withAnimation(Theme.Animation.snappy) {
                                        selectedMood = mood
                                    }
                                } label: {
                                    VStack(spacing: Theme.Spacing.xs) {
                                        Text(mood.emoji)
                                            .font(.system(size: selectedMood == mood ? 40 : 28))
                                        
                                        Text(mood.displayName)
                                            .font(.labelSmall)
                                            .foregroundStyle(
                                                selectedMood == mood
                                                    ? Color.accent
                                                    : Color.textTertiary
                                            )
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Theme.Spacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                                            .fill(
                                                selectedMood == mood
                                                    ? Color.accent.opacity(0.1)
                                                    : Color.clear
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Prompt suggestion
                    if let prompt = currentPrompt {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundStyle(Color.warmth)
                                
                                Text("Prompt")
                                    .font(.labelMedium)
                                    .foregroundStyle(Color.warmth)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        currentPrompt = JournalPrompt.randomPrompt()
                                    }
                                } label: {
                                    Text("New prompt")
                                        .font(.labelSmall)
                                        .foregroundStyle(Color.textTertiary)
                                }
                            }
                            
                            Text(prompt.question)
                                .font(.bodyMedium)
                                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        }
                        .padding(Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .fill(Color.warmth.opacity(0.1))
                        )
                    } else {
                        Button {
                            withAnimation {
                                currentPrompt = JournalPrompt.randomPrompt()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "lightbulb")
                                Text("Need a prompt?")
                            }
                            .font(.bodyMedium)
                            .foregroundStyle(Color.textSecondary)
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("What's on your mind?")
                            .font(.titleSmall)
                            .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                        
                        TextEditor(text: $content)
                            .font(.bodyMedium)
                            .frame(minHeight: 200)
                            .scrollContentBackground(.hidden)
                            .padding(Theme.Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                            )
                            .focused($isTextFocused)
                    }
                }
                .padding(Theme.Spacing.lg)
            }
            .navigationTitle("New Entry")
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
                        store.addJournalEntry(
                            content: content,
                            mood: selectedMood,
                            prompt: currentPrompt?.question ?? ""
                        )
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accent)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            isTextFocused = true
        }
    }
}

#Preview {
    JournalView()
        .environment(AppStore())
        .modelContainer(for: [JournalEntry.self, Habit.self], inMemory: true)
}
