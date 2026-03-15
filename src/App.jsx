import { useState } from "react";
import theme from "./theme";
import useStats from "./hooks/useStats";
import HomeScreen from "./views/HomeScreen";
import TableView from "./views/TableView";
import DrillMode from "./views/DrillMode";
import ContextQuiz from "./views/ContextQuiz";
import ResultsScreen from "./views/ResultsScreen";

const VIEW = { HOME: 0, TABLE: 1, DRILL: 2, CONTEXT: 3, RESULTS: 4 };

export default function App() {
  const [view, setView] = useState(VIEW.HOME);
  const [verb, setVerb] = useState(null);
  const [quizResults, setQuizResults] = useState(null);
  const [quizType, setQuizType] = useState(null);
  const { stats, recordQuiz } = useStats();

  const goHome = () => {
    setView(VIEW.HOME);
    setVerb(null);
  };
  const selectVerb = (v) => {
    setVerb(v);
    setView(VIEW.TABLE);
  };
  const goTable = () => setView(VIEW.TABLE);
  const startDrill = () => {
    setQuizType("drill");
    setView(VIEW.DRILL);
  };
  const startContext = () => {
    setQuizType("context");
    setView(VIEW.CONTEXT);
  };

  const finishQuiz = (results) => {
    setQuizResults(results);
    recordQuiz(quizType, results);
    setView(VIEW.RESULTS);
  };

  const retry = () =>
    setView(quizType === "drill" ? VIEW.DRILL : VIEW.CONTEXT);

  return (
    <div style={{ background: theme.bg, minHeight: "100vh" }}>
      {/* Top gradient */}
      <div
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          height: 160,
          background: `linear-gradient(180deg, #F3EDE4 0%, ${theme.bg} 100%)`,
          pointerEvents: "none",
          zIndex: 0,
        }}
      />

      {/* Content */}
      <div
        style={{
          maxWidth: 500,
          margin: "0 auto",
          padding: "28px 18px 48px",
          position: "relative",
          zIndex: 1,
        }}
      >
        {view === VIEW.HOME && (
          <HomeScreen onSelectVerb={selectVerb} stats={stats} />
        )}
        {view === VIEW.TABLE && verb && (
          <TableView
            verb={verb}
            onBack={goHome}
            onDrill={startDrill}
            onContext={startContext}
          />
        )}
        {view === VIEW.DRILL && verb && (
          <DrillMode verb={verb} onFinish={finishQuiz} />
        )}
        {view === VIEW.CONTEXT && verb && (
          <ContextQuiz verb={verb} onFinish={finishQuiz} />
        )}
        {view === VIEW.RESULTS && verb && quizResults && (
          <ResultsScreen
            verb={verb}
            results={quizResults}
            quizType={quizType}
            onRetry={retry}
            onHome={goHome}
            onTable={goTable}
          />
        )}
      </div>
    </div>
  );
}
