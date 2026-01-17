# Percepta - Claude Code Instructions

## Product Identity

Percepta is not an app that predicts markets or recommends trades. It is a **Thinking Desk** that reflects how users perceive the economy and how their thinking evolves over time. The goal is not action optimization, but **cognitive alignment**.

## Core Philosophy

- Track perception, not performance
- Speak every day, but adjust tone by user state
- Guide direction without recommending actions
- Usage is tracked, never judged
- Silence is a valid state
- Reduce information, preserve the Why

## Target User

People who have just started learning economics or investing, feel constant uncertainty, and are overwhelmed by news. Percepta first stabilizes perception before anything else.

---

## Technical Constraints

- **Platform**: iPadOS 18.2+ (iPad-first)
- **Language**: Swift 5.0
- **Framework**: SwiftUI only
- **Architecture**: MVVM
- **Storage**: Local-only (UserDefaults + Codable)
- **Backend**: None
- **Analytics**: None (local event logging only)
- **Logic**: Rule-based

---

## Project Structure

```
Percepta/
├── App/
│   └── PerceptaApp.swift
│
├── DesignSystem/
│   ├── Colors.swift           # Deep Teal theme
│   ├── Typography.swift       # iPad-oriented fonts
│   ├── Spacing.swift          # 8pt grid
│   └── Shadows.swift
│
├── Components/
│   ├── Cards/DSCard.swift
│   ├── Buttons/DSPrimaryButton.swift
│   ├── Inputs/DSTextField.swift, DSSegmentedPicker.swift
│   ├── Chips/DSChip.swift
│   └── Lists/DSListRow.swift
│
├── Features/Home/
│   ├── HomeScreen.swift
│   ├── HomeViewModel.swift
│   ├── Cards/
│   │   ├── PerceptionCheckInCard.swift
│   │   ├── InvestmentLogCard.swift
│   │   ├── MacroThinkingCard.swift
│   │   ├── DailyMacroBriefCard.swift
│   │   ├── InsightCard.swift
│   │   └── ThinkingTimelineCard.swift
│   └── Sheets/
│       ├── PerceptionSheet.swift
│       ├── InvestmentSheet.swift
│       └── MacroThinkingSheet.swift
│
├── Data/
│   ├── Models/
│   │   ├── Mood.swift                 # stable/neutral/anxious
│   │   ├── InvestmentAction.swift     # none/buy/sell/watch
│   │   ├── PerceptionEntry.swift
│   │   ├── InvestmentEntry.swift
│   │   ├── MacroThinking.swift        # Cause → Effect → Conclusion
│   │   ├── MacroBrief.swift           # 5-part daily narrative
│   │   └── Insight.swift              # Rule-based insight
│   └── Repositories/
│       ├── PerceptionRepository.swift
│       ├── InvestmentRepository.swift
│       ├── MacroThinkingRepository.swift
│       └── InsightEngine.swift
│
├── Presentation/Coordinators/
│   ├── Coordinator.swift
│   └── AppCoordinator.swift
│
└── Utils/
    ├── DateKeyHelper.swift
    └── EventLogger.swift
```

---

## Home = Thinking Desk

Home combines today's reflection and accumulated thinking in one space.

### Components (per specification):

| # | Component | Description |
|---|-----------|-------------|
| 1 | **Perception Check-in** | Mood selection (stable/neutral/anxious) + optional note |
| 2 | **Investment Log** | Action selection (none/buy/sell/watch) + optional memo |
| 3 | **Macro Thinking** | Button-based only: Cause → Effect → Conclusion |
| 4 | **Daily Macro Brief** | Always visible, 5-part narrative |
| 5 | **Insight Card** | Conditional, rule-based, at most 1/day |
| 6 | **Thinking Timeline** | 7-day causal flow with arrows |

---

## Macro Thinking

**Critical**: Input is button-based only. No free text.

Structure:
- **Cause**: interestRate / inflation / employment / policy / globalEvent / marketSentiment
- **Effect**: assetPriceUp / assetPriceDown / consumptionChange / uncertaintyIncrease / stabilization / noSignificantChange
- **Conclusion**: observeMore / stayCalm / prepareSlowly / noActionNeeded / needMoreInfo

One entry per day, overwrite allowed. Purpose: organize thinking, not produce content.

---

## Daily Macro Brief

Shown every day. Five fixed parts, each with a short "Why":

1. **Current atmosphere** - Overall market/economic feeling
2. **One reason for caution** - What to be aware of
3. **Normalization of anxiety** - It's okay to feel uncertain
4. **Permission to not act today** - Inaction is valid
5. **Relief from news overload** - Most news doesn't matter immediately

---

## Thinking Timeline

- Daily aggregated causal flow shown with arrows
- **No morning/evening split**
- Days without records are shown as valid empty states

---

## Insight Engine

- Local, rule-based engine
- At most one insight per day from recent 3-7 days
- Types: repetition, convergence, narrowing, moodCorrelation, neutralSummary
- **No warnings or action recommendations allowed**

### State-based Calibration:

| State | Description | Allowed Insights |
|-------|-------------|-----------------|
| S1 New | Just started | Neutral summary only |
| S2 Light | Occasional user | Basic observation |
| S3 Silent | Inactive period | No insight |
| S4 Returning | Coming back | Welcome-back insight |
| S5 Consistent | Regular user | All types (1-2 sentences) |

---

## UI & Readability Principles

- No charts, no numbers, no jargon
- 8-11 short lines total
- Clear conclusions with calm explanations
- Visual comfort is a primary requirement

---

## Data Storage Rules

| Model | Constraint |
|-------|------------|
| PerceptionEntry | 1 per day (overwrite) |
| InvestmentEntry | 1 per day (overwrite) |
| MacroThinking | 1 per day (overwrite) |

---

## Design System (Deep Teal)

Color ratio: White-ish surfaces 70%, Accent 20%, Black-ish text 10%

```swift
// Surfaces
DSColor.bgPrimary      // #F9FAFB
DSColor.surface        // #FFFFFF

// Accent
DSColor.accentPrimary  // #1F6F78
DSColor.accentTint     // #D6EFF0

// Text
DSColor.textPrimary    // #111827
DSColor.textSecondary  // #374151
```

---

## Final Product Goal

Percepta is an app users do not need every day, but deeply trust whenever they return.
