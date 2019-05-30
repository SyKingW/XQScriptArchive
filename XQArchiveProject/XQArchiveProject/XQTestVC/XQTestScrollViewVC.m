//
//  XQTestScrollViewVC.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQTestScrollViewVC.h"
#import <Masonry/Masonry.h>

#import "NSScrollView+XQScroll.h"

@interface XQTestScrollViewVC ()

@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSClipView *clipView;
@property (weak) IBOutlet NSView *contentView;


@property (weak) IBOutlet NSScroller *rightScroller;
@property (weak) IBOutlet NSScroller *bottomScroller;

@end

@implementation XQTestScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clipView.backgroundColor = [NSColor orangeColor];
    
    self.contentView.wantsLayer = YES;
    self.contentView.layer.backgroundColor = [NSColor blueColor].CGColor;
    
    NSView *view1 = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    view1.wantsLayer = YES;
    view1.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
    [self.contentView addSubview:view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(100);
    }];
    
    NSView *view2 = [[NSView alloc] initWithFrame:NSMakeRect(0, 900, 100, 100)];
    view2.wantsLayer = YES;
    view2.layer.backgroundColor = [NSColor blackColor].CGColor;
    [self.contentView addSubview:view2];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(view1.mas_bottom).offset(10);
        make.width.height.mas_equalTo(100);
    }];
    
    NSView *view3 = [NSView new];
    view3.wantsLayer = YES;
    view3.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
    [self.contentView addSubview:view3];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(100);
    }];
    
//    self.contentView.frame = NSMakeRect(0, 0, 250, 150);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.clipView);
        make.width.mas_greaterThanOrEqualTo(150);
        make.height.mas_greaterThanOrEqualTo(250);
        make.width.height.equalTo(self.clipView).priorityLow();
    }];
    
    /*
    // 监听滚动
    self.clipView.postsFrameChangedNotifications = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_viewFrameChanged:) name:@"viewFrameChanged" object:nil];
    [self.clipView viewFrameChanged:[NSNotification notificationWithName:@"viewFrameChanged" object:nil]];
    
    // 监听滚动
    self.clipView.postsBoundsChangedNotifications = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_viewBoundsChanged:) name:@"viewBoundsChanged" object:nil];
    [self.clipView viewBoundsChanged:[NSNotification notificationWithName:@"viewBoundsChanged" object:nil]];
     */
    
    [self.scrollView xq_listenScrollWithCallback:^(NSScrollView * _Nonnull scrollView) {
        NSLog(@"%@", NSStringFromRect(scrollView.contentView.bounds));
    }];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end




















