//
//  TMUmengOCManager.m
//  Timer
//
//  Created by yangqingren on 2024/3/10.
//

#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMPush/UMessage.h>
#import "TMUmengOCManager.h"

@implementation TMUmengOCManager

+ (void)registerForRemoteNotifications:(NSDictionary *)options {
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:options Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
    }];
}

@end
