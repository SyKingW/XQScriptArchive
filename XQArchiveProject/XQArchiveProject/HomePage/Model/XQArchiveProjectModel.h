//
//  XQArchiveProjectModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveModel.h"
#import "XQArchiveConfigModel.h"
#import "XQArchivePlistModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQArchiveProjectModel : XQArchiveModel

/** <#note#> */
@property (nonatomic, strong) XQArchiveConfigModel *configModel;
/** <#note#> */
@property (nonatomic, strong) XQArchivePlistModel *devPlistModel;
/** <#note#> */
@property (nonatomic, strong) XQArchivePlistModel *disPlistModel;

- (void)save;

/**
 构建项目
 */
- (void)buildWithError:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler;

/**
 构建release项目
 */
- (void)buildReleaseWithError:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler;
/**
 构建debug项目
 */
- (void)buildDebugWithError:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler;



/**
 停止任务
 */
- (void)terminate;

/**
 创建项目
 */
+ (XQArchiveProjectModel *)createProjectWithError:(NSError **)error;

/**
 获取本地保存的项目配置
 */
+ (NSArray <XQArchiveProjectModel *> *)getLocalDataArrWithError:(NSError **)error;

/**
 获取某个路径的项目
 */
+ (XQArchiveProjectModel *)getProjectWithPath:(NSString *)path;


@end

NS_ASSUME_NONNULL_END
