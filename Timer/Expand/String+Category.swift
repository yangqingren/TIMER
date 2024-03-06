//
//  NSString+Category.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import Foundation

extension String {
    
    static func getAttributedString(text: String?, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text ?? "", attributes: attributes)
        return attributedString
    }
    
    static func getAttributedStringRange(text: String?, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text ?? "")
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    static func getExpansionString(text: String?, expansion: Float = -0.2, others: [NSAttributedString.Key: Any]? = nil) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.expansion: expansion
        ]
        if let others = others {
            for item in others {
                attributes[item.key] = item.value
            }
        }
        let attributedString = NSMutableAttributedString(string: text ?? "", attributes: attributes)
        return attributedString
    }
}
