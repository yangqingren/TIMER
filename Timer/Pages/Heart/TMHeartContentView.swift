//
//  TMHeartContentView.swift
//  Timer
//
//  Created by yangqingren on 2024/3/3.
//

import UIKit
 
private let kFontSize = IsIpad ? 55.sp : 76.sp

class TMHeartImageView: UIImageView {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TMHeartContentView: TMBaseView {

    lazy var heartHHLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "iconfont-8bit-front-Regular", size: kFontSize)
        label.textColor = UIColor.init(r: 38, g: 38, b: 38, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var heartMmLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "iconfont-8bit-front-Regular", size: kFontSize)
        label.textColor = UIColor.init(r: 38, g: 38, b: 38, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var heartSsLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "iconfont-8bit-front-Regular", size: kFontSize)
        label.textColor = UIColor.init(r: 38, g: 38, b: 38, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var heartImageView: TMHeartImageView = {
        let view = TMHeartImageView(frame: .zero)
        view.imageView.image = UIImage(named: "heart_heart_nomal")
        return view
    }()
    
    override init(frame: CGRect, vcType: TMMainVcType) {
        super.init(frame: frame, vcType: vcType)
        
        let width = TMHeartContentView.viewSize().width
        let spacing = 0.dp
        
        self.addSubview(self.heartHHLabel)
        self.heartHHLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(self.heartMmLabel)
        self.heartMmLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.centerX.equalToSuperview()
            make.top.equalTo(self.heartHHLabel.snp.bottom).offset(spacing)
        }
        
        self.addSubview(self.heartSsLabel)
        self.heartSsLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.centerX.equalToSuperview()
            make.top.equalTo(self.heartMmLabel.snp.bottom).offset(spacing)
        }
        
        self.addSubview(self.heartImageView)
        self.heartImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.heartHHLabel.snp.top).offset(-spacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        CGSize(width: IsIpad ? 100.dp : 136.dp, height: LEGOScreenHeight)
    }
        
    var ss = ""
    override func timeUpdates() {
        super.timeUpdates()
        
        self.heartHHLabel.text = Date().getDateStringEn(format: self.hhFormat)
        self.heartMmLabel.text = Date().getDateStringEn(format: "mm")
        let ss = Date().getDateStringEn(format: "ss")
        self.heartSsLabel.text = ss
        if self.ss != ss {
            self.ss = ss
            if self.vcType == .main {
                TMSoundManager.playSound(.heart)
            }
            self.heartImageView.imageView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.heartImageView.imageView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }
        }
    }
    
    override func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {
        super.motionUpdates(directin: directin, duration: duration)
        
        var transform = CGAffineTransform.identity
        var transform2 = CGAffineTransform.identity
        switch directin {
        case .original:
            transform = CGAffineTransform.identity
        case .left:
            transform = CGAffineTransform.identity.rotated(by: .pi / -2.0)
            transform2 = transform.scaledBy(x: 0.8, y: 0.8)
        case .right:
            transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)
            transform2 = transform.scaledBy(x: 0.8, y: 0.8)
        case .down:
            transform = CGAffineTransform.identity.rotated(by: .pi)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.heartImageView.transform = transform2
            self.heartHHLabel.transform = transform
            self.heartMmLabel.transform = transform
            self.heartSsLabel.transform = transform
        }
    }
}
