//
//  XQArchiveConfigModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveModel.h"
#import <YYModel/YYModel.h>

#import "XQArchivePlistModel.h"

#define Notification_XQArchiveConfigModel_ChangeInfo @"XQ_Notification_XQArchiveConfigModel_ChangeInfo"

#define XQ_Archive_Release @"Release"
#define XQ_Archive_Debug @"Debug"

#define XQ_Archive_on @"1"
#define XQ_Archive_off @"0"

NS_ASSUME_NONNULL_BEGIN

@interface XQArchiveConfigModel : XQArchiveModel

/**
 build 模式
 */
@property (nonatomic, copy) NSString *buildMode;

/** 打包模式
 
 Debug: 测试
 Release: 正式
 */
@property (nonatomic, copy) NSString *archiveMode;


/** app bundle id */
@property (nonatomic, copy) NSString *bundleId;
/** .xcodeproj 路径 */
@property (nonatomic, copy) NSString *xcodeprojPath;
/** .xcworkspace 路径 */
@property (nonatomic, copy) NSString *xcworkspacePath;
/** scheme name */
@property (nonatomic, copy) NSString *schemeName;
/** 团队id */
@property (nonatomic, copy) NSString *teamId;
/** 证书
 其实这个固定这两个的 ???
 iPhone Distribution
 iPhone Developer
 
 其实不用下面这样
 格式: iPhone Distribution: 公司地址 (团队id)
 可以在自己的钥匙串访问直接查看名称
 */
@property (nonatomic, copy) NSString *signingCertificate;

/** 项目的plist文件路径 */
@property (nonatomic, copy) NSString *projectPlistPath;

/** plist文件是否自动增加版本
 
 0: 不自动增加
 1: 自动增加
 */
@property (nonatomic, copy) NSString *plistAutoIncrement;

/** 构建项目文件的保存的路径 */
@property (nonatomic, copy) NSString *buildPath;


/** 已构建好的 .xcarchive 路径 */
@property (nonatomic, copy) NSString *xcarchivePath;

/** 要上传 ipa 的路径 */
@property (nonatomic, copy) NSString *ipaPath;

/** 是否生成 dSYM
 0: 不生成
 1: 生成
 */
@property (nonatomic, copy) NSString *generateDSYM;

/** dSYM 保存的文件夹路径 */
@property (nonatomic, copy) NSString *dSYMFolderPath;


/** 是否上传App Store
 0: 不上传
 1: 上传
 */
@property (nonatomic, copy) NSString *upAppStore;
/** 苹果账号 id */
@property (nonatomic, copy) NSString *appleId;
/** 苹果账号 id 密码 */
@property (nonatomic, copy) NSString *appleIdPwd;


/** 是否上传fir
 0: 不上传
 1: 上传
 */
@property (nonatomic, copy) NSString *upFir;
/** fir token */
@property (nonatomic, copy) NSString *firToken;

/** 是否上传 dSYM 到bugly
 0: 不上传
 1: 上传
 */
@property (nonatomic, copy) NSString *buglyUploadDSYM;
/** bugly 应用id */
@property (nonatomic, copy) NSString *buglyAppId;
/** bugly 应用 key */
@property (nonatomic, copy) NSString *buglyAppKey;
/** bugly 应用版本 */
@property (nonatomic, copy) NSString *buglyAppVersion;
/** bugly */
@property (nonatomic, copy) NSString *symbolOutputPath;

/**
 构建release
 */
- (void)buildRelease;

/**
 构建debug
 */
- (void)buildDebug;

/**
 构建

 @param release YES release, NO Debug
 */
- (void)buildWithRelease:(BOOL)release;

/**
 构建
 根据当前 config 来判断
 */
- (void)build;

/**
 保存到本地, 已存在的话, 会覆盖
 */
- (BOOL)save;

/**
 获取model
 */
+ (XQArchiveConfigModel *)getConfigModelWithPath:(NSString *)path;


/*
{
    "buildMode":"1",
    "upAppStore":"0",
    "upFir":"1",
    "bundleId": "com.wxqlm.XQFlutterHybridDemo",
    "xcworkspacePath": "xxxx/XQArchiveDemo.xcworkspace",
    "schemeName": "XQArchiveDemo",
    "projectPlistPath": "xxxx/XQArchiveDemo/Info.plist",
    "archiveMode": "Debug",
    "buildPath": "xxx/XQArchiveAndIpa",
    "teamId": "HYE5WA8QEX",
    "ipaPath": "",
    "xcarchivePath":"",
    "generateDSYM":"0",
    "dSYMFolderPath": "",
    "buglyUploadDSYM":"1",
    "plistAutoIncrement": "1"
}
 */

/*
{
    "appleId": "",
    "appleIdPwd": ""
}
 */

/*
{
    "firToken": ""
}
 */

/*
{
    "buglyAppId": "",
    "buglyAppKey": "",
    "buglyAppVersion": "",
    "symbolOutputPath": ""
}
 */

@end

NS_ASSUME_NONNULL_END
