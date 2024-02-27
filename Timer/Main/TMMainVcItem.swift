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
    case neon = 5
}

class TMMainVcItem: NSObject {
    
    let type: TMPageMenuType
    
    init(type: TMPageMenuType) {
        self.type = type
    }
}
