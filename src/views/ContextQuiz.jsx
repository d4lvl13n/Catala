import { useState, useMemo } from "react";
import theme from "../theme";
import { TENSES } from "../data/constants";
import { shuffle } from "../utils";
import { Chip, PrimaryBtn, ProgressBar } from "../components/ui";

const FADE_SLIDE = `@keyframes fadeSlide {
  from { opacity: 0; transform: translateY(6px) }
  to   { opacity: 1; transform: translateY(0) }
}`;

export default function ContextQuiz({ verb, onFinish }) {
  const questions = useMemo(() => {
    return shuffle(verb.sentences).map((s) => {
      const answer = verb.tenses[s.tense][s.form];
      const escaped = answer.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      const blank = s.ca.replace(new RegExp(escaped, "i"), "___");
      const wrongs = shuffle(
        verb.tenses[s.tense].filter((_, i) => i !== s.form)
      ).slice(0, 3);
      const choices = shuffle([answer, ...wrongs]);
      return { ...s, answer, blank, choices };
    });
  }, [verb]);

  const [cur, setCur] = useState(0);
  const [selected, setSelected] = useState(null);
  const [showAnswer, setShowAnswer] = useState(false);
  const [results, setResults] = useState([]);

  const q = questions[cur];

  const handleSelect = (choice) => {
    if (showAnswer) return;
    setSelected(choice);
    setShowAnswer(true);
    setResults([
      ...results,
      { ...q, selected: choice, correct: choice === q.answer },
    ]);
  };

  const next = () => {
    if (cur + 1 >= questions.length) {
      onFinish([...results]);
    } else {
      setCur(cur + 1);
      setSelected(null);
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
        <Chip color={theme.blue}>Contexte</Chip>
      </div>
      <div
        style={{
          fontFamily: theme.body,
          fontSize: 13,
          color: theme.textMuted,
          marginBottom: 16,
        }}
      >
        Compl&egrave;te la phrase avec la bonne forme
      </div>

      <ProgressBar
        value={((cur + 1) / questions.length) * 100}
        colorFrom={theme.blue}
        colorTo={verb.color}
      />

      {/* Sentence card */}
      <div
        style={{
          background: theme.surface,
          border: `1px solid ${theme.border}`,
          borderRadius: 16,
          padding: "24px 20px",
          boxShadow: theme.shadow,
          marginBottom: 16,
        }}
      >
        <Chip color={theme.textMuted}>{TENSES[q.tense]}</Chip>

        {/* Catalan sentence with blank */}
        <div
          style={{
            fontFamily: theme.display,
            fontWeight: 600,
            fontSize: q.blank.length > 30 ? 17 : 20,
            color: theme.text,
            margin: "16px 0 10px",
            lineHeight: 1.5,
          }}
        >
          {q.blank.split("___").map((part, i, arr) => (
            <span key={i}>
              {part}
              {i < arr.length - 1 && (
                <span
                  style={{
                    display: "inline-block",
                    minWidth: 60,
                    borderBottom: `3px solid ${
                      showAnswer
                        ? selected === q.answer
                          ? theme.correct
                          : theme.wrong
                        : verb.color
                    }`,
                    textAlign: "center",
                    fontWeight: 800,
                    color: showAnswer
                      ? selected === q.answer
                        ? theme.correct
                        : theme.wrong
                      : verb.color,
                    padding: "0 4px",
                    margin: "0 4px",
                    transition: "all 0.2s",
                  }}
                >
                  {showAnswer ? q.answer : "\u00A0?\u00A0"}
                </span>
              )}
            </span>
          ))}
        </div>

        {/* French translation */}
        <div
          style={{
            fontFamily: theme.body,
            fontSize: 14,
            color: theme.textMuted,
            fontStyle: "italic",
          }}
        >
          {q.fr}
        </div>
      </div>

      {/* Choices */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "1fr 1fr",
          gap: 8,
          marginBottom: 16,
        }}
      >
        {q.choices.map((choice) => {
          let bg = theme.surface,
            border = theme.border,
            color = theme.text;
          if (showAnswer) {
            if (choice === q.answer) {
              bg = theme.correctSoft;
              border = theme.correct;
              color = theme.correct;
            } else if (choice === selected) {
              bg = theme.wrongSoft;
              border = theme.wrong;
              color = theme.wrong;
            }
          }
          return (
            <button
              key={choice}
              onClick={() => handleSelect(choice)}
              style={{
                background: bg,
                border: `2px solid ${border}`,
                borderRadius: 10,
                padding: "12px 10px",
                fontFamily: theme.display,
                fontWeight: 600,
                fontSize: choice.length > 12 ? 14 : 17,
                color,
                cursor: showAnswer ? "default" : "pointer",
                transition: "all 0.15s",
                textAlign: "center",
              }}
            >
              {showAnswer && choice === q.answer && "\u2713 "}
              {showAnswer &&
                choice === selected &&
                choice !== q.answer &&
                "\u2717 "}
              {choice}
            </button>
          );
        })}
      </div>

      {showAnswer && (
        <div style={{ animation: "fadeSlide 0.2s ease" }}>
          <PrimaryBtn onClick={next}>
            {cur + 1 >= questions.length
              ? "Voir les r\u00e9sultats"
              : "Suivant \u2192"}
          </PrimaryBtn>
        </div>
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
