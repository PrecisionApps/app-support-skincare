# Quitto Design System

## Brand Identity

**Mission**: Empower users to break free from harmful habits with compassion and intelligence.

**Tone**: Warm, supportive, non-judgmental, celebratory of progress.

## Color System

### Primary Palette (Light Mode)
| Token | HSL | Hex | Usage |
|-------|-----|-----|-------|
| `accent` | 162° 84% 39% | #10B981 | CTAs, success states, progress |
| `accentLight` | 160° 60% 45% | #2DD4A8 | Highlights, gradients |
| `accentDark` | 164° 86% 28% | #0A7B55 | Pressed states |

### Secondary Palette
| Token | HSL | Hex | Usage |
|-------|-----|-----|-------|
| `warmth` | 24° 95% 64% | #F59E5C | Encouragement, warmth |
| `calm` | 217° 91% 60% | #3B82F6 | Information, AI features |
| `alert` | 0° 84% 60% | #EF4444 | Warnings, cravings |

### Neutral Palette
| Token | HSL | Hex | Usage |
|-------|-----|-----|-------|
| `surface` | 210° 40% 98% | #F8FAFC | Backgrounds |
| `surfaceSecondary` | 214° 32% 91% | #E2E8F0 | Cards, inputs |
| `textPrimary` | 222° 47% 11% | #0F172A | Headlines |
| `textSecondary` | 215° 16% 47% | #64748B | Body text |
| `textTertiary` | 215° 20% 65% | #94A3B8 | Captions |

### Dark Mode Adjustments
- Surfaces shift to deep slate (220° 13% 10%)
- Accent brightness reduced by 10% for eye comfort
- Text colors inverted with proper contrast ratios (4.5:1 minimum)

## Typography

**Primary Font**: SF Pro (system default)

| Style | Weight | Size | Line Height | Tracking |
|-------|--------|------|-------------|----------|
| `largeTitle` | Bold | 34pt | 41pt | 0.37 |
| `title` | Semibold | 28pt | 34pt | 0.36 |
| `title2` | Semibold | 22pt | 28pt | 0.35 |
| `title3` | Semibold | 20pt | 25pt | 0.38 |
| `headline` | Semibold | 17pt | 22pt | -0.41 |
| `body` | Regular | 17pt | 22pt | -0.41 |
| `callout` | Regular | 16pt | 21pt | -0.32 |
| `subheadline` | Regular | 15pt | 20pt | -0.24 |
| `footnote` | Regular | 13pt | 18pt | -0.08 |
| `caption` | Regular | 12pt | 16pt | 0 |

### Numeric Display
- Progress counters: SF Pro Rounded Bold
- Streak numbers: Monospaced variants for alignment

## Spacing System (8pt Grid)

| Token | Value |
|-------|-------|
| `spacing.xs` | 4pt |
| `spacing.sm` | 8pt |
| `spacing.md` | 16pt |
| `spacing.lg` | 24pt |
| `spacing.xl` | 32pt |
| `spacing.xxl` | 48pt |
| `spacing.xxxl` | 64pt |

## Corner Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radius.sm` | 8pt | Small chips, tags |
| `radius.md` | 12pt | Buttons, inputs |
| `radius.lg` | 16pt | Cards |
| `radius.xl` | 24pt | Modals, sheets |
| `radius.pill` | 9999pt | Pills, toggles |

## Shadows

| Token | Values | Usage |
|-------|--------|-------|
| `shadow.sm` | 0 1px 2px rgba(0,0,0,0.05) | Subtle lift |
| `shadow.md` | 0 4px 6px rgba(0,0,0,0.07) | Cards |
| `shadow.lg` | 0 10px 15px rgba(0,0,0,0.1) | Modals |
| `shadow.glow` | 0 0 20px accent@30% | Focus, celebration |

## Motion

### Timing Functions
- **Default**: `.spring(response: 0.35, dampingFraction: 0.7)`
- **Bouncy**: `.spring(response: 0.5, dampingFraction: 0.6)`
- **Snappy**: `.spring(response: 0.25, dampingFraction: 0.8)`

### Animation Durations
- **Micro**: 150ms (button feedback)
- **Short**: 250ms (transitions)
- **Medium**: 400ms (page transitions)
- **Long**: 600ms (celebrations)

### Principles
1. Every animation must be state-driven
2. Respect Reduced Motion accessibility setting
3. Celebrate milestones with particle effects and haptics
4. Use matched geometry for hero transitions

## Iconography

- **Style**: SF Symbols 6+ (filled style preferred)
- **Size**: 20pt default, 24pt for navigation
- **Animation**: SymbolEffect for state changes

### Core Icons
| Feature | Symbol |
|---------|--------|
| Dashboard | `chart.bar.fill` |
| AI Coach | `brain.head.profile` |
| Journal | `book.fill` |
| Milestones | `trophy.fill` |
| Settings | `gearshape.fill` |
| Streak | `flame.fill` |
| Money Saved | `dollarsign.circle.fill` |
| Time Saved | `clock.fill` |

## Component Patterns

### Cards
- Background: `surfaceSecondary` with 60% opacity blur
- Border: 1pt `textTertiary` @ 10% opacity
- Corner radius: `radius.lg`
- Padding: `spacing.md`

### Buttons
- **Primary**: Solid accent background, white text, pill shape
- **Secondary**: Accent stroke, transparent fill
- **Ghost**: Text only with tappable padding
- Minimum tap target: 44x44pt

### Progress Indicators
- Circular: Stroke width 8pt, rounded caps
- Linear: Height 8pt, rounded ends
- Animated with spring timing

## Accessibility

- Minimum contrast ratio: 4.5:1 (AA compliant)
- Support for Dynamic Type (up to xxxLarge)
- VoiceOver labels on all interactive elements
- Reduced Motion alternatives for all animations
- High Contrast mode support

## Gradient Recipes

### Progress Gradient (MeshGradient)
```
Points: (0,0), (1,0), (0,1), (1,1)
Colors: accentLight → accent → warmth → accent
```

### Background Gradient
```
LinearGradient:
  - surface (top)
  - surfaceSecondary (bottom)
  - angle: 180°
```

### Celebration Gradient
```
MeshGradient with animated points
Colors: accent, warmth, calm (low saturation)
```
