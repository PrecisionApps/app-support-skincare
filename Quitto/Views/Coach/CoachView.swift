//
//  CoachView.swift
//  Quitto
//

import SwiftUI
import SwiftData

struct CoachView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    @State private var messageText: String = ""
    @State private var scrollProxy: ScrollViewProxy?
    @State private var showSourcesSheet = false
    @FocusState private var isTextFieldFocused: Bool
    
    private var currentHabit: Habit? { habits.first }
    
    /// Whether the AI is actively processing (typing indicator OR streaming tokens).
    private var isBusy: Bool {
        store.isAITyping || !store.streamingContent.isEmpty
    }
    
    /// Static preview messages shown to free users to demonstrate AI Coach value.
    private static let previewMessages: [(content: String, isFromUser: Bool)] = [
        ("Hi! I'm starting my journey to quit. Can you help me?", true),
        ("Absolutely — I'm here for you every step of the way. Quitting takes real courage, and the fact that you're here means you've already taken the hardest step.\n\nLet me ask: what's the **number one reason** you want to quit? Knowing your 'why' is the foundation we'll build everything on.", false),
        ("I keep relapsing when I'm stressed at work", true),
        ("Stress is one of the most common triggers — you're not alone in this. Here's what we can do:\n\n1. **Identify the pattern** — we'll track exactly when stress hits hardest\n2. **Build a replacement ritual** — something that gives you the same relief\n3. **Practice the 4-7-8 technique** — breathe in for 4s, hold for 7s, out for 8s\n\nNext time you feel that urge at work, message me immediately. I'll walk you through it in real time.", false),
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messagesScrollView
                
                inputBar
            }
            .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
            .navigationTitle("AI Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSourcesSheet = true
                    } label: {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                if store.isPremiumUnlocked && !store.aiMessages.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button(role: .destructive) {
                                store.clearAIMessages()
                            } label: {
                                Label("Clear Chat", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSourcesSheet) {
                SourcesSheetView(habitName: currentHabit?.habitType.displayName ?? "General")
            }
        }
        .onAppear {
            if store.isPremiumUnlocked {
                store.loadAIMessages()
                if store.aiMessages.isEmpty {
                    sendInitialGreeting()
                }
            }
        }
    }
    
    // MARK: - Messages Scroll View
    
    private var messagesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.md) {
                    // Medical disclaimer banner
                    MedicalDisclaimerBanner(compact: true)
                        .padding(.bottom, Theme.Spacing.xs)
                    
                    if store.isPremiumUnlocked {
                        // Real messages for premium users
                        ForEach(store.aiMessages, id: \.id) { message in
                            if !message.isFromUser,
                               message.id == store.aiMessages.last?.id,
                               !store.streamingContent.isEmpty {
                                MessageBubble(
                                    message: message,
                                    overrideContent: store.streamingContent
                                )
                                .id(message.id)
                            } else {
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        
                        if store.isAITyping {
                            TypingIndicator()
                                .id("typing")
                        }
                    } else {
                        // Preview conversation for free users — shows what the coach can do
                        ForEach(Array(Self.previewMessages.enumerated()), id: \.offset) { index, preview in
                            PreviewMessageBubble(
                                content: preview.content,
                                isFromUser: preview.isFromUser
                            )
                            .id("preview_\(index)")
                        }
                        
                        // Subtle unlock prompt at the bottom
                        premiumTeaser
                            .id("teaser")
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.top, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.lg)
            }
            .onAppear {
                scrollProxy = proxy
            }
            .onChange(of: store.aiMessages.count) { _, _ in
                scrollToBottom()
            }
            .onChange(of: store.isAITyping) { _, _ in
                scrollToBottom()
            }
            .onChange(of: store.streamingContent) { _, _ in
                scrollToBottom()
            }
        }
    }
    
    /// A subtle card at the bottom of the preview conversation that entices upgrade.
    private var premiumTeaser: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.accent)
                
                Text("This is a preview conversation")
                    .font(.labelMedium)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Text("Unlock your personal AI coach to get 24/7 support tailored to your triggers, habits, and recovery journey.")
                .font(.bodySmall)
                .foregroundStyle(Color.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.lg)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(Color.accent.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .stroke(Color.accent.opacity(0.12), lineWidth: 1)
                )
        )
        .padding(.top, Theme.Spacing.md)
    }
    
    private func scrollToBottom() {
        withAnimation(Theme.Animation.default) {
            if store.isAITyping {
                scrollProxy?.scrollTo("typing", anchor: .bottom)
            } else if let lastMessage = store.aiMessages.last {
                scrollProxy?.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    // MARK: - Input Bar
    
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: Theme.Spacing.sm) {
                // Quick actions
                Menu {
                    Button {
                        sendMessage("I'm having a craving right now")
                    } label: {
                        Label("Having a craving", systemImage: "exclamationmark.triangle")
                    }
                    
                    Button {
                        sendMessage("How am I doing so far?")
                    } label: {
                        Label("Check my progress", systemImage: "chart.bar")
                    }
                    
                    Button {
                        sendMessage("I need some motivation")
                    } label: {
                        Label("Need motivation", systemImage: "heart")
                    }
                    
                    Button {
                        sendMessage("I'm feeling stressed")
                    } label: {
                        Label("Feeling stressed", systemImage: "cloud.rain")
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(isBusy ? Color.textTertiary : Color.accent)
                }
                .disabled(isBusy)
                
                // Text field
                TextField("Message your coach...", text: $messageText, axis: .vertical)
                    .font(.bodyMedium)
                    .lineLimit(1...4)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .fill(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                    )
                    .focused($isTextFieldFocused)
                
                // Send button
                Button {
                    sendMessage(messageText)
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? Color.textTertiary
                                : Color.accent
                        )
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isBusy)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
        }
    }
    
    // MARK: - Actions
    
    private func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Gate: free users see the UI but can't send
        guard store.isPremiumUnlocked else {
            store.showPaywall = true
            return
        }
        
        messageText = ""
        isTextFieldFocused = false
        
        Task {
            await store.sendAIMessage(trimmed, forHabit: currentHabit)
        }
    }
    
    private func sendInitialGreeting() {
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            await store.sendAIMessage("Hi! I'm starting my journey to quit. Can you help me?", forHabit: currentHabit)
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: CoachMessage
    var overrideContent: String? = nil
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var displayContent: String {
        let raw = overrideContent ?? message.content
        return raw.isEmpty ? " " : raw
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            if message.isFromUser {
                Spacer(minLength: 60)
            } else {
                coachAvatar
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: Theme.Spacing.xs) {
                Text(markdownAttributed(displayContent))
                    .font(.bodyMedium)
                    .foregroundStyle(
                        message.isFromUser
                            ? .white
                            : (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    )
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(
                        message.isFromUser
                            ? AnyShapeStyle(LinearGradient.accentGradient)
                            : AnyShapeStyle(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    )
                    .animation(.easeOut(duration: 0.05), value: displayContent)
                
                if overrideContent == nil {
                    Text(message.timestamp, style: .time)
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                }
            }
            
            if !message.isFromUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    private func markdownAttributed(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            ?? AttributedString(text)
    }
    
    private var coachAvatar: some View {
        ZStack {
            Circle()
                .fill(LinearGradient.accentGradient)
                .frame(width: 36, height: 36)
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview Message Bubble (for free users)

struct PreviewMessageBubble: View {
    let content: String
    let isFromUser: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            if isFromUser {
                Spacer(minLength: 60)
            } else {
                coachAvatar
            }
            
            VStack(alignment: isFromUser ? .trailing : .leading, spacing: Theme.Spacing.xs) {
                Text(markdownAttributed(content))
                    .font(.bodyMedium)
                    .foregroundStyle(
                        isFromUser
                            ? .white
                            : (colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    )
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(
                        isFromUser
                            ? AnyShapeStyle(LinearGradient.accentGradient)
                            : AnyShapeStyle(colorScheme == .dark ? Color.surfaceDarkSecondary : Color.surfaceSecondary)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    )
            }
            
            if !isFromUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    private func markdownAttributed(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            ?? AttributedString(text)
    }
    
    private var coachAvatar: some View {
        ZStack {
            Circle()
                .fill(LinearGradient.accentGradient)
                .frame(width: 36, height: 36)
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(LinearGradient.accentGradient)
                    .frame(width: 36, height: 36)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.textTertiary)
                        .frame(width: 8, height: 8)
                        .offset(y: animationOffset(for: index))
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.md)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever()) {
                animationPhase = 1
            }
        }
    }
    
    private func animationOffset(for index: Int) -> CGFloat {
        let delay = CGFloat(index) * 0.15
        let phase = (animationPhase + delay).truncatingRemainder(dividingBy: 1)
        return sin(phase * .pi * 2) * 4
    }
}

#Preview {
    CoachView()
        .environment(AppStore())
        .modelContainer(for: [Habit.self, CoachMessage.self], inMemory: true)
}
