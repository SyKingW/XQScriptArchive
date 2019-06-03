//
//  XQEditMobileprovisionView.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQEditMobileprovisionView : NSView

@property (nonatomic, strong) NSTextField *mobileprovisionDescriptTF;

@property (nonatomic, strong) NSTextField *mobileprovisionDevTF;
@property (nonatomic, strong) NSButton *mobileprovisionDevBtn;

@property (nonatomic, strong) NSTextField *mobileprovisionDisTF;
@property (nonatomic, strong) NSButton *mobileprovisionDisBtn;

@end

NS_ASSUME_NONNULL_END
