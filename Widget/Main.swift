import SwiftUI
import WidgetKit
@main struct StubWidgets: WidgetBundle { var body: some Widget { W() } }
struct E: TimelineEntry { let date: Date }
struct P: TimelineProvider {
    func placeholder(in c: Context) -> E { E(date: .now) }
    func getSnapshot(in c: Context, completion: @escaping (E) -> Void) { completion(E(date: .now)) }
    func getTimeline(in c: Context, completion: @escaping (Timeline<E>) -> Void) { completion(Timeline(entries: [E(date: .now)], policy: .never)) }
}
struct W: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "x", provider: P()) { _ in Button(intent: ToggleIntent()) { Text("x") } }
    }
}
