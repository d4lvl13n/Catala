import theme from "../../theme";

export default function Chip({ color, children, style }) {
  return (
    <span
      style={{
        display: "inline-block",
        background: color + "14",
        color,
        fontFamily: theme.mono,
        fontSize: 10,
        fontWeight: 500,
        padding: "3px 9px",
        borderRadius: 6,
        letterSpacing: 0.4,
        textTransform: "uppercase",
        ...style,
      }}
    >
      {children}
    </span>
  );
}
