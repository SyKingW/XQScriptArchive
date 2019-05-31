//
//  XQEntitlementsModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

#define XQ_EntitlementsModel_ApsE_Production @"production"
#define XQ_EntitlementsModel_ApsE_Development @"development"

NS_ASSUME_NONNULL_BEGIN

@interface XQEntitlementsModel : NSObject

/** teamId.bundleId */
@property (nonatomic, copy) NSString *applicationIdentifier;
/**
 production: 生产描述
 development: 开发描述
 */
@property (nonatomic, copy) NSString *apsEnvironment;
/** <#note#> */
@property (nonatomic, assign) BOOL betaReportsActive;
/** teamId */
@property (nonatomic, copy) NSString *comAppleDeveloperTeamIdentifier;
/** <#note#> */
@property (nonatomic, assign) BOOL getTaskAllow;
/** <#note#> */
@property (nonatomic, copy) NSString *keychainAccessGroups;

/** 原数据 */
@property (nonatomic, copy) NSDictionary *rawDic;

/*
Entitlements =     {
    "application-identifier" = "xxx";
    "aps-environment" = production;
    "beta-reports-active" = 1;
    "com.apple.developer.networking.wifi-info" = 1;
    "com.apple.developer.siri" = 1;
    "com.apple.developer.team-identifier" = xxx;
    "get-task-allow" = 0;
    "keychain-access-groups" =         (
                                        "xxx.*"
                                        );
};
 */

@end

NS_ASSUME_NONNULL_END
