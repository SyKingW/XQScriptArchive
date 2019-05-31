//
//  XQEditMobileprovisionView.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQEditMobileprovisionView.h"
#import <Masonry/Masonry.h>

@implementation XQEditMobileprovisionView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mobileprovisionDescriptTF = [NSTextField labelWithString:@""];
        [self addSubview:self.mobileprovisionDescriptTF];
        
        self.mobileprovisionTF = [NSTextField new];
        [self addSubview:self.mobileprovisionTF];
        
        self.mobileprovisionBtn = [NSButton buttonWithTitle:@"选择描述文件" target:self action:@selector(respondsToSelectMobileprovision:)];
        [self addSubview:self.mobileprovisionBtn];
        
        [self.mobileprovisionDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
        }];
        
        [self.mobileprovisionTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mobileprovisionDescriptTF.mas_bottom).offset(10);
            make.leading.width.equalTo(self.mobileprovisionDescriptTF);
        }];
        
        [self.mobileprovisionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mobileprovisionTF);
            make.trailing.equalTo(self);
        }];
        
        
    }
    return self;
}

#pragma mark - responds

- (void)respondsToSelectMobileprovision:(NSButton *)sender {
    
}

@end
