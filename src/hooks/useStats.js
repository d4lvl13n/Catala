import { useState } from "react";

const STORAGE_KEY = "catala-stats";

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : { drills: 0, context: 0, mixed: 0, correct: 0, total: 0 };
  } catch {
    return { drills: 0, context: 0, mixed: 0, correct: 0, total: 0 };
  }
}

function save(data) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
}

export default function useStats() {
  const [stats, setStats] = useState(load);

  const recordQuiz = (quizType, results) => {
    const correct = results.filter((r) => r.correct).length;
    setStats((s) => {
      const next = {
        drills: s.drills + (quizType === "drill" ? 1 : 0),
        context: s.context + (quizType === "context" ? 1 : 0),
        mixed: s.mixed + (quizType === "mixed" ? 1 : 0),
        correct: s.correct + correct,
        total: s.total + results.length,
      };
      save(next);
      return next;
    });
  };

  return { stats, recordQuiz };
}
