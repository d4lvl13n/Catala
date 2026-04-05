# SRS Algorithm (SM-2 Variant)

## Overview

Each conjugation form is a **card**, keyed by `verbId:tense:pronounIndex` (e.g., `"ser:present:0"` = Jo + present tense of Ser).

Total cards = `verbCount × 3 tenses × 6 pronouns` = 18 cards per verb.

## Card State

| Field | Type | Initial | Description |
|-------|------|---------|-------------|
| `easeFactor` | Double | 2.5 | Multiplier for interval growth. Min 1.3 |
| `interval` | Int | 0 | Days until next review. 0 = new/reset |
| `consecutiveCorrect` | Int | 0 | Streak of correct answers. Resets on wrong |
| `nextReview` | Date | .distantPast | When the card is due |
| `lastSeen` | Date | .distantPast | Timestamp of last attempt |
| `correctCount` | Int | 0 | Lifetime correct answers |
| `totalAttempts` | Int | 0 | Lifetime total attempts |

## Update Algorithm

Called after each answer with `isCorrect: Bool`:

```
function updateCard(card, isCorrect) → updatedCard:
    set lastSeen = now
    set totalAttempts += 1

    if isCorrect:
        set correctCount += 1
        set consecutiveCorrect += 1

        if consecutiveCorrect == 1:
            set interval = 1 day
        else if consecutiveCorrect == 2:
            set interval = 3 days
        else:
            set interval = round(interval × easeFactor)

        set easeFactor = max(1.3, easeFactor + 0.1)

    else (wrong):
        set consecutiveCorrect = 0
        set interval = 0
        set easeFactor = max(1.3, easeFactor - 0.2)

    set nextReview = now + interval days
```

## Accent-Close Answers

An answer where the base letters match but accents differ (e.g., `"soc"` for `"sóc"`) is treated as **correct for SRS purposes** but flagged in the UI. This prevents SRS penalty for accent typos while still teaching correct accents.

The `isAccentClose` flag is on `QuizResult`, not on `SRSCard`. SRS only sees correct/wrong.

## Due Card Prioritization

Used by `MixedDrill` to select which cards to quiz. Returns all cards sorted by priority:

```
1. Due cards (nextReview <= now), ordered by most overdue first
2. Unseen cards (totalAttempts == 0)
3. Seen but not yet due, ordered by lowest accuracy first
```

Accuracy = `correctCount / totalAttempts` (0 if never attempted).

## Mixed Drill Selection

1. Get all cards via priority sort above
2. Take the first 15 cards
3. Shuffle them (so the quiz isn't always hardest-first)

## Mastery Calculation

Per-verb mastery (shown on HomeScreen verb cards):

```
mastery = (sum of accuracy for all 18 forms) / 18 × 100

where accuracy per form = correctCount / totalAttempts (0 if unseen)
```

Result: 0–100 integer percentage.

## Due Count

Shown as badge on "Pratique mixte" button:

```
dueCount = count of cards where (totalAttempts == 0) OR (nextReview <= now)
```

New/unseen cards are counted as "due" so the user is prompted to learn them.

## Stats Derivation

Stats on HomeScreen are derived from SRSCard data, not stored separately:

| Stat | Derivation |
|------|-----------|
| Sessions | Count of distinct `lastSeen` dates (day granularity) — or simply increment a counter in UserDefaults |
| Forms seen | Count of SRSCards where `totalAttempts > 0` |
| Score | `sum(correctCount) / sum(totalAttempts) × 100` across all cards |

**Note:** Session count is simpler to track as an incrementing counter (UserDefaults or a small SwiftData model) rather than derived. Increment it each time a quiz finishes.
