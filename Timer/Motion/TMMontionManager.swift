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

enum TMMontionAutoHV: Int {
    case auto = 0
    case H = 1
    case V = 2
}

private let kTMMontionAutoHV = "kTMMontionAutoHV"

class TMMontionManager: NSObject {
    
    static let share = TMMontionManager()

    lazy var motion: CMMotionManager = {
        let m = CMMotionManager()
        return m
    }()
    
    var autoHV: TMMontionAutoHV = .auto {
        didSet {
            UserDefaults.standard.set(autoHV.rawValue, forKey: kTMMontionAutoHV)
            self.setupMotionUpdates()
        }
    }
     
    var fixOriginal = false
    
    override init() {
        super.init()
        
        self.autoHV = TMMontionAutoHV.init(rawValue: UserDefaults.standard.integer(forKey: kTMMontionAutoHV)) ?? .auto
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: OperationQueue.current) { [weak self] (notification) in
            guard let `self` = self else { return }
            self.fixOriginal = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fixOriginal = false
            }
            if self.autoHV == .H {
                self.directin = .right
            }
            else {
                self.directin = .original
            }
            for delegate in TMDelegateManager.share.delegates {
                delegate.motionUpdates(directin: self.directin)
            }
        }
    }
    
    func setupMotionUpdates() {
        if self.autoHV == .H {
            self.directin = .right
            for delegate in TMDelegateManager.share.delegates {
                delegate.motionUpdates(directin: self.directin)
            }
        }
        else if self.autoHV == .V {
            self.directin = .original
            for delegate in TMDelegateManager.share.delegates {
                delegate.motionUpdates(directin: self.directin)
            }
        }
    }
    
    var directin: TMMontionDirection = .original
    
    func startMotionUpdates() {
        if self.motion.isDeviceMotionAvailable && !self.motion.isDeviceMotionActive {
            self.motion.deviceMotionUpdateInterval = 0.5
            self.motion.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let `self` = self else { return }
                
                if self.autoHV == .H {
                    self.directin = .right
                    for delegate in TMDelegateManager.share.delegates {
                        delegate.motionUpdates(directin: self.directin)
                    }
                }
                else if self.autoHV == .V {
                    self.directin = .original
                    for delegate in TMDelegateManager.share.delegates {
                        delegate.motionUpdates(directin:  self.directin)
                    }
                }
                else {
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
                            delegate.motionUpdates(directin: self.fixOriginal ? .original : self.directin)
                        }
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
    
    static func getAutoHVText() -> String {
        switch TMMontionManager.share.autoHV {
        case .auto:
            return "A"
        case .H:
            return "H"
        case .V:
            return "V"
        }
    }
}
