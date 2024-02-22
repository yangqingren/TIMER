//
//  Date+Category.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import Foundation

extension Date {
    
    func getDateStringEn(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en")
        formatter.timeZone = .current
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func getDateString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        return dateString
    }

}
