# Data Model

## 1. Postgres Schema (Backend)

### verbs

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `text` | PRIMARY KEY | Unique slug: `"ser"`, `"estar"`, `"parlar"` |
| `ca` | `text` | NOT NULL | Catalan infinitive: `"Ser"` |
| `fr` | `text` | NOT NULL | French translation: `"Être"` |
| `group` | `text` | NOT NULL | Conjugation group: `"Irregular"`, `"1er (-ar)"`, `"2n (-ent)"`, `"3e (-re)"` |
| `sort_order` | `integer` | NOT NULL DEFAULT 0 | Display order within group |
| `created_at` | `timestamptz` | DEFAULT now() | Row creation time |
| `updated_at` | `timestamptz` | DEFAULT now() | Last modification time |

### conjugations

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `serial` | PRIMARY KEY | Auto-increment |
| `verb_id` | `text` | FK → verbs(id), NOT NULL | Parent verb |
| `tense` | `text` | NOT NULL | `"present"`, `"passat"`, `"futur"` |
| `pronoun_index` | `integer` | NOT NULL | 0–5 (Jo, Tu, Ell/Ella, Nosaltres, Vosaltres, Ells/Elles) |
| `form` | `text` | NOT NULL | The conjugated form: `"sóc"`, `"ets"`, etc. |

**Unique constraint:** `(verb_id, tense, pronoun_index)`

### sentences

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `serial` | PRIMARY KEY | Auto-increment |
| `verb_id` | `text` | FK → verbs(id), NOT NULL | Parent verb |
| `tense` | `text` | NOT NULL | Which tense this sentence demonstrates |
| `pronoun_index` | `integer` | NOT NULL | Which pronoun form (0–5) |
| `ca` | `text` | NOT NULL | Catalan sentence: `"Sóc francès."` |
| `fr` | `text` | NOT NULL | French translation: `"Je suis français."` |

---

## 2. API Response Format

### `GET /v1/verbs`

Returns a flat, denormalized JSON array. The app doesn't need to do JOINs — the backend assembles the response.

```json
{
  "verbs": [
    {
      "id": "ser",
      "ca": "Ser",
      "fr": "Être",
      "group": "Irregular",
      "tenses": {
        "present": ["sóc", "ets", "és", "som", "sou", "són"],
        "passat": ["vaig ser", "vas ser", "va ser", "vam ser", "vau ser", "van ser"],
        "futur": ["seré", "seràs", "serà", "serem", "sereu", "seran"]
      },
      "sentences": [
        {
          "tense": "present",
          "pronounIndex": 0,
          "ca": "Sóc francès.",
          "fr": "Je suis français."
        }
      ]
    }
  ],
  "version": "2026-04-04T12:00:00Z"
}
```

**Notes:**
- `tenses` is an object with arrays of exactly 6 strings (one per pronoun, always in order 0–5)
- `sentences` is an array of 4–8 example sentences per verb
- `version` is the last-modified timestamp of any row, used for cache invalidation
- Response size: ~50KB for 30 verbs (no pagination needed)

---

## 3. Swift Models (iOS)

### Verb (Codable — from API)

```swift
struct Verb: Codable, Identifiable, Hashable {
    let id: String              // "ser"
    let ca: String              // "Ser"
    let fr: String              // "Être"
    let group: String           // "Irregular"
    let tenses: [String: [String]]  // ["present": ["sóc", "ets", ...]]
    let sentences: [Sentence]
}

struct Sentence: Codable, Hashable {
    let tense: String           // "present"
    let pronounIndex: Int       // 0
    let ca: String              // "Sóc francès."
    let fr: String              // "Je suis français."
}
```

### VerbResponse (API wrapper)

```swift
struct VerbResponse: Codable {
    let verbs: [Verb]
    let version: String
}
```

### SRSCard (SwiftData — local only)

```swift
@Model
class SRSCard {
    // Composite key: "ser:present:0"
    @Attribute(.unique) var cardKey: String

    var verbId: String
    var tense: String
    var pronounIndex: Int

    // SM-2 state
    var easeFactor: Double = 2.5
    var interval: Int = 0          // days
    var consecutiveCorrect: Int = 0
    var nextReview: Date = .distantPast
    var lastSeen: Date = .distantPast

    // Lifetime stats
    var correctCount: Int = 0
    var totalAttempts: Int = 0
}
```

### QuizResult (transient — not persisted)

```swift
struct QuizResult {
    let verbId: String
    let tense: String
    let pronounIndex: Int
    let userAnswer: String
    let correctAnswer: String
    let isCorrect: Bool
    let isAccentClose: Bool
}
```

---

## 4. Constants

### Tenses

| Key | Display Label |
|-----|--------------|
| `present` | Present |
| `passat` | Passat (Perfet) |
| `futur` | Futur |

### Pronouns (always in this order, index 0–5)

| Index | Catalan | French |
|-------|---------|--------|
| 0 | Jo | Je |
| 1 | Tu | Tu |
| 2 | Ell/Ella | Il/Elle |
| 3 | Nosaltres | Nous |
| 4 | Vosaltres | Vous |
| 5 | Ells/Elles | Ils/Elles |

### Verb Groups (display order)

1. Irregular
2. 1er (-ar)
3. 2n (-ent)
4. 3e (-re)

---

## 5. Group-to-Color Mapping (UI concern, not data)

Colors are assigned by the app based on `verb.group`, not stored in the database:

| Group | Color purpose |
|-------|--------------|
| Irregular | Accent (burnt orange) |
| 1er (-ar) | Green variant |
| 2n (-ent) | Blue variant |
| 3e (-re) | Warm brown |

Individual verb accent colors from the prototype (each verb had its own color) are **dropped** in the rewrite. Group-level coloring is sufficient and scales better.
