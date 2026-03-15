import { useMemo } from "react";
import theme from "../theme";
import VERBS from "../data/verbs";

export default function HomeScreen({ onSelectVerb, onMixedDrill, stats, srs }) {
  const groups = useMemo(() => {
    const map = {};
    VERBS.forEach((v) => {
      if (!map[v.group]) map[v.group] = [];
      map[v.group].push(v);
    });
    return Object.entries(map);
  }, []);

  const dueCount = srs.getDueCount(VERBS);
  const seenCount = srs.getSeenCount();
  const totalForms = VERBS.length * 18; // 6 pronouns x 3 tenses

  return (
    <div>
      {/* Header */}
      <div style={{ textAlign: "center", marginBottom: 28 }}>
        <div
          style={{
            fontSize: 14,
            color: theme.textMuted,
            fontFamily: theme.body,
            fontWeight: 600,
            letterSpacing: 1.5,
            textTransform: "uppercase",
            marginBottom: 8,
          }}
        >
          Fran&ccedil;ais &rarr; Catal&agrave;
        </div>
        <h1
          style={{
            fontFamily: theme.display,
            fontWeight: 800,
            fontSize: 32,
            color: theme.text,
            margin: "0 0 6px",
            lineHeight: 1.15,
          }}
        >
          Apr&egrave;n els verbs
        </h1>
        <p
          style={{
            fontFamily: theme.body,
            fontSize: 14,
            color: theme.textMuted,
            margin: 0,
          }}
        >
          Conjugaisons, exemples en contexte, et quiz
        </p>
      </div>

      {/* Stats bar */}
      {stats.total > 0 && <StatsBar stats={stats} seenCount={seenCount} totalForms={totalForms} />}

      {/* Practice All / SRS button */}
      <button
        onClick={onMixedDrill}
        style={{
          width: "100%",
          padding: "16px 20px",
          marginBottom: 24,
          background: `linear-gradient(135deg, ${theme.accent}, ${theme.accentHover})`,
          color: "#fff",
          border: "none",
          borderRadius: theme.radius,
          fontFamily: theme.body,
          fontWeight: 700,
          fontSize: 15,
          cursor: "pointer",
          boxShadow: "0 3px 12px rgba(192,88,43,0.25)",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          gap: 10,
        }}
      >
        <span style={{ fontSize: 18 }}>&#9881;</span>
        Pratique mixte
        {dueCount > 0 && (
          <span
            style={{
              background: "rgba(255,255,255,0.25)",
              padding: "2px 8px",
              borderRadius: 8,
              fontSize: 12,
              fontWeight: 600,
            }}
          >
            {dueCount} &agrave; r&eacute;viser
          </span>
        )}
      </button>

      {/* Verb groups */}
      {groups.map(([group, verbs]) => (
        <VerbGroup
          key={group}
          group={group}
          verbs={verbs}
          onSelect={onSelectVerb}
          srs={srs}
        />
      ))}
    </div>
  );
}

function StatsBar({ stats, seenCount, totalForms }) {
  const items = [
    { label: "Sessions", value: stats.drills + stats.context + stats.mixed, color: theme.textMid },
    { label: "Formes vues", value: `${seenCount}/${totalForms}`, color: theme.blue },
    {
      label: "Score",
      value:
        stats.total > 0
          ? Math.round((stats.correct / stats.total) * 100) + "%"
          : "\u2014",
      color: theme.accent,
    },
  ];

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        gap: 20,
        marginBottom: 20,
        padding: "14px 20px",
        background: theme.surface,
        borderRadius: theme.radius,
        border: `1px solid ${theme.border}`,
        boxShadow: theme.shadow,
      }}
    >
      {items.map((s) => (
        <div key={s.label} style={{ textAlign: "center" }}>
          <div
            style={{
              fontFamily: theme.display,
              fontWeight: 800,
              fontSize: 20,
              color: s.color,
            }}
          >
            {s.value}
          </div>
          <div
            style={{
              fontFamily: theme.body,
              fontSize: 10,
              color: theme.textMuted,
              fontWeight: 600,
              textTransform: "uppercase",
              letterSpacing: 0.5,
            }}
          >
            {s.label}
          </div>
        </div>
      ))}
    </div>
  );
}

function VerbGroup({ group, verbs, onSelect, srs }) {
  return (
    <div style={{ marginBottom: 20 }}>
      <div
        style={{
          fontFamily: theme.mono,
          fontSize: 11,
          fontWeight: 500,
          color: theme.textMuted,
          textTransform: "uppercase",
          letterSpacing: 1,
          marginBottom: 8,
          paddingLeft: 2,
        }}
      >
        {group}
      </div>
      <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
        {verbs.map((verb) => (
          <VerbCard
            key={verb.id}
            verb={verb}
            onClick={() => onSelect(verb)}
            mastery={srs.getVerbMastery(verb.id, verb.tenses)}
          />
        ))}
      </div>
    </div>
  );
}

function MasteryBar({ value, color }) {
  return (
    <div
      style={{
        width: 48,
        height: 4,
        background: theme.border,
        borderRadius: 2,
        overflow: "hidden",
        flexShrink: 0,
      }}
    >
      <div
        style={{
          width: `${value}%`,
          height: "100%",
          background: value >= 80 ? theme.correct : value >= 40 ? color : theme.textLight,
          borderRadius: 2,
          transition: "width 0.3s",
        }}
      />
    </div>
  );
}

function VerbCard({ verb, onClick, mastery }) {
  return (
    <div
      onClick={onClick}
      style={{
        background: theme.surface,
        border: `1px solid ${theme.border}`,
        borderRadius: theme.radius,
        padding: "14px 18px",
        cursor: "pointer",
        transition: "all 0.15s",
        boxShadow: theme.shadow,
        display: "flex",
        alignItems: "center",
        gap: 14,
        borderLeft: `3px solid ${verb.color}`,
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.boxShadow =
          "0 3px 14px rgba(26,22,18,0.09)";
        e.currentTarget.style.transform = "translateY(-1px)";
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.boxShadow = theme.shadow;
        e.currentTarget.style.transform = "none";
      }}
    >
      <div style={{ flex: 1 }}>
        <div style={{ display: "flex", alignItems: "baseline", gap: 10 }}>
          <span
            style={{
              fontFamily: theme.display,
              fontWeight: 800,
              fontSize: 18,
              color: theme.text,
            }}
          >
            {verb.ca}
          </span>
          <span
            style={{
              fontFamily: theme.body,
              fontSize: 14,
              color: theme.textMuted,
            }}
          >
            &mdash; {verb.fr}
          </span>
        </div>
        <div
          style={{
            fontFamily: theme.mono,
            fontSize: 12,
            color: theme.textLight,
            marginTop: 3,
          }}
        >
          {verb.tenses.present.slice(0, 3).join(", ")}&hellip;
        </div>
      </div>
      <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 4 }}>
        {mastery > 0 && (
          <>
            <span
              style={{
                fontFamily: theme.mono,
                fontSize: 10,
                color: mastery >= 80 ? theme.correct : mastery >= 40 ? verb.color : theme.textLight,
                fontWeight: 600,
              }}
            >
              {mastery}%
            </span>
            <MasteryBar value={mastery} color={verb.color} />
          </>
        )}
        {mastery === 0 && (
          <div style={{ color: theme.textLight, fontSize: 16 }}>&rarr;</div>
        )}
      </div>
    </div>
  );
}
