# Architecture

## System Overview

```
┌─────────────────────────┐         ┌─────────────────────────┐
│       iOS App            │  HTTPS  │       Backend            │
│                          │◄───────►│                          │
│  SwiftUI + SwiftData     │         │  REST API + Postgres     │
│  iOS 17+                 │         │  Supabase or Railway     │
└─────────────────────────┘         └─────────────────────────┘
```

## iOS App

### Tech Stack
- **Language:** Swift 6
- **UI:** SwiftUI
- **Local storage:** SwiftData
- **TTS:** AVSpeechSynthesizer (ca-ES locale)
- **Networking:** URLSession + async/await (no Alamofire)
- **Target:** iOS 17+ (covers 95%+ of active iPhones)

### App Structure

```
Catala/
├── CatalaApp.swift                  # App entry point
├── ContentView.swift                # Root navigation (NavigationStack)
│
├── Models/
│   ├── Verb.swift                   # Codable struct (from API)
│   ├── Conjugation.swift            # Per-tense conjugation data
│   ├── Sentence.swift               # Example sentence
│   ├── SRSCard.swift                # SwiftData @Model — local SRS state
│   └── QuizResult.swift             # Transient struct for quiz session results
│
├── Services/
│   ├── VerbService.swift            # Fetch verbs from API, cache with ETag
│   ├── SRSEngine.swift              # SM-2 algorithm (pure functions + SwiftData queries)
│   ├── SpeechService.swift          # AVSpeechSynthesizer wrapper
│   └── StatsService.swift           # Aggregate stats from SRSCard data
│
├── Views/
│   ├── Home/
│   │   ├── HomeScreen.swift         # Verb list, stats bar, mixed drill CTA
│   │   ├── VerbCard.swift           # Single verb row with mastery bar
│   │   └── StatsBar.swift           # Sessions / forms seen / score
│   │
│   ├── VerbDetail/
│   │   ├── TableView.swift          # Conjugation table with tense tabs
│   │   └── SentenceRow.swift        # Example sentence with speak button
│   │
│   ├── Quiz/
│   │   ├── DrillMode.swift          # Fill-in-the-blank conjugation drill
│   │   ├── ContextQuiz.swift        # Multiple-choice sentence completion
│   │   ├── MixedDrill.swift         # SRS-prioritized mixed quiz
│   │   └── QuizShared/
│   │       ├── AccentKeyboard.swift # Custom input accessory for Catalan chars
│   │       ├── ProgressBar.swift    # Gradient quiz progress
│   │       └── FeedbackView.swift   # Correct / wrong / accent-close feedback
│   │
│   ├── Results/
│   │   └── ResultsScreen.swift      # Score, accent review, wrong answers
│   │
│   ├── Onboarding/
│   │   └── OnboardingView.swift     # 2-3 slides, shown once
│   │
│   └── Settings/
│       └── SettingsView.swift       # Reset progress, speech toggle, about/credits
│
├── Theme/
│   └── Theme.swift                  # Colors, fonts, spacing tokens
│
├── Resources/
│   ├── verbs-fallback.json          # Bundled verb data for offline first-launch
│   └── Assets.xcassets/             # App icon, accent colors
│
└── Utils/
    ├── TextUtils.swift              # checkAnswer(), accent stripping
    └── ArrayExtensions.swift        # shuffle (Fisher-Yates already in Swift stdlib)
```

## Backend

### Tech Stack
- **Database:** Postgres (hosted on Supabase free tier or Neon)
- **API:** Supabase auto-generated REST, or a minimal Express/Fastify server on Railway
- **No auth at launch.** Public read-only endpoint.

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/v1/verbs` | Returns all verbs with conjugations and sentences |

Single endpoint. That's it. The backend exists solely so you can add verbs without an app release.

### Caching Strategy
1. API returns `ETag` header based on content hash
2. App sends `If-None-Match` on subsequent requests
3. `304 Not Modified` = use cached data
4. On first launch or network failure = use `verbs-fallback.json` from bundle

### Why Not Just Bundle Everything?
- Adding a verb would require: code change → build → App Store review (1-2 days) → users update
- With an API: add row to DB → users see it on next app launch (seconds)

## Data Flow

### Verb Content Flow
```
Postgres → API → iOS (cache in memory) → Views
                   ↓ (on failure)
            verbs-fallback.json → Views
```

### SRS Data Flow
```
Quiz answer → SRSEngine.updateCard() → SwiftData (local)
                                           ↓
HomeScreen ← SRSEngine.getDueCards() ← SwiftData query
```

### Stats Flow
Stats are **derived from SRSCard data**, not stored separately. No need for a separate stats model — just query:
- Total sessions = count of distinct quiz sessions (derived from timestamps)
- Forms seen = count of SRSCards where `totalAttempts > 0`
- Accuracy = sum(correct) / sum(totalAttempts)

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| SwiftData over Core Data | Modern API, less boilerplate, better SwiftUI integration |
| No auth | Unnecessary complexity for a content-consumption app. Add later if sync is needed. |
| Single API endpoint | Content is small (~50KB for 30 verbs). One fetch gets everything. No pagination needed at this scale. |
| AVSpeechSynthesizer over web TTS | Native, reliable, works offline, no API keys |
| No third-party deps | Reduces maintenance, review friction, and binary size. Everything needed is in Apple SDKs. |
| iOS 17+ minimum | SwiftData requires iOS 17. Worth the tradeoff — covers vast majority of active devices. |
