//
//  TMSoundManager.swift
//  Timer
//
//  Created by yangqingren on 2024/3/2.
//

import UIKit
import AudioToolbox

class TMSoundManager: NSObject {

    static let share = TMSoundManager()
    
    override init() {
        super.init()
        
    }
    
    var date = Date()
    
    static func playSound(_ type: TMPageMenuType) {
        let now = Date()
        let timeInterval = now.timeIntervalSince(TMSoundManager.share.date)
        if TMMainSettingManager.getOpenStatus(.sound), timeInterval > 0.7, let topVc = TMGetTopController(), let topVc = topVc as? TMMainViewController, let page = topVc.pageViewController.viewControllers?.first as? TMBasePageViewController, page.item.type == type {
            var name = ""
            switch type {
            case .bw:
                name = "flip"
            case .electron:
                name = "slim"
            case .shadow:
                name = "neon"
            case .block:
                name = "digit"
            case .heart:
                name = "slim"
            case .clock:
                name = "pointer"
            case .clock2:
                name = "digit"
            case .neon:
                name = "slim"
            case .flip:
                name = "flip"
            }
            if let soundURL = Bundle.main.url(forResource: name, withExtension: "wav") {
                TMSoundManager.share.date = now
                var soundID: SystemSoundID = 0
                let _ = AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
                AudioServicesPlaySystemSound(soundID)
            }
            else {
                print("Sound not play 1")
            }
        }
    }
}
