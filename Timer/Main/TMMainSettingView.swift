//
//  TMMainSettingView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

enum TMSettingType: String {
    case lock = "lock"
    case systemTime = "systemTime"
    case sound = "sound"
    case impact = "impact"
    case horizontal = "horizontal"
}

class TMMainSettingItem: NSObject {
    let type: TMSettingType
    var isOpen: Bool {
        didSet {
            UserDefaults.standard.set(isOpen, forKey: "\(kTMMainSettingPrefix)\(type.rawValue)")
            if type == .systemTime {
                NotificationCenter.default.post(name: NSNotification.Name.kNotifiSystemTimeChanged, object: nil)
            }
        }
    }
    
    init(type: TMSettingType, isOpen: Bool) {
        self.type = type
        self.isOpen = isOpen
    }
}

private let kTMMainSettingInited = "kTMMainSettingInited"
private let kTMMainSettingPrefix = "kTMMainSettingPrefix_"

class TMMainSettingManager: NSObject {
    
    static let share = TMMainSettingManager()
        
    var array: [TMMainSettingItem] = {
        let types: [TMSettingType] = [
            .lock,
            .systemTime,
            .horizontal,
            .sound,
            .impact
        ]
        
        let inited = UserDefaults.standard.bool(forKey: kTMMainSettingInited)
        if !inited {
            UserDefaults.standard.set(true, forKey: kTMMainSettingInited)
            UserDefaults.standard.set(true, forKey: "\(kTMMainSettingPrefix)\(TMSettingType.lock.rawValue)")
            UserDefaults.standard.set(false, forKey: "\(kTMMainSettingPrefix)\(TMSettingType.systemTime.rawValue)")
            let horizontal = TMMontionManager.share.autoHV == .H
            UserDefaults.standard.set(horizontal, forKey: "\(kTMMainSettingPrefix)\(TMSettingType.horizontal.rawValue)")
            UserDefaults.standard.set(true, forKey: "\(kTMMainSettingPrefix)\(TMSettingType.sound.rawValue)")
            UserDefaults.standard.set(true, forKey: "\(kTMMainSettingPrefix)\(TMSettingType.impact.rawValue)")
        }
        
        var list = [TMMainSettingItem]()
        for type in types {
            let isOpen = UserDefaults.standard.bool(forKey: "\(kTMMainSettingPrefix)\(type.rawValue)")
            list.append(TMMainSettingItem.init(type: type, isOpen: isOpen))
        }
        return list
    }()
    
    override init() {
        super.init()

    }
    
    static func getOpenStatus(_ type: TMSettingType) -> Bool {
        var item: TMMainSettingItem?
        for obj in TMMainSettingManager.share.array {
            if obj.type == type {
                item = obj
                break
            }
        }
        return item?.isOpen ?? false
    }
    
    static func setOpenStatus(_ open: Bool, _ type: TMSettingType) {
        var item: TMMainSettingItem?
        for obj in TMMainSettingManager.share.array {
            if obj.type == type {
                item = obj
                break
            }
        }
        item?.isOpen = open
    }
    
}

class TMMainSettingContentView: UIView {
    
    @objc func switchButtonChanged(_ sender: UISwitch) {
        if sender.isEqual(self.lockSwitch) {
            TMMainSettingManager.setOpenStatus(sender.isOn, .lock)
        }
        else if sender.isEqual(self.systemTimeSwitch) {
            TMMainSettingManager.setOpenStatus(sender.isOn, .systemTime)
        }
        else if sender.isEqual(self.soundSwitch) {
            TMMainSettingManager.setOpenStatus(sender.isOn, .sound)
        }
        else if sender.isEqual(self.impactSwitch) {
            TMMainSettingManager.setOpenStatus(sender.isOn, .impact)
        }
        else if sender.isEqual(self.horizontalSwitch) {
            TMMainSettingManager.setOpenStatus(sender.isOn, .horizontal)
            if sender.isOn {
                TMMontionManager.share.autoHV = .H
            }
            else {
                TMMontionManager.share.autoHV = .auto
            }
            NotificationCenter.default.post(name: NSNotification.Name.kNotifiSettingChanged, object: nil)
        }
    }
    
    @objc func entryButtonClick(_ sender: UIButton) {
        if sender.isEqual(self.homeButton) {
            let url = URL(string: "https://support.apple.com/guide/iphone/iphb8f1bf206/ios")
            if let url = url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TMLocalizedString("通用")
        label.textColor = UIColor.init(r: 10, g: 10, b: 10, a: 10)
        label.font = .systemFont(ofSize: 17.sp, weight: .medium)
        return label
    }()

    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.init(r: 10, g: 10, b: 10, a: 10)
        label.font = IsChinese ? .systemFont(ofSize: 17.sp, weight: .regular) : .systemFont(ofSize: 15.sp, weight: .medium)
        return label
    }
    
    func createSwitchButton() -> UISwitch {
        let switchButton = UISwitch()
        switchButton.onTintColor = UIColor.init(r: 42, g: 95, b: 215, a: 0.7)
        switchButton.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        switchButton.layer.borderColor = UIColor.white.cgColor
        switchButton.layer.borderWidth = 1
        switchButton.layer.cornerRadius = 30.dp / 2.0
        switchButton.addTarget(self, action: #selector(switchButtonChanged(_:)), for: .valueChanged)
        return switchButton
    }
    
    lazy var lockLabel: UILabel = {
        let label = self.createTitleLabel()
        label.text = TMLocalizedString("锁屏小组件")
        return label
    }()
    lazy var lockSwitch: UISwitch = {
        let switchButton = self.createSwitchButton()
        switchButton.isOn = TMMainSettingManager.getOpenStatus(.lock)
        return switchButton
    }()
    
    lazy var systemTimeLabel: UILabel = {
        let label = self.createTitleLabel()
        label.text = TMLocalizedString("12小时制")
        return label
    }()
    lazy var systemTimeSwitch: UISwitch = {
        let switchButton = self.createSwitchButton()
        switchButton.isOn = TMMainSettingManager.getOpenStatus(.systemTime)
        return switchButton
    }()
    
    lazy var homeLabel: UILabel = {
        let label = self.createTitleLabel()
        label.text = TMLocalizedString("桌面小组件")
        return label
    }()
    lazy var homeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: "setting_home_nomal"), for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(entryButtonClick(_:)), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var horizontalLabel: UILabel = {
        let label = self.createTitleLabel()
        label.text = TMLocalizedString("固定横屏")
        return label
    }()
    lazy var horizontalSwitch: UISwitch = {
        let switchButton = self.createSwitchButton()
        switchButton.isOn = TMMainSettingManager.getOpenStatus(.horizontal)
        return switchButton
    }()
    
    lazy var soundLabel: UILabel = {
        let label = self.createTitleLabel()
        label.text = TMLocalizedString("声音反馈")
        return label
    }()
    lazy var soundSwitch: UISwitch = {
        let switchButton = self.createSwitchButton()
        switchButton.isOn = TMMainSettingManager.getOpenStatus(.sound)
        return switchButton
    }()
    
    lazy var impactLabel: UILabel = {
        let label = self.createTitleLabel()
        label.text = TMLocalizedString("震动反馈")
        return label
    }()
    lazy var impactSwitch: UISwitch = {
        let switchButton = self.createSwitchButton()
        switchButton.isOn = TMMainSettingManager.getOpenStatus(.impact)
        return switchButton
    }()
    
    lazy var TiiMiiPorLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.init(r: 222, g: 228, b: 234, a: 1)
        label.textAlignment = .center
        label.isHidden = true
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 215, g: 225, b: 235, a: 1)
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: "TiiMii Pro", expansion: 0.0, others: [    NSAttributedString.Key.shadow: shadow])

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 207, g: 216, b: 227, a: 0.5)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius  = 20.dp
        self.layer.masksToBounds = true
        
        //        let maskPath = UIBezierPath(roundedRect: self.contentView.bounds, byRoundingCorners: [.topRight, .bottomRight, .topLeft], cornerRadii: CGSize(width: 20.dp, height: 20.dp))
        //        let maskLayer = CAShapeLayer()
        //        maskLayer.frame = self.contentView.bounds
        //        maskLayer.path = maskPath.cgPath
        //        self.contentView.layer.mask = maskLayer
                
        self.addSubview(self.blurView)
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let left = 20.dp
        let right = IsChinese ? 18.dp : 15.dp
        let size = CGSize(width: 50.dp, height: 30.dp)
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalToSuperview().offset(25.dp)
        }
        
        self.addSubview(self.TiiMiiPorLabel)
        self.TiiMiiPorLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-left)
            make.centerY.equalTo(self.titleLabel)
        }
        
        let top = 22.dp
        self.addSubview(self.lockLabel)
        self.lockLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(top)
        }
        self.addSubview(self.lockSwitch)
        self.lockSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-right)
            make.size.equalTo(size)
            make.centerY.equalTo(self.lockLabel)
        }
                
        self.addSubview(self.systemTimeLabel)
        self.systemTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.lockLabel.snp.bottom).offset(top)
        }
        self.addSubview(self.systemTimeSwitch)
        self.systemTimeSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-right)
            make.size.equalTo(size)
            make.centerY.equalTo(self.systemTimeLabel)
        }
        
        self.addSubview(self.homeLabel)
        self.homeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.systemTimeLabel.snp.bottom).offset(top)
        }
        self.addSubview(self.homeButton)
        self.homeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-right)
            make.size.equalTo(size)
            make.centerY.equalTo(self.homeLabel)
        }
        
        self.addSubview(self.horizontalLabel)
        self.horizontalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.homeLabel.snp.bottom).offset(top)
        }
        self.addSubview(self.horizontalSwitch)
        self.horizontalSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-right)
            make.size.equalTo(size)
            make.centerY.equalTo(self.horizontalLabel)
        }
        
        self.addSubview(self.soundLabel)
        self.soundLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.horizontalLabel.snp.bottom).offset(top)
        }
        self.addSubview(self.soundSwitch)
        self.soundSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-right)
            make.size.equalTo(size)
            make.centerY.equalTo(self.soundLabel)
        }
        
        self.addSubview(self.impactLabel)
        self.impactLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.soundLabel.snp.bottom).offset(top)
        }
        self.addSubview(self.impactSwitch)
        self.impactSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-right)
            make.size.equalTo(size)
            make.centerY.equalTo(self.impactLabel)
        }
        
        self.setupTiiMiiPro()
    }
    
    func setupTiiMiiPro() {
        if TMStoreManager.share.isPro {
            self.TiiMiiPorLabel.isHidden = false
        }
        else {
            self.TiiMiiPorLabel.isHidden = true
        }
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: 232.dp, height: 330.dp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TMMainSettingView: UIView {

    var closure: (() -> Void)?
    
    static func show(inView: UIView, originalRect: CGRect, closure: @escaping (() -> Void)) -> TMMainSettingView {
        let view = TMMainSettingView.init(frame: .zero, inView: inView, originalRect: originalRect)
        view.closure = closure
        view.show()
        return view
    }
    
    lazy var coverView: UIControl = {
        let view = UIControl()
        view.backgroundColor = .black.withAlphaComponent(0)
        view.addTarget(self, action: #selector(coverViewClick), for: .touchUpInside)
        return view
    }()
    
    @objc func coverViewClick() {
        self.dismiss()
    }
            
    lazy var contentView: TMMainSettingContentView = {
        let view = TMMainSettingContentView()
        return view
    }()
        
    let inView: UIView
    let originalRect: CGRect
    
    init(frame: CGRect, inView: UIView, originalRect: CGRect) {
        self.inView = inView
        self.originalRect = originalRect
        super.init(frame: frame)
        
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
        
        self.addSubview(self.contentView)
        let contentSize = TMMainSettingContentView.viewSize()
        self.contentView.frame = CGRect(x: self.originalRect.maxX, y: self.originalRect.minY - contentSize.height, width: contentSize.width, height: contentSize.height)
        
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
        self.coverView.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.contentView.transform = CGAffineTransform.identity
            self.contentView.alpha = 1
            self.coverView.alpha = 1
        }
    }
    
    func dismiss() {
        self.contentView.transform = CGAffineTransform.identity
        self.contentView.alpha = 1
        self.coverView.alpha = 1
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.contentView.alpha = 0
            self.coverView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            self.closure?()
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
