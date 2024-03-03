//
//  TMClockClock2View.swift
//  Timer
//
//  Created by yangqingren on 2024/3/2.
//

import UIKit

private let hourW = 5.dp
private let minW = 3.dp
private let secW = 1.5.dp

private let hourLength = TMClockClockView.viewSize().width * 0.5
private let minLength = TMClockClockView.viewSize().width * 0.7
private let secLength = TMClockClockView.viewSize().width * 0.9

class TMClockClock2BaseView: UIView {
    
    lazy var line: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.line)
        self.line.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TMClockClock2View: TMBaseView {

    lazy var hour: TMClockClock2BaseView = {
        let width = TMClockClock2View.viewSize().width
        let view = TMClockClock2BaseView(frame: CGRect(x: 0, y: 0, width: hourW, height: hourLength))
        view.line.backgroundColor = .black
        view.layer.cornerRadius = hourW / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var min: TMClockClock2BaseView = {
        let width = TMClockClock2View.viewSize().width
        let view = TMClockClock2BaseView(frame: CGRect(x: 0, y: 0, width: minW, height: minLength))
        view.line.backgroundColor = .black
        view.layer.cornerRadius = minW / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var sec: TMClockClock2BaseView = {
        let width = TMClockClock2View.viewSize().width
        let view = TMClockClock2BaseView(frame: CGRect(x: 0, y: 0, width: secW, height: secLength))
        view.line.backgroundColor = .systemRed
        view.layer.cornerRadius = secW / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    func createNumber(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .init(name: "DevanagariSangamMN-Bold", size: 18.sp)
        return label
    }
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "clock_clock2_bg")
        return view
    }()
        
    override init(frame: CGRect, vcType: TMMainVcType) {
        super.init(frame: frame, vcType: vcType)
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.hour)
        self.hour.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: hourW, height: hourLength))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.addSubview(self.min)
        self.min.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: minW, height: minLength))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.addSubview(self.sec)
        self.sec.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: secW, height: secLength))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let center = UIView()
        center.backgroundColor = .black
        center.layer.cornerRadius = 15.dp / 2.0
        self.addSubview(center)
        center.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15.dp, height: 15.dp))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.timeUpdates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: 245.dp, height: 245.dp)
    }
    
    var ss = 0
    
    override func timeUpdates() {
        super.timeUpdates()

        let date = Date()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)

        let secAngle = .pi * 2.0 / 60.0 * CGFloat(sec)
        let minAngle = .pi * 2.0 / 60.0 * CGFloat(min) + secAngle / 60.0
        let hourAngle = .pi * 2.0 / 12.0 * CGFloat(hour) + minAngle / 12.0
        self.sec.transform = CGAffineTransform.identity.rotated(by: secAngle)
        self.min.transform = CGAffineTransform.identity.rotated(by: minAngle)
        self.hour.transform = CGAffineTransform(rotationAngle: hourAngle)
        
        if self.ss != sec {
            self.ss = sec
            if self.vcType == .main {
                TMSoundManager.playSound("pointer")
            }
        }
    }
}
