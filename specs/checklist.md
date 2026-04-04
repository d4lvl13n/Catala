# App Store Checklist

## Before Submission

### Apple Developer Account
- [ ] Apple Developer Program enrolled ($99/year)
- [ ] Bundle ID registered: `com.yourname.catala` (replace with actual)
- [ ] Signing certificate + provisioning profile configured in Xcode

### App Store Connect Metadata
- [ ] App name: "Catala — Aprèn els verbs" (or similar, check availability)
- [ ] Subtitle: "Conjugaisons catalanes" (max 30 chars)
- [ ] Category: Education
- [ ] Age rating: 4+ (no objectionable content)
- [ ] Keywords: catalan, conjugaison, verbes, apprendre, langue, majorque, barcelona, catalogne
- [ ] Description (French): App purpose, features, what makes it useful
- [ ] Promotional text (optional): Can be updated without review
- [ ] Support URL (required)
- [ ] Privacy policy URL (required)

### Screenshots (required)
- [ ] iPhone 6.7" (iPhone 15 Pro Max) — at least 3 screenshots
- [ ] iPhone 6.5" (iPhone 11 Pro Max) — at least 3 screenshots
- [ ] Suggested screens to capture: HomeScreen, TableView, DrillMode (with answer), ResultsScreen

### App Icon
- [ ] 1024×1024 icon for App Store Connect
- [ ] All required sizes in Assets.xcassets (Xcode generates from single 1024 source)
- [ ] No transparency, no rounded corners (Apple adds them)
- [ ] Design: something recognizable — consider Catalan flag colors, a "V" for verbs, or a book motif

### Launch Screen
- [ ] Storyboard or SwiftUI launch screen configured
- [ ] Matches app background color (#F7F3ED)
- [ ] App name or logo centered

### Privacy Policy
- [ ] Hosted at a public URL
- [ ] Content: "No personal data collected. All learning progress is stored locally on your device. No analytics, no tracking, no accounts."
- [ ] If analytics are added later: update policy before submission

---

## Technical Requirements

### Build & Runtime
- [ ] App runs on iOS 17.0+
- [ ] Builds with latest Xcode (16+) and Swift 6
- [ ] No crashes on launch, during quizzes, or on results screen
- [ ] Works in airplane mode (offline fallback with bundled verbs)
- [ ] Handles interruptions gracefully (phone call during quiz, backgrounding)

### Safe Areas & Device Compatibility
- [ ] Content respects safe area insets (notch, Dynamic Island, home indicator)
- [ ] Status bar text is readable over background color
- [ ] Works on all iPhone sizes: SE (3rd gen) through 15 Pro Max
- [ ] iPad: runs in compatibility mode (acceptable for v1) or basic iPad layout

### Accessibility
- [ ] All interactive elements are accessible via VoiceOver
- [ ] Buttons have accessibility labels
- [ ] Text respects Dynamic Type (at least partially — don't break layout at largest sizes)
- [ ] Color is not the sole indicator of state (correct/wrong also has text/icon)

### Data & Storage
- [ ] SwiftData schema migration strategy (even if v1 has no migrations, the infrastructure should be ready)
- [ ] App handles corrupted/missing SwiftData gracefully (reset to defaults)
- [ ] Bundled `verbs-fallback.json` is valid and complete

### Networking
- [ ] API calls use HTTPS
- [ ] App works if API is unreachable (fallback to bundled data)
- [ ] ETag caching implemented
- [ ] No hardcoded IP addresses (use domain name)

### Text-to-Speech
- [ ] AVSpeechSynthesizer works with ca-ES locale
- [ ] Graceful fallback if no Catalan voice available on device
- [ ] Speech doesn't overlap (cancel previous utterance before starting new one)

---

## App Store Review Preparation

### Common Rejection Reasons (and how to avoid them)

| Reason | Prevention |
|--------|-----------|
| "Minimum functionality" | App has 3 quiz modes, SRS, TTS, 12+ verbs — sufficient. Include review notes explaining the niche educational purpose. |
| "Guideline 4.2 — app is a simple web wrapper" | Not applicable — this is a native SwiftUI app |
| "Missing privacy policy" | Include before submission |
| "Crashes" | Test on real device, not just simulator. Test airplane mode, low memory. |
| "Broken links" | Ensure privacy policy URL works. Ensure API endpoint works (but app must function without it). |

### Review Notes (for App Store Connect)
Include a note for the reviewer:
> "This is a niche educational app for French speakers learning Catalan verb conjugations. It features spaced repetition (SM-2 algorithm), three quiz modes, and text-to-speech. The app works fully offline with bundled content, and can fetch updated verb data from our API when online."

---

## Post-Submission

- [ ] Monitor App Store Connect for review status
- [ ] Respond promptly to any reviewer questions
- [ ] After approval: verify app appears correctly in store
- [ ] Consider: TestFlight beta first (invite 5-10 testers before public launch)
