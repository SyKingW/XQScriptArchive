//
//  XQUserNotification.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/5.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQUserNotification : NSObject

/**
 获取当前是否有通知权限

 @param callback granted YES 那么就通过
 */
+ (void)requestAuthorizationWithCallback:(void(^)(BOOL granted, NSError * _Nullable error))callback;

/**
 获取当前是否有通知权限

 @param options 设置通知支持部分
 */
+ (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options callback:(void(^)(BOOL granted, NSError * _Nullable error))callback;

/**
 添加时间间隔通知

 @param timeInterval 触发时间间隔, 单位 s
 @param repeats 是否重复
 */
+ (UNNotificationRequest *)addTimeIntervalNotificationWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler;

/**
 添加某个时刻通知

 @param year 年 (-1表示忽略, 以下都是)
 @param month 月
 @param day 日
 @param hour 小时
 @param minute 分
 @param second 秒
 @parma repeats 是否重复
 */
+ (UNNotificationRequest *)addSomeTimeNotificationWithIdentifier:(NSString *)identifier year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler;

/**
 添加闹钟式通知

 @param weekday 周几 ( 1 ~ 7 == 星期天 ~ 星期六 ) (-1表示忽略, 以下都是)
 @param hour 小时
 @param minute 分
 @param second 秒
 @param repeats 是否重复
 */
+ (UNNotificationRequest *)addAlarmClockNotificationWithIdentifier:(NSString *)identifier weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler;

/**
 添加日历触发通知

 @param dateComponents 触发时间
 @param repeats 是否重复
 */
+ (UNNotificationRequest *)addCalendarNotificationWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler;

/**
 添加圆形区域触发

 @param latitude 纬度
 @param longitude 经度
 @param radius 范围
 @param circularRegionId 范围对象id
 */
+ (UNNotificationRequest *)addCircularRegionNotificationWithIdentifier:(NSString *)identifier latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius circularRegionId:(NSString *)circularRegionId content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler __WATCHOS_PROHIBITED;

/**
 添加区域触发

 @param region 区域
 */
+ (UNNotificationRequest *)addRegionNotificationWithIdentifier:(NSString *)identifier region:(CLRegion *)region content:(UNNotificationContent *)content repeats:(BOOL)repeats withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler __WATCHOS_PROHIBITED;

/**
 添加通知

 @param identifier 通知的id
 @param content 通知内容
 @param trigger 通知触发器
 @param completionHandler 是否添加成功
 */
+ (UNNotificationRequest *)addNotificationWithIdentifier:(NSString *)identifier content:(UNNotificationContent *)content trigger:(nullable UNNotificationTrigger *)trigger withCompletionHandler:(nullable void(^)(NSError *__nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
