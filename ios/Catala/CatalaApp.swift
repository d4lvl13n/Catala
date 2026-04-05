import SwiftUI
import SwiftData

@main
struct CatalaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([SRSCard.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            // If schema migration fails, delete and recreate
            let url = config.url
            try? FileManager.default.removeItem(at: url)
            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ErrorBoundary {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
