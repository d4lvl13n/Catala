import theme from "../../theme";

/**
 * Small speaker icon button. Calls `onClick` to trigger speech.
 * Rendered inline next to text elements.
 */
export default function SpeakButton({ onClick, size = 28 }) {
  return (
    <button
      type="button"
      onClick={onClick}
      title="&Eacute;couter"
      style={{
        width: size,
        height: size,
        background: theme.bgSubtle,
        border: `1px solid ${theme.border}`,
        borderRadius: size / 2,
        cursor: "pointer",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: 0,
        flexShrink: 0,
        transition: "all 0.15s",
        color: theme.textMid,
        fontSize: size * 0.5,
      }}
    >
      &#x1f50a;
    </button>
  );
}
