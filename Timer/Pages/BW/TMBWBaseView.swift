//
//  TMBWssView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/22.
//

import UIKit

private let kBackgroundColor = UIColor.init(r: 248, g: 248, b: 248, a: 1)

class TMBWBaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .init(name: "TMTimer", size: 180.sp)
        self.textColor = .black
        self.textAlignment = .center
        self.backgroundColor = kBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 21.dp, left: 0, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}

class TMBWBaseView: TMBaseView {

    lazy var timeLabel1: UILabel = {
        return TMBWBaseLabel()
    }()
    
    lazy var timeLabel2: UILabel = {
        return TMBWBaseLabel()
    }()
        
    let format: String
    
    init(frame: CGRect, format: String) {
        self.format = format
        super.init(frame: frame)
        self.backgroundColor = kBackgroundColor
        self.layer.cornerRadius = 14.dp
        self.layer.shadowRadius = 10.dp
        self.layer.shadowOffset = CGSize(width: 0, height: 5.dp)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
        
        self.addSubview(self.timeLabel1)
        self.timeLabel1.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.subViewSize())
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.addSubview(self.timeLabel2)
        self.timeLabel2.snp.makeConstraints { make in
            make.size.equalTo(TMBWBaseView.subViewSize())
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        let height = (LEGOScreenHeight - LEGONavMargan - LEGOBottomMargan) / 3.0 - 50.dp
        return CGSize(width: height, height: height)
    }
    
    static func subViewSize() -> CGSize {
        let size = TMBWBaseView.viewSize()
        return CGSize(width: size.width / 2.0, height: size.height)
    }
        
    override func timeUpdates() {
        super.timeUpdates()
        
        let text = Date().getDateStringEn(format: self.format)
        self.transformPage(String(text.prefix(1)), label: self.timeLabel1)
        self.transformPage(String(text.suffix(1)), label: self.timeLabel2)
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
        
        let view1 = TMBWHalfView1(frame: rect, new: text, old: label.text ?? "")
        self.addSubview(view1)
        view1.snp.makeConstraints { make in
            make.edges.equalTo(label)
        }
        var transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 10.dp)
        view1.layer.transform = transform
        
        let view2 = TMBWHalfView2(frame: rect, new: text, old: label.text ?? "")
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
    }
}

enum TMBWHalfType {
    case top
    case bottom
}

class TMBWHalfLabel: TMBWBaseLabel {
    
    let type: TMBWHalfType
    
    init(frame: CGRect, type: TMBWHalfType) {
        self.type = type
        super.init(frame: frame)
        self.backgroundColor = kBackgroundColor
        
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

class TMBWHalfView1: UIView {
    
    init(frame: CGRect, new: String, old: String) {
        super.init(frame: frame)
            
        let label1 = TMBWHalfLabel(frame: frame, type: .top)
        label1.text = new
        self.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label2 = TMBWHalfLabel(frame: frame, type: .bottom)
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
    
    init(frame: CGRect, new: String, old: String) {
            
        label1 = TMBWHalfLabel(frame: frame, type: .top)
        label1.text = old
        label2 = TMBWHalfLabel(frame: frame, type: .bottom)
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