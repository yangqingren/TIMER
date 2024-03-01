//
//  TMMainVcItem.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

enum TMPageMenuType: Int {
    case bw = 0
    case electron = 1
    case shadow = 2
    case block = 3
    case clock = 4
    case clock2 = 5
    case neon = 6
}

class TMMainVcItem: NSObject {
    
    let type: TMPageMenuType
    
    var subType: TMBwVcTheme?
    
    var isSelected: Bool = false
    
    init(type: TMPageMenuType, _ subType: TMBwVcTheme? = nil) {
        self.type = type
        self.subType = subType
    }
}
