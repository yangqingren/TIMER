//
//  TMMainViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

extension NSNotification.Name {
    static let kBackgroundColor = NSNotification.Name(rawValue: "kNotifiBackgroundColor")
}

let kNotifiBackgroundColor = "kNotifiBackgroundColor"

class TMMainViewController: TMBaseViewController {

    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    lazy var pages: [TMBasePageViewController] = {
        let vc1 = TMNeonClockViewController()
        let v2 = TMBWClockViewController()
        return [vc1, v2]
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 不息屏
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.pageViewController.setViewControllers([self.pages.first!], direction: .forward, animated: false)
        
        TMMontionManager.share.startMotionUpdates()
        TMTimerRunManager.share.startTimeUpdates()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.current) { [weak self] (notification) in
            guard let `self` = self else { return }
            TMMontionManager.share.startMotionUpdates()
            TMTimerRunManager.share.startTimeUpdates()
            if let vc = self.pageViewController.viewControllers?.first, vc.isKind(of: TMNeonClockViewController.self) {
                UIScreen.main.brightness = 1.0
            }
        }

        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.current) { [weak self] (notification) in
            guard let `self` = self else { return }
            UIScreen.main.brightness = 0.5
            TMMontionManager.share.stopMotionUpdates()
            TMTimerRunManager.share.stopTimeUpdates()
        }


        NotificationCenter.default.addObserver(forName: NSNotification.Name.kBackgroundColor, object: nil, queue: .main) { noti in
            if let color = noti.object as? UIColor {
                self.view.backgroundColor = color
            }
        }
        
        // Do any additional setup after loading the view.
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
    
}
 
