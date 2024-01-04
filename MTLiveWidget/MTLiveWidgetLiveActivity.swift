//
//  MTLiveWidgetLiveActivity.swift
//  MTLiveWidget
//
//  Created by yangqingren on 2024/1/3.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MTLiveWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var date: Date
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MTLiveWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MTLiveWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Label {
                    Text(TMTimerManager.getDate(), style: .timer)
                }
                icon: {
                    Image(systemName: "timer")
                        .foregroundColor(.indigo)
                }
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text(TMTimerManager.getDate(), style: .timer)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}


