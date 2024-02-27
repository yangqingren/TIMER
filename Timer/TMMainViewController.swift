//
//  TMMainViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

extension NSNotification.Name {
    static let kNotifiBackgroundColor = NSNotification.Name(rawValue: "kNotifiBackgroundColor")
    static let kNotifiMainBrightness = NSNotification.Name(rawValue: "kNotifiMainBrightness")
    static let kNotifiVcThemeChanged = NSNotification.Name(rawValue: "kNotifiVcThemeChanged")

}

let kNotifiBackgroundColor = "kNotifiBackgroundColor"
let kUserDefaultsVcType = "kUserDefaultsVcType"
let kTMBwVcThemeColor = "kTMBwVcThemeColor"

enum TMMainVcType {
    case main
    case bottom
}

class TMMainViewController: TMBaseViewController {

    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.dataSource = self
        vc.delegate = self
        vc.view.layer.masksToBounds = true
        return vc
    }()
    
    lazy var pages: [TMBasePageViewController] = {
        var array = [TMBasePageViewController]()
        for item in TMMainViewController.getDataArray() {
            let vc = TMMainViewController.getPageVc(item)
            array.append(vc)
        }
        return array
    }()
    
    static func getDataArray(_ vcType: TMMainVcType = .main) -> [TMMainVcItem] {
        var array = [
            TMMainVcItem.init(type: .electron),
            TMMainVcItem.init(type: .shadow),
            TMMainVcItem.init(type: .block),
            TMMainVcItem.init(type: .clock),
            TMMainVcItem.init(type: .neon)
        ]
        if vcType == .bottom {
            array.insert(TMMainVcItem.init(type: .bw, .black), at: 0)
            array.insert(TMMainVcItem.init(type: .bw, .white), at: 0)
        }
        else {
            array.insert(TMMainVcItem.init(type: .bw), at: 0)
        }
        return array
    }
    
    static func getPageVc(_ item: TMMainVcItem, _ vcType: TMMainVcType = .main) -> TMBasePageViewController {
        switch item.type {
        case .bw:
            return TMBWClockViewController(item, vcType)
        case .electron:
            return TMElectronViewController(item, vcType)
        case .shadow:
            return TMShadowClockViewController(item, vcType)
        case .block:
            return TMBlockClockViewController(item, vcType)
        case .clock:
            return TMClockClockViewController(item, vcType)
        case .neon:
            return TMNeonClockViewController(item, vcType)
        }
    }
    
    lazy var menuView: TMPageMenuView = {
        let view = TMPageMenuView()
        view.delegate = self
        return view
    }()
    
    lazy var bottomView: TMMainBottomView = {
        let view = TMMainBottomView()
        view.didSelect = {[weak self] item in
            guard let `self` = self else { return }
            self.menuView.setupType(item)
        }
        return view
    }()
    
    var location = 0.0
    var offsetY = 0.0
    
    lazy var pan: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureRecognizer(_:)))
        return recognizer
    }()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TMDelegateManager.share.main = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TMDelegateManager.share.main = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 不息屏
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(TMMainBottomView.viewSize())
        }
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.pageViewController.view.addSubview(self.menuView)
        self.menuView.snp.makeConstraints { make in
            make.size.equalTo(TMPageMenuView.viewSize())
            make.bottom.equalToSuperview().offset(IsPhoneX ? -23.dp : -15.dp)
            make.right.equalToSuperview().offset(-25.dp)
        }
                
        let type = TMPageMenuType.init(rawValue: UserDefaults.standard.integer(forKey: kUserDefaultsVcType)) ?? .bw
        let subType = TMBwVcTheme.init(rawValue: UserDefaults.standard.integer(forKey: kTMBwVcThemeColor)) ?? .white
        self.menuView.setupType(TMMainVcItem.init(type: type, subType))
        
        TMMontionManager.share.startMotionUpdates()
        TMTimerRunManager.share.startTimeUpdates()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.current) { [weak self] (notification) in
            guard let `self` = self else { return }
            TMMontionManager.share.startMotionUpdates()
            TMTimerRunManager.share.startTimeUpdates()
            if let vc = self.pageViewController.viewControllers?.first, vc.isKind(of: TMNeonClockViewController.self) {
                self.setupMainBrightness(true)
            }
        }

        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.current) { [weak self] (notification) in
            guard let `self` = self else { return }
            self.setupMainBrightness(false)
            TMMontionManager.share.stopMotionUpdates()
            TMTimerRunManager.share.stopTimeUpdates()
        }


        NotificationCenter.default.addObserver(forName: NSNotification.Name.kNotifiBackgroundColor, object: nil, queue: .main) {[weak self] noti in
            guard let `self` = self else { return }
            if let color = noti.object as? UIColor {
                self.pageViewController.view.backgroundColor = color
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.kNotifiMainBrightness, object: nil, queue: .main) {[weak self] noti in
            guard let `self` = self else { return }
            if let brightness = noti.object as? Bool {
                self.setupMainBrightness(brightness)
            }
        }
        
        self.view.addGestureRecognizer(self.pan)
        
        // Do any additional setup after loading the view.
    }
    
    func setupMainBrightness(_ brightness: Bool) {
        if brightness {
            self.menuView.contentView.alpha = 0.65
            self.bottomView.alpha = 0.65
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIScreen.main.brightness = 1.0
            }
        }
        else {
            UIScreen.main.brightness = 0.5
            self.menuView.contentView.alpha = 1
            self.bottomView.alpha = 1
        }
    }
    
    override func motionUpdates(directin: TMMontionDirection) {
        super.motionUpdates(directin: directin)
        
    }
}

extension TMMainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? TMBasePageViewController, var index = self.pages.firstIndex(of: vc) else { return nil }
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return self.pages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? TMBasePageViewController, var index = self.pages.firstIndex(of: vc) else { return nil }
        if index == NSNotFound || index == (self.pages.count - 1) {
            return nil
        }
        index += 1
        return self.pages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first as? TMBasePageViewController, finished, completed {
            self.menuView.item = vc.item
        }
    }
}
 

extension TMMainViewController: TMPageMenuViewDelegate {

    func pageMenuRoundViewCick(_ item: TMMainVcItem, _ navigation: UIPageViewController.NavigationDirection) {
        var vc: TMBasePageViewController?
        for page in self.pages {
            if page.item.type == item.type {
                vc = page
                break
            }
        }
        if let vc = vc {
            self.pageViewController.setViewControllers([vc], direction: navigation, animated: true)
            if let bwVc = vc as? TMBWClockViewController {
                bwVc.subType = item.subType ?? .white
                NotificationCenter.default.post(name: NSNotification.Name.kNotifiVcThemeChanged, object: nil)
            }
        }
    }
    
    
    @objc func panGestureRecognizer(_ pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self.view)
        let velocity = pan.velocity(in: self.view)
        let max = TMMainBottomView.viewSize().height
        let min = 0.0
        var offsetY = 0.0
        let cornerRadius = kBottomCornerRadius
        
        switch pan.state {
        case .began:
            self.location = location.y
            offsetY = self.offsetY + (location.y - self.location)
            break
        case .changed:
            offsetY = self.offsetY + (location.y - self.location)
        case .ended, .cancelled:
            offsetY = self.offsetY + (location.y - self.location)
            if offsetY < -max * 0.5 {
                offsetY = -max
            }
            else {
                offsetY = min
            }
            self.offsetY = offsetY
        default:
            break
        }
        
        if abs(velocity.y) >= 1000 {
            var transform = CGAffineTransform.identity
            if velocity.y > 0 {
                transform = .identity
                self.offsetY = min
            }
            else {
                transform = .identity.translatedBy(x: 0, y: -max)
                self.offsetY = -max
            }
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.pageViewController.view.transform = transform
                if abs(self.offsetY / max) * 2 > 1.0 {
                    self.pageViewController.view.layer.cornerRadius = cornerRadius
                }
                else {
                    self.pageViewController.view.layer.cornerRadius = cornerRadius * abs(self.offsetY / max) * 2
                }
            }
            return
        }
        
        if offsetY < -max {
            offsetY = -max
        }
        else if offsetY > min {
            offsetY = min
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.pageViewController.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: offsetY)
            if abs(offsetY / max) * 2 > 1.0 {
                self.pageViewController.view.layer.cornerRadius = cornerRadius
            }
            else {
                self.pageViewController.view.layer.cornerRadius = cornerRadius * abs(offsetY / max) * 2
            }
        }
    }

}
