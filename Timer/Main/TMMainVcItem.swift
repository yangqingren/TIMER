//
//  TMMainVcItem.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

enum TMPageMenuType: Int {
    case bw = 1
    case electron = 2
    case shadow = 3
    case block = 4
    case heart = 5
    case flip =  6
    case clock = 7
    case clock2 = 8
    case neon = 9
}

class TMMainVcItem: NSObject {
    
    let type: TMPageMenuType
    
    var subType: TMBwVcTheme?
    
    var isSelected: Bool = false
    
    let name: String
    
    init(type: TMPageMenuType, _ subType: TMBwVcTheme? = nil) {
        self.type = type
        self.subType = subType
        switch type {
        case .bw:
            if subType == .black {
                name = TMLocalizedString("翻页时钟(B)")
            }
            else {
                name = TMLocalizedString("翻页时钟(W)")
            }
        case .electron:
            name = TMLocalizedString("墨水屏表盘")
        case .shadow:
            name = TMLocalizedString("膨胀时钟")
        case .block:
            name = TMLocalizedString("榻榻米方格时钟")
        case .heart:
            name = TMLocalizedString("心跳电子时钟")
        case .flip:
            name = TMLocalizedString("翻页时钟")
        case .clock:
            name = TMLocalizedString("真模拟时钟I")
        case .clock2:
            name = TMLocalizedString("真模拟时钟II")
        case .neon:
            name = TMLocalizedString("夜间霓虹时钟")
        }
    }
}
