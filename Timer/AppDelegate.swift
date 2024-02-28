//
//  AppDelegate.swift
//  Timer
//
//  Created by yangqingren on 2024/1/3.
//

import UIKit
import ActivityKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let view = UIWindow.init(frame: UIScreen.main.bounds)
        view.makeKeyAndVisible()
        return view
    }()

    var deliveryActivity: Activity<MTLiveWidgetAttributes>?
    
    var timer: Timer?
    
    var timeInterval: Int = 0

    var noCheckActivity = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc = TMMainViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        
//        let vc = LaunchViewController()
//        let nav = UINavigationController.init(rootViewController: vc)
//        self.window?.rootViewController = nav
                
        return true
    }
    
//    @objc func timeRun() {
//        
//        // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeRun), userInfo: nil, repeats: true)
//
//        debugPrint("\(self.timeInterval)")
//        self.timeInterval += 1
//        if self.timeInterval % 60 == 0, let deliveryActivity = self.deliveryActivity {
//            Task {
//                guard let current = Activity<MTLiveWidgetAttributes>.activities.first else {
//                    return
//                }
//                let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
//                await current.update(using: state)
//            }
//        }
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.setupLiveAndLockWidger()
    }


    func setupLiveAndLockWidger() {
        if TMMainSettingManager.getOpenStatus(.lock) {
            if let current = Activity<MTLiveWidgetAttributes>.activities.first {
                Task {
                    let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
                    let content = ActivityContent(state: state, staleDate: .distantFuture)
                    await current.update(content)
                    debugPrint("MTLiveWidget更新成功=\(current.id)")
                }
            }
            else {
                let attributes = MTLiveWidgetAttributes(name: "Widger")
                let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
                let content = ActivityContent(state: state, staleDate: .distantFuture)
                do {
                    self.deliveryActivity = try Activity.request(attributes: attributes, content: content, pushType: nil)
                    debugPrint("MTLiveWidget开启成功=\(String(describing: self.deliveryActivity?.id))")
                }
                catch (let error) {
                    debugPrint("MTLiveWidget开启失败=\(error.localizedDescription)")
                    if self.noCheckActivity {
                        self.noCheckActivity = false
                        return
                    }
                    NotificationCenter.default.post(name: NSNotification.Name.kNotifiActivitesWarm, object: nil)
                }
            }
        }
        else {
            if let current = Activity<MTLiveWidgetAttributes>.activities.first {
                Task {
                    let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
                    let content = ActivityContent(state: state, staleDate: .now)
                    await current.end(content, dismissalPolicy: .immediate)
                    debugPrint("MTLiveWidget立即停止=\(current.id)")
                }
            }
        }
        
        if let current = Activity<MTLiveWidgetAttributes>.activities.first {
            Task {
                 for await state in current.contentUpdates {
                     debugPrint("MTLiveWidget监听state状态=\(state)")
                 }
            }
            Task {
                for await state in current.activityStateUpdates {
                    debugPrint("MTLiveWidget监听activity状态=\(state)")
                }
            }
        }
        


    }
}

