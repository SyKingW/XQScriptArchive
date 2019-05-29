//
//  XQEntitlementsModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQEntitlementsModel : NSObject

/** bundle id */
@property (nonatomic, copy) NSString *applicationIdentifier;
/** 生成 or 开发 */
@property (nonatomic, copy) NSString *apsEnvironment;
/** <#note#> */
@property (nonatomic, copy) NSString *betaReportsActive;
/** <#note#> */
@property (nonatomic, copy) NSString *comAppleDeveloperTeamIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSString *getTaskAllow;
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
