/** Fisher-Yates shuffle — returns a new array. */
export function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

/**
 * Accent-tolerant comparison for Catalan input.
 *
 * Returns an object:
 *   - exact:       true if the input matches perfectly
 *   - accentClose: true if the letters match but accents differ
 *   - wrong:       true if neither match
 *   - expected:    the correct answer (for display)
 *
 * We strip accents via NFD decomposition + combining-mark removal,
 * then compare the base letters. This lets "soc" match "sóc" as
 * "accent close" while "abc" would be fully wrong.
 */
export function checkAnswer(input, expected) {
  const trimmed = input.trim();
  const lower = trimmed.toLowerCase();
  const target = expected.toLowerCase();

  if (lower === target) {
    return { exact: true, accentClose: false, wrong: false, expected };
  }

  const strip = (s) => s.normalize("NFD").replace(/[\u0300-\u036f]/g, "");

  if (strip(lower) === strip(target)) {
    return { exact: false, accentClose: true, wrong: false, expected };
  }

  return { exact: false, accentClose: false, wrong: true, expected };
}
