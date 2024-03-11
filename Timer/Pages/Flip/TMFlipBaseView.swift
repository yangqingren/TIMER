//
//  TMFlipBaseView.swift
//  Timer
//
//  Created by yangqingren on 2024/3/6.
//

import UIKit

private let kCornerRadius = 14.dp
let kTMFlipBaseSpacingY = IsIpad ? 15.dp : 22.dp
private let kTMFlipTimeBg = UIColor.init(r: 37, g: 37, b: 37, a: 1)

class TMFlipBaseLabel: UILabel {
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 1, g: 1, b: 1, a: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kTMFlipTimeBg
        self.textColor = .white
        self.font = .init(name: "FlipClock", size: IsIpad ? 100.sp : 160.sp)
        self.textAlignment = .center
        self.layer.cornerRadius = kCornerRadius
        self.layer.masksToBounds = true
        
        self.addSubview(self.line)
        self.line.snp.makeConstraints { make in
            make.height.equalTo(3.dp)
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TMFlipBaseView: TMBaseView {

    lazy var timeLabel: TMFlipBaseLabel = {
        let label = TMFlipBaseLabel()
        return label
    }()
    
    var format: TMBaseHhMmSsType

    init(frame: CGRect, format: TMBaseHhMmSsType, vcType: TMMainVcType) {
        self.format = format
        super.init(frame: frame, vcType: vcType)
        self.isUserInteractionEnabled = false

        self.layer.borderWidth = 1.dp
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = kCornerRadius
        
        self.layer.shadowRadius = 10.dp
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
                
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        if IsIpad {
            let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan - kTMFlipBaseSpacingY * 2 - 115.dp) / 3.0
            return CGSize(width: height, height: height)
        }
        else {
            let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan - kTMFlipBaseSpacingY * 2 - 165.dp) / 3.0
            return CGSize(width: height, height: height)
        }
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
    
    override func timeUpdates() {
        super.timeUpdates()
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
        self.transformPage(text, label: self.timeLabel)
    }
    
    func transformPage(_ text: String, label: UILabel) {
        if label.text == nil {
            label.text = text
        }
        if text == label.text {
            return
        }
        let durtion = 1.0
        let rect = CGRect(x: 0, y: 0, width: TMFlipBaseView.viewSize().width, height: TMFlipBaseView.viewSize().height)
        
        let view1 = TMFlipHalfView1(frame: rect, new: text, old: label.text ?? "")
        self.addSubview(view1)
        view1.snp.makeConstraints { make in
            make.edges.equalTo(label)
        }
        var transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 10.dp)
        view1.layer.transform = transform
        
        let view2 = TMFlipHalfView2(frame: rect, new: text, old: label.text ?? "")
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
            TMSoundManager.playSound(.flip)
        }
    }
}

class TMFlipHalfView1: UIView {
    
    init(frame: CGRect, new: String, old: String) {
        super.init(frame: frame)
            
        self.layer.borderWidth = 1.dp
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = kCornerRadius
        
        let label1 = TMFlipHalfLabel(frame: frame, type: .top)
        label1.text = new
        self.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label2 = TMFlipHalfLabel(frame: frame, type: .bottom)
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

class TMFlipHalfView2: UIView {
    
    let label1: UILabel
    
    let label2: UILabel
    
    init(frame: CGRect, new: String, old: String) {
            
        label1 = TMFlipHalfLabel(frame: frame, type: .top)
        label1.text = old
        label2 = TMFlipHalfLabel(frame: frame, type: .bottom)
        label2.text = new
        super.init(frame: frame)

        self.layer.borderWidth = 1.dp
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = kCornerRadius
        
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

class TMFlipHalfLabel: TMFlipBaseLabel {
    
    let type: TMBaseHalfType
    
    init(frame: CGRect, type: TMBaseHalfType) {
        self.type = type
        super.init(frame: frame)
        
        self.backgroundColor = kTMFlipTimeBg
        
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

