//
//  TMShadowClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/24.
//

import UIKit

class TMShadowClockViewController: TMBasePageViewController {

    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "shadow_bg_nomal")
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1)
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = TMNeonBlue
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TIIMII, expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
        return label
    }()
    
    lazy var topDateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var topDateLabel2: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var shadowHHView: TMShadowBaseView = {
        let format = Date.getHhFormatter()
        let view = TMShadowBaseView(frame: .zero, format: format)
        view.setupFormatLabel(TMLocalizedString("时"))
        return view
    }()
    
    lazy var shadowMmView: TMShadowBaseView = {
        let view = TMShadowBaseView(frame: .zero, format: "mm")
        view.setupFormatLabel(TMLocalizedString("分"))
        return view
    }()
    
    lazy var shadowSsView: TMShadowBaseView = {
        let view = TMShadowBaseView(frame: .zero, format: "ss")
        view.setupFormatLabel(TMLocalizedString("秒"))
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.vcType == .main {
            TMDelegateManager.share.shadow = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.vcType == .main {
            TMDelegateManager.share.shadow = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(r: 78, g: 122, b: 198, a: 1)
        
        self.view.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: LEGOScreenWidth, height: LEGOScreenWidth / 1170.0 * 2532))
        }
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(44.dp)
            make.centerY.equalTo(self.view.snp.centerY).offset(-316.dp)
        }
        
        self.view.addSubview(self.topDateLabel)
        self.topDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.shadowLabel.snp.centerY)
        }
        
        self.view.insertSubview(self.topDateLabel2, belowSubview: self.topDateLabel)
        self.topDateLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(1.dp)
            make.centerY.equalTo(self.shadowLabel.snp.centerY)
        }
        
        self.view.addSubview(self.shadowMmView)
        self.shadowMmView.snp.makeConstraints { make in
            make.size.equalTo(TMShadowBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(self.shadowHHView)
        self.shadowHHView.snp.makeConstraints { make in
            make.size.equalTo(TMShadowBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.shadowMmView.snp.top).offset(-35.dp)
        }
        
        self.view.addSubview(self.shadowSsView)
        self.shadowSsView.snp.makeConstraints { make in
            make.size.equalTo(TMShadowBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.shadowMmView.snp.bottom).offset(35.dp)
        }
        
        self.timeUpdates()
        
        // Do any additional setup after loading the view.
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        let text = Date().getDateStringEn(format: "MM dd EEEE")
        self.topDateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3)
        self.topDateLabel2.attributedText = String.getExpansionString(text: text, expansion: 0.3)
    }

    override func motionUpdates(directin: TMMontionDirection) {
        super.motionUpdates(directin: directin)
        
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
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            self.shadowHHView.transform = transform
            self.shadowMmView.transform = transform
            self.shadowSsView.transform = transform
        }
    }
    
    override func setupSystemTimeChanged() {
        super.setupSystemTimeChanged()
        
        let format = Date.getHhFormatter()
        self.shadowHHView.format = format
        self.shadowHHView.timeUpdates()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
