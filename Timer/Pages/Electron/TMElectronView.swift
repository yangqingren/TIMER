//
//  TMElectronView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

let kTMElectronAlpha = 0.025

class TMElectronView: TMBaseView {
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "electron_bg_nomal")
        return view
    }()
    
    lazy var electronHHView: TMElectronBaseView = {
        let view = TMElectronBaseView()
        return view
    }()
    
    lazy var electronMmView: TMElectronBaseView = {
        let view = TMElectronBaseView()
        return view
    }()
    
    lazy var electronSsView: TMElectronBaseView = {
        let view = TMElectronBaseView()
        return view
    }()
    
    lazy var dian1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
        return view
    }()
    
    lazy var dian2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
        return view
    }()
    
    lazy var dian3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
        return view
    }()
    
    lazy var dian4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
        return view
    }()

    let vcType: TMMainVcType
    
    init(frame: CGRect, vcType: TMMainVcType) {
        self.vcType = vcType
        super.init(frame: frame)
        
        self.layer.shadowOffset = CGSize(width: 30.dp, height: 30.dp)
        self.layer.shadowColor = UIColor.init(r: 215, g: 225, b: 235, a: 1).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 30.dp
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.electronMmView)
        self.electronMmView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(TMElectronBaseView.viewSize())
        }
        
        let spacing = 0.dp
        
        self.addSubview(self.electronHHView)
        self.electronHHView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.electronMmView.snp.top).offset(-spacing)
            make.size.equalTo(TMElectronBaseView.viewSize())
        }
        
        self.addSubview(self.electronSsView)
        self.electronSsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.electronMmView.snp.bottom).offset(spacing)
            make.size.equalTo(TMElectronBaseView.viewSize())
        }
        
        let width = 13.dp
        let spcaing = 13.dp
        self.addSubview(self.dian1)
        self.dian1.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.right.equalTo(self.snp.centerX).offset(-spcaing)
            make.centerY.equalTo(self.electronMmView.snp.top).offset(abs(spacing) / 2.0)
        }
        self.addSubview(self.dian2)
        self.dian2.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.left.equalTo(self.snp.centerX).offset(spcaing)
            make.centerY.equalTo(self.electronMmView.snp.top).offset(abs(spacing) / 2.0)
        }

        self.addSubview(self.dian3)
        self.dian3.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.right.equalTo(self.snp.centerX).offset(-spcaing)
            make.centerY.equalTo(self.electronMmView.snp.bottom).offset(-abs(spacing) / 2.0)
        }
        self.addSubview(self.dian4)
        self.dian4.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.left.equalTo(self.snp.centerX).offset(spcaing)
            make.centerY.equalTo(self.electronMmView.snp.bottom).offset(-abs(spacing) / 2.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        let width = LEGOScreenWidth * 0.8
        return CGSize(width: width, height: width / 768.0 * 1408.0)
    }
    
    var format = Date.getHhFormatter()
    
    var flag: Int = 0
    var ss = ""
    override func timeUpdates() {
        super.timeUpdates()
        
        self.electronHHView.setupText(Date().getDateStringEn(format: self.format))
        self.electronMmView.setupText(Date().getDateStringEn(format: "mm"))
        let ss = Date().getDateStringEn(format: "ss")
        self.electronSsView.setupText(ss)
        if self.ss != ss {
            self.ss = ss
            if self.vcType == .main {
                TMSoundManager.playSound("slim")
            }
        }
        
        self.flag += 1
        
        if self.flag % 2 == 0 && self.flag >= 2 * 2 {
            self.dian1.alpha = kTMElectronAlpha
            self.dian2.alpha = kTMElectronAlpha
            self.dian3.alpha = kTMElectronAlpha
            self.dian4.alpha = kTMElectronAlpha
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dian1.alpha = 1
                self.dian2.alpha = 1
                self.dian3.alpha = 1
                self.dian4.alpha = 1
            }
        }
        else {
            self.dian1.alpha = 1
            self.dian2.alpha = 1
            self.dian3.alpha = 1
            self.dian4.alpha = 1
        }
        

    }
    
    override func motionUpdates(directin: TMMontionDirection) {
        super.motionUpdates(directin: directin)
        
        var transform = CGAffineTransform.identity
        var transform2 = CGAffineTransform.identity
        switch directin {
        case .original:
            transform = transform.scaledBy(x: 1, y: 1)
            transform2 = transform.translatedBy(x: 3.dp, y: 0)
        case .left:
            transform = transform.scaledBy(x: 0.8, y:0.8)
            transform2 = transform.rotated(by: .pi / -2.0)
        case .right:
            transform = transform.scaledBy(x: 0.8, y: 0.8)
            transform2 = transform.rotated(by: .pi / 2.0)
        case .down:
            transform = transform.scaledBy(x: 1, y: 1)
            transform = transform.rotated(by: .pi)
            transform2 = transform.translatedBy(x: 3.dp, y: 0)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.electronHHView.transform = transform2
            self.electronMmView.transform = transform2
            self.electronSsView.transform = transform2
            self.dian1.transform = transform
            self.dian2.transform = transform
            self.dian3.transform = transform
            self.dian4.transform = transform
        }
    }

}

private let kSpecaing = 1.5.dp

class TMElectronBaseView: UIView {
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.font = .init(name: "DS-Digital-Bold", size: 135.sp)
        label.textColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
        return label
    }()
        
    lazy var label2: UILabel = {
        let label = UILabel()
        label.font = .init(name: "DS-Digital-Bold", size: 135.sp)
        label.textColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.font = .init(name: "DS-Digital-Bold", size: 135.sp)
        label.textColor = UIColor.init(r: 26, g: 26, b: 26, a: kTMElectronAlpha)
        label.text = "8"
        return label
    }()
        
    lazy var label4: UILabel = {
        let label = UILabel()
        label.font = .init(name: "DS-Digital-Bold", size: 135.sp)
        label.textColor = UIColor.init(r: 26, g: 26, b: 26, a: kTMElectronAlpha)
        label.text = "8"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.label1)
        self.label1.snp.makeConstraints { make in
            make.right.equalTo(self.snp.centerX).offset(-kSpecaing)
            make.left.top.bottom.equalToSuperview()
        }
        
        self.addSubview(self.label2)
        self.label2.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(kSpecaing)
            make.right.top.bottom.equalToSuperview()
        }
        
        self.insertSubview(self.label3, belowSubview: self.label1)
        self.label3.snp.makeConstraints { make in
            make.edges.equalTo(self.label1)
        }
        
        self.insertSubview(self.label4, belowSubview: self.label2)
        self.label4.snp.makeConstraints { make in
            make.edges.equalTo(self.label2)
        }
    }
    
    func setupText(_ text: String) {
        let text1 = String(text.prefix(1))
        if text1 == "1" {
            self.label1.textAlignment = .right
        }
        else {
            self.label1.textAlignment = .left
        }
        let text2 = String(text.suffix(1))
        if text2 == "1" {
            self.label2.textAlignment = .right
        }
        else {
            self.label2.textAlignment = .left
        }
        self.label1.text = text1
        self.label2.text = text2
    }
    
    static func viewSize() -> CGSize {
        let width = LEGOScreenWidth * 0.2 * 2.0 + kSpecaing * 2.0
        return CGSize(width: width, height: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
