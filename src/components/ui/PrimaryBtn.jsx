import theme from "../../theme";

export default function PrimaryBtn({ onClick, children, disabled }) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      style={{
        width: "100%",
        padding: "13px 20px",
        background: disabled ? theme.textLight : theme.accent,
        color: "#fff",
        border: "none",
        borderRadius: theme.radius,
        fontFamily: theme.body,
        fontWeight: 700,
        fontSize: 14,
        cursor: disabled ? "default" : "pointer",
        transition: "all 0.15s",
        boxShadow: disabled ? "none" : "0 2px 8px rgba(192,88,43,0.2)",
      }}
    >
      {children}
    </button>
  );
}
