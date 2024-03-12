//
//  TMTimerManager.swift
//  Timer
//
//  Created by yangqingren on 2024/1/3.
//

import UIKit

@available(iOS 16.2, *)
class TMTimerManager: NSObject {
    
    static let share = TMTimerManager()
    
    var count: Int = 0
    
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
    
    func getCount() -> String {
        self.count += 1
        return "\(self.count)"
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
