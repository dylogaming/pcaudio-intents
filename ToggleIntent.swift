import AppIntents

// Identical copy in Sources/PCAudioWidget and ios/intents (the macOS runner builds Metadata.appintents from it).
// Runs in the app process; the app sets IntentHook.toggle at launch.
struct ToggleIntent: AudioPlaybackIntent {
    static var title: LocalizedStringResource = "Toggle PC Audio"
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        await IntentHook.toggle?()
        return .result()
    }
}

enum IntentHook {
    @MainActor static var toggle: (@MainActor () -> Void)?
}
