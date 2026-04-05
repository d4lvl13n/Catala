# Screens Specification

## Navigation Structure

```
NavigationStack
├── HomeScreen
│   ├── → TableView (tap verb)
│   │   ├── → DrillMode (tap "Drill conjugaison")
│   │   │   └── → ResultsScreen
│   │   └── → ContextQuiz (tap "Quiz en contexte")
│   │       └── → ResultsScreen
│   └── → MixedDrill (tap "Pratique mixte")
│       └── → ResultsScreen
│
├── OnboardingView (shown once, on first launch)
└── SettingsView (accessible from HomeScreen nav bar)
```

All navigation uses `NavigationStack` with `navigationDestination`. No tab bar — the app is linear and focused.

---

## Screen 1: OnboardingView

**When:** First launch only (tracked via `@AppStorage("hasSeenOnboarding")`).

**Content (2 slides):**

1. **Slide 1:** Welcome
   - Title: "Aprèn els verbs"
   - Subtitle: "Maîtrise les conjugaisons catalanes grâce à la répétition espacée"
   - Visual: Simple verb conjugation preview

2. **Slide 2:** How it works
   - "Explore les tableaux de conjugaison"
   - "Entraîne-toi avec les quiz"
   - "L'app mémorise tes points faibles et te les repropose"

**Actions:**
- "Commencer" button → dismiss, go to HomeScreen
- Page indicator dots at bottom

---

## Screen 2: HomeScreen

### Header
- Title: "Aprèn els verbs" (Literata, 32pt, bold)
- Subtitle: "Français → Català" (small caps label above title)
- Tagline: "Conjugaisons, exemples en contexte, et quiz"
- Nav bar trailing: gear icon → SettingsView

### Stats Bar (only visible when `totalAttempts > 0`)
Three stats in a horizontal card:

| Stat | Label | Format |
|------|-------|--------|
| Sessions | "Sessions" | Integer count |
| Forms seen | "Formes vues" | `seen/total` (e.g., "24/216") |
| Score | "Score" | Percentage (e.g., "78%") |

### Mixed Drill CTA
Full-width button with gradient background (accent → accentDark):
- Label: "Pratique mixte"
- Icon: gear/shuffle icon on the left
- Badge (right side): "{dueCount} à réviser" — only shown when dueCount > 0

### Verb List
Grouped by `verb.group` in order: Irregular, 1er (-ar), 2n (-ent), 3e (-re).

Each group has:
- Section header: group name in mono, uppercase, muted color

Each verb card shows:
- Left border: 3px colored bar (group color)
- **Verb name** (Catalan, bold, 18pt)
- **French translation** (muted, 14pt) — "— Être"
- **Preview** of first 3 present tense forms: "sóc, ets, és..."
- **Mastery** (right side):
  - If mastery > 0: percentage + small progress bar
  - If mastery == 0: right arrow "→"
- Progress bar color: green if ≥80%, group color if ≥40%, light gray otherwise

**Tap** → navigate to TableView for that verb.

---

## Screen 3: TableView

### Header
- Back button (chevron.left)
- Verb name + French translation: "Ser — Être"
- Group chip below: colored badge with group name

### Tense Tabs
Segmented control with 3 options:
- Present | Passat (Perfet) | Futur
- Selected tab: white background + shadow
- Unselected: transparent

### Conjugation Table
6 rows (one per pronoun), displayed in a card:

| Row content | Style |
|-------------|-------|
| Catalan pronoun (bold) | Left column, 100pt wide |
| French pronoun (light, below) | Small, muted |
| Conjugated form | Right side, display font, verb group color |
| Speak button | Far right, only if speech available |

Alternating row backgrounds: white / subtle cream.

### Example Sentences
Section label: "EXEMPLES EN CONTEXTE" (mono, uppercase)

Filtered to current tense. Each sentence card:
- Catalan sentence (display font, 15pt)
- French translation below (body font, muted, italic-ish)
- Chip showing which pronoun/form it demonstrates
- Speak button (speaks Catalan sentence)

### Action Buttons (bottom)
Two buttons side by side:
- "Drill conjugaison" (secondary style) → DrillMode
- "Quiz en contexte" (primary/accent style) → ContextQuiz

---

## Screen 4: DrillMode

**Purpose:** Fill-in-the-blank conjugation quiz for a single verb.

### Setup
- Generate questions: all 18 forms (6 pronouns × 3 tenses), shuffle, take first 12
- Each question = one conjugation form to type

### Header
- Verb name + "Drill" chip
- Instruction: "Tape la forme conjuguée correcte"

### Progress Bar
- Gradient bar from verb color to accent
- Shows `(currentQuestion + 1) / totalQuestions`

### Question Card
- Tense chip: e.g., "Present"
- Large pronoun: "Jo" (28pt, verb color)
- Small French equivalent: "(Je)"
- Text input field (centered, display font, 20pt)
  - Default: subtle background, border
  - After answer: green bg (correct), red bg (wrong), gold bg (accent-close)
  - Border color matches feedback
- Accent keyboard (below input, only when input is active/unanswered):
  - Characters: à è é ì ò ó ú ü ï ç ·
  - Tap inserts at cursor position without losing focus

### Feedback (after checking)
Three states:

1. **Correct:** "✓ Correct !" in green + speak button
2. **Accent-close:** "Presque ! Attention aux accents :" in gold + correct form displayed large + speak
3. **Wrong:** "✗ La bonne réponse :" in red + correct form displayed large + speak

Auto-speaks the correct answer on check.

### Buttons
- Before check: "Vérifier" (disabled if input empty)
- After check: "Suivant →" or "Voir les résultats" (if last question)

### Counter
- "{current} / {total}" centered below button

### Keyboard Interaction
- Enter key: check answer (if unanswered) or go to next (if answered)
- This maps to iOS Return key behavior

---

## Screen 5: ContextQuiz

**Purpose:** Multiple-choice sentence completion for a single verb.

### Setup
- Questions = all sentences for the verb, shuffled
- Each question: the sentence has one conjugated form replaced with "___"
- 4 choices: correct answer + 3 wrong forms from the same tense (different pronouns)
- Choices are shuffled

### Header
- Verb name + "Contexte" chip (blue)
- Instruction: "Complète la phrase avec la bonne forme"

### Progress Bar
- Gradient: blue to verb color

### Question Card
- Tense chip
- Catalan sentence with blank (display font, underline where blank is)
  - Blank shows "?" before answer, correct form after
  - Underline color: verb color (before), green (correct), red (wrong)
- French translation below (italic, muted)
- Speak button (top right, only after answering — speaks full Catalan sentence)

### Choice Grid
2×2 grid of buttons:
- Default: white background, border
- After answer:
  - Correct choice: green background, "✓" prefix
  - Wrong selected choice: red background, "✗" prefix
  - Other choices: unchanged

Tap selects immediately (no separate "check" step).

### Buttons
- "Suivant →" or "Voir les résultats" appears after selection (with fadeSlide animation)

### Counter
- "{current} / {total}" centered

---

## Screen 6: MixedDrill

**Purpose:** SRS-prioritized drill across ALL verbs. Combines the fill-in-the-blank mechanic from DrillMode with cross-verb selection.

### Setup
- Get due cards from SRS engine (priority: overdue → unseen → weak)
- Take first 15, shuffle
- Each question: a specific verb + tense + pronoun combination

### Header
- Title: "Pratique mixte"
- "SRS" chip (accent color)
- Instruction: "Les formes les plus urgentes à réviser"

### Progress Bar
- Gradient: accent to verb green

### Question Card
Same as DrillMode except:
- **Two chips** at top: verb name chip (verb color) + tense chip
- Pronoun shown large (verb color)
- Below pronoun: "(French pronoun) — French verb translation"
- Input + accent keyboard + feedback: identical to DrillMode

### Buttons & Counter
Same as DrillMode.

---

## Screen 7: ResultsScreen

**Purpose:** Show quiz score and review mistakes.

### Score Card
Centered card with:
- Large emoji (context-dependent):
  - 100%: trophy
  - ≥80%: star
  - ≥60%: thumbs up
  - <60%: book
- Large percentage (42pt, green if ≥60%, accent if <60%)
- "{correct}/{total} — {message}"
  - 100%: "Parfait !"
  - ≥80%: "Excellent !"
  - ≥60%: "Pas mal !"
  - <60%: "Continue !"
  - <40%: "Revois le tableau et réessaie !"
- Accent issues note (if any): "{n} réponse(s) acceptée(s) mais avec des accents manquants" (gold)
- Quiz type chip: "Verb name · Drill" or "Verb name · Contexte" or "Mixte"

### Accent Review Section (if accent issues exist)
Section label: "ACCENTS À RETENIR" (gold)
Each item:
- Gold background card
- User's answer (mono) → correct form (mono, bold, gold)
- Speak button

### Wrong Answers Section (if wrong answers exist)
Section label: "À RÉVISER"
Each item:
- White card
- Context info: verb name + pronoun + tense (for drill/mixed), or French sentence (for context quiz)
- User's answer (strikethrough, red) → correct answer (green, bold)
- Speak button

### Action Buttons
- "Réessayer" (secondary) — restart same quiz type
- "Revoir le tableau" (secondary) — go to TableView (only for single-verb quizzes)
- "Tous les verbes" (primary, full width) — go home

---

## Screen 8: SettingsView

### Sections

**Apprentissage**
- Toggle: "Lecture audio automatique" (auto-speak on answer check) — default ON
- Speech rate picker: Lent / Normal / Rapide — default Normal

**Données**
- "Réinitialiser ma progression" — destructive button with confirmation alert
  - Alert: "Réinitialiser ?" / "Toute ta progression sera perdue." / Cancel + "Réinitialiser" (red)
  - Clears all SRSCard data and session counter

**À propos**
- App version
- "Fait avec ❤️ pour apprendre le catalan"
- Link: Privacy policy (opens Safari)

---

## Animations

| Animation | Where | Detail |
|-----------|-------|--------|
| fadeSlide | Feedback after answer, "next" button appear | opacity 0→1, translateY 6→0, 0.2s ease |
| Card press | VerbCard on HomeScreen | translateY -1px + shadow increase on press |
| Progress bar | All quiz modes | width transition 0.3s |
| Mastery bar | HomeScreen verb cards | width transition 0.3s |

Use SwiftUI `.animation()` and `.transition()` for these. Keep it subtle.

---

## Safe Areas & Layout

- All content: max width 500pt, centered horizontally (for iPad compatibility)
- Top: respect safe area (notch / Dynamic Island)
- Bottom: 48pt padding minimum (home indicator)
- Input fields: when keyboard appears, scroll content so input stays visible
- Accent keyboard: positioned as inputAccessoryView attached to the text field (native iOS pattern)
