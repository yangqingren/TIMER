//
//  TMTimerRunManager.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

class TMTimerRunManager: NSObject {
    
    static let share = TMTimerRunManager()
    
    override init() {
        super.init()
    }
    
    var timer: Timer?
    
    func startTimeUpdates() {
        self.stopTimeUpdates()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timeRun(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func timeRun(_ sender: Timer) {
        for delegate in TMDelegateManager.share.delegates {
            delegate.timeUpdates()
        }
    }
    
    func stopTimeUpdates() {
        if let timer = self.timer, timer.isValid {
            timer.invalidate()
            self.timer = nil
        }
    }
}
