//
//  TMElectronView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

class TMElectronView: TMBaseView {
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "electron_bg_nomal")
        return view
    }()
    
    lazy var electronHHLabel: TMElectronBaseLabel = {
        let label = TMElectronBaseLabel()
        return label
    }()
    
    lazy var electronMmLabel: TMElectronBaseLabel = {
        let label = TMElectronBaseLabel()
        return label
    }()
    
    lazy var electronSsLabel: TMElectronBaseLabel = {
        let label = TMElectronBaseLabel()
        return label
    }()
    
    lazy var dian1Label: TMElectronBaseLabel = {
        let label = TMElectronBaseLabel()
        label.text = ":"
        return label
    }()
    
    lazy var dian2Label: TMElectronBaseLabel = {
        let label = TMElectronBaseLabel()
        label.text = ":"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowOffset = CGSize(width: 30.dp, height: 30.dp)
        self.layer.shadowColor = UIColor.init(r: 215, g: 225, b: 235, a: 1).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 30.dp
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.electronMmLabel)
        self.electronMmLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let spacing = 30.dp
        
        self.addSubview(self.electronHHLabel)
        self.electronHHLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.electronMmLabel.snp.top).offset(-spacing)
        }
        
        self.addSubview(self.electronSsLabel)
        self.electronSsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.electronMmLabel.snp.bottom).offset(spacing)
        }
        
        self.addSubview(self.dian1Label)
        self.dian1Label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.electronMmLabel.snp.top).offset(-spacing / 2.0)
        }
        self.addSubview(self.dian2Label)
        self.dian2Label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.electronMmLabel.snp.bottom).offset(spacing / 2.0)
        }
        self.dian1Label.transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)
        self.dian2Label.transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        let width = LEGOScreenWidth * 0.8
        return CGSize(width: width, height: width / 768.0 * 1408.0)
    }
    
    var flag: Int = 0
    override func timeUpdates() {
        super.timeUpdates()
        
        self.electronHHLabel.text = Date().getDateStringEn(format: "HH")
        self.electronMmLabel.text = Date().getDateStringEn(format: "mm")
        self.electronSsLabel.text = Date().getDateStringEn(format: "ss")
        
        self.flag += 1
        if self.flag % 2 == 0 {
            self.dian1Label.isHidden = true
            self.dian2Label.isHidden = true
        }
        else {
            self.dian1Label.isHidden = false
            self.dian2Label.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dian1Label.isHidden = true
                self.dian2Label.isHidden = true
            }
        }
    }

}


class TMElectronBaseLabel: UILabel {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .init(name: "DS-Digital-Bold", size: 135.sp)
        self.textColor = UIColor.init(r: 26, g: 26, b: 26, a: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
