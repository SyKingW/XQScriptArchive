//
//  XQEditView.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQEditView.h"
#import <Masonry/Masonry.h>

@implementation XQEditView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [NSScrollView new];
        self.contentView = [NSView new];
        self.scrollView.contentView.documentView = self.contentView;
//        self.scrollView.documentView = self.contentView;
        
        [self addSubview:self.scrollView];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.scrollView.contentView);
            make.width.mas_greaterThanOrEqualTo(200);
            make.height.mas_greaterThanOrEqualTo(200);
            
//            make.width.mas_lessThanOrEqualTo(200);
//            make.height.mas_lessThanOrEqualTo(200);
            
            make.width.height.equalTo(self.scrollView.contentView).priorityLow();
        }];
        
        self.contentView.wantsLayer = YES;
        self.contentView.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
        
    }
    return self;
}

@end
