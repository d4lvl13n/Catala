import { useState } from "react";
import theme from "../theme";
import { TENSES, PRONOUNS, PRONOUNS_FR } from "../data/constants";
import { BackButton, Chip, SecondaryBtn } from "../components/ui";

export default function TableView({ verb, onBack, onDrill, onContext }) {
  const [tense, setTense] = useState("present");

  return (
    <div>
      {/* Header */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 12,
          marginBottom: 20,
        }}
      >
        <BackButton onClick={onBack} />
        <div>
          <div
            style={{
              fontFamily: theme.display,
              fontWeight: 800,
              fontSize: 22,
              color: theme.text,
            }}
          >
            {verb.ca}{" "}
            <span style={{ fontWeight: 400, color: theme.textMuted }}>
              &mdash; {verb.fr}
            </span>
          </div>
          <Chip color={verb.color}>{verb.group}</Chip>
        </div>
      </div>

      {/* Tense tabs */}
      <TenseTabs current={tense} onChange={setTense} />

      {/* Conjugation rows */}
      <div
        style={{
          background: theme.surface,
          border: `1px solid ${theme.border}`,
          borderRadius: theme.radius,
          overflow: "hidden",
          boxShadow: theme.shadow,
          marginBottom: 16,
        }}
      >
        {PRONOUNS.map((pro, i) => (
          <div
            key={i}
            style={{
              display: "flex",
              alignItems: "center",
              padding: "12px 18px",
              borderBottom: i < 5 ? `1px solid ${theme.border}` : "none",
              background:
                i % 2 === 0 ? theme.surface : theme.bgSubtle + "80",
            }}
          >
            <div style={{ width: 100, flexShrink: 0 }}>
              <div
                style={{
                  fontFamily: theme.body,
                  fontSize: 13,
                  fontWeight: 600,
                  color: theme.textMid,
                }}
              >
                {pro}
              </div>
              <div
                style={{
                  fontFamily: theme.body,
                  fontSize: 11,
                  color: theme.textLight,
                }}
              >
                {PRONOUNS_FR[i]}
              </div>
            </div>
            <div
              style={{
                fontFamily: theme.display,
                fontSize: 17,
                fontWeight: 600,
                color: verb.color,
              }}
            >
              {verb.tenses[tense][i]}
            </div>
          </div>
        ))}
      </div>

      {/* Example sentences for current tense */}
      <SentenceExamples verb={verb} tense={tense} />

      {/* Action buttons */}
      <div style={{ display: "flex", gap: 8 }}>
        <SecondaryBtn onClick={onDrill}>Drill conjugaison</SecondaryBtn>
        <button
          onClick={onContext}
          style={{
            flex: 1,
            padding: "12px 16px",
            background: theme.accent,
            border: "none",
            borderRadius: theme.radius,
            fontFamily: theme.body,
            fontWeight: 700,
            fontSize: 13,
            color: "#fff",
            cursor: "pointer",
          }}
        >
          Quiz en contexte
        </button>
      </div>
    </div>
  );
}

function TenseTabs({ current, onChange }) {
  return (
    <div
      style={{
        display: "flex",
        gap: 4,
        marginBottom: 16,
        background: theme.bgSubtle,
        borderRadius: 10,
        padding: 3,
      }}
    >
      {Object.entries(TENSES).map(([key, label]) => (
        <button
          key={key}
          onClick={() => onChange(key)}
          style={{
            flex: 1,
            padding: "9px 8px",
            border: "none",
            borderRadius: 8,
            background: current === key ? theme.surface : "transparent",
            boxShadow: current === key ? theme.shadow : "none",
            fontFamily: theme.body,
            fontWeight: current === key ? 700 : 500,
            fontSize: 12,
            color: current === key ? theme.text : theme.textMuted,
            cursor: "pointer",
            transition: "all 0.15s",
          }}
        >
          {label}
        </button>
      ))}
    </div>
  );
}

function SentenceExamples({ verb, tense }) {
  const filtered = verb.sentences.filter((s) => s.tense === tense);
  if (filtered.length === 0) return null;

  return (
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
        Exemples en contexte
      </div>
      {filtered.map((s, i) => (
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
          <div
            style={{
              fontFamily: theme.display,
              fontSize: 15,
              fontWeight: 600,
              color: theme.text,
              lineHeight: 1.4,
            }}
          >
            {s.ca}
          </div>
          <div
            style={{
              fontFamily: theme.body,
              fontSize: 13,
              color: theme.textMuted,
              marginTop: 3,
            }}
          >
            {s.fr}
          </div>
          <Chip color={verb.color} style={{ marginTop: 6 }}>
            {PRONOUNS[s.form]} &rarr; {verb.tenses[tense][s.form]}
          </Chip>
        </div>
      ))}
    </div>
  );
}
