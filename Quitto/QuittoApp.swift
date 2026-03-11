//
//  QuittoApp.swift
//  Quitto
//
//  Created by Kaan Yıldız on 28.11.2025.
//

import SwiftUI
import SwiftData
import RevenueCat

@main
struct QuittoApp: App {
    @State private var appStore = AppStore()
    
    init() {
        Purchases.logLevel = .warn
        Purchases.configure(withAPIKey: AppConstants.Purchases.apiKey)
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            CravingLog.self,
            Milestone.self,
            JournalEntry.self,
            UserProfile.self,
            CoachMessage.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appStore)
                .onOpenURL { url in
                    appStore.handleDeepLink(url)
                }
                .onAppear {
                    appStore.configure(with: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
