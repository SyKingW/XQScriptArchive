//
//  XQArchivePlistModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveModel.h"

#define XQ_ArchivePlist_Method_AS @"app-store"
#define XQ_ArchivePlist_Method_Dev @"development"

#define XQ_ArchivePlist_SCer_Dis @"iPhone Distribution"
#define XQ_ArchivePlist_SCer_Dev @"iPhone Developer"

#define XQ_ArchivePlist_SigningStyle_Automatic @"automatic"
#define XQ_ArchivePlist_SigningStyle_Manual @"manual"

NS_ASSUME_NONNULL_BEGIN

@interface XQArchivePlistModel : XQArchiveModel

/** 默认 export */
@property (nonatomic, copy) NSString *destination;

/**
 导出
 
 app-store: 生产
 development: 测试
 */
@property (nonatomic, copy) NSString *method;

/**
 描述证书
 
 @note 格式如下
 { "bundleId": ".mobileprovision 文件的 Name" }
 
 自动签名, 不需要这个
 */
@property (nonatomic, copy) NSDictionary *provisioningProfiles;

/** 证书
 
 iPhone Distribution: 生产
 iPhone Developer: 开发
 
 自动签名 这个可没有
 */
@property (nonatomic, copy) NSString *signingCertificate;

/**
 默认YES
 
 测试才有??
 */
@property (nonatomic, assign) BOOL compileBitcode;

/** 签名方式
 
 automatic: 自动
 manual: 手动
 */
@property (nonatomic, copy) NSString *signingStyle;

/** 是否移除swift符号 */
@property (nonatomic, assign) BOOL stripSwiftSymbols;

/** 团队id */
@property (nonatomic, copy) NSString *teamID;

/**
 针对特定机型, 默认 <none> 所有的意思
 
 开发才有这个属性
 */
@property (nonatomic, copy) NSString *thinning;


/**
 导出是否包含 bitcode
 
 默认 NO
 */
@property (nonatomic, assign) BOOL uploadBitcode;

/**
 导出是否包含符号
 
 默认 YES
 */
@property (nonatomic, assign) BOOL uploadSymbols;

/**
 保存到本地, 已存在的话, 会覆盖
 */
- (BOOL)save;

/**
 获取 plist model
 */
+ (XQArchivePlistModel *)getPlistModelWithPath:(NSString *)path;


/*
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>destination</key>
<string>export</string>
<key>method</key>
<string>app-store</string>
<key>provisioningProfiles</key>
<dict>
<key>com.wxqlm.XQFlutterHybridDemo</key>
<string>FlutterHybridDemoDis</string>
</dict>
<key>signingCertificate</key>
<string>iPhone Distribution</string>
<key>signingStyle</key>
<string>manual</string>
<key>stripSwiftSymbols</key>
<true/>
<key>teamID</key>
<string>HYE5WA8QEX</string>
<key>uploadBitcode</key>
<false/>
<key>uploadSymbols</key>
<true/>
</dict>
</plist>
*/

@end

NS_ASSUME_NONNULL_END
