//
//  XQArchiveProjectModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveProjectModel.h"
#import <XQProjectTool/XQTask.h>

@implementation XQArchiveProjectModel

- (void)save {
    [self.configModel save];
    [self.devPlistModel save];
    [self.disPlistModel save];
}

- (void)buildRelease {
    [self buildWithRelease:YES];
}

- (void)buildDebug {
    [self buildWithRelease:NO];
}

- (void)build {
    [self buildWithRelease:[self.configModel.archiveMode isEqualToString:XQ_Archive_Release]];
}

- (void)buildWithRelease:(BOOL)release {
    NSString *archivePath = [[NSBundle mainBundle] pathForResource:@"xq_archive" ofType:@"sh"];
    if (!archivePath) {
        NSLog(@"找不到脚本");
        return;
    }
    
    if (self.xq_path.length == 0) {
        NSLog(@"配置 json 为 nil");
        return;
    }
    
    if (!self.configModel.buildPath || self.configModel.buildPath.length == 0) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
        path = [NSString stringWithFormat:@"%@/%@/%@", path, @"XQArchive", self.configModel.bundleId];
        NSFileManager *f = [NSFileManager defaultManager];
        if (![f fileExistsAtPath:path]) {
            [f createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.configModel.buildPath = path;
    }
    
    [self.configModel save];
    
    NSString *plistPath = nil;
    if (release) {
        plistPath = self.disPlistModel.xq_path;
    }else {
        plistPath = self.devPlistModel.xq_path;
    }
    
    NSString *cmd = [NSString stringWithFormat:@"bash %@ %@ %@", archivePath, self.configModel.xq_path, plistPath];
    [[XQTask manager] xq_executeSudoWithCmd:cmd];
    
}

- (void)terminate {
    [[XQTask manager] xq_terminate];
}

+ (NSArray <XQArchiveProjectModel *> *)getLocalDataArrWithError:(NSError **)error {
    NSMutableArray *muArr = [NSMutableArray array];
    NSFileManager *f = [NSFileManager defaultManager];
    NSString *path = [self getSavePath];
    NSArray *arr = [f contentsOfDirectoryAtPath:path error:error];
    
    if (*error) {
        return nil;
    }
    
    for (NSString *name in arr) {
        NSString *nPath = [path stringByAppendingPathComponent:name];
        XQArchiveProjectModel *model = [self getProjectWithPath:nPath];
        if (model) {
            [muArr addObject:model];
        }
    }
    return muArr;
}

+ (XQArchiveProjectModel *)getProjectWithPath:(NSString *)path {
    NSFileManager *f = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    
    // 不存在路径
    if (![f fileExistsAtPath:path isDirectory:&isDirectory]) {
        return nil;
    }
    
    // 不是文件夹
    if (!isDirectory) {
        return nil;
    }
    
    // 创建model
    XQArchiveProjectModel *model = [XQArchiveProjectModel new];
    model.xq_path = path;
    
    /**
     下面有以下文件
     
     xq_config.json
     xq_dev_exportOptions.plist
     xq_dis_exportOptions.plist
     */
    
    NSString *configPath = [self getConfigPathWithDirectoryPath:path];
    if ([f fileExistsAtPath:configPath]) {
        model.configModel = [XQArchiveConfigModel getConfigModelWithPath:configPath];
    }else {
        model.configModel = [self createConfigWithPath:path];
    }
    
    NSString *devPlistPath = [self getDevPlistPathWithDirectoryPath:path];
    if ([f fileExistsAtPath:devPlistPath]) {
        model.devPlistModel = [XQArchivePlistModel getPlistModelWithPath:devPlistPath];
    }else {
        model.devPlistModel = [self createDevPlistWithPath:path];
    }
    
    NSString *disPlistPath = [self getDisPlistPathWithDirectoryPath:path];
    if ([f fileExistsAtPath:disPlistPath]) {
        model.disPlistModel = [XQArchivePlistModel getPlistModelWithPath:disPlistPath];
    }else {
        model.disPlistModel = [self createDisPlistWithPath:path];
    }
    
    return model;
}

+ (XQArchiveProjectModel *)createProjectWithError:(NSError **)error {
    // 创建文件夹
    NSString *path = [self getSavePath];
    NSFileManager *f = [NSFileManager defaultManager];
    path = [path stringByAppendingPathComponent:[NSUUID UUID].UUIDString];
    [f createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    if (*error) {
        return nil;
    }
    
    // 获取文件夹项目
    return [self getProjectWithPath:path];
}

+ (XQArchiveConfigModel *)createConfigWithPath:(NSString *)path {
    NSFileManager *f = [NSFileManager defaultManager];
    NSString *configJsonPath = [self getConfigPathWithDirectoryPath:path];
    
    XQArchiveConfigModel *model = [XQArchiveConfigModel new];
    model.xq_id = [NSUUID UUID].UUIDString;
    model.xq_path = configJsonPath;
    
    NSData *configData = [[model yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding];
    if ([f fileExistsAtPath:configJsonPath isDirectory:nil]) {
        [f removeItemAtPath:configJsonPath error:nil];
    }
    
    if ([f createFileAtPath:configJsonPath contents:configData attributes:nil]) {
        return model;
    }
    
    return nil;
}

+ (XQArchivePlistModel *)createDevPlistWithPath:(NSString *)path {
    NSString *plistPath = [self getDevPlistPathWithDirectoryPath:path];
    
    XQArchivePlistModel *model = [XQArchivePlistModel new];
    model.xq_id = [NSUUID UUID].UUIDString;
    model.xq_path = plistPath;
    
    if ([model save]) {
        return model;
    }
    return nil;
}

+ (XQArchivePlistModel *)createDisPlistWithPath:(NSString *)path {
    NSString *plistPath = [self getDisPlistPathWithDirectoryPath:path];
    
    XQArchivePlistModel *model = [XQArchivePlistModel new];
    model.xq_id = [NSUUID UUID].UUIDString;
    model.xq_path = plistPath;
    model.method = XQ_ArchivePlist_Method_AS;
    model.signingCertificate = XQ_ArchivePlist_SCer_Dis;
    
    if ([model save]) {
        return model;
    }
    return nil;
}

+ (NSString *)getConfigPathWithDirectoryPath:(NSString *)path {
    return [path stringByAppendingPathComponent:@"xq_config.json"];
}

+ (NSString *)getDevPlistPathWithDirectoryPath:(NSString *)path {
    return [path stringByAppendingPathComponent:@"xq_dev_exportOptions.plist"];
}

+ (NSString *)getDisPlistPathWithDirectoryPath:(NSString *)path {
    return [path stringByAppendingPathComponent:@"xq_dis_exportOptions.plist"];
}

+ (NSString *)getSavePathWithName:(NSString *)name {
    if (!name) {
        return nil;
    }
    return [[self getSavePath] stringByAppendingPathComponent:name];
}

+ (NSString *)getSavePath {
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"XQArchiveProject/xq_shell_config"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
