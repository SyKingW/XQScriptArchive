//
//  XQTaskManager.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XQArchiveProjectModel.h"




NS_ASSUME_NONNULL_BEGIN

@interface XQTaskManager : NSObject

+ (instancetype)manager;

- (NSArray <XQArchiveProjectModel *> *)getTaskArr;

- (NSArray <XQArchiveProjectModel *> *)getDoneTaskArr;

@end

NS_ASSUME_NONNULL_END
