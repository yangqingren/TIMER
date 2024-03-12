//
//  MTLiveWidgetLiveActivity.swift
//  MTLiveWidget
//
//  Created by yangqingren on 2024/1/3.
//

import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 16.2, *)
struct MTLiveWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var date: Date
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

@available(iOS 16.2, *)
struct MTLiveAndLockWidget: Widget {
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: MTLiveWidgetAttributes.self) { context in

            TMLockScreenView(context: context)
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
                            .shadow(color: .white, radius: 2, x: 0, y: 2)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(TMTimerManager.getDate(), style: .timer)
                        .font(.custom("TMWidgetTimer", size: 85))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                }
            } compactLeading: {
//                Text("  \(TMTimerManager.getWeek("MM/dd EEE"))")
//                    .font(.system(size: 11))
//                    .multilineTextAlignment(.center)
//                    .shadow(color: .white, radius: 2, x: 0, y: 2)
            } compactTrailing: {
                
//                Text(TMTimerManager.getDate(), style: .timer)
//                    .font(.system(size: 11))
//                    .multilineTextAlignment(.center)
//                    .shadow(color: .white, radius: 2, x: 0, y: 2)
            } minimal: {

            }
            .keylineTint(Color.clear)
        }
    }
}

@available(iOS 16.2, *)
struct TMLockScreenView: View {
    
    let context: ActivityViewContext <MTLiveWidgetAttributes>
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 42.0 / 255.0, green: 95.0 / 255.0, blue: 215.0 / 255.0, opacity: 0.3), Color.clear, Color.clear]), startPoint: UnitPoint(x: 0.3, y: 0), endPoint: UnitPoint(x: 0.7, y: 1))
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 42.0 / 255.0, green: 95.0 / 255.0, blue: 215.0 / 255.0, opacity: 0.3), Color.clear, Color.clear]), startPoint: UnitPoint(x: 0.7, y: 1), endPoint: UnitPoint(x: 0.3, y: 0))

            VStack {
                
                Spacer(minLength: 20)
                
                HStack {
                    
                    Text(TMTimerManager.getDate(), style: .date)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                    
                    Text(TMTimerManager.getWeek("EEE"))
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                    
//                    Text(TMTimerManager.share.getCount())
//                        .font(.system(size: 16))
//                        .multilineTextAlignment(.center)
//                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                }

                
                Text(TMTimerManager.getDate(), style: .timer)
                    .font(.custom("TMWidgetTimer", size: 85))
                    .multilineTextAlignment(.center)
                    .shadow(color: .gray, radius: 2, x: 0, y: 5)
                
                Spacer(minLength: 20)
            }
        }


    }
}
