import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var navigationPath = NavigationPath()
    @State private var verbService = VerbService()

    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView()
        } else {
            NavigationStack(path: $navigationPath) {
                HomeScreen(navigationPath: $navigationPath, verbService: verbService)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .table(let verb):
                            TableView(verb: verb, navigationPath: $navigationPath)
                        case .drill(let verb):
                            DrillMode(verb: verb, navigationPath: $navigationPath)
                        case .contextQuiz(let verb):
                            ContextQuiz(verb: verb, navigationPath: $navigationPath)
                        case .mixedDrill:
                            MixedDrill(
                                verbService: verbService,
                                navigationPath: $navigationPath
                            )
                        case .results(let results, let quizType, let verb):
                            ResultsScreen(
                                results: results,
                                quizType: quizType,
                                verb: verb,
                                navigationPath: $navigationPath
                            )
                        case .settings:
                            SettingsView()
                        }
                    }
            }
            .task {
                await verbService.loadVerbs()
            }
        }
    }
}

enum Route: Hashable {
    case table(Verb)
    case drill(Verb)
    case contextQuiz(Verb)
    case mixedDrill
    case results([QuizResult], QuizType, Verb?)
    case settings
}

enum QuizType: Hashable {
    case drill
    case context
    case mixed
}
