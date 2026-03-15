import theme from "../theme";
import { TENSES } from "../data/constants";
import { Chip, PrimaryBtn, SecondaryBtn } from "../components/ui";

export default function ResultsScreen({
  verb,
  results,
  quizType,
  onRetry,
  onHome,
  onTable,
}) {
  const correct = results.filter((r) => r.correct).length;
  const pct = Math.round((correct / results.length) * 100);
  const wrongs = results.filter((r) => !r.correct);

  let msg = "Continue !",
    emoji = "\uD83D\uDCAA";
  if (pct === 100) {
    msg = "Parfait !";
    emoji = "\uD83C\uDFC6";
  } else if (pct >= 80) {
    msg = "Excellent !";
    emoji = "\uD83C\uDF1F";
  } else if (pct >= 60) {
    msg = "Pas mal !";
    emoji = "\uD83D\uDC4D";
  } else if (pct < 40) {
    msg = "Revois le tableau et r\u00e9essaie !";
    emoji = "\uD83D\uDCD6";
  }

  return (
    <div>
      {/* Score card */}
      <div
        style={{
          textAlign: "center",
          background: theme.surface,
          border: `1px solid ${theme.border}`,
          borderRadius: 16,
          padding: "32px 24px",
          boxShadow: theme.shadow,
          marginBottom: 20,
        }}
      >
        <div style={{ fontSize: 44, marginBottom: 10 }}>{emoji}</div>
        <div
          style={{
            fontFamily: theme.display,
            fontWeight: 800,
            fontSize: 42,
            color: pct >= 60 ? theme.correct : theme.accent,
          }}
        >
          {pct}%
        </div>
        <div
          style={{
            fontFamily: theme.body,
            fontSize: 14,
            fontWeight: 600,
            color: theme.textMid,
            marginTop: 4,
          }}
        >
          {correct}/{results.length} &mdash; {msg}
        </div>
        <Chip color={verb.color} style={{ marginTop: 10 }}>
          {verb.ca} &middot; {quizType === "drill" ? "Drill" : "Contexte"}
        </Chip>
      </div>

      {/* Wrong answers to review */}
      {wrongs.length > 0 && (
        <div style={{ marginBottom: 20 }}>
          <div
            style={{
              fontFamily: theme.mono,
              fontSize: 10,
              fontWeight: 500,
              color: theme.textMuted,
              textTransform: "uppercase",
              letterSpacing: 1,
              marginBottom: 8,
            }}
          >
            &Agrave; r&eacute;viser
          </div>
          {wrongs.map((r, i) => (
            <div
              key={i}
              style={{
                background: theme.surface,
                border: `1px solid ${theme.border}`,
                borderRadius: 10,
                padding: "12px 16px",
                marginBottom: 6,
              }}
            >
              {r.blank ? (
                <div
                  style={{
                    fontFamily: theme.body,
                    fontSize: 14,
                    color: theme.text,
                    lineHeight: 1.5,
                  }}
                >
                  {r.fr}
                </div>
              ) : (
                <div
                  style={{
                    fontFamily: theme.body,
                    fontSize: 14,
                    color: theme.textMid,
                  }}
                >
                  {r.pronoun} ({TENSES[r.tense]})
                </div>
              )}
              <div
                style={{
                  display: "flex",
                  gap: 12,
                  marginTop: 6,
                  flexWrap: "wrap",
                }}
              >
                <span
                  style={{
                    fontFamily: theme.mono,
                    fontSize: 12,
                    color: theme.wrong,
                    textDecoration: "line-through",
                  }}
                >
                  {r.userAnswer || r.selected}
                </span>
                <span
                  style={{
                    fontFamily: theme.mono,
                    fontSize: 12,
                    color: theme.correct,
                    fontWeight: 600,
                  }}
                >
                  &rarr; {r.answer}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Actions */}
      <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <SecondaryBtn onClick={onRetry}>R&eacute;essayer</SecondaryBtn>
        <SecondaryBtn onClick={onTable}>Revoir le tableau</SecondaryBtn>
      </div>
      <div style={{ marginTop: 8 }}>
        <PrimaryBtn onClick={onHome}>Tous les verbes</PrimaryBtn>
      </div>
    </div>
  );
}
