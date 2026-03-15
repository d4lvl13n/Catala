import { useCallback, useRef } from "react";

/**
 * Web Speech API hook for Catalan text-to-speech.
 *
 * Falls back gracefully if the browser doesn't support speech synthesis
 * or doesn't have a Catalan voice.
 */
export default function useSpeech() {
  const supported = typeof window !== "undefined" && "speechSynthesis" in window;
  const speakingRef = useRef(false);

  const speak = useCallback(
    (text, lang = "ca-ES") => {
      if (!supported || speakingRef.current) return;

      // Cancel any in-progress speech
      window.speechSynthesis.cancel();

      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = lang;
      utterance.rate = 0.9;
      utterance.pitch = 1;

      // Try to find a Catalan voice, fall back to any available
      const voices = window.speechSynthesis.getVoices();
      const catalanVoice = voices.find((v) => v.lang.startsWith("ca"));
      if (catalanVoice) {
        utterance.voice = catalanVoice;
      }

      speakingRef.current = true;
      utterance.onend = () => {
        speakingRef.current = false;
      };
      utterance.onerror = () => {
        speakingRef.current = false;
      };

      window.speechSynthesis.speak(utterance);
    },
    [supported]
  );

  return { speak, supported };
}
