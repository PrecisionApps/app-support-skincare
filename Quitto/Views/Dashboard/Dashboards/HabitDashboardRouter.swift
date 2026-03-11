//
//  HabitDashboardRouter.swift
//  Quitto
//
//  Routes to the correct habit-specific dashboard based on habit type
//

import SwiftUI

struct HabitDashboardRouter: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    
    var body: some View {
        Group {
            switch habit.habitType {
            case .smoking:
                SmokingDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .alcohol:
                AlcoholDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .porn:
                PornDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .socialMedia:
                SocialMediaDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .gambling:
                GamblingDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .sugar:
                SugarDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .cannabis:
                CannabisDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .caffeine:
                CaffeineDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .vaping:
                VapingDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .gaming:
                GamingDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
                
            case .other:
                GenericDashboard(
                    habit: habit,
                    showCravingSheet: $showCravingSheet,
                    showJournalSheet: $showJournalSheet
                )
            }
        }
    }
}

// MARK: - Generic Dashboard for Other Habits

struct GenericDashboard: View {
    let habit: Habit
    @Binding var showCravingSheet: Bool
    @Binding var showJournalSheet: Bool
    @State private var showEmergency = false
    @State private var animateProgress = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                HeroTimerCard(habit: habit, animateProgress: animateProgress)
                
                ModeMotivationalBanner(habit: habit)
                
                ModeStatsHeader(habit: habit)
                
                SavingsCard(habit: habit, showMoney: habit.moneySaved > 0, showTime: true)
                
                ModeDailyInsightCard(habit: habit)
                
                UnitsAvoidedCard(habit: habit)
                
                RecoveryPhaseCard(habit: habit)
                
                MilestoneTimeline(habit: habit, showAll: false)
                
                QuickActionsBar(
                    habitType: .other,
                    onCravingTap: { showCravingSheet = true },
                    onJournalTap: { showJournalSheet = true },
                    onEmergencyTap: { showEmergency = true }
                )
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, 100)
        }
        .onAppear {
            withAnimation(Theme.Animation.slow.delay(0.3)) {
                animateProgress = true
            }
        }
        .sheet(isPresented: $showEmergency) {
            EmergencyInterventionSheet(habitType: .other)
        }
    }
}

// MARK: - Dashboard Preview Provider

struct HabitDashboardRouter_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(HabitType.allCases) { habitType in
            NavigationStack {
                HabitDashboardRouter(
                    habit: previewHabit(for: habitType),
                    showCravingSheet: .constant(false),
                    showJournalSheet: .constant(false)
                )
                .navigationTitle(habitType.displayName)
            }
            .previewDisplayName(habitType.displayName)
        }
    }
    
    static func previewHabit(for type: HabitType) -> Habit {
        Habit(
            name: type.displayName,
            type: type,
            quitDate: Date().addingTimeInterval(-Double.random(in: 1...90) * 24 * 3600),
            dailyAmount: type.defaultDailyAmount,
            costPerUnit: type.defaultCostPerUnit,
            motivation: "For a better life"
        )
    }
}
