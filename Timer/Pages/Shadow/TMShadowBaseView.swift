//
//  TMShadowBaseView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/24.
//

import UIKit

private let kFontSize = IsIpad ? 100.sp : 132.sp
private let kFormatFontSize = IsIpad ? 18.sp : 18.sp

class TMShadowBaseView: TMBaseView {

    lazy var label1: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: kFontSize)
        label.textColor = UIColor.init(r: 51, g: 51, b: 51, a: 1)
        return label
    }()
    
    lazy var whiteLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: kFontSize)
        label.textColor = UIColor.init(r: 255, g: 255, b: 255, a: 0.3)
        return label
    }()
    
    lazy var blackLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: kFontSize)
        label.textColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3)
        return label
    }()
    
    lazy var formatLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: kFormatFontSize)
        label.textColor = UIColor.init(r: 51, g: 51, b: 51, a: 1)
        return label
    }()
    
    lazy var whiteFormatLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: kFormatFontSize)
        label.textColor = UIColor.init(r: 255, g: 255, b: 255, a: 0.3)
        return label
    }()
    
    lazy var blackFormatLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "SinhalaSangamMN-Bold", size: kFormatFontSize)
        label.textColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3)
        return label
    }()
    
    func setupFormatLabel(_ text: String) {
        self.formatLabel.text = text
        self.whiteFormatLabel.text = text
        self.blackFormatLabel.text = text
    }
    
    var format: TMBaseHhMmSsType

    init(frame: CGRect, format: TMBaseHhMmSsType, vcType: TMMainVcType) {
        self.format = format
        super.init(frame: frame, vcType: vcType)
        
        self.addSubview(self.formatLabel)
        self.formatLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if IsIpad {
                make.bottom.equalTo(self.snp.top).offset(0.dp)
            }
            else {
                make.centerY.equalTo(self.snp.top).offset(0.dp)
            }
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
        let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan) / 3.0 - (IsIpad ? 70.dp : 100.dp)
        return CGSize(width: height, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        var isSame = false
        var format = ""
        switch self.format {
        case .hh:
            format = self.hhFormat
        case .mm:
            format = "mm"
        case .ss:
            format = "ss"
        }
        let text = Date().getDateStringEn(format: format)
        if text == self.label1.text {
            isSame = true
        }
        self.label1.text = text
        self.whiteLabel.text = text
        self.blackLabel.text = text
        
        if !isSame {
            var transform = CGAffineTransform.identity
            switch TMMontionManager.share.directin {
            case .original:
                transform = transform.scaledBy(x: 1.2, y: 1)
            case .left:
                transform = transform.scaledBy(x: 1, y: 1.2)
            case .right:
                transform = transform.scaledBy(x: 1, y: 1.2)
            case .down:
                transform = transform.scaledBy(x: 1.2, y: 1)
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                self.setupLabelTransform(transform)
            } completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                    let transform = CGAffineTransform.identity
                    self.setupLabelTransform(transform)
                } completion: { _ in
                    
                }
            }
            if self.vcType == .main && self.format == .ss {
                TMSoundManager.playSound(.shadow)
            }
        }
    }
    
    func setupLabelTransform(_ transform: CGAffineTransform) {
        self.label1.transform = transform
        self.whiteLabel.transform = transform
        self.blackLabel.transform = transform
    }
    
    override func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {
        super.motionUpdates(directin: directin, duration: duration)
        
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
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut) {
            self.transform = transform
        }
    }
}
