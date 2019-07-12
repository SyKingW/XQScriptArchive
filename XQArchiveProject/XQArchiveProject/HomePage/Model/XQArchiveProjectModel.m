//
//  XQArchiveProjectModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveProjectModel.h"
#import <XQProjectTool/XQTask.h>


// 开始清理项目
#define XQ_Def_Clean_Project_Start @"49CECB67-99E5-4B30-A73F-D5EBD8AA3E68"
// 结束清理项目
#define XQ_Def_Clean_Project_End @"A0661894-953B-41B6-B0A4-B520163E1DA2"

// 开始编译
#define XQ_Def_Build_Project_Start @"6042B410-261D-4B81-9037-9B4288DCAFB0"
// 结束编译
#define XQ_Def_Build_Project_End @"B125B79C-5DA1-47D3-AFA5-CE763F4173B8"

// 开始导出 .ipa 包
#define XQ_Def_Export_Ipa_Start @"61486A3E-C857-4DCE-8AA2-681F6614A922"
// 结束导入 .ipa 包
#define XQ_Def_Export_Ipa_End @"443C5591-8181-4117-B95A-8776A2BFE08C"

// 开始上传 fir
#define XQ_Def_Upload_Fir_Start @"ED247AB0-79C4-4956-A3C1-1472902C126A"
// 结束上传 fir
#define XQ_Def_Upload_Fir_End @"31A9A078-333D-4AFF-9FFB-17E263F44BD2"

// 开始上传 App Store
#define XQ_Def_Upload_AppStore_Start @"F4163373-6DD2-492A-9FDB-9DA3F12065BD"
// 结束上传 App Store
#define XQ_Def_Upload_AppStore_End @"3899EE42-1211-460B-B969-311CB0925E37"

// 开始上传 Bugly
#define XQ_Def_Upload_Bugly_Start @"D9027F18-1086-4C1A-9A62-256CD64CF8AC"
// 结束上传 Bugly
#define XQ_Def_Upload_Bugly_End @"1A096E70-E133-4725-ADB7-020760A8D0BF"

@implementation XQArchiveProjectModel

- (void)save {
    [self.configModel save];
    [self.devPlistModel save];
    [self.disPlistModel save];
}

- (void)buildReleaseWithError:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    [self buildWithRelease:YES error:error outLogHandle:outLogHandle errorLogHandle:errorLogHandle terminationHandler:terminationHandler];
}

- (void)buildDebugWithError:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    [self buildWithRelease:NO error:error outLogHandle:outLogHandle errorLogHandle:errorLogHandle terminationHandler:terminationHandler];
}

- (void)buildWithError:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    [self buildWithRelease:[self.configModel.archiveMode isEqualToString:XQ_Archive_Release] error:error outLogHandle:outLogHandle errorLogHandle:errorLogHandle terminationHandler:terminationHandler];
}

- (void)buildWithRelease:(BOOL)release error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
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
    
    self.shProgress = XQArchiveProjectProgressUnknow;
    
    NSString *cmd = [NSString stringWithFormat:@"bash %@ %@ %@", archivePath, self.configModel.xq_path, plistPath];
    [[XQTask manager] xq_executeSudoWithCmd:cmd key:self.configModel.bundleId error:error outLogHandle:^(NSString * _Nonnull log) {
        if ([log containsString:XQ_Def_Clean_Project_Start]) {
            // 清理项目
            NSLog(@"开始清理项目");
            self.shProgress = XQArchiveProjectProgressCleanProjectStart;
            
        }else if ([log containsString:XQ_Def_Clean_Project_End]) {
            NSLog(@"结束清理项目");
            self.shProgress = XQArchiveProjectProgressCleanProjectEnd;
            
            
            
        }else if ([log containsString:XQ_Def_Build_Project_Start]) {
            // 编译
            NSLog(@"开始编译项目");
            self.shProgress = XQArchiveProjectProgressBuildProjectStart;
            
        }else if ([log containsString:XQ_Def_Build_Project_End]) {
            NSLog(@"结束编译项目");
            self.shProgress = XQArchiveProjectProgressBuildProjectEnd;
            
            
            
        }else if ([log containsString:XQ_Def_Export_Ipa_Start]) {
            // ipa
            NSLog(@"开始导出ipa");
            self.shProgress = XQArchiveProjectProgressExportIpaStart;
            
        }else if ([log containsString:XQ_Def_Export_Ipa_End]) {
            NSLog(@"结束导出ipa");
            self.shProgress = XQArchiveProjectProgressExportIpaEnd;
            
            
            
        }else if ([log containsString:XQ_Def_Upload_Fir_Start]) {
            // fir
            NSLog(@"开始上传fir");
            self.shProgress = XQArchiveProjectProgressUploadFirStart;
            
        }else if ([log containsString:XQ_Def_Upload_Fir_End]) {
            NSLog(@"结束上传fir");
            self.shProgress = XQArchiveProjectProgressUploadFirEnd;
            
            
            
        }else if ([log containsString:XQ_Def_Upload_AppStore_Start]) {
            // App Store
            NSLog(@"开始上传App Store");
            self.shProgress = XQArchiveProjectProgressUploadAppStoreStart;
            
        }else if ([log containsString:XQ_Def_Upload_AppStore_End]) {
            NSLog(@"结束上传App Store");
            self.shProgress = XQArchiveProjectProgressUploadAppStoreEnd;
            
            
        }else if ([log containsString:XQ_Def_Upload_Bugly_Start]) {
            // Bugly
            NSLog(@"开始上传Bugly");
            self.shProgress = XQArchiveProjectProgressUploadBuglyStart;
            
        }else if ([log containsString:XQ_Def_Upload_Bugly_End]) {
            NSLog(@"结束上传Bugly");
            self.shProgress = XQArchiveProjectProgressUploadBuglyEnd;
            
        }
        
        if (outLogHandle) {
            outLogHandle(log);
        }
        
    } errorLogHandle:errorLogHandle terminationHandler:^(NSTask * _Nonnull task) {
        self.shProgress = XQArchiveProjectProgressUnknow;
        if (terminationHandler) {
            terminationHandler(task);
        }
        
        
    }];
}

- (void)terminate {
    [[XQTask manager] xq_terminateWithKey:self.configModel.bundleId];
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

#pragma mark - set

- (void)setShProgress:(XQArchiveProjectProgress)shProgress {
    // 不相等, 那么通知外面
    if (_shProgress != shProgress) {
        _shProgress = shProgress;
        if (self.shProgressChangeCallback) {
            self.shProgressChangeCallback(self);
        }
        return;
    }
    _shProgress = shProgress;
}

@end
