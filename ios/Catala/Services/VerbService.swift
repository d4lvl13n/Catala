import Foundation
import Observation

@Observable
class VerbService {
    private(set) var verbs: [Verb] = []
    private(set) var isLoading = false
    private(set) var error: String?

    /// Grouped verbs in display order.
    var groupedVerbs: [(group: String, verbs: [Verb])] {
        let grouped = Dictionary(grouping: verbs) { $0.group }
        return VerbGroup.displayOrder.compactMap { group in
            guard let verbs = grouped[group], !verbs.isEmpty else { return nil }
            return (group: group, verbs: verbs)
        }
    }

    // MARK: - API Configuration

    private let apiBaseURL = "https://your-api.supabase.co/v1"
    private let cacheFileName = "verbs-cache.json"
    private let etagKey = "verbs-etag"

    // MARK: - Load

    /// Loads verbs with priority: cached → API → bundled fallback.
    func loadVerbs() async {
        isLoading = true
        defer { isLoading = false }

        // 1. Load cached data immediately (fast startup)
        if let cached = loadCachedVerbs() {
            verbs = cached
        }

        // 2. Try API fetch in background
        do {
            let fetched = try await fetchFromAPI()
            if let fetched {
                verbs = fetched
                return
            }
            // 304 Not Modified — cached data is current
            if !verbs.isEmpty { return }
        } catch {
            // Network failure — fall through to fallback
        }

        // 3. If still empty, use bundled fallback
        if verbs.isEmpty {
            verbs = loadBundledVerbs()
        }
    }

    // MARK: - API Fetch

    /// Fetches verbs from API. Returns nil on 304 (not modified).
    private func fetchFromAPI() async throws -> [Verb]? {
        guard let url = URL(string: "\(apiBaseURL)/verbs") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10

        // Send cached ETag for conditional request
        if let etag = UserDefaults.standard.string(forKey: etagKey) {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 304 {
            return nil // Not modified
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let verbResponse = try JSONDecoder().decode(VerbResponse.self, from: data)

        // Cache the response
        if let etag = httpResponse.value(forHTTPHeaderField: "ETag") {
            UserDefaults.standard.set(etag, forKey: etagKey)
        }
        cacheVerbs(data: data)

        return verbResponse.verbs
    }

    // MARK: - Cache

    private var cacheURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheFileName)
    }

    private func cacheVerbs(data: Data) {
        try? data.write(to: cacheURL)
    }

    private func loadCachedVerbs() -> [Verb]? {
        guard let data = try? Data(contentsOf: cacheURL),
              let response = try? JSONDecoder().decode(VerbResponse.self, from: data) else {
            return nil
        }
        return response.verbs
    }

    // MARK: - Bundled Fallback

    private func loadBundledVerbs() -> [Verb] {
        guard let url = Bundle.main.url(forResource: "verbs-fallback", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(VerbResponse.self, from: data) else {
            return []
        }
        return response.verbs
    }
}
