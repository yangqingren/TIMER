//
//  LEGOHighlightButton.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

class LEGOHighlightButton: UIButton {

    var hotspot = 0.0
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        bounds = CGRect(x: self.bounds.origin.x - self.hotspot, y: self.bounds.origin.y - self.hotspot, width: self.bounds.size.width + 2*self.hotspot, height: self.bounds.size.height + 2*self.hotspot)
        return bounds.contains(point)
    }

}
