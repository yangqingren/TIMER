//
//  TMMainSettingView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

class TMMainSettingView: UIView {

    static func show(inView: UIView, originalRect: CGRect) {
        let view = TMMainSettingView.init(frame: .zero, inView: inView, originalRect: originalRect)
        view.show()
    }
    
    lazy var coverView: UIControl = {
        let view = UIControl()
        view.backgroundColor = .black.withAlphaComponent(0)
        view.addTarget(self, action: #selector(coverViewClick), for: .touchUpInside)
        return view
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    @objc func coverViewClick() {
        self.dismiss()
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 207, g: 216, b: 227, a: 0.5)
        return view
    }()
    
    let inView: UIView
    let originalRect: CGRect
    
    init(frame: CGRect, inView: UIView, originalRect: CGRect) {
        self.inView = inView
        self.originalRect = originalRect
        super.init(frame: frame)
        
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.cornerRadius  = 20.dp
        self.contentView.layer.masksToBounds = true

        self.inView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.coverView)
        self.coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.coverView.backgroundColor = .black.withAlphaComponent(0.25)
        }
        
        let contentSize = CGSize(width: 232.dp, height: 322.dp)
        self.addSubview(self.contentView)
        self.contentView.frame = CGRect(x: self.originalRect.maxX, y: self.originalRect.minY - contentSize.height, width: contentSize.width, height: contentSize.height)
        
//        let maskPath = UIBezierPath(roundedRect: self.contentView.bounds, byRoundingCorners: [.topRight, .bottomRight, .topLeft], cornerRadii: CGSize(width: 20.dp, height: 20.dp))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.contentView.bounds
//        maskLayer.path = maskPath.cgPath
//        self.contentView.layer.mask = maskLayer
        
        self.contentView.addSubview(self.blurView)
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        let rect = CGRect(x: self.originalRect.origin.x - 5.dp, y: self.originalRect.origin.y - 5.dp, width: self.originalRect.size.width + 10.dp, height: self.originalRect.size.height + 10.dp)
        let path = UIBezierPath(rect: UIScreen.main.bounds)
        path.append(UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2.0).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer


    }
    
    func show() {
        self.setAnchorPointTo(view: self.contentView, point: CGPoint(x: 0, y: 1))
        self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.contentView.transform = CGAffineTransform.identity
            self.contentView.alpha = 1
        }
    }
    
    func dismiss() {
        self.contentView.transform = CGAffineTransform.identity
        self.contentView.alpha = 1
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.contentView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    func setAnchorPointTo(view: UIView, point: CGPoint) {
        let oldFrame = view.frame
        view.layer.anchorPoint = point
        view.frame = oldFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
