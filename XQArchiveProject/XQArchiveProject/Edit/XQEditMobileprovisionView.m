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
        
        self.mobileprovisionDevTF = [NSTextField labelWithString:@""];
        [self addSubview:self.mobileprovisionDevTF];
        
        self.mobileprovisionDevBtn = [NSButton buttonWithTitle:@"选择开发描述文件" target:self action:@selector(respondsToSelectDevMobileprovision:)];
        [self addSubview:self.mobileprovisionDevBtn];
        self.mobileprovisionDevBtn.enabled = NO;
        
        self.mobileprovisionDisTF = [NSTextField labelWithString:@""];
        [self addSubview:self.mobileprovisionDisTF];
        
        self.mobileprovisionDisBtn = [NSButton buttonWithTitle:@"选择生产描述文件" target:self action:@selector(respondsToSelectDisMobileprovision:)];
        [self addSubview:self.mobileprovisionDisBtn];
        self.mobileprovisionDisBtn.enabled = NO;
        
        [self.mobileprovisionDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self);
            make.width.equalTo(self).multipliedBy(2.0/3);
        }];
        
        [self.mobileprovisionDevTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mobileprovisionDescriptTF.mas_bottom).offset(10);
            make.leading.width.equalTo(self.mobileprovisionDescriptTF);
        }];
        
        [self.mobileprovisionDevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mobileprovisionDevTF);
            make.left.equalTo(self.mobileprovisionDevTF.mas_right).offset(10);
        }];
        
        [self.mobileprovisionDisTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mobileprovisionDevTF.mas_bottom).offset(10);
            make.leading.width.equalTo(self.mobileprovisionDescriptTF);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self.mobileprovisionDisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mobileprovisionDisTF);
            make.left.equalTo(self.mobileprovisionDisTF.mas_right).offset(10);
        }];
        
        
    }
    return self;
}

#pragma mark - responds

- (void)respondsToSelectDevMobileprovision:(NSButton *)sender {
    
}

- (void)respondsToSelectDisMobileprovision:(NSButton *)sender {
    
}

@end
