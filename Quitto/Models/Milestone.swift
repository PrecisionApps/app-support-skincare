//
//  Milestone.swift
//  Quitto
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Milestone {
    var id: UUID
    var title: String
    var descriptionText: String
    var daysRequired: Int
    var achievedDate: Date?
    var isUnlocked: Bool
    var badgeIcon: String
    var celebrationShown: Bool
    
    var habit: Habit?
    
    init(
        title: String,
        description: String,
        daysRequired: Int,
        badgeIcon: String
    ) {
        self.id = UUID()
        self.title = title
        self.descriptionText = description
        self.daysRequired = daysRequired
        self.achievedDate = nil
        self.isUnlocked = false
        self.badgeIcon = badgeIcon
        self.celebrationShown = false
    }
    
    func unlock() {
        guard !isUnlocked else { return }
        isUnlocked = true
        achievedDate = Date()
    }
}

// MARK: - Milestone Templates

struct MilestoneTemplate {
    let title: String
    let description: String
    let daysRequired: Int
    let badgeIcon: String
    
    static let standard: [MilestoneTemplate] = [
        MilestoneTemplate(
            title: "First Step",
            description: "You've made it through day one. The hardest part is starting.",
            daysRequired: 1,
            badgeIcon: "star.fill"
        ),
        MilestoneTemplate(
            title: "Three Days Strong",
            description: "72 hours in. The worst withdrawal symptoms are behind you.",
            daysRequired: 3,
            badgeIcon: "flame.fill"
        ),
        MilestoneTemplate(
            title: "One Week Wonder",
            description: "A full week! Your body is thanking you.",
            daysRequired: 7,
            badgeIcon: "medal.fill"
        ),
        MilestoneTemplate(
            title: "Two Weeks",
            description: "Two weeks of freedom. New habits are forming.",
            daysRequired: 14,
            badgeIcon: "shield.fill"
        ),
        MilestoneTemplate(
            title: "Monthly Master",
            description: "30 days! You've proven you can do this.",
            daysRequired: 30,
            badgeIcon: "crown.fill"
        ),
        MilestoneTemplate(
            title: "Two Months",
            description: "60 days of growth and healing.",
            daysRequired: 60,
            badgeIcon: "bolt.shield.fill"
        ),
        MilestoneTemplate(
            title: "Quarter Year",
            description: "90 days—a true transformation is happening.",
            daysRequired: 90,
            badgeIcon: "trophy.fill"
        ),
        MilestoneTemplate(
            title: "Half Year Hero",
            description: "6 months! You're a completely different person.",
            daysRequired: 180,
            badgeIcon: "heart.circle.fill"
        ),
        MilestoneTemplate(
            title: "One Year Champion",
            description: "365 days. You did it. You're free.",
            daysRequired: 365,
            badgeIcon: "sparkles"
        )
    ]
    
    static func generateMilestones() -> [Milestone] {
        standard.map { template in
            Milestone(
                title: template.title,
                description: template.description,
                daysRequired: template.daysRequired,
                badgeIcon: template.badgeIcon
            )
        }
    }
}

// MARK: - Badge Display

struct BadgeView: View {
    let milestone: Milestone
    let size: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(_ milestone: Milestone, size: CGFloat = 60) {
        self.milestone = milestone
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    milestone.isUnlocked
                        ? LinearGradient.accentGradient
                        : LinearGradient(colors: [Color.textTertiary.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: size, height: size)
            
            if milestone.isUnlocked {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: size - 4, height: size - 4)
            }
            
            Image(systemName: milestone.badgeIcon)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundStyle(
                    milestone.isUnlocked
                        ? .white
                        : Color.textTertiary.opacity(0.5)
                )
        }
        .modifier(milestone.isUnlocked ? Theme.shadow(.glow) : Theme.shadow(.sm))
    }
}
