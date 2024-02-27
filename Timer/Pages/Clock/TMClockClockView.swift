//
//  TMClockClockView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/24.
//

import UIKit

let hourW = 5.dp
let minW = 3.dp
let secW = 1.5.dp

let hourLength = TMClockClockView.viewSize().width * 0.5
let minLength = TMClockClockView.viewSize().width * 0.7
let secLength = TMClockClockView.viewSize().width * 0.9

class TMClockClockBaseView: UIView {
    
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

class TMClockClockView: TMBaseView {

    lazy var hour: TMClockClockBaseView = {
        let width = TMClockClockView.viewSize().width
        let view = TMClockClockBaseView(frame: CGRect(x: 0, y: 0, width: hourW, height: hourLength))
        view.line.backgroundColor = .black
        view.layer.cornerRadius = hourW / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var min: TMClockClockBaseView = {
        let width = TMClockClockView.viewSize().width
        let view = TMClockClockBaseView(frame: CGRect(x: 0, y: 0, width: minW, height: minLength))
        view.line.backgroundColor = .black
        view.layer.cornerRadius = minW / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var sec: TMClockClockBaseView = {
        let width = TMClockClockView.viewSize().width
        let view = TMClockClockBaseView(frame: CGRect(x: 0, y: 0, width: secW, height: secLength))
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = TMClockClockView.viewSize().width
        let height = TMClockClockView.viewSize().height
        let offsetB = width / 2.0 * 0.5
        let offsetM = width / 2.0 * 0.36
        let offsetS = width / 2.0 - offsetB - offsetM
        let rotate0 = CGAffineTransform.identity
        let rotate30 = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 30.0)
        let rotate60 = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 60.0)
        let rotate90 = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 90.0)
        let rotate120 = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 120.0)
        let rotate150 = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 150.0)
        for index in 1...12 {
            let line = UIView()
            line.backgroundColor = .black
            self.addSubview(line)
            let size = CGSize(width: 4.dp, height: 10.dp)
            var centerX = 0.0
            var centerY = 0.0
            var transform = CGAffineTransform.identity
            switch index {
            case 12:
                centerX = width / 2.0
                centerY = 0
                transform = CGAffineTransform.identity
            case 1:
                centerX = width / 2.0 + offsetB
                centerY = offsetS
                transform = rotate30
            case 2:
                centerX = width / 2.0 + offsetB + offsetM
                centerY = offsetS + offsetM
                transform = rotate60
            case 3:
                centerX = width
                centerY = offsetS + offsetM + offsetB
                transform = rotate90
            case 4:
                centerX = width / 2.0 + offsetB + offsetM
                centerY = height / 2.0 + offsetB
                transform = rotate120
            case 5:
                centerX = width / 2.0 + offsetB
                centerY = height / 2.0 + offsetB + offsetM
                transform = rotate150
            case 6:
                centerX = width / 2.0
                centerY = height
                transform = rotate0
            case 7:
                centerX = offsetS + offsetM
                centerY = height / 2.0 + offsetB + offsetM
                transform = rotate30
            case 8:
                centerX = offsetS
                centerY = height / 2.0 + offsetB
                transform = rotate60
            case 9:
                centerX = 0
                centerY = height / 2.0
                transform = rotate90
            case 10:
                centerX = offsetS
                centerY = offsetS + offsetM
                transform = rotate120
            case 11:
                centerX = offsetS + offsetM
                centerY = offsetS
                transform = rotate150
            default:
                break
            }
            line.snp.makeConstraints { make in
                make.size.equalTo(size)
                make.centerX.equalTo(self.snp.left).offset(centerX)
                make.centerY.equalTo(self.snp.top).offset(centerY)
            }
            line.transform = transform
            
            let offset = 22.dp
            let num12 = self.createNumber("12")
            self.addSubview(num12)
            num12.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(self.snp.top).offset(offset)
            }
            let num3 = self.createNumber("3")
            self.addSubview(num3)
            num3.snp.makeConstraints { make in
                make.centerX.equalTo(self.snp.right).offset(-offset)
                make.centerY.equalToSuperview()
            }
            let num6 = self.createNumber("6")
            self.addSubview(num6)
            num6.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(self.snp.bottom).offset(-offset)
            }
            let num9 = self.createNumber("9")
            self.addSubview(num9)
            num9.snp.makeConstraints { make in
                make.centerX.equalTo(self.snp.left).offset(offset)
                make.centerY.equalToSuperview()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        CGSize(width: LEGOScreenWidth / 2.0, height: LEGOScreenWidth / 2.0)
    }
    
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
    }
}
