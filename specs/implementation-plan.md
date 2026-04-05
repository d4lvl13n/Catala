# Implementation Plan

## Sprint Overview

| Sprint | Focus | Deliverable |
|--------|-------|-------------|
| **1** | Foundation | Xcode project, models, theme, bundled JSON, verb service |
| **2** | Core screens | HomeScreen, TableView, navigation |
| **3** | Quiz engine | DrillMode, ContextQuiz, accent checking, accent keyboard |
| **4** | SRS system | SRSCard SwiftData model, SM-2 engine, MixedDrill, ResultsScreen |
| **5** | Backend | Postgres schema, seed data, REST endpoint, ETag caching in app |
| **6** | Polish & App Store | Onboarding, Settings, TTS, safe areas, error handling, checklist |

---

## Sprint 1 — Foundation

**Goal:** Xcode project builds and runs. Models exist. Verb data loads from bundled JSON.

### Tasks
- [ ] Create Xcode project (Catala, SwiftUI, SwiftData, iOS 17+)
- [ ] Add `Theme.swift` — all colors, fonts, spacing from `specs/design-tokens.md`
- [ ] Add Swift models: `Verb`, `Sentence`, `VerbResponse` (Codable)
- [ ] Add constants: `Tense` enum, `Pronoun` struct with ca/fr labels
- [ ] Create `verbs-fallback.json` from `specs/content.md` matching API format
- [ ] Add `VerbService.swift` — loads verbs from bundled JSON (network fetch in Sprint 5)
- [ ] Add `TextUtils.swift` — `checkAnswer()` with accent-tolerant comparison
- [ ] Verify: app launches, loads 12 verbs from JSON, prints them to console

### Acceptance
- App compiles and runs on iOS 17 simulator
- `Verb` array decodes from bundled JSON with 12 verbs, 18 conjugations each, ~6 sentences each
- `checkAnswer("soc", "sóc")` returns `.accentClose`

---

## Sprint 2 — Core Screens

**Goal:** User can browse verbs and view conjugation tables.

### Tasks
- [ ] Add `ContentView.swift` with `NavigationStack`
- [ ] Build `HomeScreen` — header, verb list grouped by group, verb cards with group color
- [ ] Build `VerbCard` — name, translation, present tense preview, mastery placeholder (always 0 for now)
- [ ] Build `StatsBar` — sessions/forms seen/score (all zeros for now, wired in Sprint 4)
- [ ] Build `TableView` — tense tabs (segmented control), conjugation rows, sentence examples
- [ ] Build shared UI components: `Chip`, `ProgressBarView`, `PrimaryButton`, `SecondaryButton`
- [ ] Wire navigation: HomeScreen → tap verb → TableView → back

### Acceptance
- User can scroll verb list, tap any verb, see full conjugation table
- Tense tabs switch between present/passat/futur
- Sentences filter by selected tense
- Back navigation works

---

## Sprint 3 — Quiz Engine

**Goal:** DrillMode and ContextQuiz are playable for a single verb.

### Tasks
- [ ] Build `DrillMode` — question generation (18 forms → shuffle → take 12), text input, check/next flow
- [ ] Build `AccentKeyboard` — input accessory view with Catalan special characters (à è é ì ò ó ú ü ï ç ·)
- [ ] Wire accent keyboard to insert characters at cursor position
- [ ] Implement feedback states: correct (green), wrong (red), accent-close (gold)
- [ ] Build `ContextQuiz` — sentence with blank, 4 choices (1 correct + 3 wrong from same tense), tap-to-select
- [ ] Build `ResultsScreen` — score card, accent review section, wrong answers section, action buttons
- [ ] Wire navigation: TableView → "Drill" → DrillMode → ResultsScreen → Home/Retry/Table
- [ ] Wire navigation: TableView → "Quiz en contexte" → ContextQuiz → ResultsScreen

### Acceptance
- User can complete a full drill (12 questions) with text input and accent keyboard
- User can complete a context quiz with multiple choice
- Results show score, accent issues, wrong answers
- Retry restarts the same quiz type
- "Tous les verbes" returns to HomeScreen

---

## Sprint 4 — SRS System

**Goal:** Spaced repetition works. MixedDrill is playable. Stats are live.

### Tasks
- [ ] Add `SRSCard` SwiftData model with all fields from `specs/srs-algorithm.md`
- [ ] Add `SRSEngine.swift` — `updateCard()`, `getDueCards()`, `getDueCount()`, `getVerbMastery()`, `getSeenCount()`
- [ ] Wire DrillMode + ContextQuiz results into SRS (record each answer)
- [ ] Build `MixedDrill` — selects 15 due cards across all verbs, same input mechanic as DrillMode
- [ ] Wire MixedDrill results into SRS
- [ ] Update HomeScreen: live mastery bars on verb cards, live stats bar, due count badge on "Pratique mixte"
- [ ] Add session counter (increment on each quiz completion, persisted in UserDefaults)
- [ ] Wire navigation: HomeScreen → "Pratique mixte" → MixedDrill → ResultsScreen

### Acceptance
- After completing a drill, verb mastery updates on HomeScreen
- Mixed drill prioritizes due/unseen cards first
- Stats bar shows real sessions, forms seen, score
- Due count badge reflects actual SRS state
- Answering correctly increases interval; answering wrong resets to 0

---

## Sprint 5 — Backend

**Goal:** Verbs load from Postgres via REST API. Content can be updated without app release.

### Tasks
- [ ] Create Postgres schema: `verbs`, `conjugations`, `sentences` tables per `specs/data-model.md`
- [ ] Write seed SQL script with all 12 verbs from `specs/content.md`
- [ ] Create REST endpoint: `GET /v1/verbs` — returns denormalized JSON matching `VerbResponse` format
- [ ] Add ETag header based on latest `updated_at` across all tables
- [ ] Update `VerbService.swift`: fetch from API on launch, fall back to bundled JSON on failure
- [ ] Implement ETag caching: send `If-None-Match`, handle `304 Not Modified`
- [ ] Cache fetched verbs locally (write to app documents directory as JSON)
- [ ] Load priority: cached JSON → API fetch → bundled fallback

### Acceptance
- App fetches verbs from live API on launch
- In airplane mode, app works using cached or bundled data
- Adding a verb to the database makes it appear in the app on next launch
- ETag prevents unnecessary re-downloads

---

## Sprint 6 — Polish & App Store

**Goal:** App is complete, polished, and ready for App Store submission.

### Tasks
- [ ] Build `OnboardingView` — 2 slides, shown once (tracked via @AppStorage)
- [ ] Build `SettingsView` — speech toggle, reset progress (with confirmation), about section
- [ ] Integrate `AVSpeechSynthesizer` via `SpeechService.swift` — speak button on conjugation rows, sentences, quiz feedback
- [ ] Handle safe area insets (notch, Dynamic Island, home indicator)
- [ ] Set max content width to 500pt (for iPad compat)
- [ ] Add error boundary: catch SwiftData failures, show recovery UI
- [ ] Handle app interruptions: backgrounding during quiz preserves state
- [ ] Add app icon (1024×1024) to Assets.xcassets
- [ ] Configure launch screen (matches bg color #F7F3ED)
- [ ] Add `verbs-fallback.json` to bundle (final version matching API)
- [ ] Run through `specs/checklist.md` — verify every item

### Acceptance
- Onboarding shows on first launch only
- Settings allows reset (with confirmation) and speech toggle
- TTS speaks Catalan forms and sentences
- App works on iPhone SE through 15 Pro Max
- App works fully offline
- No crashes on launch, during quizzes, or on results
- All checklist items in `specs/checklist.md` are addressed

---

## Progress Tracker

| Sprint | Status | Completed |
|--------|--------|-----------|
| 1 — Foundation | DONE | Models, Theme, VerbService, bundled JSON, TextUtils |
| 2 — Core Screens | DONE | HomeScreen, TableView, VerbCard, StatsBar, shared UI |
| 3 — Quiz Engine | DONE | DrillMode, ContextQuiz, AccentKeyboard, FeedbackView, ResultsScreen |
| 4 — SRS System | DONE | SRSEngine (SM-2), MixedDrill, live mastery/stats on HomeScreen |
| 5 — Backend | DONE | Postgres schema, seed SQL (12 verbs), get_verbs() RPC endpoint |
| 6 — Polish | DONE | Onboarding, Settings, ErrorBoundary, privacy policy link |
| Code Review | DONE | Fixed: speech settings, blank text, theme tokens, safe subscript |

### Known Items Requiring Manual Work (Xcode)
- Bundle Literata + Plus Jakarta Sans fonts and register in Info.plist
- App icon (1024x1024) in Assets.xcassets
- Launch screen storyboard (bg color #F7F3ED)
- Replace privacy policy placeholder URL
- Replace API base URL in VerbService.swift
- Apple Developer account + signing configuration
- App Store Connect metadata (screenshots, description, keywords)
