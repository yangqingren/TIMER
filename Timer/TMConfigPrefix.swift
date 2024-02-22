//
//  TMConfigPrefix.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import Foundation
import SnapKit

let IsPhoneX: Bool = {
    var isPhoneX = false
    if #available(iOS 11.0, *) {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if appdelegate.window?.safeAreaInsets.bottom ?? 0 > 0 {
                isPhoneX = true
            }
        }
    }
    return isPhoneX
}()

let IsPhoneXisland: Bool = {
    var isPhoneX = false
    if #available(iOS 11.0, *) {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if appdelegate.window?.safeAreaInsets.bottom ?? 0 > 59.0 {
                isPhoneX = true
            }
        }
    }
    return isPhoneX
}()

let LEGOScreenWidth = UIScreen.main.bounds.width
let LEGOScreenHeight = UIScreen.main.bounds.height
let LEGOViewRate = LEGOScreenWidth / 375.0
let LEGONavMargan = IsPhoneX ? 40.0 : 20.0
let LEGOBottomMargan = IsPhoneX ? 34.0 : 0.0

extension UIColor {
    public convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
}

public protocol UIAdapter {
    var dp: CGFloat { get }
    var sp: CGFloat { get }
}

extension Int: UIAdapter {
    public var dp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }
    
    public var sp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }
}

extension Double: UIAdapter {
    public var dp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }

    public var sp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }
}

extension CGFloat: UIAdapter {
    public var dp: CGFloat {
        return self * LEGOViewRate
    }

    public var sp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }
}

extension Float: UIAdapter {
    public var dp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }

    public var sp: CGFloat {
        return CGFloat(self) * LEGOViewRate
    }
}
