import theme from "../../theme";

export default function ProgressBar({ value, colorFrom, colorTo }) {
  return (
    <div
      style={{
        background: theme.border,
        borderRadius: 6,
        height: 4,
        marginBottom: 24,
        overflow: "hidden",
      }}
    >
      <div
        style={{
          width: `${value}%`,
          height: "100%",
          background: `linear-gradient(90deg, ${colorFrom}, ${colorTo})`,
          borderRadius: 6,
          transition: "width 0.3s",
        }}
      />
    </div>
  );
}
