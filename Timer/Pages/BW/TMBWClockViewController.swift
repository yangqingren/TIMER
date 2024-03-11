//
//  TMBlackWhiteClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

enum TMBwVcTheme: Int {
    case white = 0
    case black = 1
}
 
enum TMBwVcThemeType {
    case vcBg
    case timeBg
    case timeText
}

class TMBWClockViewController: TMBasePageViewController {
    
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
        label.textColor = .black
        label.textAlignment = .center
        label.layer.shadowOffset = CGSize(width: 0.dp, height: 0.dp)
        label.layer.shadowColor = UIColor.lightGray.cgColor
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 4.dp
        return label
    }()
    
    lazy var bwHHView: TMBWBaseView = {
        let format = Date.getHhFormatter()
        let view = TMBWBaseView(frame: .zero, format: .hh, vcType: self.vcType)
        view.topLabel.text = TMLocalizedString("时")
        return view
    }()
    
    lazy var bwMmView: TMBWBaseView = {
        let view = TMBWBaseView(frame: .zero, format: .mm, vcType: self.vcType)
        view.topLabel.text = TMLocalizedString("分")
        return view
    }()
    
    lazy var bwSsView: TMBWBaseView = {
        let view = TMBWBaseView(frame: .zero, format: .ss, vcType: self.vcType)
        view.topLabel.text = TMLocalizedString("秒")
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(kShadowLabelTop)
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
            make.centerY.equalToSuperview().offset(IsIpad ? -4.dp : 0)
        }
        
        self.view.addSubview(self.bwHHView)
        self.bwHHView.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.bwMmView.snp.top).offset(-kTMBWBaseViewSpacingY)
        }
        
        self.view.addSubview(self.bwSsView)
        self.bwSsView.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.bwMmView.snp.bottom).offset(kTMBWBaseViewSpacingY)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupThemeVcChanged), name: NSNotification.Name.kNotifiVcThemeChanged, object: nil)
        
        self.setupBatteryView()
        self.setupThemeVcChanged()
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        let text = Date().getDateStringEn(format: "MM dd EEEE")
        self.topDateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3)
    }

    @objc func setupThemeVcChanged() {
        let theme = self.item.subType ?? .white
        self.view.backgroundColor = TMBWClockViewController.getThemeColor(theme, .vcBg)
        self.bwHHView.setupTheme(theme)
        self.bwMmView.setupTheme(theme)
        self.bwSsView.setupTheme(theme)
        self.topDateLabel.textColor = theme == .white ? .black : .white
        if self.vcType == .main {
            NotificationCenter.default.post(name: NSNotification.Name.kNotifiBackgroundColor, object: self.view.backgroundColor)
        }
    }
        
    static func getThemeColor(_ theme: TMBwVcTheme, _ type: TMBwVcThemeType) -> UIColor {
        var color: UIColor = .clear
        if theme == .black {
            switch type {
            case .vcBg:
                color = .init(r: 8, g: 8, b: 8, a: 1)
            case .timeBg:
                color = .init(r: 2, g: 2, b: 2, a: 1)
            case .timeText:
                color = .white
            }
        }
        else {
            switch type {
            case .vcBg:
                color = .init(r: 242, g: 242, b: 242, a: 1)
            case .timeBg:
                color = .init(r: 248, g: 248, b: 248, a: 1)
            case .timeText:
                color = .black
            }
        }
        return color
    }
}
