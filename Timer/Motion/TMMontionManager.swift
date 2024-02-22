//
//  TMMontionManager.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit
import CoreMotion

enum TMMontionDirection {
    case original
    case left
    case right
    case down
}

class TMMontionManager: NSObject {
    
    static let share = TMMontionManager()

    lazy var motion: CMMotionManager = {
        let m = CMMotionManager()
        return m
    }()
    
    override init() {
        super.init()
        
    }
    
    var directin: TMMontionDirection = .original
    
    func startMotionUpdates() {
        if self.motion.isDeviceMotionAvailable && !self.motion.isDeviceMotionActive {
            self.motion.deviceMotionUpdateInterval = 0.5
            self.motion.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let `self` = self else { return }
                if error == nil, let motion = motion {
                    let gravityX = motion.gravity.x
                    let gravityY = motion.gravity.y
                    let xyTheta = atan2(gravityX, gravityY) / .pi * 180.0
                    var directin: TMMontionDirection = .original
                    if ((xyTheta > 115 && xyTheta <= 180) || (xyTheta >= -180 && xyTheta < -115)) {
                        directin = .original;
                    } else if (xyTheta >= 65 && xyTheta <= 115) {
                        directin = .left;
                    } else if ((xyTheta >= 0 && xyTheta < 65) || (xyTheta <= 0 && xyTheta > -65)) {
                        directin = .down;
                    } else if (xyTheta >= -115 && xyTheta <= -65) {
                        directin = .right;
                    }
                    self.directin = directin
                    for delegate in TMDelegateManager.share.delegates {
                        delegate.motionUpdates(directin: directin)
                    }
                }
            }
        }
    }
    
    func stopMotionUpdates() {
        if self.motion.isDeviceMotionAvailable && self.motion.isDeviceMotionActive {
            self.motion.stopGyroUpdates()
        }
    }
}
