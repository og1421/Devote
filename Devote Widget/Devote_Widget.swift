//
//  Devote_Widget.swift
//  Devote Widget
//
//  Created by Orlando Moraes Martins on 17/02/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Devote_WidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    var fontStyle: Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote, design: .rounded)
        } else {
            return .system(.headline, design: .rounded)
        }
    }

    var body: some View {
//        Text(entry.date, style: .time)
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                
                Image("logo")
                    .resizable()
                    .frame(
                        width: widgetFamily != .systemSmall ? 56 : 36,
                        height: widgetFamily != .systemSmall ? 56 : 36
                    )
                    .offset(x: (geometry.size.width / 2) - 20, y: (geometry.size.height / -2 ) + 20 )
                    .padding(.top, widgetFamily != .systemSmall ? 32 : 20)
                    .padding(.trailing, widgetFamily != .systemSmall ? 32 : 20)
                
                HStack {
                    Text("Just do it")
                        .foregroundColor(.white)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 4)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.5)
                            .blendMode(.overlay))
                    .clipShape(Capsule())
                    
                    if widgetFamily != .systemSmall {
                        Spacer()
                    }
                }//: Hstack
                .padding()
                .offset(y: (geometry.size.height / 2) - 24 )
            } //: ZStack
        }//: Geometry Reeader
    }
}

struct Devote_Widget: Widget {
    let kind: String = "Devote_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Devote_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Devote Laucher")
        .description("This is an example widget for the task manager app.")
    }
}

struct Devote_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Devote_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            Devote_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            Devote_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
