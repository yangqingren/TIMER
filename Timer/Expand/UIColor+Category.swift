//
//  UIColor+Category.swift
//  Timer
//
//  Created by yangqingren on 2024/2/28.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
}
