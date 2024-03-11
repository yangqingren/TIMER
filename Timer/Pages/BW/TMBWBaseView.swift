//
//  TMBWssView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/22.
//

import UIKit

private let kCornerRadius = 14.dp
let kTMBWBaseViewSpacingY = IsIpad ? 15.dp : 22.dp

class TMBWBaseLabel: UILabel {
    
    init(frame: CGRect, theme: TMBwVcTheme) {
        super.init(frame: frame)
        self.font = .init(name: "TMTimer", size: IsIpad ? 95.sp : 150.sp)
        self.textAlignment = .center
        self.layer.cornerRadius = kCornerRadius
        self.layer.masksToBounds = true
        self.setupTheme(theme)
    }
    
    func setupTheme(_ theme: TMBwVcTheme) {
        self.backgroundColor = TMBWClockViewController.getThemeColor(theme, .timeBg)
        self.textColor = TMBWClockViewController.getThemeColor(theme, .timeText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: IsIpad ? 12.dp : 21.dp, left: 0, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}

class TMBWBaseView: TMBaseView {

    lazy var timeLabel1: TMBWBaseLabel = {
        return TMBWBaseLabel(frame: .zero, theme: .white)
    }()
    
    lazy var timeLabel2: TMBWBaseLabel = {
        return TMBWBaseLabel(frame: .zero, theme: .white)
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: IsIpad ? 12.sp : 18.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    var format: TMBaseHhMmSsType

    init(frame: CGRect, format: TMBaseHhMmSsType, vcType: TMMainVcType) {
        self.format = format
        super.init(frame: frame, vcType: vcType)
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = kCornerRadius
        self.layer.shadowRadius = 10.dp
        self.layer.shadowOffset = CGSize(width: 0, height: 5.dp)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
                
        self.addSubview(self.timeLabel1)
        self.timeLabel1.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.subViewSize())
            make.left.equalToSuperview().offset(4.dp)
            make.centerY.equalToSuperview()
        }
        self.addSubview(self.timeLabel2)
        self.timeLabel2.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.subViewSize())
            make.right.equalToSuperview().offset(-4.dp)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.topLabel)
        self.topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5.dp)
        }
        self.topLabel.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, TMBWBaseView.subViewSize().height)
    }
    
    var theme: TMBwVcTheme = .white
    
    func setupTheme(_ theme: TMBwVcTheme) {
        self.theme = theme
        self.backgroundColor = TMBWClockViewController.getThemeColor(theme, .timeBg)
        self.timeLabel1.setupTheme(theme)
        self.timeLabel2.setupTheme(theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        if IsIpad {
            let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan - kTMBWBaseViewSpacingY * 2 - 115.dp) / 3.0
            return CGSize(width: height, height: height)
        }
        else {
            let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan - kTMBWBaseViewSpacingY * 2 - 165.dp) / 3.0
            return CGSize(width: height, height: height)
        }
    }
    
    static func subViewSize() -> CGSize {
        let size = TMBWBaseView.viewSize()
        return CGSize(width: size.width / 2.0, height: size.height)
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
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.transform = transform
        }
    }
    
    var timeUpdatesEnable = true
    
    override func timeUpdates() {
        super.timeUpdates()
        
        if self.timeUpdatesEnable {
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
            self.transformPage(String(text.prefix(1)), label: self.timeLabel1)
            self.transformPage(String(text.suffix(1)), label: self.timeLabel2)
        }
    }
    
    var random1: Int = Int(arc4random() % 10)
    var random2: Int = Int(arc4random() % 10)
    func transformArc4random () {
        self.transformPage(String("\(random1)".prefix(1)), label: self.timeLabel1)
        self.transformPage(String("\(random2)".prefix(1)), label: self.timeLabel2)
        random1 += 1
        random2 += 1
        

        switch self.format {
        case .hh:
            if self.hhFormat == "hh" {
                if random1 > 1 {
                    random1 = 0
                }
                if random2 > 2 {
                    random2 = 0
                }
            }
            else {
                if random1 > 2 {
                    random1 = 0
                }
                if random2 > 4 {
                    random2 = 0
                }
            }
        case .mm:
            if random1 > 6 {
                random1 = 0
            }
            if random2 >= 10 {
                random2 = 0
            }
        case .ss:
            if random1 > 6 {
                random1 = 0
            }
            if random2 >= 10 {
                random2 = 0
            }
        }
    }
    
    func transformPage(_ text: String, label: UILabel) {
        if label.text == nil {
            label.text = text
        }
        if text == label.text {
            return
        }
        let durtion = 1.0
        let rect = CGRect(x: 0, y: 0, width: TMBWBaseView.subViewSize().width, height: TMBWBaseView.subViewSize().height)
        
        let view1 = TMBWHalfView1(frame: rect, new: text, old: label.text ?? "", theme: self.theme)
        self.addSubview(view1)
        view1.snp.makeConstraints { make in
            make.edges.equalTo(label)
        }
        var transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 10.dp)
        view1.layer.transform = transform
        
        let view2 = TMBWHalfView2(frame: rect, new: text, old: label.text ?? "", theme: self.theme)
        self.addSubview(view2)
        view2.snp.makeConstraints { make in
            make.edges.equalTo(label)
        }
        transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 20.dp)
        view2.layer.transform = transform
  
        label.text = text
        UIView.animate(withDuration: durtion / 2.0, delay: 0, options: .curveLinear) {
            view2.layer.transform = CATransform3DRotate(view2.layer.transform, .pi * -0.99, 1, 0, 0)
        } completion: { _ in
            view1.removeFromSuperview()
            view2.removeFromSuperview()
        }

        view2.label1.isHidden = false
        view2.label2.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + durtion / 4.0) {
            view2.label1.isHidden = true
            view2.label2.isHidden = false
        }
        
        if self.vcType == .main && self.format == .ss {
            TMSoundManager.playSound(.bw)
        }
    }
}

class TMBWHalfView1: UIView {
    
    init(frame: CGRect, new: String, old: String, theme: TMBwVcTheme) {
        super.init(frame: frame)
            
        let label1 = TMBWHalfLabel(frame: frame, type: .top, theme: theme)
        label1.text = new
        self.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label2 = TMBWHalfLabel(frame: frame, type: .bottom, theme: theme)
        label2.text = old
        self.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//背后：上 新5，下 旧4
//上面：上 旧4，下 空；背后：上 新5(180) X 
//动画结束不用移除

class TMBWHalfView2: UIView {
    
    let label1: UILabel
    
    let label2: UILabel
    
    init(frame: CGRect, new: String, old: String, theme: TMBwVcTheme) {
            
        label1 = TMBWHalfLabel(frame: frame, type: .top, theme: theme)
        label1.text = old
        label2 = TMBWHalfLabel(frame: frame, type: .bottom, theme: theme)
        label2.text = new
        super.init(frame: frame)

        self.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -5.dp)
        label1.layer.transform = transform

        transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -2.5.dp)
        transform = CATransform3DRotate(transform, -.pi, 1, 0, 0)
        label2.layer.transform = transform
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TMBWHalfLabel: TMBWBaseLabel {
    
    let type: TMBaseHalfType
    
    init(frame: CGRect, type: TMBaseHalfType, theme: TMBwVcTheme) {
        self.type = type
        super.init(frame: frame, theme: theme)
        
        self.backgroundColor = TMBWClockViewController.getThemeColor(theme, .timeBg)
        
        var rect = CGRect.zero
        if type == .top {
            rect = CGRect(x: 0, y: self.frame.size.height / 2.0, width: self.frame.size.width, height: self.frame.size.height / 2.0)
        }
        else {
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 2.0)
        }
        let path = UIBezierPath(rect: self.bounds)
        path.append(UIBezierPath(roundedRect: rect, cornerRadius: 0.0).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
