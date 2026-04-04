# Catala — Catalan Verb Learning App

## Project Overview

Rewriting a React/Vite web prototype into a native iOS app (SwiftUI) with a lightweight backend for content delivery. The goal is App Store submission targeting French speakers learning Catalan.

## Architecture

```
iOS App (SwiftUI)          Backend (REST API)
├── SwiftData (local)  ◄── GET /v1/verbs  ──►  Postgres (Supabase/Neon)
├── SRS engine (local)
├── AVSpeechSynthesizer
└── StoreKit-ready
```

- **SRS state is on-device only** (SwiftData). No user accounts, no cloud sync at launch.
- **Backend serves verb content only.** App bundles a fallback JSON snapshot for offline use.
- **No auth at launch.** Can be added later for progress sync if needed.

## Spec Files

All specs live in `/specs/`. They are the source of truth for the rewrite:

| File | Purpose |
|------|---------|
| `specs/architecture.md` | System architecture, data flow, tech decisions |
| `specs/data-model.md` | Database schema (Postgres) + SwiftData models + API contract |
| `specs/srs-algorithm.md` | SM-2 algorithm spec, exact parameters, edge cases |
| `specs/screens.md` | Every screen: layout, behavior, navigation, states |
| `specs/design-tokens.md` | Colors, typography, spacing — portable from current theme.js |
| `specs/content.md` | All 12 verbs with conjugations and sentences (seed data) |
| `specs/checklist.md` | App Store compliance checklist |

## Development Rules

- **Language:** Swift 6, SwiftUI, iOS 17+
- **Local storage:** SwiftData (not UserDefaults or Core Data directly)
- **No third-party dependencies** unless absolutely necessary. Prefer Apple frameworks.
- **Verb colors are NOT part of verb data.** Colors are a UI concern, assigned by the app based on verb group.
- **All user-facing text is in French** (the user's native language). Catalan is the target language.
- **SRS runs fully offline.** Backend failure must never block quiz functionality.
- **Bundled fallback:** The app ships with a `verbs-fallback.json` identical to the API response. Used when offline or on first launch before first fetch.
- **Content versioning:** API returns an ETag. App caches and only re-fetches when content changes.

## Build & Run (current web prototype)

```bash
npm install
npm run dev      # http://localhost:5173
npm run build    # Production → dist/
npm run lint     # ESLint
```

## Git

- Feature branch: `claude/app-store-preparation-myefd`
- Commit often with clear messages
- Never push to main without explicit permission
