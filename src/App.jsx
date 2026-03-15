import { useState } from "react";
import theme from "./theme";
import useStats from "./hooks/useStats";
import useSRS from "./hooks/useSRS";
import HomeScreen from "./views/HomeScreen";
import TableView from "./views/TableView";
import DrillMode from "./views/DrillMode";
import ContextQuiz from "./views/ContextQuiz";
import MixedDrill from "./views/MixedDrill";
import ResultsScreen from "./views/ResultsScreen";

const VIEW = { HOME: 0, TABLE: 1, DRILL: 2, CONTEXT: 3, MIXED: 4, RESULTS: 5 };

export default function App() {
  const [view, setView] = useState(VIEW.HOME);
  const [verb, setVerb] = useState(null);
  const [quizResults, setQuizResults] = useState(null);
  const [quizType, setQuizType] = useState(null);
  const { stats, recordQuiz } = useStats();
  const srs = useSRS();

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
  const startMixed = () => {
    setQuizType("mixed");
    setVerb(null);
    setView(VIEW.MIXED);
  };

  const finishQuiz = (results) => {
    setQuizResults(results);
    recordQuiz(quizType, results);
    // Feed results into SRS
    if (quizType === "mixed") {
      // Mixed results already have verbId and pronounIdx
      for (const r of results) {
        srs.recordAnswer(r.verbId, r.tense, r.pronounIdx, r.correct);
      }
    } else if (verb) {
      srs.recordResults(verb.id, results);
    }
    setView(VIEW.RESULTS);
  };

  const retry = () => {
    if (quizType === "mixed") setView(VIEW.MIXED);
    else if (quizType === "drill") setView(VIEW.DRILL);
    else setView(VIEW.CONTEXT);
  };

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
          <HomeScreen
            onSelectVerb={selectVerb}
            onMixedDrill={startMixed}
            stats={stats}
            srs={srs}
          />
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
        {view === VIEW.MIXED && (
          <MixedDrill getDueCards={srs.getDueCards} onFinish={finishQuiz} />
        )}
        {view === VIEW.RESULTS && quizResults && (
          <ResultsScreen
            verb={verb}
            results={quizResults}
            quizType={quizType}
            onRetry={retry}
            onHome={goHome}
            onTable={verb ? goTable : goHome}
          />
        )}
      </div>
    </div>
  );
}
