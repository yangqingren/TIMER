//
//  TMBlockClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/23.
//

import UIKit

let kBlockClockBlue = UIColor.init(r: 87, g: 144, b: 232, a: 1)

class TMBlockClockViewController: TMBasePageViewController {

    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 0.5)
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TIIMII, expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
        return label
    }()
    
    lazy var topDateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var topDateLabel2: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentView: TMBlockClockView = {
        let view = TMBlockClockView()
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "block_bg_nomal")
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var topGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: LEGOScreenWidth, height: 40.dp))
        view.isUserInteractionEnabled = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kBlockClockBlue.cgColor,
                                kBlockClockBlue.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    lazy var leftGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15.dp, height: LEGOScreenHeight))
        view.isUserInteractionEnabled = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kBlockClockBlue.cgColor,
                                kBlockClockBlue.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    lazy var rightGradientView: UIView = {
        let view = UIView(frame: CGRect(x: LEGOScreenWidth - 15.dp, y: 0, width: 15.dp, height: LEGOScreenHeight))
        view.isUserInteractionEnabled = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kBlockClockBlue.withAlphaComponent(0).cgColor,
                                kBlockClockBlue.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    lazy var bottomGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: LEGOScreenHeight - 40.dp, width: LEGOScreenWidth, height: 40.dp))
        view.isUserInteractionEnabled = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kBlockClockBlue.withAlphaComponent(0).cgColor,
                                kBlockClockBlue.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.vcType == .main {
            TMDelegateManager.share.blcok = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.vcType == .main {
            TMDelegateManager.share.blcok = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        self.view.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: LEGOScreenWidth, height: LEGOScreenWidth / 1170.0 * 2532))
        }
        
        self.view.addSubview(self.topDateLabel)
        self.topDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.insertSubview(self.topDateLabel2, belowSubview: self.topDateLabel)
        self.topDateLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(1.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.addSubview(self.topGradientView)
        self.view.addSubview(self.leftGradientView)
        self.view.addSubview(self.rightGradientView)
        self.view.addSubview(self.bottomGradientView)
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.contentView.timeHHView.transform = transform
            self.contentView.timeMmView.transform = transform
            self.contentView.timeSsView.transform = transform
        }
    }
}




