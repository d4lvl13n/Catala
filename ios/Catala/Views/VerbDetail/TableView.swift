import SwiftUI

struct TableView: View {
    let verb: Verb
    @Binding var navigationPath: NavigationPath
    @State private var selectedTense: Tense = .present
    @State private var speechService = SpeechService()

    private var groupColor: Color {
        Theme.groupColor(for: verb.group)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                header
                    .padding(.bottom, 20)

                // Tense tabs
                tenseTabs
                    .padding(.bottom, 16)

                // Conjugation table
                conjugationTable
                    .padding(.bottom, 16)

                // Example sentences
                sentencesSection

                // Action buttons
                actionButtons
            }
            .padding(.horizontal, Theme.screenPaddingH)
            .padding(.top, Theme.screenPaddingTop)
            .padding(.bottom, Theme.screenPaddingBottom)
        }
        .background(Theme.bg)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigationPath.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.textMid)
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(verb.ca)
                    .font(.system(size: 22, weight: .heavy, design: .serif))
                    .foregroundStyle(Theme.text)

                Text("— \(verb.fr)")
                    .font(.system(size: 22, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textMuted)
            }

            Chip(text: verb.group, color: groupColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Tense Tabs

    private var tenseTabs: some View {
        HStack(spacing: 4) {
            ForEach(Tense.allCases) { tense in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        selectedTense = tense
                    }
                } label: {
                    Text(tense.displayLabel)
                        .font(Theme.body(
                            size: 12,
                            weight: selectedTense == tense ? .bold : .medium
                        ))
                        .foregroundStyle(selectedTense == tense ? Theme.text : Theme.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            selectedTense == tense
                                ? Theme.surface
                                : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(
                            color: selectedTense == tense ? Theme.shadow : .clear,
                            radius: 2, y: 1
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Theme.bgSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Conjugation Table

    private var conjugationTable: some View {
        VStack(spacing: 0) {
            let forms = verb.forms(for: selectedTense.rawValue)
            ForEach(Array(Pronoun.all.enumerated()), id: \.offset) { index, pronoun in
                HStack(spacing: 0) {
                    // Pronoun column
                    VStack(alignment: .leading, spacing: 1) {
                        Text(pronoun.ca)
                            .font(Theme.body(size: 13, weight: .semibold))
                            .foregroundStyle(Theme.textMid)
                        Text(pronoun.fr)
                            .font(Theme.body(size: 11))
                            .foregroundStyle(Theme.textLight)
                    }
                    .frame(width: 100, alignment: .leading)

                    // Conjugated form
                    if index < forms.count {
                        Text(forms[index])
                            .font(.system(size: 17, weight: .semibold, design: .serif))
                            .foregroundStyle(groupColor)
                    }

                    Spacer()

                    // Speak button
                    if index < forms.count {
                        SpeakButton(
                            action: { speechService.speak(forms[index]) },
                            size: 24
                        )
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(index % 2 == 0 ? Theme.surface : Theme.bgSubtle.opacity(0.5))

                if index < 5 {
                    Divider()
                        .foregroundStyle(Theme.border)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius)
                .stroke(Theme.border, lineWidth: 1)
        )
        .shadow(color: Theme.shadow, radius: 4, y: 1)
    }

    // MARK: - Sentences

    private var sentencesSection: some View {
        let filtered = verb.sentences.filter { $0.tense == selectedTense.rawValue }

        return Group {
            if !filtered.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("EXEMPLES EN CONTEXTE")
                        .font(Theme.mono(size: 10, weight: .medium))
                        .foregroundStyle(Theme.textMuted)
                        .tracking(1)
                        .padding(.leading, 2)
                        .padding(.bottom, 2)

                    ForEach(filtered, id: \.ca) { sentence in
                        SentenceRow(
                            sentence: sentence,
                            verb: verb,
                            tense: selectedTense.rawValue,
                            onSpeak: { speechService.speak($0) }
                        )
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 8) {
            SecondaryButton(title: "Drill conjugaison") {
                navigationPath.append(Route.drill(verb))
            }

            Button {
                navigationPath.append(Route.contextQuiz(verb))
            } label: {
                Text("Quiz en contexte")
                    .font(Theme.body(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
            }
        }
    }
}
