//
//  XQUserNotification.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/5.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQUserNotification.h"
#import <Intents/INIntentIdentifiers.h>

@implementation XQUserNotification

+ (void)requestAuthorizationWithCallback:(void(^)(BOOL granted, NSError * _Nullable error))callback {
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
    [self requestAuthorizationWithOptions:options callback:callback];
}

+ (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options callback:(void(^)(BOOL granted, NSError * _Nullable error))callback {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@", settings);
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            NSLog(@"未申请");
            
            // Mac(OS X) 申请不用同意, 直接通过..
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                NSLog(@"申请结果: %d, %@", granted, error);
                
                if (callback) {
                    callback(granted, error);
                }
                
//                if (granted) {
                    //                    [[UIApplication sharedApplication] registerForRemoteNotifications];
//                }
            }];
        }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            NSLog(@"已同意");
            if (callback) {
                callback(YES, nil);
            }
            //            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }else {
            NSLog(@"已拒绝");
            if (callback) {
                callback(NO, nil);
            }
        }
    }];
}

+ (void)asdasd {
//    [UNUserNotificationCenter currentNotificationCenter].delegate;
}

+ (void)aweqhwjek {
    //    [UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:<#(nonnull NSSet<UNNotificationCategory *> *)#>
    
    /**
     UNNotificationActionOptionAuthenticationRequired: 需要开锁, 会在后台唤醒app
     UNNotificationActionOptionDestructive: 取消, 什么都不做
     UNNotificationActionOptionForeground: 需要开锁, 会直接进入app
     */
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"qwe" title:@"关注" options:UNNotificationActionOptionForeground];
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"asd" title:@"取消" options:UNNotificationActionOptionDestructive];
    
    /**
     Identifier: 唯一id, 创建 ( 对应 UNMutableNotificationContent.categoryIdentifier )
     hiddenPreviewsBodyPlaceholder: 当开启隐私保护时, 会由这个替代内容
     categorySummaryFormat: 预览时, 显示在底部的小小文字.  @"%u 更多消息啦啦" 显示时就会把 %u 变成 category 通知条数
     intentIdentifiers: 意图标识符 可在 <Intents/INIntentIdentifiers.h> 中查看，主要是针对电话、carplay 等开放的 API (没试过...)
     
     options
     UNNotificationCategoryOptionCustomDismissAction: 用户点击系统取消Action是否响应到通知代理
     UNNotificationCategoryOptionAllowInCarPlay: 支持 CarPlay (CarPlay 是美国苹果公司发布的车载系统) 这个干嘛用的....
     UNNotificationCategoryOptionHiddenPreviewsShowTitle: 通知预览关闭情况下是否显示通知的title
     UNNotificationCategoryOptionHiddenPreviewsShowSubtitle: 通知预览关闭情况下是否显示通知的subtitle
     
     */
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"fasd" actions:@[action, action1] intentIdentifiers:@[] hiddenPreviewsBodyPlaceholder:@"hiddenPreviewsBodyPlaceholder" categorySummaryFormat:@"%u 更多消息啦啦" options:UNNotificationCategoryOptionNone];
}

+ (void)asdaseqwe {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    // 基本内容
    content.title = @"";
    content.subtitle = @"";
    content.body = @"";
    
    // 通知触发, 显示的 badge 数量, nil 就不做任何事情
    content.badge = @(100);
    
    // 通知声音
//    content.sound
    
    // 图片名称, mac 上不可用
//    content.launchImageName = @"";
    
    // 通知的选择按钮, 对应 UNNotificationCategory.identifier
    content.categoryIdentifier = @"";
    
    // 带的一些信息
    content.userInfo = @{};
    
    // 下面一行小字会显示 来自wxq
    content.summaryArgument = @"wxq";
    
    // 当多个消息归拢到一起的时候，苹果会将summaryArgumentCount值加在一起，然后进行显示 (我想说, 那么默认值就是1咯???)
    content.summaryArgumentCount = 1;
    
    // 组id, 系统会把你的通知根据这个分组
    content.threadIdentifier = @"asdasd";
    
    
    // 附件, 可以放, 图片, 音视频等等
    // 官网介绍, 图片和视频大小的等等 https://developer.apple.com/documentation/usernotifications/unnotificationattachment?preferredLanguage=occ
    content.attachments = @[];
    
}

#pragma mark - 时间

+ (UNNotificationRequest *)addTimeIntervalNotificationWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler {
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval  repeats:repeats];
    return [self addNotificationWithIdentifier:identifier content:content trigger:trigger withCompletionHandler:completionHandler];
}

#pragma mark - 日历

+ (UNNotificationRequest *)addSomeTimeNotificationWithIdentifier:(NSString *)identifier year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if (year >= 0) { components.year = year; }
    if (month >= 0) { components.month = month; }
    if (day >= 0) { components.day = day; }
    if (hour >= 0) { components.hour = hour; }
    if (minute >= 0) { components.minute = minute; }
    if (second >= 0) { components.second = second; }
    
    return [self addCalendarNotificationWithIdentifier:identifier dateComponents:components content:content repeats:repeats withCompletionHandler:completionHandler];
}

+ (UNNotificationRequest *)addAlarmClockNotificationWithIdentifier:(NSString *)identifier weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    // 1 ~ 7, 星期天 ~ 星期六
    if (weekday >= 1) { components.weekday = weekday; }
    if (hour >= 0) { components.hour = hour; }
    if (minute >= 0) { components.minute = minute; }
    if (second >= 0) { components.second = second; }
    
    return [self addCalendarNotificationWithIdentifier:identifier dateComponents:components content:content repeats:NO withCompletionHandler:completionHandler];
}

+ (UNNotificationRequest *)addCalendarNotificationWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler {
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:repeats];
    return [self addNotificationWithIdentifier:identifier content:content trigger:trigger withCompletionHandler:completionHandler];
}


#pragma mark - 区域


+ (UNNotificationRequest *)addCircularRegionNotificationWithIdentifier:(NSString *)identifier latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius circularRegionId:(NSString *)circularRegionId content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler __WATCHOS_PROHIBITED {
    // 中心点
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    // 范围
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:circularRegionId];
    // 设置进入通知
    region.notifyOnEntry = YES;
    region.notifyOnExit = NO;
    return [self addRegionNotificationWithIdentifier:identifier region:region content:content repeats:repeats withCompletionHandler:completionHandler];
}

+ (UNNotificationRequest *)addRegionNotificationWithIdentifier:(NSString *)identifier region:(CLRegion *)region content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler __WATCHOS_PROHIBITED {
    #if TARGET_OS_WATCH
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:repeats];
    return [self addNotificationWithIdentifier:identifier content:content trigger:trigger withCompletionHandler:completionHandler];
    #endif
    return nil;
}


+ (UNNotificationRequest *)addNotificationWithIdentifier:(NSString *)identifier content:(UNNotificationContent *)content trigger:(nullable UNNotificationTrigger *)trigger withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler {
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:completionHandler];
    return request;
}

@end
