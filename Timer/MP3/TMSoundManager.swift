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
    
    static func playSound(_ name: String) {
        let now = Date()
        let timeInterval = now.timeIntervalSince(TMSoundManager.share.date)
        if TMMainSettingManager.getOpenStatus(.sound), timeInterval > 0.7 , let soundURL = Bundle.main.url(forResource: name, withExtension: "wav") {
            TMSoundManager.share.date = now
            var soundID: SystemSoundID = 0
            let error = AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            debugPrint("error=\(error)")
            AudioServicesPlaySystemSound(soundID)
        }
        else {
            print("Sound file not found")
        }
    }
}