//
//  XQArchiveModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQArchiveModel.h"

@implementation XQArchiveModel

- (BOOL)deleteModel {
    if (!self.xq_path) {
        return NO;
    }
    
    NSFileManager *f = [NSFileManager defaultManager];
    if ([f fileExistsAtPath:self.xq_path isDirectory:nil]) {
        return [f removeItemAtPath:self.xq_path error:nil];
    }
    
    return NO;
}

@end
