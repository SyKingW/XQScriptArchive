//
//  XQHomePageItem.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XQArchiveProjectModel;
@class XQHomePageItem;

#define XQ_XQHomePageItem_Item @"XQHomePageItem"

typedef NS_ENUM(NSUInteger, XQHomePageItemTap) {
    XQHomePageItemTapBuild = 0,
    XQHomePageItemTapBuildDebug,
    XQHomePageItemTapBuildXcarchive,
    XQHomePageItemTapIpa,
    XQHomePageItemTapDYSM,
    XQHomePageItemTapDelete,
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^XQHomePageItemCallback)(XQHomePageItem *item, XQHomePageItemTap tapType);

@interface XQHomePageItem : NSCollectionViewItem

/** <#note#> */
@property (nonatomic, strong) XQArchiveProjectModel *archiveModel;

/** <#note#> */
@property (nonatomic, copy) XQHomePageItemCallback callback;

@end

NS_ASSUME_NONNULL_END
