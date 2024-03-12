//
//  MTLiveWidget.swift
//  MTLiveWidget
//
//  Created by yangqingren on 2024/1/3.
//

import WidgetKit
import SwiftUI

@available(iOS 16.2, *)
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

@available(iOS 16.2, *)
struct SimpleEntry: TimelineEntry {
    let date: Date
}

@available(iOS 16.2, *)
struct MTLiveWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry

    var body: some View {
        
        if family == .systemSmall {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 42.0 / 255.0, green: 95.0 / 255.0, blue: 215.0 / 255.0, opacity: 0.5), Color.clear, Color.clear, Color.clear]), startPoint: UnitPoint(x: 0.0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 42.0 / 255.0, green: 95.0 / 255.0, blue: 215.0 / 255.0, opacity: 0.5), Color.clear, Color.clear, Color.clear]), startPoint: UnitPoint(x: 1, y: 1), endPoint: UnitPoint(x: 0, y: 0))
                
                VStack {
                    
                    Spacer()
                    
                    Text(TMTimerManager.getDate(), style: .date)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)

                    Text("")
                    
                    Text(TMTimerManager.getDate(), style: .timer)
                        .font(.custom("TMWidgetTimer", size: 34))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                    
                    
                    Text("")

                    Text(TMTimerManager.getWeek("EEE"))
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)

                    Spacer()
                }
                .offset(x: 0.0, y: 6.5)
            }
            
        }
        else if family == .systemMedium {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 42.0 / 255.0, green: 95.0 / 255.0, blue: 215.0 / 255.0, opacity: 0.3), Color.clear, Color.clear, Color.clear, Color.clear]), startPoint: UnitPoint(x: 0.3, y: 0), endPoint: UnitPoint(x: 0.7, y: 1))
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 42.0 / 255.0, green: 95.0 / 255.0, blue: 215.0 / 255.0, opacity: 0.3), Color.clear, Color.clear, Color.clear, Color.clear]), startPoint: UnitPoint(x: 0.7, y: 1), endPoint: UnitPoint(x: 0.3, y: 0))
                
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
                        .font(.custom("TMWidgetTimer", size: 78))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                    
                    Spacer()
                }
                .offset(x: 0.0, y: 6.5)
            }
        }
        else {
            Text("")
        }
    }
}

@available(iOS 16.2, *)
struct MTUniversalWidget: Widget {
    
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
        .supportedFamilies([.systemMedium, .systemSmall])
        .configurationDisplayName("TiiMii")
        .description("This is an Timer widget.")
    }
}

//#Preview(as: .systemSmall) {
//    MTLiveWidget()
//} timeline: {
//    SimpleEntry(date: .now)
//    SimpleEntry(date: .now)
//}
