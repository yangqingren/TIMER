//
//  TMPageMenuView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/25.
//

import UIKit

protocol TMPageMenuViewDelegate {
    func pageMenuRoundViewCick(_ item: TMMainVcItem, _ navigation : UIPageViewController.NavigationDirection)
}

class TMPageMenuView: UIView {
    
    var delegate: TMPageMenuViewDelegate?
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.init(r: 200, g: 200, b: 200, a: 1).cgColor, UIColor.init(r: 223, g: 223, b: 223, a: 1).cgColor, UIColor.init(r: 230, g: 230, b: 230, a: 1).cgColor]
        layer.locations = [0.0, 0.2, 1.0]
        layer.startPoint = CGPoint(x: 0.15, y: 0)
        layer.endPoint = CGPoint(x: 0.85, y: 1)
        layer.frame = CGRect(x: -5.dp, y: 0, width: TMPageMenuView.viewSize().width + 5.dp * 2, height: TMPageMenuView.viewSize().height)
        return layer
    }()

    lazy var items = [TMPageRoundView]()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.layer.addSublayer(self.gradientLayer)
        self.gradientLayer.cornerRadius = TMPageMenuView.viewSize().height / 2.0
        self.gradientLayer.borderColor = UIColor.white.cgColor
        self.gradientLayer.borderWidth = 2.dp
        self.gradientLayer.shadowColor = UIColor.init(r: 225, g: 230, b: 234, a: 1).cgColor
        self.gradientLayer.shadowOffset = CGSize(width: 0, height: 0)
        self.gradientLayer.shadowOpacity = 1.0
        self.gradientLayer.shadowRadius = 2.dp
        
        let itemW = TMPageMenuView.viewSize().width / 6.0
        let itemH = TMPageMenuView.viewSize().height
        for (index, item) in TMMainViewController.getDataArray().enumerated() {
            let item = TMPageRoundView(frame: .zero, item: item)
            self.contentView.addSubview(item)
            item.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: itemW, height: itemH))
                make.centerY.equalToSuperview()
                make.left.equalTo(self.snp.left).offset(itemW * CGFloat(index))
            }
            item.addTarget(self, action: #selector(roundViewCick(_:)), for: .touchUpInside)
            self.items.append(item)
        }
        
    }
    
    var item: TMMainVcItem?
    
    @objc func roundViewCick(_ sender: TMPageRoundView) {
        if sender.item.type == .bw, let currItem = self.item {
            if currItem.subType == .black {
                sender.item.subType = .white
            }
            else {
                sender.item.subType = .black
            }
        }
        self.setupType(sender.item)
    }
    
    func setupType(_ item: TMMainVcItem) {
        let navigation: UIPageViewController.NavigationDirection = self.item?.type.rawValue ?? 0 > item.type.rawValue ? .reverse : .forward
        for obj in self.items {
            if item.type == .bw && obj.item.type == .bw {
                if item.subType == .black {
                    obj.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0 + .pi)
                }
                else {
                    obj.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0)
                }
            }
            if obj.item.type == item.type {
                obj.isSelected = true
            }
            else {
                obj.isSelected = false
            }
        }
        if item.type == .bw {
            UserDefaults.standard.set(item.subType?.rawValue ?? 0, forKey: kTMBwVcThemeColor)
        }
        UserDefaults.standard.set(item.type.rawValue, forKey: kUserDefaultsVcType)
        self.item = item
        self.delegate?.pageMenuRoundViewCick(item, navigation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        let height = 35.dp
        return CGSize(width: height * 0.875 * 6 , height: height)
    }
    
}

class TMPageRoundView: UIButton {
    
    var item: TMMainVcItem
    
    lazy var round: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var bwRound: TMPageBWRoundView = {
        let view = TMPageBWRoundView()
        return view
    }()
        
    lazy var selectRound: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.init(r: 51, g: 51, b: 51, a: 1)
        return view
    }()
    
    init(frame: CGRect, item: TMMainVcItem) {
        self.item = item
        super.init(frame: frame)
            
        self.addSubview(self.selectRound)
        self.selectRound.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25.dp, height: 25.dp))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.selectRound.layer.cornerRadius = 25.dp / 2.0
        self.selectRound.layer.masksToBounds = true
        
        self.addSubview(self.round)
        self.round.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 18.dp, height: 18.dp))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.round.layer.cornerRadius = 18.dp / 2.0
        self.round.layer.shadowOffset = CGSize(width: 1.dp, height: 1.dp)
        self.round.layer.shadowColor = UIColor.lightGray.cgColor
        self.round.layer.shadowOpacity = 1.0
        self.round.layer.shadowRadius = 1.dp
        
        self.round.addSubview(self.bwRound)
        self.bwRound.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.bwRound.layer.cornerRadius = 18.dp / 2.0
        self.bwRound.layer.masksToBounds = true
        
        switch self.item.type {
        case .bw:
            self.round.backgroundColor = UIColor.init(r: 242, g: 242, b: 242, a: 0)
            self.bwRound.isHidden = false
            let subType = TMBwVcTheme.init(rawValue: UserDefaults.standard.integer(forKey: kTMBwVcThemeColor)) ?? .white
            if subType == .black {
                self.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0 + .pi)
            }
            else {
                self.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0)
            }
        case .shadow:
            self.round.backgroundColor = UIColor.init(r: 116, g: 188, b: 136, a: 1)
            self.bwRound.isHidden = true
        case .block:
            self.round.backgroundColor = UIColor.systemBlue
            self.bwRound.isHidden = true
        case .clock:
            self.round.backgroundColor = UIColor.init(r: 231, g: 215, b: 207, a: 1)
            self.bwRound.isHidden = true
        case .electron:
            self.round.backgroundColor = UIColor.init(r: 186, g: 186, b: 186, a: 1)
            self.bwRound.isHidden = true
        case .neon:
            self.round.backgroundColor = .black
            self.bwRound.isHidden = true
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.selectRound.backgroundColor = UIColor.init(r: 58, g: 58, b: 58, a: 1)
                self.round.layer.masksToBounds = true
            }
            else {
                self.selectRound.backgroundColor = UIColor.init(r: 234, g: 240, b: 246, a: 1)
                self.round.layer.masksToBounds = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TMPageBWRoundView: UIView {
    
    lazy var round1: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.init(r: 242, g: 242, b: 242, a: 1)
        return view
    }()
    
    lazy var round2: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.round1)
        self.round1.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(self.round2)
        self.round2.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
