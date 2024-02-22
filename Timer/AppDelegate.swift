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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc = TMMainViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeRun), userInfo: nil, repeats: true)
        
        return true
    }
    
    @objc func timeRun() {
        debugPrint("\(self.timeInterval)")
        self.timeInterval += 1
        if self.timeInterval % 60 == 0, let deliveryActivity = self.deliveryActivity {
            Task {
                guard let current = Activity<MTLiveWidgetAttributes>.activities.first else {
                    return
                }
                let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
                await current.update(using: state)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.resetDeliveryActivity()
    }


    func resetDeliveryActivity() {
        
        if let current = Activity<MTLiveWidgetAttributes>.activities.first {
            Task {
                let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
                await current.update(using: state)
                debugPrint("MTLiveWidget更新成功=\(current.id)")
            }
        }
        else {
            let attributes = MTLiveWidgetAttributes(name: "Widger")
            let state = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
            do {
                self.deliveryActivity = try Activity.request(attributes: attributes, contentState: state)
                debugPrint("MTLiveWidget开启成功=\(String(describing: self.deliveryActivity?.id))")
            } 
            catch (let error) {
                debugPrint("MTLiveWidget开启失败=\(error.localizedDescription)")
            }
        }
        
        if let current = Activity<MTLiveWidgetAttributes>.activities.first {
            Task {
                 for await state in current.contentStateUpdates {
                     debugPrint("监听state状态=\(state)")
                 }
            }
            Task {
                for await state in current.activityStateUpdates {
                    debugPrint("监听activity状态=\(state)")
                }
            }
        }
        
        //            Task {
        //                    for activity in Activity<TestAttributes>.activities {
        //                      await activity.end(dismissalPolicy: .immediate)
        //                    }
        //                }

    }
}

