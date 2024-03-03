//
//  TMBaseView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/22.
//

import UIKit

class TMBaseView: UIView, TMTimeUpdatesProtocol {

    var vcType: TMMainVcType = .main
    var hhFormat: String {
        get {
            return Date.getHhFormatter()
        }
    }
        
    init(frame: CGRect, vcType: TMMainVcType) {
        self.vcType = vcType
        super.init(frame: frame)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {

    }
    
    func timeUpdates() {
        
    }
    
    func setupSystemTimeChanged() {
        self.timeUpdates()
    }


}
