import { useState, useCallback } from "react";

const STORAGE_KEY = "catala-srs";

/**
 * Simplified SM-2 spaced repetition.
 *
 * Each card is keyed by "verbId:tense:pronounIdx".
 * We track:
 *   - ease      : multiplier (starts at 2.5, min 1.3)
 *   - interval  : days until next review (starts at 0 = "new")
 *   - reps      : consecutive correct answers
 *   - nextReview: timestamp (ms) of when the card is due
 *   - lastSeen  : timestamp of last attempt
 *   - correct   : lifetime correct count
 *   - total     : lifetime attempt count
 */

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch {
    return {};
  }
}

function save(data) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
}

function makeKey(verbId, tense, pronounIdx) {
  return `${verbId}:${tense}:${pronounIdx}`;
}

function defaultCard() {
  return {
    ease: 2.5,
    interval: 0,
    reps: 0,
    nextReview: 0,
    lastSeen: 0,
    correct: 0,
    total: 0,
  };
}

function updateCard(card, isCorrect) {
  const now = Date.now();
  const updated = { ...card, lastSeen: now, total: card.total + 1 };

  if (isCorrect) {
    updated.correct = card.correct + 1;
    updated.reps = card.reps + 1;

    if (updated.reps === 1) {
      updated.interval = 1;
    } else if (updated.reps === 2) {
      updated.interval = 3;
    } else {
      updated.interval = Math.round(card.interval * card.ease);
    }
    updated.ease = Math.max(1.3, card.ease + 0.1);
  } else {
    updated.reps = 0;
    updated.interval = 0;
    updated.ease = Math.max(1.3, card.ease - 0.2);
  }

  updated.nextReview = now + updated.interval * 24 * 60 * 60 * 1000;
  return updated;
}

export default function useSRS() {
  const [cards, setCards] = useState(load);

  const recordAnswer = useCallback((verbId, tense, pronounIdx, isCorrect) => {
    setCards((prev) => {
      const key = makeKey(verbId, tense, pronounIdx);
      const card = prev[key] || defaultCard();
      const next = { ...prev, [key]: updateCard(card, isCorrect) };
      save(next);
      return next;
    });
  }, []);

  const recordResults = useCallback(
    (verbId, results) => {
      setCards((prev) => {
        const next = { ...prev };
        for (const r of results) {
          const key = makeKey(verbId, r.tense, r.pronounIdx ?? r.form);
          const card = next[key] || defaultCard();
          next[key] = updateCard(card, r.correct);
        }
        save(next);
        return next;
      });
    },
    []
  );

  /** Get the SRS card for a specific form (or a default if unseen). */
  const getCard = useCallback(
    (verbId, tense, pronounIdx) => {
      return cards[makeKey(verbId, tense, pronounIdx)] || defaultCard();
    },
    [cards]
  );

  /**
   * Mastery percentage for a verb (0–100).
   * Based on average accuracy across all 18 forms (6 pronouns x 3 tenses).
   * Unseen forms count as 0%.
   */
  const getVerbMastery = useCallback(
    (verbId, tenses) => {
      let totalAcc = 0;
      let formCount = 0;
      for (const tense of Object.keys(tenses)) {
        for (let i = 0; i < 6; i++) {
          formCount++;
          const card = cards[makeKey(verbId, tense, i)];
          if (card && card.total > 0) {
            totalAcc += card.correct / card.total;
          }
        }
      }
      return formCount > 0 ? Math.round((totalAcc / formCount) * 100) : 0;
    },
    [cards]
  );

  /**
   * Return forms sorted by priority: due for review first, then weakest, then unseen.
   * Each item: { verbId, tense, pronounIdx, card }
   */
  const getDueCards = useCallback(
    (verbs) => {
      const now = Date.now();
      const items = [];
      for (const verb of verbs) {
        for (const tense of Object.keys(verb.tenses)) {
          for (let i = 0; i < 6; i++) {
            const card = cards[makeKey(verb.id, tense, i)] || defaultCard();
            items.push({ verbId: verb.id, tense, pronounIdx: i, card });
          }
        }
      }
      // Sort: due items first (by how overdue), then by lowest accuracy, then unseen
      items.sort((a, b) => {
        const aDue = a.card.nextReview <= now;
        const bDue = b.card.nextReview <= now;
        if (aDue !== bDue) return aDue ? -1 : 1;

        // Among due items, most overdue first
        if (aDue && bDue) return a.card.nextReview - b.card.nextReview;

        // Unseen (total === 0) before seen-but-not-due
        if (a.card.total === 0 !== (b.card.total === 0))
          return a.card.total === 0 ? -1 : 1;

        // Lowest accuracy first
        const accA = a.card.total > 0 ? a.card.correct / a.card.total : 0;
        const accB = b.card.total > 0 ? b.card.correct / b.card.total : 0;
        return accA - accB;
      });

      return items;
    },
    [cards]
  );

  const getDueCount = useCallback(
    (verbs) => {
      const now = Date.now();
      let count = 0;
      for (const verb of verbs) {
        for (const tense of Object.keys(verb.tenses)) {
          for (let i = 0; i < 6; i++) {
            const card = cards[makeKey(verb.id, tense, i)];
            if (!card || card.nextReview <= now) count++;
          }
        }
      }
      return count;
    },
    [cards]
  );

  const getSeenCount = useCallback(() => {
    return Object.values(cards).filter((c) => c.total > 0).length;
  }, [cards]);

  return {
    cards,
    recordAnswer,
    recordResults,
    getCard,
    getVerbMastery,
    getDueCards,
    getDueCount,
    getSeenCount,
  };
}
