//
//  XQMobileprovision.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQMobileprovision.h"

@implementation XQMobileprovision

+ (NSArray <XQMobileprovisionModel *> *)getSystemMobileprovisionsWithError:(NSError **)error {
    NSMutableArray *muArr = [NSMutableArray array];
    
    NSFileManager *f = [NSFileManager defaultManager];
    NSString *path = [self getSystemNormalPath];
    NSArray *arr = [f contentsOfDirectoryAtPath:path error:error];
    if (*error) {
        NSLog(@"error: %@", *error);
        return nil;
    }
    for (NSString *name in arr) {
        if ([name hasSuffix:@".mobileprovision"]) {
            NSDictionary *dic = [self getMobileprovisionWithFilepath:[path stringByAppendingPathComponent:name] plistString:nil];
            if (dic) {
                XQMobileprovisionModel *model = [XQMobileprovisionModel yy_modelWithDictionary:dic];
                model.rawDic = dic;
                model.Entitlements.rawDic = dic[@"Entitlements"];
                [muArr addObject:model];
            }
        }
    }
    
    return muArr;
}


+ (NSArray <XQMobileprovisionModel *> *)getSystemMobileprovisionsWithBundleId:(NSString *)bundleId error:(NSError **)error {
    if (!bundleId) {
        return nil;
    }
    
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray <XQMobileprovisionModel *> *arr = [XQMobileprovision getSystemMobileprovisionsWithError:error];
    if (*error) {
        return nil;
    }
    
    for (XQMobileprovisionModel *model in arr) {
        if ([model.Entitlements.applicationIdentifier hasSuffix:bundleId]) {
            [muArr addObject:model];
        }
    }
    return muArr;
}


/**
 获取某个 bundle id 的 Mobileprovision 信息
 */
+ (XQMobileprovision *)getSystemMobileprovisionsCollectionWithBundleId:(NSString *)bundleId error:(NSError **)error {
    
    NSArray <XQMobileprovisionModel *> *modelArr = [self getSystemMobileprovisionsWithBundleId:bundleId error:error];
    
    XQMobileprovision *mobileprovision = [XQMobileprovision new];
    NSMutableArray *devArr = [NSMutableArray array];
    NSMutableArray *disArr = [NSMutableArray array];
    
    for (XQMobileprovisionModel *model in modelArr) {
        if ([model.Entitlements.applicationIdentifier hasSuffix:bundleId]) {
            if ([model.Entitlements.apsEnvironment isEqualToString:XQ_EntitlementsModel_ApsE_Production]) {
                [disArr addObject:model];
            }else {
                [devArr addObject:model];
            }
        }
    }
    
    mobileprovision.devModelArr = devArr;
    mobileprovision.devModelArr = disArr;
    return mobileprovision;
}


+ (NSString *)getSystemNormalPath {
    
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    
    return [[libraryPath stringByAppendingPathComponent:@"MobileDevice"] stringByAppendingPathComponent:@"Provisioning Profiles"];
    
//    return @"~/Library/MobileDevice/Provisioning\\ Profiles";
    
//    NSArray *arr = [[NSBundle mainBundle].bundlePath componentsSeparatedByString:@"/"];
//
//    if (arr.count < 3) {
//        return @"~/Library/MobileDevice/Provisioning Profiles";
//    }
//
//    NSString *path = [NSString stringWithFormat:@"/%@/%@/%@", arr[1], arr[2], @"Library/MobileDevice/Provisioning Profiles"];
//    return path;
    
//    return @"/Users/wangxingqian/Library/MobileDevice/Provisioning Profiles";
    
}




+ (NSDictionary *)getMobileprovisionWithFilepath:(NSString *)filePath plistString:(NSString *_Nullable*_Nullable)plistString {
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSData *rawData = [NSData dataWithContentsOfFile:filePath];
        return [self getMobileprovisionWithData:rawData plistString:plistString];
    }
    return nil;
}

+ (NSDictionary *)getMobileprovisionWithData:(NSData *)rawData plistString:(NSString *_Nullable*_Nullable)plistString {
    
    /**
     wxq: 原文 https://github.com/shaojiankui/ProfilesManager
     */
    
    if (!rawData) {
        return nil;
    }
    
    NSString *startString = @"<?xml version";
    
    NSString *endString = @"</plist>";
//    NSString *endString = @"</Scheme>";
    
    
    NSData *startData = [NSData dataWithBytes:[startString UTF8String] length:startString.length];
    NSData *endData = [NSData dataWithBytes:[endString UTF8String] length:endString.length];
    
    NSRange fullRange = {.location = 0, .length = [rawData length]};
    
    NSRange startRange = [rawData rangeOfData:startData options:0 range:fullRange];
    NSRange endRange = [rawData rangeOfData:endData options:0 range:fullRange];
    
    NSRange plistRange = {.location = startRange.location, .length = endRange.location + endRange.length - startRange.location};
    NSData *plistData = [rawData subdataWithRange:plistRange];
    
    
    // wxq
    if (plistString != NULL) {
        *plistString = [[NSString alloc] initWithData:plistData encoding:NSUTF8StringEncoding];
    }
    
    id obj = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:NULL error:nil];
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}

@end
