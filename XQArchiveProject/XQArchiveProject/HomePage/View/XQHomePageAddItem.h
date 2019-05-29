//
//  XQHomePageAddItem.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define XQ_XQHomePageAddItem_item @"XQHomePageAddItem"

typedef void(^XQHomePageAddItemCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface XQHomePageAddItem : NSCollectionViewItem

/** <#note#> */
@property (nonatomic, copy) XQHomePageAddItemCallback callback;

@end

NS_ASSUME_NONNULL_END
