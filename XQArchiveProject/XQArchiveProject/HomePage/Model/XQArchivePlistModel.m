//
//  XQArchivePlistModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchivePlistModel.h"
#import <YYModel/YYModel.h>

@implementation XQArchivePlistModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.destination = @"export";
        self.method = XQ_ArchivePlist_Method_Dev;
        self.signingCertificate = XQ_ArchivePlist_SCer_Dev;
        self.compileBitcode = YES;
        self.signingStyle = XQ_ArchivePlist_SigningStyle_Automatic;
        self.stripSwiftSymbols = YES;
        self.thinning = @"<none>";
        self.uploadBitcode = NO;
        self.uploadSymbols = YES;
    }
    return self;
}


/**
 保存到本地, 已存在的话, 会覆盖
 */
- (BOOL)save {
    if (!self.xq_path) {
        NSLog(@"%s, plist 路径不存在", __func__);
        return NO;
    }
    NSDictionary *dic = [self yy_modelToJSONObject];
    NSMutableDictionary *muDic = dic.mutableCopy;
    
    muDic[@"compileBitcode"] = [muDic[@"compileBitcode"] intValue] == 1 ? @(YES) : @(NO);
    muDic[@"stripSwiftSymbols"] = [muDic[@"stripSwiftSymbols"] intValue] == 1 ? @(YES) : @(NO);
    muDic[@"uploadBitcode"] = [muDic[@"uploadBitcode"] intValue] == 1 ? @(YES) : @(NO);
    muDic[@"uploadSymbols"] = [muDic[@"uploadSymbols"] intValue] == 1 ? @(YES) : @(NO);
    
    if ([muDic writeToFile:self.xq_path atomically:YES]) {
        return YES;
    }
    
    NSLog(@"create fali: %@", dic);
    return NO;
}

/**
 删除model
 */
- (BOOL)deleteModel {
    if (!self.xq_path) {
        return NO;
    }
    
    NSFileManager *f = [NSFileManager defaultManager];
    return [f removeItemAtPath:self.xq_path error:nil];
}


+ (XQArchivePlistModel *)getPlistModelWithPath:(NSString *)path {
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (dic) {
        return[XQArchivePlistModel yy_modelWithDictionary:dic];
    }
    return nil;
}


@end
