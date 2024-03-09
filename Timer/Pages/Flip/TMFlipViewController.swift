//
//  TMFlipViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/3/6.
//

import UIKit

class TMFlipViewController: TMBasePageViewController {

    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1)
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = TMNeonBlue
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TIIMII, expansion: 0.3, others: [NSAttributedString.Key.shadow: shadow])
        return label
    }()
    
    lazy var topDateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowOffset = CGSize(width: 0.dp, height: 0.dp)
        label.layer.shadowColor = UIColor.lightGray.cgColor
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 4.dp
        return label
    }()
    
    lazy var bwHHView: TMFlipBaseView = {
        let format = Date.getHhFormatter()
        let view = TMFlipBaseView(frame: .zero, format: .hh, vcType: self.vcType)
        return view
    }()
    
    lazy var bwMmView: TMFlipBaseView = {
        let view = TMFlipBaseView(frame: .zero, format: .mm, vcType: self.vcType)
        return view
    }()
    
    lazy var bwSsView: TMFlipBaseView = {
        let view = TMFlipBaseView(frame: .zero, format: .ss, vcType: self.vcType)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(r: 1, g: 1, b: 1, a: 1)
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.addSubview(self.topDateLabel)
        self.topDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.shadowLabel.snp.centerY)
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
            make.bottom.equalTo(self.bwMmView.snp.top).offset(-kTMFlipBaseSpacingY)
        }
        
        self.view.addSubview(self.bwSsView)
        self.bwSsView.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.bwMmView.snp.bottom).offset(kTMFlipBaseSpacingY)
        }
        
        self.setupBatteryView()
        
        // Do any additional setup after loading the view.
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        let text = Date().getDateStringEn(format: "MM dd EEEE")
        self.topDateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3)
    }
    
}
