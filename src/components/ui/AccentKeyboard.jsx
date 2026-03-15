import theme from "../../theme";

const KEYS = [
  "\u00e0", "\u00e8", "\u00e9", "\u00ec", "\u00f2", "\u00f3", "\u00fa",
  "\u00fc", "\u00ef", "\u00e7", "\u00b7",
];

/**
 * Soft keyboard strip for Catalan special characters.
 * Calls onInsert(char) when a key is tapped — the parent
 * is responsible for inserting it at the cursor position.
 */
export default function AccentKeyboard({ onInsert }) {
  return (
    <div
      style={{
        display: "flex",
        flexWrap: "wrap",
        justifyContent: "center",
        gap: 5,
        margin: "10px auto 0",
        maxWidth: 320,
      }}
    >
      {KEYS.map((ch) => (
        <button
          key={ch}
          type="button"
          onMouseDown={(e) => {
            // Prevent stealing focus from the input
            e.preventDefault();
            onInsert(ch);
          }}
          style={{
            width: 32,
            height: 36,
            background: theme.bgSubtle,
            border: `1px solid ${theme.border}`,
            borderRadius: 6,
            fontFamily: theme.display,
            fontSize: 16,
            fontWeight: 600,
            color: theme.text,
            cursor: "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            transition: "all 0.1s",
            padding: 0,
          }}
        >
          {ch}
        </button>
      ))}
    </div>
  );
}
