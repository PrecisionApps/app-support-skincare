//
//  JournalEntrySheet.swift
//  Quitto
//
//  Sheet for creating journal entries with habit-specific prompts
//

import SwiftUI
import SwiftData

struct JournalEntrySheet: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    @State private var content: String = ""
    @State private var mood: JournalMood = .neutral
    @State private var selectedPrompt: String?
    
    private var currentHabit: Habit? { habits.first }
    
    private var theme: HabitModeTheme {
        HabitModeTheme.theme(for: currentHabit?.habitType ?? .smoking)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Mood selector
                    moodSelector
                    
                    // Prompts
                    if let habit = currentHabit {
                        promptsSection(for: habit)
                    }
                    
                    // Content editor
                    contentEditor
                }
                .padding(Theme.Spacing.lg)
            }
            .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
            .navigationTitle("Journal Entry")
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
                        saveEntry()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accent)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    // MARK: - Mood Selector
    
    private var moodSelector: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("How are you feeling?")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            HStack(spacing: Theme.Spacing.md) {
                ForEach(JournalMood.allCases) { moodOption in
                    Button {
                        withAnimation(Theme.Animation.snappy) {
                            mood = moodOption
                        }
                    } label: {
                        VStack(spacing: Theme.Spacing.xs) {
                            Text(moodOption.emoji)
                                .font(.system(size: 32))
                            Text(moodOption.displayName)
                                .font(.labelSmall)
                                .foregroundStyle(
                                    mood == moodOption
                                        ? Color.accent
                                        : Color.textSecondary
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .fill(
                                    mood == moodOption
                                        ? Color.accent.opacity(0.15)
                                        : Color.clear
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(
                                    mood == moodOption
                                        ? Color.accent
                                        : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Prompts Section
    
    private func promptsSection(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Writing Prompts")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(prompts(for: habit.habitType), id: \.self) { prompt in
                        Button {
                            withAnimation {
                                selectedPrompt = prompt
                                if content.isEmpty {
                                    content = prompt + "\n\n"
                                }
                            }
                        } label: {
                            Text(prompt)
                                .font(.bodySmall)
                                .foregroundStyle(
                                    selectedPrompt == prompt
                                        ? .white
                                        : theme.glowColor
                                )
                                .padding(.horizontal, Theme.Spacing.md)
                                .padding(.vertical, Theme.Spacing.sm)
                                .background(
                                    Capsule()
                                        .fill(
                                            selectedPrompt == prompt
                                                ? theme.glowColor
                                                : theme.glowColor.opacity(0.15)
                                        )
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Content Editor
    
    private var contentEditor: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Your thoughts")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceElevated)
                    .frame(minHeight: 200)
                
                TextEditor(text: $content)
                    .font(.bodyMedium)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    .padding(Theme.Spacing.md)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                
                if content.isEmpty {
                    Text("Write about your journey today...")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textTertiary)
                        .padding(Theme.Spacing.md)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func saveEntry() {
        guard store.isPremiumUnlocked else {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                store.showPaywall = true
            }
            return
        }
        
        guard let habit = currentHabit else { return }
        
        let entry = JournalEntry(
            content: content,
            mood: mood,
            promptUsed: selectedPrompt ?? ""
        )
        entry.habit = habit
        
        modelContext.insert(entry)
        store.engagementManager.recordSuccessfulAction()
        
        dismiss()
    }
    
    // MARK: - Prompts Data
    
    private func prompts(for type: HabitType) -> [String] {
        switch type {
        case .smoking:
            return [
                "What triggered a craving today?",
                "How does breathing feel different?",
                "What will I do with the money saved?",
                "Who am I becoming without cigarettes?",
                "What made me proud today?"
            ]
        case .alcohol:
            return [
                "What social situation was challenging?",
                "How did I sleep last night?",
                "What am I learning about myself?",
                "What healthy way did I cope today?",
                "What relationships are improving?"
            ]
        case .porn:
            return [
                "What triggered an urge today?",
                "How is my focus and energy?",
                "What real connection did I make?",
                "What am I grateful for?",
                "How do I feel about myself?"
            ]
        case .socialMedia:
            return [
                "What did I do with my extra time?",
                "How present was I today?",
                "What real conversation did I have?",
                "How is my attention span?",
                "What did I accomplish offline?"
            ]
        case .gambling:
            return [
                "How did I handle an urge?",
                "What am I doing with saved money?",
                "Who supported me today?",
                "What am I rebuilding?",
                "What does financial peace feel like?"
            ]
        case .sugar:
            return [
                "How stable was my energy today?",
                "What healthy food did I enjoy?",
                "How do my cravings compare to before?",
                "What changes do I notice in my body?",
                "What meal am I most proud of?"
            ]
        case .cannabis:
            return [
                "How clear is my thinking today?",
                "What dreams did I have?",
                "How am I coping with stress naturally?",
                "What motivated me today?",
                "How is my memory improving?"
            ]
        case .caffeine:
            return [
                "How was my natural energy today?",
                "How did I sleep last night?",
                "What time did I feel most alert?",
                "How is my anxiety level?",
                "What energy boost worked naturally?"
            ]
        case .vaping:
            return [
                "How does breathing feel?",
                "What did I do instead of vaping?",
                "How strong were the cravings?",
                "What healthy habit am I building?",
                "Who noticed a positive change?"
            ]
        case .gaming:
            return [
                "What did I accomplish IRL today?",
                "Who did I spend time with?",
                "What new skill am I developing?",
                "How did I handle boredom?",
                "What real achievement am I proud of?"
            ]
        case .other:
            return [
                "How did I feel today?",
                "What triggered an urge?",
                "How did I cope with challenges?",
                "What am I grateful for?",
                "What progress am I proud of?"
            ]
        }
    }
}

#Preview {
    JournalEntrySheet()
        .environment(AppStore())
        .modelContainer(for: [Habit.self, JournalEntry.self], inMemory: true)
}
