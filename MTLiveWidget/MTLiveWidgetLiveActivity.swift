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

            LockScreenLiveActivityView(context: context)
                .background(Color(red: 1, green: 1, blue: 1, opacity: 1))
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    
                    HStack {
                        
                        Text(TMTimerManager.getDate(), style: .date)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .shadow(color: .white, radius: 2, x: 0, y: 2)
                        
                        Text(TMTimerManager.getWeek("EEE"))
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    }

                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(TMTimerManager.getDate(), style: .timer)
                        .font(.custom("TMTimer", size: 85))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                }
            } compactLeading: {
                
                Text("  \(TMTimerManager.getWeek("MM/dd EEE"))")
                    .font(.system(size: 11))
                    .multilineTextAlignment(.center)
                    .shadow(color: .white, radius: 2, x: 0, y: 2)

            } compactTrailing: {
                
                Text(TMTimerManager.getDate(), style: .timer)
                    .font(.system(size: 11))
                    .multilineTextAlignment(.center)
                    .shadow(color: .white, radius: 2, x: 0, y: 2)
            } minimal: {

            }
            .keylineTint(Color.red)
        }
    }
}

struct LockScreenLiveActivityView: View {
    
    let context: ActivityViewContext <MTLiveWidgetAttributes>
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.white, Color.white]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                
                Spacer(minLength: 20)
                
                HStack {
                    
                    Text(TMTimerManager.getDate(), style: .date)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    
                    Text(TMTimerManager.getWeek("EEE"))
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                }

                
                Text(TMTimerManager.getDate(), style: .timer)
                    .font(.custom("TMTimer", size: 85))
                    .multilineTextAlignment(.center)
                    .shadow(color: .gray, radius: 2, x: 0, y: 5)
                
                Spacer(minLength: 20)
            }
        }


    }
}
