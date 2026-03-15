import theme from "../../theme";

export default function SecondaryBtn({ onClick, children }) {
  return (
    <button
      onClick={onClick}
      style={{
        flex: 1,
        padding: "12px 16px",
        background: theme.surface,
        border: `2px solid ${theme.accent}`,
        borderRadius: theme.radius,
        fontFamily: theme.body,
        fontWeight: 700,
        fontSize: 13,
        color: theme.accent,
        cursor: "pointer",
      }}
    >
      {children}
    </button>
  );
}
