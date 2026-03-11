# Quitto - Break Free, Stay Free

**A beautiful, AI-powered habit-quitting companion for iOS**

Quitto helps users break harmful habits like smoking, alcohol, procrastination, and more through intelligent tracking, AI coaching, and meaningful rewards.

## Features

### Core Features
- **Smart Habit Tracking** - Track multiple habits with detailed progress metrics
- **AI Coach** - Personalized support powered by on-device ML and optional cloud AI
- **Milestone Rewards** - Celebrate achievements with unlockable badges and rewards
- **Daily Reflections** - Journal your journey with guided prompts
- **Progress Visualization** - Beautiful charts showing your transformation

### AI-Powered Features
- **Craving Prediction** - ML model predicts high-risk moments
- **Smart Notifications** - Contextual support when you need it most
- **Personalized Insights** - AI analyzes patterns and provides tailored advice
- **Motivational Messages** - Dynamic encouragement based on your progress

### Technical Stack
- **iOS 18+** (iOS 26 optimized)
- **Swift 6** with strict concurrency
- **SwiftUI** with modern APIs
- **SwiftData** for persistence
- **Core ML** for on-device predictions
- **OpenAI API** for advanced coaching (optional)
- **WidgetKit** for home screen widgets
- **Live Activities** for real-time progress

## Architecture

```
Quitto/
├── App/
│   └── QuittoApp.swift
├── Core/
│   ├── Theme.swift
│   ├── Color+Extensions.swift
│   └── Components.swift
├── Models/
│   ├── Habit.swift
│   ├── Milestone.swift
│   ├── JournalEntry.swift
│   └── UserProfile.swift
├── Stores/
│   └── AppStore.swift
├── Services/
│   ├── AICoachService.swift
│   ├── NotificationService.swift
│   └── AnalyticsService.swift
├── Views/
│   ├── Onboarding/
│   ├── Dashboard/
│   ├── Coach/
│   ├── Journal/
│   └── Settings/
└── Widgets/
    └── QuittoWidget.swift
```

## Setup

1. Open `Quitto.xcodeproj` in Xcode 16+
2. Set your development team
3. (Optional) Add OpenAI API key to enable cloud AI features
4. Build and run on simulator or device

## Design Philosophy

Quitto embraces a warm, encouraging aesthetic that makes users feel supported—not judged. The design uses:
- Soft gradients that evolve with progress
- Gentle animations celebrating milestones
- Dark mode that feels calm, not clinical
- Accessibility-first approach

---

*Built with ❤️ for a healthier future*
