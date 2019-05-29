//
//  XQEditVC.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XQArchiveProjectModel;

NS_ASSUME_NONNULL_BEGIN

@interface XQEditVC : NSViewController

/** <#note#> */
@property (nonatomic, strong) XQArchiveProjectModel *archiveModel;

@end

NS_ASSUME_NONNULL_END
