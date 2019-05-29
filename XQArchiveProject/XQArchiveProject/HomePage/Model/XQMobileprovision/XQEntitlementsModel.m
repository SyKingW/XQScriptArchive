//
//  XQEntitlementsModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQEntitlementsModel.h"

@implementation XQEntitlementsModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"applicationIdentifier":@"application-identifier",
             @"apsEnvironment":@"aps-environment",
             @"betaReportsActive":@"beta-reports-active",
             @"comAppleDeveloperTeamIdentifier":@"com.apple.developer.team-identifier",
             @"getTaskAllow":@"get-task-allow",
             @"keychainAccessGroups":@"keychain-access-groups",
             };
}

@end
