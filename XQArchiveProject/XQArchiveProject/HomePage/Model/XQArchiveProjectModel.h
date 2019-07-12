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

/**
 执行脚本的进度

 - XQArchiveProjectProgressUnknow: 未知
 - XQArchiveProjectProgressCleanProjectStart: 开始清理项目
 - XQArchiveProjectProgressCleanProjectEnd: 清理完成
 - XQArchiveProjectProgressBuildProjectStart: 开始编译项目
 - XQArchiveProjectProgressBuildProjectEnd: 编译完成
 - XQArchiveProjectProgressExportIpaStart: 开始导出ipa
 - XQArchiveProjectProgressExportIpaEnd: 导出ipa完成
 - XQArchiveProjectProgressUploadFirStart: 开始上传ipa到fir
 - XQArchiveProjectProgressUploadFirEnd: 上传ipa到fir完成
 - XQArchiveProjectProgressUploadAppStoreStart: 开始上传ipa到App Store
 - XQArchiveProjectProgressUploadAppStoreEnd: 上传ipa到App Store完成
 - XQArchiveProjectProgressUploadBuglyStart: 开始上传dsym到bugly
 - XQArchiveProjectProgressUploadBuglyEnd: 上传dsym到bugly完成
 */
typedef NS_ENUM(NSUInteger, XQArchiveProjectProgress) {
    XQArchiveProjectProgressUnknow = 0,
    XQArchiveProjectProgressCleanProjectStart,
    XQArchiveProjectProgressCleanProjectEnd,
    XQArchiveProjectProgressBuildProjectStart,
    XQArchiveProjectProgressBuildProjectEnd,
    XQArchiveProjectProgressExportIpaStart,
    XQArchiveProjectProgressExportIpaEnd,
    XQArchiveProjectProgressUploadFirStart,
    XQArchiveProjectProgressUploadFirEnd,
    XQArchiveProjectProgressUploadAppStoreStart,
    XQArchiveProjectProgressUploadAppStoreEnd,
    XQArchiveProjectProgressUploadBuglyStart,
    XQArchiveProjectProgressUploadBuglyEnd,
};



NS_ASSUME_NONNULL_BEGIN

@class XQArchiveModel;

typedef void(^XQArchiveProjectProgressCallback)(XQArchiveModel *archiveModel);

@interface XQArchiveProjectModel : XQArchiveModel

/** <#note#> */
@property (nonatomic, strong) XQArchiveConfigModel *configModel;
/** <#note#> */
@property (nonatomic, strong) XQArchivePlistModel *devPlistModel;
/** <#note#> */
@property (nonatomic, strong) XQArchivePlistModel *disPlistModel;

/** 执行脚本进度 */
@property (nonatomic, assign) XQArchiveProjectProgress shProgress;
/** 执行脚本进度 */
@property (nonatomic, copy) XQArchiveProjectProgressCallback shProgressChangeCallback;

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
