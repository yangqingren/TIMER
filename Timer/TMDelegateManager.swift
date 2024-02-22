//
//  TMBaseManager.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit



class TMDelegateManager: NSObject {

    static let share = TMDelegateManager()

    weak var neon: TMBaseViewController?
    
    weak var bw: TMBaseViewController?
    
    var delegates: [TMBaseViewController] {
        get {
            var array = [TMBaseViewController]()
            if let neon = self.neon {
                array.append(neon)
            }
            if let bw = self.bw {
                array.append(bw)
            }
            return array
        }
    }
}
