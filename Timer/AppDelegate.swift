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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc = ViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let deliveryActivity = self.deliveryActivity {
//            await deliveryActivity.update(using: updatedDeliveryStatus, alertConfiguration: alertConfiguration)
            return
        }
        let initialContentState = MTLiveWidgetAttributes.ContentState(date: TMTimerManager.getDate())
        let activityAttributes = MTLiveWidgetAttributes(name: "Widger")
        do {
            deliveryActivity = try Activity.request(attributes: activityAttributes, contentState: initialContentState)
            print("Requested a pizza delivery Live Activity \(String(describing: deliveryActivity?.id ?? "nil")).")
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
        }
    }



}

