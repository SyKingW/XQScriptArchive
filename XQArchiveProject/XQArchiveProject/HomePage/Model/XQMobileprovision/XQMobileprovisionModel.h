//
//  XQMobileprovisionModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQEntitlementsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQMobileprovisionModel : NSObject

/** 原数据 */
@property (nonatomic, copy) NSDictionary *rawDic;

/** <#note#> */
@property (nonatomic, copy) NSString *AppIDName;
/** <#note#> */
@property (nonatomic, copy) NSArray <NSString *> *ApplicationIdentifierPrefix;

/** <#note#> */
@property (nonatomic, copy) NSArray <NSData *> *DeveloperCertificates;

/** <#note#> */
@property (nonatomic, strong) XQEntitlementsModel *Entitlements;

/** 创建日期 */
@property (nonatomic, copy) NSString *CreationDate;
/** 过期日期 */
@property (nonatomic, strong) NSDate *ExpirationDate;

/** <#note#> */
@property (nonatomic, assign) NSInteger IsXcodeManaged;

/** 打包对于的 provisioningProfiles 就是用这个 */
@property (nonatomic, copy) NSString *Name;

/** 支持平台 */
@property (nonatomic, copy) NSArray <NSString *> *Platform;

/** <#note#> */
@property (nonatomic, copy) NSArray <NSString *> *TeamIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSString *TeamName;
/** <#note#> */
@property (nonatomic, assign) NSInteger TimeToLive;
/** 唯一标识符 */
@property (nonatomic, copy) NSString *UUID;
/** <#note#> */
@property (nonatomic, assign) NSInteger Version;


/**
 

{
    AppIDName = "xxx";
    ApplicationIdentifierPrefix =     (
                                       xxx
                                       );
    CreationDate = "2019-05-17 01:08:50 +0000";
    DeveloperCertificates =     (
                                 xxxx二进制数据
                                 );
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
    ExpirationDate = "2019-12-26 08:29:06 +0000";
    IsXcodeManaged = 0;
    Name = FlutterHybridDemoDis;
    Platform =     (
                    iOS
                    );
    TeamIdentifier =     (
                          xxxx
                          );
    TeamName = "地址";
    TimeToLive = 223;
    UUID = "6ce4cd76-1046-4ad8-8c4f-7112dd855499";
    Version = 1;
}
 
 */

@end

NS_ASSUME_NONNULL_END
