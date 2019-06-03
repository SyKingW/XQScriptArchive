//
//  PBXProject.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXProject.h"

#import "PBXNativeTarget.h"

#import "PBXAggregateTarget.h"

#import "PBXGroup.h"

#import "XCConfigurationList.h"

#import "PBXObjects.h"

#import "PBXProjParser.h"

#import "XCBuildConfiguration.h"

@interface PBXProject ()

@end

@implementation PBXProject

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        [self _parseProjectWithObjectId:objId data:data];
    }
    return self;
}

- (void)_parseProjectWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    // objects
    NSDictionary *objects = [PBXProjParser sharedInstance].objects.data;

    // targets
    NSArray *targetIds = data[@"targets"];
    
    self.targets = [[NSMutableArray alloc] init];
    
    for (NSString *targetId in targetIds)
    {
        PBXTarget *target = [self _createTarget:targetId];
        [self.targets addObject:target];
    }
    
    // mainGroup
    NSString *mainGroupId = data[@"mainGroup"];
    self.mainGroup = [[PBXGroup alloc] initWithObjectId:mainGroupId data:objects[mainGroupId]];
    
    // product ref group
    NSString *productRefGroupId = data[@"productRefGroup"];
    self.productRefGroup = [[PBXGroup alloc] initWithObjectId:productRefGroupId data:objects[productRefGroupId]];
    
    // buildConfigurationList
    NSString *configListId = data[@"buildConfigurationList"];
    self.buildConfigurationList = [[XCConfigurationList alloc] initWithObjectId:configListId data:objects[productRefGroupId]];
}

- (PBXTarget *)_createTarget:(NSString *)targetId
{
    if (targetId && targetId.length > 0)
    {
        NSDictionary *obj = [PBXProjParser sharedInstance].objects.data[targetId];
        NSString *isa = obj[@"isa"];
        
        if ([isa isEqualToString:@"PBXNativeTarget"])
        {
            NSDictionary *targetAttrs = self.data[@"attributes"][@"TargetAttributes"][targetId];
            
            return [[PBXNativeTarget alloc] initWithObjectId:targetId data:obj targetAttrs:targetAttrs];
        }
        else if ([isa isEqualToString:@"PBXAggregateTarget"])
        {
            return [[PBXAggregateTarget alloc] initWithObjectId:targetId data:obj];
        }
    }
    return nil;
}


// wxq
- (NSArray <PBXTarget *> *)xq_getAppTargets {
    NSMutableArray *muArr = [NSMutableArray array];
    
    for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets) {
        /**
         target.productType
         com.apple.product-type.application: app
         com.apple.product-type.app-extension: extension
         */
        NSString *productType = target.rawData[@"productType"];
        // 是app
        if ([productType isEqualToString:XQ_ProductType_Application]) {
            [muArr addObject:target];
        }
    }
    
    return muArr;
}

// wxq
- (PBXTarget *)xq_getAppTargetWithBundleId:(NSString *)bundleId {
    if (!bundleId) {
        return nil;
    }
    PBXTarget *resultTarget = nil;
    for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets) {
        XCBuildConfiguration *bc = target.buildConfigurationList.buildConfigurations.firstObject;
        if (bc) {
            NSString *bundleId = [bc getBuildSetting:@"PRODUCT_BUNDLE_IDENTIFIER"];
            if ([bundleId isEqualToString:bundleId]) {
                resultTarget = target;
                break;
            }
        }
    }
    return resultTarget;
}

@end
