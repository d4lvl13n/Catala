# Design Tokens

Ported from the React prototype's `theme.js`. Adapt to SwiftUI `Color` and `Font`.

## Colors

### Backgrounds
| Token | Hex | Usage |
|-------|-----|-------|
| `bg` | `#F7F3ED` | Main background |
| `bgSubtle` | `#F1ECE3` | Alternating rows, input default bg |
| `surface` | `#FFFFFF` | Cards, elevated surfaces |

### Borders
| Token | Hex | Usage |
|-------|-----|-------|
| `border` | `#E2DAD0` | Card borders, dividers |
| `borderFocus` | `#C4B9AA` | Input focus ring |

### Accent
| Token | Hex | Usage |
|-------|-----|-------|
| `accent` | `#C0582B` | Primary action, CTA buttons, highlights |
| `accentSoft` | `#C0582B` @ 8% | Accent background tint |
| `accentHover` | `#A84B22` | Pressed state / gradient end |

### Semantic
| Token | Hex | Usage |
|-------|-----|-------|
| `verb` | `#2D6A4F` | Verb-related highlights |
| `verbSoft` | `#2D6A4F` @ 7% | Verb background tint |
| `blue` | `#2B6CB0` | Context quiz accent |
| `blueSoft` | `#2B6CB0` @ 7% | Context quiz bg tint |
| `gold` | `#B7922B` | Accent-close feedback |
| `goldSoft` | `#B7922B` @ 10% | Accent-close bg tint |
| `pink` | `#B04668` | Currently unused in rewrite (was per-verb color for "estar") |

### Feedback
| Token | Hex | Usage |
|-------|-----|-------|
| `correct` | `#2D6A4F` | Correct answer (same as verb green) |
| `correctSoft` | `#2D6A4F` @ 10% | Correct answer bg |
| `wrong` | `#C0392B` | Wrong answer |
| `wrongSoft` | `#C0392B` @ 8% | Wrong answer bg |

### Text
| Token | Hex | Usage |
|-------|-----|-------|
| `text` | `#1A1612` | Primary text |
| `textMid` | `#4A4035` | Secondary text |
| `textMuted` | `#8C8177` | Labels, captions |
| `textLight` | `#B5ADA5` | Placeholder, disabled |

### Verb Group Colors
| Group | Color | Hex |
|-------|-------|-----|
| Irregular | accent | `#C0582B` |
| 1er (-ar) | green | `#3D7A68` |
| 2n (-ent) | blue | `#2B6CB0` |
| 3e (-re) | warm brown | `#9B6B4A` |

---

## Typography

### Font Families

| Token | Font | Fallback | Usage |
|-------|------|----------|-------|
| `display` | Literata | Georgia, serif | Titles, verb names, conjugated forms, large numbers |
| `body` | Plus Jakarta Sans | system sans-serif | Body text, labels, buttons, instructions |
| `mono` | JetBrains Mono | Menlo, monospace | Section headers, accent keyboard, form previews |

**iOS approach:** Bundle Literata and Plus Jakarta Sans as custom fonts in the app. JetBrains Mono can be replaced with `.monospaced` system font to save bundle size — the difference is minimal for small labels.

### Font Sizes

| Usage | Size | Weight | Font |
|-------|------|--------|------|
| Screen title | 32pt | 800 (ExtraBold) | display |
| Verb name (card) | 18pt | 800 | display |
| Verb name (detail) | 22pt | 800 | display |
| Quiz pronoun | 28pt | 800 | display |
| Conjugated form | 17pt | 600 (SemiBold) | display |
| Score percentage | 42pt | 800 | display |
| Correct answer reveal | 22pt | 800 | display |
| Input field | 20pt | 600 | display |
| Body text | 14pt | 400 | body |
| Button label | 13-15pt | 700 (Bold) | body |
| Section header | 10-11pt | 500-600 | mono |
| Caption / muted | 12pt | 400 | body |
| Chip text | 11pt | 600 | mono |
| Subtitle / uppercase label | 14pt | 600 | body |

---

## Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `radius` | 12pt | Default card border radius |
| `radiusSmall` | 6pt | Chips, small elements |
| `radiusLarge` | 16pt | Quiz cards, results card |
| `shadow` | `0 1px 8px rgba(26,22,18,0.05)` | Cards, elevated surfaces |
| `shadowHover` | `0 3px 14px rgba(26,22,18,0.09)` | Card press/hover state |
| `contentMaxWidth` | 500pt | Max width for all content (centered) |
| `screenPadding` | 18pt horizontal, 28pt top, 48pt bottom | Page content insets |
| `cardPadding` | 14-18pt | Internal card padding |
| `sectionGap` | 20-24pt | Space between sections |
| `elementGap` | 6-8pt | Space between cards in a list |

---

## Dark Mode (future)

Not in v1 but designed to be easy to add. All colors are defined as tokens — create a dark variant:

| Token | Light | Dark (suggested) |
|-------|-------|-------|
| `bg` | `#F7F3ED` | `#1A1612` |
| `bgSubtle` | `#F1ECE3` | `#242018` |
| `surface` | `#FFFFFF` | `#2A2520` |
| `border` | `#E2DAD0` | `#3A3530` |
| `text` | `#1A1612` | `#F7F3ED` |
| `textMid` | `#4A4035` | `#C4B9AA` |
| `textMuted` | `#8C8177` | `#8C8177` |

Accent, feedback, and verb colors stay the same in both modes.
