import { useState, useMemo, useRef } from "react";
import theme from "../theme";
import { TENSES, PRONOUNS, PRONOUNS_FR } from "../data/constants";
import VERBS from "../data/verbs";
import { shuffle, checkAnswer } from "../utils";
import { Chip, PrimaryBtn, ProgressBar, AccentKeyboard, SpeakButton } from "../components/ui";
import useSpeech from "../hooks/useSpeech";

const FADE_SLIDE = `@keyframes fadeSlide {
  from { opacity: 0; transform: translateY(6px) }
  to   { opacity: 1; transform: translateY(0) }
}`;

const QUESTION_COUNT = 15;

export default function MixedDrill({ getDueCards, onFinish }) {
  const { speak, supported: speechSupported } = useSpeech();
  const inputRef = useRef(null);

  const verbMap = useMemo(() => {
    const map = {};
    VERBS.forEach((v) => (map[v.id] = v));
    return map;
  }, []);

  const questions = useMemo(() => {
    const due = getDueCards(VERBS);
    const selected = due.slice(0, QUESTION_COUNT);
    return shuffle(selected).map((item) => {
      const verb = verbMap[item.verbId];
      return {
        verbId: item.verbId,
        verb,
        tense: item.tense,
        pronounIdx: item.pronounIdx,
        pronoun: PRONOUNS[item.pronounIdx],
        pronounFr: PRONOUNS_FR[item.pronounIdx],
        answer: verb.tenses[item.tense][item.pronounIdx],
      };
    });
  }, [getDueCards, verbMap]);

  const [cur, setCur] = useState(0);
  const [input, setInput] = useState("");
  const [showAnswer, setShowAnswer] = useState(false);
  const [results, setResults] = useState([]);

  const q = questions[cur];
  const lastResult = results.length > 0 ? results[results.length - 1] : null;

  const insertAccent = (ch) => {
    const el = inputRef.current;
    if (!el) return;
    const start = el.selectionStart;
    const end = el.selectionEnd;
    const next = input.slice(0, start) + ch + input.slice(end);
    setInput(next);
    requestAnimationFrame(() => {
      el.selectionStart = el.selectionEnd = start + ch.length;
    });
  };

  const check = () => {
    if (showAnswer) return;
    const result = checkAnswer(input, q.answer);
    const correct = result.exact || result.accentClose;
    setResults([
      ...results,
      { ...q, userAnswer: input.trim(), correct, accentClose: result.accentClose },
    ]);
    setShowAnswer(true);
    if (speechSupported) speak(q.answer);
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

  const feedbackColor = lastResult
    ? lastResult.correct
      ? lastResult.accentClose
        ? theme.gold
        : theme.correct
      : theme.wrong
    : null;

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
          Pratique mixte
        </div>
        <Chip color={theme.accent}>SRS</Chip>
      </div>
      <div
        style={{
          fontFamily: theme.body,
          fontSize: 13,
          color: theme.textMuted,
          marginBottom: 16,
        }}
      >
        Les formes les plus urgentes &agrave; r&eacute;viser
      </div>

      <ProgressBar
        value={((cur + 1) / questions.length) * 100}
        colorFrom={theme.accent}
        colorTo={theme.verb}
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
        <div style={{ display: "flex", justifyContent: "center", gap: 6, marginBottom: 12 }}>
          <Chip color={q.verb.color}>{q.verb.ca}</Chip>
          <Chip color={theme.textMuted}>{TENSES[q.tense]}</Chip>
        </div>

        <div
          style={{
            fontFamily: theme.display,
            fontWeight: 800,
            fontSize: 28,
            color: q.verb.color,
            margin: "8px 0 4px",
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
          ({q.pronounFr}) &mdash; {q.verb.fr}
        </div>

        <div style={{ margin: "20px auto 0", maxWidth: 280 }}>
          <input
            ref={inputRef}
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
                  ? lastResult?.accentClose
                    ? theme.goldSoft
                    : theme.correctSoft
                  : theme.wrongSoft
                : theme.bgSubtle,
              border: `2px solid ${
                showAnswer ? feedbackColor : theme.border
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
          {!showAnswer && <AccentKeyboard onInsert={insertAccent} />}
        </div>

        {showAnswer && (
          <div style={{ marginTop: 14, animation: "fadeSlide 0.2s ease" }}>
            {lastResult?.accentClose ? (
              <div>
                <div
                  style={{
                    fontFamily: theme.body,
                    fontWeight: 700,
                    fontSize: 15,
                    color: theme.gold,
                  }}
                >
                  Presque ! Attention aux accents :
                </div>
                <div
                  style={{
                    fontFamily: theme.display,
                    fontWeight: 800,
                    fontSize: 22,
                    color: theme.text,
                    marginTop: 4,
                    display: "inline-flex",
                    alignItems: "center",
                    gap: 8,
                  }}
                >
                  {q.answer}
                  {speechSupported && (
                    <SpeakButton onClick={() => speak(q.answer)} />
                  )}
                </div>
              </div>
            ) : lastResult?.correct ? (
              <div
                style={{
                  fontFamily: theme.body,
                  fontWeight: 700,
                  fontSize: 15,
                  color: theme.correct,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  gap: 8,
                }}
              >
                &#10003; Correct !
                {speechSupported && (
                  <SpeakButton onClick={() => speak(q.answer)} size={24} />
                )}
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
                    display: "inline-flex",
                    alignItems: "center",
                    gap: 8,
                  }}
                >
                  {q.answer}
                  {speechSupported && (
                    <SpeakButton onClick={() => speak(q.answer)} />
                  )}
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
