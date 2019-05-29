//
//  PBXBuildPhases.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class PBXNavigatorItem;
@class PBXBuildFile;

NS_ASSUME_NONNULL_BEGIN

@interface PBXBuildPhases : PBXObject

/**
 wxq: 原本是放在里面的, 我移到 .h 了
 */
@property (nonatomic, strong) NSMutableArray <PBXBuildFile *> *files;

// 添加编译文件
- (void)addBuildFile:(PBXNavigatorItem *)fileRef;

// 移除编译文件
- (void)removeBuildFile:(PBXNavigatorItem *)fileRef;

// 获取buildActionMask
- (NSString *)getBuildActionMask;

// 设置buildActionMask
- (void)setBuildActionMask:(NSString *)buildActionMask;

@end

NS_ASSUME_NONNULL_END
