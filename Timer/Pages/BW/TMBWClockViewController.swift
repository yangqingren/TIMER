//
//  TMBlackWhiteClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

class TMBWClockViewController: TMBasePageViewController {

    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "TMTimer", size: 20.sp)
        label.textColor = .black
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.clear
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TIIMII, expansion: 0, others: [    NSAttributedString.Key.shadow: shadow])
        label.alpha = 0.75
        return label
    }()
    
    lazy var bwHHView: TMBWBaseView = {
        let view = TMBWBaseView(frame: .zero, format: "HH")
        return view
    }()
    
    lazy var bwMmView: TMBWBaseView = {
        let view = TMBWBaseView(frame: .zero, format: "mm")
        return view
    }()
    
    lazy var bwSsView: TMBWBaseView = {
        let view = TMBWBaseView(frame: .zero, format: "ss")
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TMDelegateManager.share.bw = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TMDelegateManager.share.bw = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(r: 242, g: 242, b: 242, a: 1)
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaInsets.left).offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.addSubview(self.bwMmView)
        self.bwMmView.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(self.bwHHView)
        self.bwHHView.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.bwMmView.snp.top).offset(-20.dp)
        }
        
        self.view.addSubview(self.bwSsView)
        self.bwSsView.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.bwMmView.snp.bottom).offset(20.dp)
        }
    }
    
    override func motionUpdates(directin: TMMontionDirection) {
        super.motionUpdates(directin: directin)
        
        var transform = CGAffineTransform.identity
        switch directin {
        case .original:
            transform = CGAffineTransform.identity
        case .left:
            transform = CGAffineTransform.identity.rotated(by: .pi / -2.0)
        case .right:
            transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)
        case .down:
            transform = CGAffineTransform.identity.rotated(by: .pi)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.bwHHView.transform = transform
            self.bwMmView.transform = transform
            self.bwSsView.transform = transform
        }
    }
}
