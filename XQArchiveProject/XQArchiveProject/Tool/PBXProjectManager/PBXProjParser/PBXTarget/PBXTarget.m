//
//  PBXTarget.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXTarget.h"

#import "XCConfigurationList.h"
#import "PBXTargetDependency.h"

#import "PBXSourcesBuildPhase.h"
#import "PBXFrameworksBuildPhase.h"
#import "PBXResourcesBuildPhase.h"
#import "PBXShellScriptBuildPhase.h"

#import "XCBuildConfiguration.h"

#import "PBXObjects.h"

#import "PBXProjParser.h"

// wxq
#import "PBXBuildFile.h"

@interface PBXTarget ()

@property (nonatomic, strong) NSMutableDictionary *buildConfigs;

@end

@implementation PBXTarget

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        NSArray *dependencyIds = self.data[@"dependencies"];
        self.dependencies = [[NSMutableArray alloc] init];
        for (NSString *dependencyId in dependencyIds)
        {
            NSDictionary *dependency = [PBXProjParser sharedInstance].objects.data[dependencyId];
            NSString *dependencyISA = dependency[@"isa"];
            if ([dependencyISA isEqualToString:@"PBXTargetDependency"])
            {
                [self.dependencies addObject:[[PBXTargetDependency alloc] initWithObjectId:dependencyId data:dependency]];
            }
        }
        
        NSArray *buildPhasesIds = self.data[@"buildPhases"];
        self.buildPhases = [[NSMutableArray alloc] init];
        for (NSString *buildPhasesId in buildPhasesIds)
        {
            NSDictionary *buildPhases = [PBXProjParser sharedInstance].objects.data[buildPhasesId];
            NSString *buildPhasesType = buildPhases[@"isa"];
            
            PBXBuildPhases *buildPhaseObj = nil;
            
            if ([buildPhasesType isEqualToString:@"PBXSourcesBuildPhase"])
            {
                self.sourcesBuildPhase = [[PBXSourcesBuildPhase alloc] initWithObjectId:buildPhasesId data:buildPhases];
                buildPhaseObj = self.sourcesBuildPhase;
            }
            else if ([buildPhasesType isEqualToString:@"PBXFrameworksBuildPhase"])
            {
                self.frameworkBuildPhase = [[PBXFrameworksBuildPhase alloc] initWithObjectId:buildPhasesId data:buildPhases];
                buildPhaseObj = self.frameworkBuildPhase;
            }
            else if ([buildPhasesType isEqualToString:@"PBXResourcesBuildPhase"])
            {
                self.resourceBuildPhase = [[PBXResourcesBuildPhase alloc] initWithObjectId:buildPhasesId data:buildPhases];
                buildPhaseObj = self.resourceBuildPhase;
            }
            else if ([buildPhasesType isEqualToString:@"PBXShellScriptBuildPhase"])
            {
                buildPhaseObj = [[PBXShellScriptBuildPhase alloc] initWithObjectId:buildPhasesId data:buildPhases];
            }
            else
            {
                buildPhaseObj = [[PBXBuildPhases alloc] initWithObjectId:buildPhasesId data:buildPhases];
            }
            [self.buildPhases addObject:buildPhaseObj];
        }

        NSString *configListId = self.data[@"buildConfigurationList"];
        self.buildConfigurationList = [[XCConfigurationList alloc] initWithObjectId:configListId data:[PBXProjParser sharedInstance].objects.data[configListId]];

    }
    return self;
}

// 获取编译配置
- (XCBuildConfiguration *)getBuildConfigs:(NSString *)scheme
{
    if (!self.buildConfigs[scheme])
    {
        for (XCBuildConfiguration *buildConfigs in self.buildConfigurationList.buildConfigurations)
        {
            if ([[buildConfigs getName] isEqualToString:scheme])
            {
                self.buildConfigs[scheme] = buildConfigs;
                break;
            }
        }
    }
    return self.buildConfigs[scheme];
}

// 获取编译配置
- (id)getBuildSetting:(NSString *)scheme name:(NSString *)name
{
    return [[self getBuildConfigs:scheme] getBuildSetting:name];
}

// 设置编译配置
- (void)setBuildSetting:(NSString *)scheme name:(NSString *)name value:(id)value
{
    [[self getBuildConfigs:scheme] setBuildSetting:name settingValue:value];
}

// 获取Target名字
- (NSString *)getName
{
    return self.data[@"name"];
}

// 设置Target名字
- (void)setName:(NSString *)name
{
    self.data[@"name"] = name;
}

// 获取产品名称
- (NSString *)getProductName
{
    return self.data[@"productName"];
}

// 设置产品名称
- (void)setProductName:(NSString *)productName
{
    self.data[@"productName"] = productName;
}

/**
 添加Shell脚本编译设置
 
 @param shellScript shell 脚本
 @param path shell路径，传nil则默认"/bin/sh".
 */
- (void)addShellScriptBuildPhase:(NSString *)shellScript path:(NSString *)path
{
    if (!shellScript) return;
    
    shellScript = [shellScript stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    shellScript = [shellScript stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSMutableDictionary *info = [@{} mutableCopy];
    info[@"isa"] = @"PBXShellScriptBuildPhase";
    info[@"buildActionMask"] = [self.buildPhases[0] getBuildActionMask];
    info[@"files"] = [@[] mutableCopy];
    info[@"inputPaths"] = [@[] mutableCopy];
    info[@"outputPaths"] = [@[] mutableCopy];
    info[@"runOnlyForDeploymentPostprocessing"] = @"0";
    info[@"shellPath"] = path;
    info[@"shellScript"] = [NSString stringWithFormat:@"\"%@\"", shellScript];
    
    PBXShellScriptBuildPhase *buildPhase = [[PBXShellScriptBuildPhase alloc] initWithObjectId:[self genObjectId] data:info];
    
    [[PBXProjParser sharedInstance].objects setObject:buildPhase];
    [self.buildPhases addObject:buildPhase];
    [self.data[@"buildPhases"] addObject:buildPhase.objectId];
}

- (NSArray <PBXTarget *> *)xq_getExtensionTargets {
    NSString *productType = self.rawData[@"productType"];
    
    // 不是app
    if (![productType isEqualToString:XQ_ProductType_Application]) {
        return nil;
    }
    
    NSMutableArray *muArr = [NSMutableArray array];
    
    for (PBXBuildPhases *buildPhases in self.buildPhases) {
        
        /**
         根据 isa 执行来判断
         
         PBXShellScriptBuildPhase: 脚本
         PBXSourcesBuildPhase: 源码资源
         PBXFrameworksBuildPhase: framework
         PBXResourcesBuildPhase: 资源文件
         PBXCopyFilesBuildPhase: extension (系统默认 name: Embed App Extensions)
         */
        if ([[buildPhases getISA] isEqualToString:@"PBXCopyFilesBuildPhase"]) {
            // 获取到项目依赖的库, 从这里面筛选出来 Extension
            for (PBXBuildFile *file in buildPhases.files) {
                NSString *targetId = file.rawData[@"fileRef"];
                
                for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets) {
                    if ([target.rawData[@"productReference"] isEqualToString:targetId]) {
                        
                        // 再判断一下是否是扩展
                        if ([target.rawData[@"productType"] isEqualToString:XQ_ProductType_AppExtension]) {
//                            NSLog(@"找到引用的 target 了: %@", target.rawData);
                            [muArr addObject:target];
                        }
                        break;
                    }
                }
                
            }
        }
    }
    
    return muArr;
}

- (NSString *)xq_getDevProfileName {
    for (XCBuildConfiguration *bc in self.buildConfigurationList.buildConfigurations) {
        if ([[bc getName] isEqualToString:@"Debug"]) {
            NSString *profileName = [bc getBuildSetting:@"PROVISIONING_PROFILE_SPECIFIER"];
            return profileName;
        }
    }
    return nil;
}

- (NSString *)xq_getDisProfileName {
    for (XCBuildConfiguration *bc in self.buildConfigurationList.buildConfigurations) {
        if ([[bc getName] isEqualToString:@"Release"]) {
            NSString *profileName = [bc getBuildSetting:@"PROVISIONING_PROFILE_SPECIFIER"];
            return profileName;
        }
    }
    return nil;
}

- (NSString *)xq_getbundleId {
    XCBuildConfiguration *bc = self.buildConfigurationList.buildConfigurations.firstObject;
    return [bc getBuildSetting:@"PRODUCT_BUNDLE_IDENTIFIER"];
}

#pragma mark - wxq get

- (NSMutableDictionary *)buildConfigs
{
    if (!_buildConfigs)
    {
        _buildConfigs = [[NSMutableDictionary alloc] init];
    }
    return _buildConfigs;
}






@end
