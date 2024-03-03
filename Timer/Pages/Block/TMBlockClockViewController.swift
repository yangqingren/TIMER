//
//  TMBlockClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/23.
//

import UIKit

let kBlockClockBlue = UIColor.init(r: 86, g: 144, b: 232, a: 1)
let kBlockScale = 0.85
let kBlockBgSize = CGSize(width: LEGOScreenWidth * kBlockScale, height: LEGOScreenWidth * kBlockScale / 1170.0 * 2488.0)
let kGradientTop = 100.dp
let kGradientLeft = kGradientTop / LEGOScreenHeight * LEGOScreenWidth

class TMBlockClockViewController: TMBasePageViewController {

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
        let view = TMBlockClockView(frame: .zero, vcType: self.vcType)
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "block_bg_nomal")
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var topGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kBlockBgSize.width, height: kGradientTop))
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kGradientLeft, height: kBlockBgSize.height))
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
        let view = UIView(frame: CGRect(x: kBlockBgSize.width - kGradientLeft, y: 0, width: kGradientLeft, height: kBlockBgSize.height))
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
        let view = UIView(frame: CGRect(x: 0, y: kBlockBgSize.height - kGradientTop, width: kBlockBgSize.width, height: kGradientTop))
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kBlockClockBlue
                
        self.view.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(kBlockBgSize)
        }
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
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
        
        self.bgView.addSubview(self.topGradientView)
        self.bgView.addSubview(self.leftGradientView)
        self.bgView.addSubview(self.rightGradientView)
        self.bgView.addSubview(self.bottomGradientView)
                
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.setupUnlockBanner()

        // Do any additional setup after loading the view.
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        let text = Date().getDateStringEn(format: "MM dd EEEE")
        self.topDateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3)
        self.topDateLabel2.attributedText = String.getExpansionString(text: text, expansion: 0.3)
    }
}




