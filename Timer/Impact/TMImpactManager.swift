//
//  TMImpaceManager.swift
//  Timer
//
//  Created by yangqingren on 2024/2/28.
//

import UIKit

class TMImpactManager: NSObject {
    
    static let share = TMImpactManager()
    
    var intensity = 0.25
    
    lazy var displayLink1: CADisplayLink = {
        let link = CADisplayLink.init(target: self, selector: #selector(displayLink))
        link.isPaused = true
        link.preferredFramesPerSecond = 60
        link.add(to: .current, forMode: .common)
        return link
    }()
    
    lazy var displayLink2: CADisplayLink = {
        let link = CADisplayLink.init(target: self, selector: #selector(displayLink))
        link.isPaused = true
        link.preferredFramesPerSecond = 60
        link.add(to: .current, forMode: .common)
        return link
    }()
    
    static func start() {
        if TMImpactManager.share.displayLink1.isPaused {
            TMImpactManager.share.displayLink1.isPaused = false
        }
        if TMImpactManager.share.displayLink2.isPaused {
            TMImpactManager.share.displayLink2.isPaused = false
        }
    }
    
    static func stop() {
        if !TMImpactManager.share.displayLink1.isPaused {
            TMImpactManager.share.displayLink1.isPaused = true
        }
        if !TMImpactManager.share.displayLink2.isPaused {
            TMImpactManager.share.displayLink2.isPaused = true
        }
    }
    
    @objc func displayLink() {
        if TMMainSettingManager.getOpenStatus(.impact) {
            let generator = UIImpactFeedbackGenerator.init(style: .soft)
            generator.prepare()
            generator.impactOccurred(intensity: self.intensity)
        }
    }
    
    func startContinueStopWait(_ wait: TimeInterval) {
        TMImpactManager.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            TMImpactManager.stop()
        }
    }
    
    func startWeakContinueStopWait(_ wait: TimeInterval) {
        let intensity = self.intensity
        TMImpactManager.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            TMImpactManager.stop()
            self.intensity = intensity
        }
    }
    
    func impactOccurred(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if TMMainSettingManager.getOpenStatus(.impact) {
            let generator = UIImpactFeedbackGenerator.init(style: style)
            generator.prepare()
            generator.impactOccurred(intensity: self.intensity)
        }
    }
}
