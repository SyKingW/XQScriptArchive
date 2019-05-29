//
//  XQArchiveConfigModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveConfigModel.h"


#import "XQArchivePlistModel.h"

@interface XQArchiveConfigModel ()


@end

@implementation XQArchiveConfigModel

+ (XQArchiveConfigModel *)getConfigModelWithPath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        XQArchiveConfigModel *model = [XQArchiveConfigModel yy_modelWithJSON:str];
        return model;
    }
    return nil;
}

- (BOOL)save {
    if (!self.xq_path) {
        return NO;
    }
    
    if (!self.xq_id) {
        self.xq_id = [NSUUID UUID].UUIDString;
    }
    
    NSString *str = [self yy_modelToJSONString];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!data) {
        return NO;
    }
    
    NSFileManager *f = [NSFileManager defaultManager];
    
    if ([f fileExistsAtPath:self.xq_path isDirectory:nil]) {
        [f removeItemAtPath:self.xq_path error:nil];
    }
    
    return [f createFileAtPath:self.xq_path contents:data attributes:nil];
}

#pragma mark - get

- (NSString *)archiveMode {
    if (_archiveMode.length == 0) {
        _archiveMode = XQ_Archive_Debug;
    }
    return _archiveMode;
}

- (NSString *)buildMode {
    if (_buildMode.length == 0) {
        _buildMode = XQ_Archive_on;
    }
    return _buildMode;
}

- (NSString *)generateDSYM {
    if (_generateDSYM.length == 0) {
        _generateDSYM = XQ_Archive_off;
    }
    return _generateDSYM;
}





@end
