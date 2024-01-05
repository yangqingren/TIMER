//
//  MTLiveWidget.swift
//  MTLiveWidget
//
//  Created by yangqingren on 2024/1/3.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
//        let currentDate = Date()
//        for hourOffset in 0 ..< 12 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
        
        let currentDate = Date()
        for offset in 1 ..< 40 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset * 15 , to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct MTLiveWidgetEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.white, Color.white, Color.white]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Text(TMTimerManager.getDate(), style: .date)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    
                    Text(TMTimerManager.getWeek("EEE"))
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
                
                Text(TMTimerManager.getDate(), style: .timer)
                    .font(.custom("TMTimer", size: 78))
                    .multilineTextAlignment(.center)
                    .shadow(color: .gray, radius: 2, x: 0, y: 5)
                
                Spacer()
            }
            .offset(x: 0.0, y: 7.0)
        }
        
    }
}

struct MTLiveWidget: Widget {
    
    let kind: String = "MTLiveWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MTLiveWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                MTLiveWidgetEntryView(entry: entry)
                    .padding()
                    .background()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Timer")
        .description("This is an Timer widget.")
    }
}

//#Preview(as: .systemSmall) {
//    MTLiveWidget()
//} timeline: {
//    SimpleEntry(date: .now)
//    SimpleEntry(date: .now)
//}
