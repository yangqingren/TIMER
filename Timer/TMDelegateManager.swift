//
//  TMBaseManager.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit



class TMDelegateManager: NSObject {

    static let share = TMDelegateManager()
    
    weak var main: TMBaseViewController?

    weak var neon: TMBaseViewController?
    
    weak var bw: TMBaseViewController?
    
    weak var blcok: TMBaseViewController?
    
    weak var shadow: TMBaseViewController?
    
    weak var clock: TMBaseViewController?
    
    weak var electron: TMBaseViewController?

    var delegates: [TMBaseViewController] {
        get {
            var array = [TMBaseViewController]()
            if let main = self.main {
                array.append(main)
            }
            if let neon = self.neon {
                array.append(neon)
            }
            if let bw = self.bw {
                array.append(bw)
            }
            if let blcok = self.blcok {
                array.append(blcok)
            }
            if let shadow = self.shadow {
                array.append(shadow)
            }
            if let clock = self.clock {
                array.append(clock)
            }
            if let electron = self.electron {
                array.append(electron)
            }
            return array
        }
    }
}
