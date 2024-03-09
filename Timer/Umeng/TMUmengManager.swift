//
//  TMUmengManager.swift
//  Timer
//
//  Created by yangqingren on 2024/3/9.
//

import UIKit
import AppTrackingTransparency
import UserNotifications

let kUmeng_Curr_Clock = "kUmeng_Curr_Clock"
let kUmeng_Purchase_Try = "kUmeng_Purchase_Try"
let kUmeng_Purchase_Success = "kUmeng_Purchase_Success"

class TMUmengManager: NSObject {
    
    static let share = TMUmengManager()
    
    func event(id: String, attributes: [String : String]? = nil) {
        
#if DEBUG
        
#else
        if let attributes = attributes {
            MobClick.event(id, attributes: attributes)
        }
        else {
            MobClick.event(id)
        }
#endif
        
    }
    
    func requestTracking(complete: @escaping (Bool) -> Void) {
        let status = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .notDetermined:
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    complete(true)
                }
                else {
                    complete(false)
                }
            }
        case .restricted:
            complete(false)
        case .denied:
            complete(false)
        case .authorized:
            complete(true)
        default:
            complete(false)
        }
    }
    
    func requestNotification(complete: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                complete(true)
            case .denied:
                complete(false)
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    if granted {
                        complete(true)
                    } else {
                        complete(false)
                    }
                }
            case .provisional:
                complete(true)
            case .ephemeral:
                complete(false)
            default:
                complete(false)
                break
            }
        }
    }
}
