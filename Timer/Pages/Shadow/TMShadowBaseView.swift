//
//  TMShadowBaseView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/24.
//

import UIKit

class TMShadowBaseView: TMBaseView {

    lazy var label1: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: 144.sp)
        label.textColor = UIColor.init(r: 51, g: 51, b: 51, a: 1)
        return label
    }()
    
    lazy var whiteLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: 144.sp)
        label.textColor = UIColor.init(r: 255, g: 255, b: 255, a: 0.3)
        return label
    }()
    
    lazy var blackLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: 144.sp)
        label.textColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3)
        return label
    }()
    
    lazy var formatLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: 18.sp)
        label.textColor = UIColor.init(r: 51, g: 51, b: 51, a: 1)
        return label
    }()
    
    lazy var whiteFormatLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: 18.sp)
        label.textColor = UIColor.init(r: 255, g: 255, b: 255, a: 0.3)
        return label
    }()
    
    lazy var blackFormatLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: 18.sp)
        label.textColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3)
        return label
    }()
    
    func setupFormatLabel(_ text: String) {
        self.formatLabel.text = text
        self.whiteFormatLabel.text = text
        self.blackFormatLabel.text = text
    }
    
    let format: String
    
    init(frame: CGRect, format: String) {
        self.format = format
        super.init(frame: frame)
        
        self.addSubview(self.formatLabel)
        self.formatLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.top).offset(0.dp)
        }
        self.insertSubview(self.whiteFormatLabel, belowSubview: self.formatLabel)
        self.whiteFormatLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-1.dp)
            make.centerY.equalTo(self.formatLabel.snp.centerY).offset(-1.dp)
        }
        self.insertSubview(self.blackFormatLabel, belowSubview: self.formatLabel)
        self.blackFormatLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(1.dp)
            make.centerY.equalTo(self.formatLabel.snp.centerY).offset(1.dp)
        }
        
        self.addSubview(self.label1)
        self.label1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.insertSubview(self.whiteLabel, belowSubview: self.label1)
        self.whiteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-2.dp)
            make.centerY.equalToSuperview().offset(-2.dp)
        }
        
        self.insertSubview(self.blackLabel, belowSubview: self.label1)
        self.blackLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(2.dp)
            make.centerY.equalToSuperview().offset(2.dp)
        }
        
    }
    
    static func viewSize() -> CGSize {
        let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan) / 3.0 - 100.dp
        return CGSize(width: height, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        let text = Date().getDateStringEn(format: self.format)
        self.label1.text = text
        self.whiteLabel.text = text
        self.blackLabel.text = text
    }
    
}
