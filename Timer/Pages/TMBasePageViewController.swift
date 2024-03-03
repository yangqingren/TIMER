//
//  TMBasePageViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

class TMBasePageViewController: TMBaseViewController {
    
    var item: TMMainVcItem
    
    let vcType: TMMainVcType

    init(_ item: TMMainVcItem, _ vcType: TMMainVcType) {
        self.item = item
        self.vcType = vcType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var transformView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var unlockBanner = {
        let view = TMUnlockBannerView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.masksToBounds = true

        self.view.addSubview(self.transformView)
        self.transformView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                        
        // Do any additional setup after loading the view.
    }
    
    func setupUnlockBanner() {
        if self.vcType == .main {
            self.view.addSubview(self.unlockBanner)
            self.unlockBanner.snp.remakeConstraints { make in
                make.size.equalTo(TMUnlockBannerView.viewSize())
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-kMenuHeightAndBottom - 15.dp)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                    self.unlockBanner.layer.shadowOffset = CGSize(width: 0, height: 0)
                    self.unlockBanner.layer.shadowColor = UIColor.white.cgColor
                    self.unlockBanner.layer.shadowOpacity = 1.0
                    self.unlockBanner.layer.shadowRadius = 88.dp
                }
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupDelegate(self)
        self.timeUpdates()
        TMMontionManager.share.setupMotionUpdates(duration: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDelegate(self)
        if self.vcType == .main {
            NotificationCenter.default.post(name: NSNotification.Name.kNotifiBackgroundColor, object: self.view.backgroundColor)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupDelegate(nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.setupDelegate(nil)
    }
    
    func setupDelegate(_ vc: TMBasePageViewController?) {
        if self.vcType == .main {
            switch self.item.type {
            case .bw:
                TMDelegateManager.share.bw = vc
            case .electron:
                TMDelegateManager.share.electron = vc
            case .shadow:
                TMDelegateManager.share.shadow = vc
            case .block:
                TMDelegateManager.share.blcok = vc
            case .heart:
                TMDelegateManager.share.heart = vc
            case .clock:
                TMDelegateManager.share.clock = vc
            case .clock2:
                TMDelegateManager.share.clock2 = vc
            case .neon:
                TMDelegateManager.share.neon = vc
            }
        }
    }
    
    override func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {
        super.motionUpdates(directin: directin, duration: duration)
        
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
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.transformView.transform = transform
        }
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
