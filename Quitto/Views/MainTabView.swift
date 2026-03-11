//
//  MainTabView.swift
//  Quitto
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        @Bindable var store = store
        
        TabView(selection: $store.selectedTab) {
            DashboardView()
                .tag(AppTab.dashboard)
                .tabItem {
                    Label(AppTab.dashboard.title, systemImage: AppTab.dashboard.icon)
                }
            
            CoachView()
                .tag(AppTab.coach)
                .tabItem {
                    Label(AppTab.coach.title, systemImage: AppTab.coach.icon)
                }
            
            JournalView()
                .tag(AppTab.journal)
                .tabItem {
                    Label(AppTab.journal.title, systemImage: AppTab.journal.icon)
                }
            
            MilestonesView()
                .tag(AppTab.milestones)
                .tabItem {
                    Label(AppTab.milestones.title, systemImage: AppTab.milestones.icon)
                }
        }
        .tint(Color.accent)
        .toolbar(store.selectedTab == .coach ? .hidden : .visible, for: .tabBar)
        .animation(.easeInOut(duration: 0.25), value: store.selectedTab)
        .sheet(isPresented: $store.showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $store.showJournalSheet) {
            NewJournalEntrySheet()
                .presentationDetents([.large])
        }
        
        .alert("Milestone Achieved!", isPresented: $store.showMilestoneAlert) {
            Button("Celebrate!") {
                store.showMilestoneAlert = false
            }
        } message: {
            if let milestone = store.recentMilestone {
                Text("\(milestone.title): \(milestone.descriptionText)")
            }
        }
        .alert(
            "Help Shape Quitto \u{2728}",
            isPresented: Binding(
                get: { store.engagementManager.showTikTokCTAForActions },
                set: { store.engagementManager.showTikTokCTAForActions = $0 }
            )
        ) {
            Button("Follow on TikTok") {
                store.engagementManager.openTikTok()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("Request features, report bugs, and get behind-the-scenes updates. Your feedback directly shapes the app!")
        }
        .alert(
            "Join Our Community \u{1F31F}",
            isPresented: Binding(
                get: { store.engagementManager.showTikTokCTAForChurn },
                set: { store.engagementManager.showTikTokCTAForChurn = $0 }
            )
        ) {
            Button("Follow on TikTok") {
                store.engagementManager.openTikTok()
            }
            Button("Not Now", role: .cancel) { }
        } message: {
            Text("Get daily motivation, recovery tips, and connect with thousands on the same journey. Follow us on TikTok!")
        }
        .sheet(isPresented: $store.showPaywall) {
            PaywallView(
                userName: "",
                habitType: store.currentHabit?.habitType,
                packages: store.onboardingPackages,
                onPurchase: { package in
                    Task {
                        await store.purchasePackage(package)
                    }
                },
                onRestore: {
                    Task {
                        await store.restorePurchases()
                    }
                },
                onContinueFree: {
                    store.showPaywall = false
                },
                isOnboarding: false
            )
            .interactiveDismissDisabled()
        }
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        if colorScheme == .dark {
            appearance.backgroundColor = UIColor(Color.surfaceDark)
        } else {
            appearance.backgroundColor = UIColor(Color.surfaceElevated)
        }
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environment(AppStore())
        .modelContainer(for: [Habit.self, UserProfile.self], inMemory: true)
}
