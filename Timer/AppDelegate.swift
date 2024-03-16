//
//  AppDelegate.swift
//  Timer
//
//  Created by yangqingren on 2024/1/3.
//

import UIKit
import ActivityKit
import UserNotifications
import CoreTelephony

@available(iOS 16.2, *)
var deliveryActivity: Activity<MTLiveWidgetAttributes>?

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    lazy var window: UIWindow? = {
        let view = UIWindow.init(frame: UIScreen.main.bounds)
        view.makeKeyAndVisible()
        return view
    }()
        
    var timer: Timer?
    
    var timeInterval: Int = 0
    
    var noCheckActivity = false
    
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    let cellularData = CTCellularData()
    
    var networkHappen = false
    
    var isLaunchFinish: Bool = UserDefaults.standard.bool(forKey: "kIsLaunchFinish") {
        didSet {
            UserDefaults.standard.set(isLaunchFinish, forKey: "kIsLaunchFinish")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.launchOptions = launchOptions
        
        let vc = TMMainViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        
        //        let vc = LaunchViewController()
        //        let nav = UINavigationController.init(rootViewController: vc)
        //        self.window?.rootViewController = nav
        
        if !self.isLaunchFinish {
            self.cellularData.cellularDataRestrictionDidUpdateNotifier = {[weak self] state in
                guard let `self` = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if !self.isLaunchFinish {
                        self.isLaunchFinish = true
                        self.initUMWithOptions(launchOptions: nil) {[weak self] in
                            self?.showBgMp3PupouView()
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if !self.isLaunchFinish {
                    self.isLaunchFinish = true
                    self.initUMWithOptions(launchOptions: nil) {[weak self] in
                        self?.showBgMp3PupouView()
                    }
                }
            }
        }
        
        LEGONetworking.startMonitorNetworkStatus()
        TMStoreManager.share.requestCurrAndListener()
        
        return true
    }
    
    func showBgMp3PupouView() {
        if let view = TMGetTopController()?.view {
            TMBgMp3PupouView.show(inView: view)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if self.isLaunchFinish {
            self.initUMWithOptions(launchOptions: nil)
        }
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let device = NSData(data: deviceToken)
//        let deviceId = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
//        debugPrint("deviceToken：(deviceId)")
//        
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        debugPrint("didFailToRegisterForRemoteNotificationsWithError=\(error)")
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        if let trigger = notification.request.trigger as? UNPushNotificationTrigger {
//            UMessage.setAutoAlert(false)
//            // 必须加这句代码
//            UMessage.didReceiveRemoteNotification(userInfo)
//        } else {
//            // 应用处于前台时的本地推送接收
//        }
//        completionHandler([.sound, .badge, .alert])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        if let trigger = response.notification.request.trigger as? UNPushNotificationTrigger {
//            // 必须加这句代码
//            UMessage.didReceiveRemoteNotification(userInfo)
//        } else {
//            // 应用处于后台时的本地推送接收
//        }
//        completionHandler()
//    }
}

extension AppDelegate {
    
    func initUMWithOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, compete: (() -> Void)? = nil) {
        let options = launchOptions ?? self.launchOptions
        UNUserNotificationCenter.current().delegate = self
        TMUmengManager.share.requestTracking { _ in
            TMUmengManager.share.initWithAppkey()
            TMUmengManager.share.requestNotification { authorized in
                DispatchQueue.main.async {
                    if authorized && TMMainSettingManager.getOpenStatus(.push) {
                        TMUmengManager.share.registerForRemoteNotifications(launchOptions: options)
                    }
                    compete?()
                }
            }
        }
    }
    
    func unregisterForRemoteNotifications() {
        UMessage.unregisterForRemoteNotifications()
    }
}

extension AppDelegate {
    
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
            if #available(iOS 16.2, *) {
                self.setupLiveAndLockWidger()
            }
        }

        @available(iOS 16.2, *)
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
                        deliveryActivity = try Activity.request(attributes: attributes, content: content, pushType: nil)
                        debugPrint("MTLiveWidget开启成功=\(String(describing: deliveryActivity?.id))")
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
