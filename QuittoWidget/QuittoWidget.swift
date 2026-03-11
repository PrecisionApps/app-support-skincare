//
//  QuittoWidget.swift
//  QuittoWidget
//

import WidgetKit
import SwiftUI

// MARK: - App Group Configuration

private let appGroupIdentifier = "group.com.quitto.shared"

private enum WidgetKeys {
    static let daysSinceQuit = "widget_days_since_quit"
    static let habitName = "widget_habit_name"
    static let habitIcon = "widget_habit_icon"
    static let habitTypeRaw = "widget_habit_type"
    static let moneySaved = "widget_money_saved"
    static let streakDays = "widget_streak_days"
    static let progressToNextMilestone = "widget_progress"
    static let nextMilestoneName = "widget_next_milestone"
    static let unitsAvoided = "widget_units_avoided"
    static let quitDate = "widget_quit_date"
    static let dailyAmount = "widget_daily_amount"
    static let costPerUnit = "widget_cost_per_unit"
    static let lastUpdated = "widget_last_updated"
}

// MARK: - Widget Entry

struct QuittoEntry: TimelineEntry {
    let date: Date
    let daysSinceQuit: Int
    let habitName: String
    let habitIcon: String
    let habitTypeRaw: String
    let moneySaved: Double
    let streakDays: Int
    let unitsAvoided: Int
    let progressToNextMilestone: Double
    let nextMilestoneName: String
    let isEmpty: Bool
    
    var habitColor: Color {
        habitColorForType(habitTypeRaw)
    }
    
    static var placeholder: QuittoEntry {
        QuittoEntry(
            date: Date(),
            daysSinceQuit: 14,
            habitName: "Smoking",
            habitIcon: "smoke.fill",
            habitTypeRaw: "smoking",
            moneySaved: 140.00,
            streakDays: 14,
            unitsAvoided: 140,
            progressToNextMilestone: 0.7,
            nextMilestoneName: "30 Days",
            isEmpty: false
        )
    }
    
    static var empty: QuittoEntry {
        QuittoEntry(
            date: Date(),
            daysSinceQuit: 0,
            habitName: "No habit",
            habitIcon: "leaf.fill",
            habitTypeRaw: "other",
            moneySaved: 0,
            streakDays: 0,
            unitsAvoided: 0,
            progressToNextMilestone: 0,
            nextMilestoneName: "Start tracking",
            isEmpty: true
        )
    }
}

// Helper function to get color for habit type
private func habitColorForType(_ type: String) -> Color {
    switch type {
    case "smoking": return Color(red: 0.9, green: 0.4, blue: 0.3)
    case "alcohol": return Color(red: 0.6, green: 0.4, blue: 0.8)
    case "caffeine": return Color(red: 0.6, green: 0.4, blue: 0.2)
    case "sugar": return Color(red: 0.9, green: 0.4, blue: 0.6)
    case "socialMedia": return Color(red: 0.2, green: 0.5, blue: 0.9)
    case "procrastination": return Color(red: 0.9, green: 0.7, blue: 0.2)
    case "gambling": return Color(red: 0.8, green: 0.2, blue: 0.2)
    case "junkFood": return Color(red: 0.9, green: 0.6, blue: 0.2)
    case "shopping": return Color(red: 0.8, green: 0.3, blue: 0.6)
    case "gaming": return Color(red: 0.5, green: 0.3, blue: 0.8)
    default: return Color(red: 0.2, green: 0.7, blue: 0.5)
    }
}

// MARK: - Timeline Provider

struct QuittoTimelineProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> QuittoEntry {
        .placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QuittoEntry) -> Void) {
        let entry = loadFromSharedDefaults()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuittoEntry>) -> Void) {
        let entry = loadFromSharedDefaults()
        
        // Update every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    private func loadFromSharedDefaults() -> QuittoEntry {
        guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
            return .empty
        }
        
        let habitName = defaults.string(forKey: WidgetKeys.habitName) ?? ""
        
        // If no habit name, return empty state
        guard !habitName.isEmpty else {
            return .empty
        }
        
        // Calculate days since quit from stored quit date for accuracy
        var daysSinceQuit = defaults.integer(forKey: WidgetKeys.daysSinceQuit)
        if let quitTimestamp = defaults.object(forKey: WidgetKeys.quitDate) as? Double {
            let quitDate = Date(timeIntervalSince1970: quitTimestamp)
            daysSinceQuit = max(0, Calendar.current.dateComponents([.day], from: quitDate, to: Date()).day ?? 0)
        }
        
        // Calculate money saved dynamically
        let dailyAmount = defaults.integer(forKey: WidgetKeys.dailyAmount)
        let costPerUnit = defaults.double(forKey: WidgetKeys.costPerUnit)
        let moneySaved = Double(daysSinceQuit * dailyAmount) * costPerUnit
        
        return QuittoEntry(
            date: Date(),
            daysSinceQuit: daysSinceQuit,
            habitName: habitName,
            habitIcon: defaults.string(forKey: WidgetKeys.habitIcon) ?? "leaf.fill",
            habitTypeRaw: defaults.string(forKey: WidgetKeys.habitTypeRaw) ?? "other",
            moneySaved: moneySaved,
            streakDays: defaults.integer(forKey: WidgetKeys.streakDays),
            unitsAvoided: daysSinceQuit * dailyAmount,
            progressToNextMilestone: defaults.double(forKey: WidgetKeys.progressToNextMilestone),
            nextMilestoneName: defaults.string(forKey: WidgetKeys.nextMilestoneName) ?? "First milestone",
            isEmpty: false
        )
    }
}

// MARK: - Small Widget View

struct QuittoWidgetSmallView: View {
    let entry: QuittoEntry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: entry.habitIcon)
                    .font(.system(size: 16))
                    .foregroundStyle(entry.habitColor)
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.orange)
                
                Text("\(entry.streakDays)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.orange)
            }
            
            Spacer()
            
            Text("\(entry.daysSinceQuit)")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text(entry.daysSinceQuit == 1 ? "day" : "days")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Medium Widget View

struct QuittoWidgetMediumView: View {
    let entry: QuittoEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - main counter
            VStack(spacing: 4) {
                Image(systemName: entry.habitIcon)
                    .font(.system(size: 24))
                    .foregroundStyle(entry.habitColor)
                
                Text("\(entry.daysSinceQuit)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(entry.daysSinceQuit == 1 ? "day clean" : "days clean")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            // Right side - stats
            VStack(alignment: .leading, spacing: 12) {
                StatRow(icon: "flame.fill", color: .orange, title: "Streak", value: "\(entry.streakDays) days")
                
                if entry.moneySaved > 0 {
                    StatRow(icon: "dollarsign.circle.fill", color: .green, title: "Saved", value: "$\(Int(entry.moneySaved))")
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next: \(entry.nextMilestoneName)")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 6)
                            
                            Capsule()
                                .fill(LinearGradient(colors: [.green.opacity(0.8), .green], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * entry.progressToNextMilestone, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct StatRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(color)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - Large Widget View

struct QuittoWidgetLargeView: View {
    let entry: QuittoEntry
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: entry.habitIcon)
                    .font(.system(size: 20))
                    .foregroundStyle(entry.habitColor)
                
                Text(entry.habitName)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("\(entry.streakDays)")
                        .fontWeight(.semibold)
                }
                .font(.system(size: 14))
            }
            
            // Main counter
            VStack(spacing: 4) {
                Text("\(entry.daysSinceQuit)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(entry.daysSinceQuit == 1 ? "day clean" : "days clean")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            
            // Progress
            VStack(spacing: 8) {
                HStack {
                    Text("Progress to \(entry.nextMilestoneName)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(entry.progressToNextMilestone * 100))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.green)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(LinearGradient(colors: [.green.opacity(0.8), .green], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * entry.progressToNextMilestone, height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            // Stats grid
            HStack(spacing: 16) {
                if entry.moneySaved > 0 {
                    LargeStatCard(icon: "dollarsign.circle.fill", color: .green, title: "Saved", value: "$\(Int(entry.moneySaved))")
                }
                
                LargeStatCard(icon: "xmark.circle.fill", color: entry.habitColor, title: "Avoided", value: "\(entry.unitsAvoided)")
                
                LargeStatCard(icon: "clock.fill", color: .blue, title: "Hours", value: "\(entry.daysSinceQuit * 24)")
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct LargeStatCard: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Widget Configuration

struct QuittoWidget: Widget {
    let kind: String = "QuittoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuittoTimelineProvider()) { entry in
            QuittoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quitto Progress")
        .description("Track your progress in quitting harmful habits.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct QuittoWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: QuittoEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            QuittoWidgetSmallView(entry: entry)
        case .systemMedium:
            QuittoWidgetMediumView(entry: entry)
        case .systemLarge:
            QuittoWidgetLargeView(entry: entry)
        default:
            QuittoWidgetSmallView(entry: entry)
        }
    }
}

// MARK: - Widget Bundle

@main
struct QuittoWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuittoWidget()
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    QuittoWidget()
} timeline: {
    QuittoEntry.placeholder
}

#Preview("Medium", as: .systemMedium) {
    QuittoWidget()
} timeline: {
    QuittoEntry.placeholder
}

#Preview("Large", as: .systemLarge) {
    QuittoWidget()
} timeline: {
    QuittoEntry.placeholder
}
