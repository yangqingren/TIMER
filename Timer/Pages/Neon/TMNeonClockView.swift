//
//  TMNeonClockView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/22.
//

import UIKit

class TMNeonClockView: TMBaseView {

    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20.dp
        view.layer.borderWidth = 4.dp
        view.layer.borderColor = TMNeonBlue.cgColor
        view.layer.shadowRadius = 5.dp
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowColor = TMNeonBlue.cgColor
        view.layer.shadowOpacity = 1.0
        
        let line = UIView()
        line.layer.cornerRadius = 2.dp
        line.backgroundColor = TMNeonBlue
        
        line.layer.shadowRadius = 5.dp
        line.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        line.layer.shadowColor = TMNeonBlue.cgColor
        line.layer.shadowOpacity = 0.3
        
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.width.equalTo(LEGOScreenWidth * 0.6)
            make.height.equalTo(4.dp)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY).offset(13.dp)
        }
        
        return view
    }()
    
    lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.textColor = TMNeonYellow
        label.font = .init(name: "Copperplate-Bold", size: 18.sp)
        return label
    }()
    
    func setupWeekLabel() {
        let shadow = NSShadow()
        shadow.shadowColor = TMNeonYellow
        shadow.shadowBlurRadius = 7.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let text = Date().getDateString(format: "EEE")
        self.weekLabel.attributedText = String.getExpansionString(text: text, expansion: 0.5, others: [    NSAttributedString.Key.shadow: shadow])
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = TMNeonPink
        label.font = .init(name: "Copperplate-Bold", size: 40.sp)
        return label
    }()
    
    var format = Date.getHhFormatter()
    var text = ""
    func setupTimeLabel() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 255, g: 154, b: 195, a: 1)
        shadow.shadowBlurRadius = 10.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let text = Date().getDateStringEn(format: "\(self.format) : mm : ss")
        self.timeLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3, others: [NSAttributedString.Key.shadow: shadow])
        
        if self.text != text {
            self.text = text
            if self.vcType == .main {
                TMSoundManager.playSound("slim")
            }
        }
    }
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = TMNeonYellow
        label.font = .init(name: "Copperplate-Bold", size: 26.sp)
        return label
    }()
    
    func setupDateLabel() {
        let shadow = NSShadow()
        shadow.shadowColor = TMNeonYellow
        shadow.shadowBlurRadius = 7.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let text = Date().getDateStringEn(format: "MMM dd")
        self.dateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3, others: [NSAttributedString.Key.shadow: shadow])
    }

    let vcType: TMMainVcType

    init(frame: CGRect, vcType: TMMainVcType) {
        self.vcType = vcType
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-18.dp)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: LEGOScreenWidth * 0.9, height: LEGOScreenWidth * 0.4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupWeekLabel()
    }
    
}
