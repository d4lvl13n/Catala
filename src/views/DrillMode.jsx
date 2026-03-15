import { useState, useMemo } from "react";
import theme from "../theme";
import { TENSES, PRONOUNS, PRONOUNS_FR } from "../data/constants";
import { shuffle } from "../utils";
import { Chip, PrimaryBtn, ProgressBar } from "../components/ui";

const FADE_SLIDE = `@keyframes fadeSlide {
  from { opacity: 0; transform: translateY(6px) }
  to   { opacity: 1; transform: translateY(0) }
}`;

export default function DrillMode({ verb, onFinish }) {
  const questions = useMemo(() => {
    const qs = [];
    Object.entries(verb.tenses).forEach(([tense, forms]) => {
      forms.forEach((form, i) => {
        qs.push({
          tense,
          pronoun: PRONOUNS[i],
          pronounFr: PRONOUNS_FR[i],
          answer: form,
          pronounIdx: i,
        });
      });
    });
    return shuffle(qs).slice(0, 12);
  }, [verb]);

  const [cur, setCur] = useState(0);
  const [input, setInput] = useState("");
  const [showAnswer, setShowAnswer] = useState(false);
  const [results, setResults] = useState([]);

  const q = questions[cur];
  const lastResult = results.length > 0 ? results[results.length - 1] : null;

  const check = () => {
    if (showAnswer) return;
    const correct = input.trim().toLowerCase() === q.answer.toLowerCase();
    setResults([...results, { ...q, userAnswer: input.trim(), correct }]);
    setShowAnswer(true);
  };

  const next = () => {
    if (cur + 1 >= questions.length) {
      onFinish([...results]);
    } else {
      setCur(cur + 1);
      setInput("");
      setShowAnswer(false);
    }
  };

  return (
    <div>
      {/* Title */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 12,
          marginBottom: 4,
        }}
      >
        <div
          style={{
            fontFamily: theme.display,
            fontWeight: 800,
            fontSize: 20,
            color: theme.text,
          }}
        >
          {verb.ca}
        </div>
        <Chip color={verb.color}>Drill</Chip>
      </div>
      <div
        style={{
          fontFamily: theme.body,
          fontSize: 13,
          color: theme.textMuted,
          marginBottom: 16,
        }}
      >
        Tape la forme conjugu&eacute;e correcte
      </div>

      <ProgressBar
        value={((cur + 1) / questions.length) * 100}
        colorFrom={verb.color}
        colorTo={theme.accent}
      />

      {/* Question card */}
      <div
        style={{
          background: theme.surface,
          border: `1px solid ${theme.border}`,
          borderRadius: 16,
          padding: "28px 24px",
          textAlign: "center",
          boxShadow: theme.shadow,
          marginBottom: 16,
        }}
      >
        <Chip color={theme.textMuted}>{TENSES[q.tense]}</Chip>
        <div
          style={{
            fontFamily: theme.display,
            fontWeight: 800,
            fontSize: 28,
            color: verb.color,
            margin: "16px 0 4px",
          }}
        >
          {q.pronoun}
        </div>
        <div
          style={{
            fontFamily: theme.body,
            fontSize: 13,
            color: theme.textLight,
          }}
        >
          ({q.pronounFr})
        </div>

        <div style={{ margin: "20px auto 0", maxWidth: 280 }}>
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                showAnswer ? next() : check();
              }
            }}
            disabled={showAnswer}
            placeholder="conjugaison\u2026"
            autoFocus
            style={{
              width: "100%",
              boxSizing: "border-box",
              background: showAnswer
                ? lastResult?.correct
                  ? theme.correctSoft
                  : theme.wrongSoft
                : theme.bgSubtle,
              border: `2px solid ${
                showAnswer
                  ? lastResult?.correct
                    ? theme.correct
                    : theme.wrong
                  : theme.border
              }`,
              borderRadius: 10,
              padding: "12px 16px",
              fontFamily: theme.display,
              fontSize: 20,
              fontWeight: 600,
              color: theme.text,
              textAlign: "center",
              outline: "none",
              transition: "all 0.2s",
            }}
          />
        </div>

        {showAnswer && (
          <div style={{ marginTop: 14, animation: "fadeSlide 0.2s ease" }}>
            {lastResult?.correct ? (
              <div
                style={{
                  fontFamily: theme.body,
                  fontWeight: 700,
                  fontSize: 15,
                  color: theme.correct,
                }}
              >
                &#10003; Correct !
              </div>
            ) : (
              <div>
                <div
                  style={{
                    fontFamily: theme.body,
                    fontWeight: 700,
                    fontSize: 15,
                    color: theme.wrong,
                  }}
                >
                  &#10007; La bonne r&eacute;ponse :
                </div>
                <div
                  style={{
                    fontFamily: theme.display,
                    fontWeight: 800,
                    fontSize: 22,
                    color: theme.text,
                    marginTop: 4,
                  }}
                >
                  {q.answer}
                </div>
              </div>
            )}
          </div>
        )}
      </div>

      {!showAnswer ? (
        <PrimaryBtn onClick={check} disabled={!input.trim()}>
          V&eacute;rifier
        </PrimaryBtn>
      ) : (
        <PrimaryBtn onClick={next}>
          {cur + 1 >= questions.length
            ? "Voir les r\u00e9sultats"
            : "Suivant \u2192"}
        </PrimaryBtn>
      )}

      <div
        style={{
          textAlign: "center",
          fontFamily: theme.body,
          fontSize: 12,
          color: theme.textLight,
          marginTop: 10,
        }}
      >
        {cur + 1} / {questions.length}
      </div>

      <style>{FADE_SLIDE}</style>
    </div>
  );
}
