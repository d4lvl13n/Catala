import { useState } from "react";

const INITIAL = { drills: 0, context: 0, correct: 0, total: 0 };

export default function useStats() {
  const [stats, setStats] = useState(INITIAL);

  const recordQuiz = (quizType, results) => {
    const correct = results.filter((r) => r.correct).length;
    setStats((s) => ({
      drills: s.drills + (quizType === "drill" ? 1 : 0),
      context: s.context + (quizType === "context" ? 1 : 0),
      correct: s.correct + correct,
      total: s.total + results.length,
    }));
  };

  return { stats, recordQuiz };
}
