//
//  TMBgMusicButton.swift
//  Timer
//
//  Created by yangqingren on 2024/3/13.
//

import UIKit

class TMBgMusicButton: UIControl {
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mian_button_emtry")
        return view
    }()
    
    lazy var musicView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "main_music_nomal")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.musicView)
        self.musicView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
            make.centerX.equalToSuperview().offset(1.dp)
            make.centerY.equalToSuperview().offset(1.dp)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        self.stopAnimation()
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 8
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.musicView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimation() {
        self.musicView.layer.removeAllAnimations()
    }
    
}
