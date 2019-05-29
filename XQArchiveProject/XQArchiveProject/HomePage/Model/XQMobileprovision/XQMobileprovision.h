//
//  XQMobileprovision.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQMobileprovisionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQMobileprovision : NSObject

/**
 获取当前系统下面所有的 Mobileprovision 信息
 */
+ (NSArray <XQMobileprovisionModel *> *)getSystemMobileprovisionsWithError:(NSError **)error;

/**
 获取某个 bundle id 的 Mobileprovision 信息
 */
+ (NSArray <XQMobileprovisionModel *> *)getSystemMobileprovisionsWithBundleId:(NSString *)bundleId error:(NSError **)error;

/**
 获取 .mobileprovision 信息

 @param plistString 原xml信息
 */
+ (NSDictionary *)getMobileprovisionWithFilepath:(NSString *)filePath plistString:(NSString *_Nullable*_Nullable)plistString;

/**
 获取 .mobileprovision 信息
 
 @param plistString 原xml信息
 */
+ (NSDictionary *)getMobileprovisionWithData:(NSData *)rawData plistString:(NSString *_Nullable*_Nullable)plistString;

@end

NS_ASSUME_NONNULL_END
