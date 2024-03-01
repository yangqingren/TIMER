//
//  TMTimerContentView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/29.
//

import UIKit

class TMTimerContentView: UIView {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "timerVc_content_nomal")
        return view
    }()
    
    lazy var dian: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 10, g: 10, b: 10, a: 1)
        label.font = .init(name: "Courier-Bold", size: 46.sp)
        label.text = ":"
        return label
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 10, g: 10, b: 10, a: 1)
        label.font = .init(name: "Courier-Bold", size: 46.sp)
        label.text = "00"
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 10, g: 10, b: 10, a: 1)
        label.font = .init(name: "Courier-Bold", size: 46.sp)
        label.text = "00"
        label.textAlignment = .left
        return label
    }()

    private var progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.dian)
        self.dian.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-3.dp)
        }
        self.addSubview(self.label1)
        self.label1.snp.makeConstraints { make in
            make.right.equalTo(self.dian.snp.left).offset(-2.dp)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        self.addSubview(self.label2)
        self.label2.snp.makeConstraints { make in
            make.left.equalTo(self.dian.snp.right).offset(2.dp)
            make.centerY.equalToSuperview()
        }
        
        let width = 22.dp
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: TMTimerContentView.viewSize().width / 2, y: TMTimerContentView.viewSize().height / 2), radius: TMTimerContentView.viewSize().height / 2 - 15.dp, startAngle: -.pi / 180.0 * 85.0, endAngle: .pi / 180.0 * 264.0, clockwise: true)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemGreen.withAlphaComponent(0.25).cgColor
        progressLayer.lineWidth = width.dp
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0

        layer.addSublayer(progressLayer)
    }
    
    func setupProgressLayer(duration: TimeInterval, from: Float, to: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "animation")
    }
    
    func setupProgressLayer(to: CGFloat) {
        progressLayer.strokeEnd = to
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: 250.dp, height: 250.dp)
    }
    
}
