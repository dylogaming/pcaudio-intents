import AppIntents
import Foundation

// Identical copy in Sources/PCAudioWidget and ios/intents (the macOS runner builds Metadata.appintents from it).
// LiveActivityIntent makes the Live Activity button run in the app process (build 27 was AudioPlaybackIntent only and
// its tap did nothing); the app sets IntentHook.toggle at launch.
struct ToggleIntent: LiveActivityIntent, AudioPlaybackIntent {
    static var title: LocalizedStringResource = "Toggle PC Audio"
    static var openAppWhenRun: Bool = false
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    func perform() async throws -> some IntentResult {
        let hook = await IntentHook.toggle
        IntentHook.log("intent toggle in \(Bundle.main.bundleIdentifier ?? "?") hook \(hook != nil)")
        await hook?()
        return .result()
    }
}

enum IntentHook {
    @MainActor static var toggle: (@MainActor () -> Void)?
    // keeps the linker from stripping ToggleIntent out of the app binary (build 28 had no copy, so taps did nothing)
    @MainActor static var types: [any AppIntent.Type] = []

    static func log(_ line: String) {
        var c = URLComponents(string: "https://pcaudio.dylostudio.com/diag")!
        c.queryItems = [URLQueryItem(name: "e", value: line)]
        guard let u = c.url else { return }
        var req = URLRequest(url: u)
        req.setValue("PCAudio/1", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: req).resume()
    }
}
