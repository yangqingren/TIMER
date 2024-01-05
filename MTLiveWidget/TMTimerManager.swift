//
//  TMTimerManager.swift
//  Timer
//
//  Created by yangqingren on 2024/1/3.
//

import UIKit

class TMTimerManager: NSObject {
    
    static let shader = TMTimerManager()
        
    static func getDate() -> Date {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.startOfDay(for: endDate)
        return startDate
    }
    
    static func getWeek(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .current
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    ///     var content: AttributedString {
    ///         var attributedString = AttributedString("Blue text")
    ///         attributedString.foregroundColor = .blue
    ///         return attributedString
    ///     }
//    static func getDate() -> Date {
//        let date = Date()
//        let calendar:Calendar = Calendar.current;
//        let year = calendar.component(.year, from: date);
//        let month = calendar.component(.month, from: date);
//        let day = calendar.component(.day, from: date);
//        let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
//        return Calendar.current.date(from: components)!
//    }
}
