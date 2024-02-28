//
//  TMConfigPrefix.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import Foundation
import SnapKit

let TIIMII = "TIIMII"

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

let IsChinese: Bool = {
    var isChinese = false
    if let systemLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] {
        for language in systemLanguages {
            if language.contains("zh-Hans") || language.contains("en") || language.contains("zh-Hant") {
                if language.contains("zh-Hans") {
                    return true
                }
                if language.contains("zh-Hant") {
                    return true
                }
                if language.contains("en") {
                    return false
                }
            }
        }
    }
    return false
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

func TMLocalizedString(_ key: String) -> String {
    return Bundle.main.localizedString(forKey: key, value: "", table: nil)
}

let LEGOScreenWidth = UIScreen.main.bounds.width
let LEGOScreenHeight = UIScreen.main.bounds.height
let LEGOViewRate = LEGOScreenWidth / 375.0
let LEGONavMargan = IsPhoneX ? 40.0 : 20.0
let LEGOBottomMargan = IsPhoneX ? 34.0 : 0.0

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
