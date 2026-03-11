//
//  ContentView.swift
//  Quitto
//
//  Created by Kaan Yıldız on 28.11.2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            if store.showOnboarding {
                OnboardingView()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(Theme.Animation.default, value: store.showOnboarding)
    }
}

#Preview {
    RootView()
        .environment(AppStore())
        .modelContainer(for: [Habit.self, UserProfile.self], inMemory: true)
}
