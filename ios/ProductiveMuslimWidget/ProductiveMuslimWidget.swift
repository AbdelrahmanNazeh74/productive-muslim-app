import WidgetKit
import SwiftUI

// ── Shared data key ──────────────────────────────────────────────────────────
private let kAppGroupId = "group.com.example.productiveMuslim"

// ── Timeline entry ────────────────────────────────────────────────────────────
struct ProductiveMuslimEntry: TimelineEntry {
    let date: Date
    let nextPrayerName: String
    let nextPrayerTime: String
    let timeRemaining: String
    let currentBlockTitle: String
}

// ── Data reader ───────────────────────────────────────────────────────────────
private func readEntry() -> ProductiveMuslimEntry {
    let prefs = UserDefaults(suiteName: kAppGroupId)
    return ProductiveMuslimEntry(
        date: Date(),
        nextPrayerName:    prefs?.string(forKey: "nextPrayerName")    ?? "—",
        nextPrayerTime:    prefs?.string(forKey: "nextPrayerTime")    ?? "—",
        timeRemaining:     prefs?.string(forKey: "timeRemaining")     ?? "—",
        currentBlockTitle: prefs?.string(forKey: "currentBlockTitle") ?? "—"
    )
}

// ── Timeline provider ─────────────────────────────────────────────────────────
struct ProductiveMuslimProvider: TimelineProvider {

    func placeholder(in context: Context) -> ProductiveMuslimEntry {
        ProductiveMuslimEntry(
            date: Date(),
            nextPrayerName: "Dhuhr",
            nextPrayerTime: "12:45 PM",
            timeRemaining: "2h 15m",
            currentBlockTitle: "Deep Work"
        )
    }

    func getSnapshot(in context: Context,
                     completion: @escaping (ProductiveMuslimEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<ProductiveMuslimEntry>) -> Void) {
        let entry = readEntry()
        // Request a refresh every 30 minutes; the Flutter app also triggers
        // reloads via WidgetKit.reloadAllTimelines() through home_widget.
        let nextRefresh = Calendar.current.date(
            byAdding: .minute, value: 30, to: Date()
        )!
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

// ── Widget view ───────────────────────────────────────────────────────────────
struct ProductiveMuslimWidgetView: View {
    let entry: ProductiveMuslimEntry

    private let islamicGreen = Color(red: 27/255, green: 107/255, blue: 58/255)

    var body: some View {
        ZStack {
            ContainerRelativeShape().fill(islamicGreen)

            VStack(alignment: .leading, spacing: 4) {

                Text("Productive Muslim")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("🤲").font(.system(size: 18))

                    Text(entry.nextPrayerName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .layoutPriority(1)

                    Spacer()

                    Text(entry.nextPrayerTime)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }

                Text("in \(entry.timeRemaining)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.75))

                Rectangle()
                    .fill(Color.white.opacity(0.25))
                    .frame(height: 1)
                    .padding(.vertical, 2)

                Text(entry.currentBlockTitle)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            .padding(14)
        }
    }
}

// ── Widget configuration ──────────────────────────────────────────────────────
struct ProductiveMuslimWidget: Widget {
    let kind = "ProductiveMuslimWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProductiveMuslimProvider()) { entry in
            ProductiveMuslimWidgetView(entry: entry)
        }
        .configurationDisplayName("Productive Muslim")
        .description("Next prayer time and current schedule block.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// ── Entry point ───────────────────────────────────────────────────────────────
@main
struct ProductiveMuslimWidgetBundle: WidgetBundle {
    var body: some Widget {
        ProductiveMuslimWidget()
    }
}
