import theme from "../../theme";

export default function BackButton({ onClick }) {
  return (
    <button
      onClick={onClick}
      style={{
        background: theme.surface,
        border: `1px solid ${theme.border}`,
        borderRadius: 10,
        width: 36,
        height: 36,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        cursor: "pointer",
        fontSize: 15,
        color: theme.textMid,
        flexShrink: 0,
      }}
    >
      &#8592;
    </button>
  );
}
