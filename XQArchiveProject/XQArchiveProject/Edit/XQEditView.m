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
        
//        self.scrollView.borderType = NSBezelBorder;
        // 默认为dark, 如果设置为其他, 旁边上下滑就会出现黑边
//        self.scrollView.scrollerStyle = NSScrollerKnobStyleDark;
//        self.scrollView.findBarPosition = NSScrollViewFindBarPositionAboveContent;
//        self.scrollView.horizontalScrollElasticity = NSScrollElasticityAutomatic;
//        self.scrollView.verticalScrollElasticity = NSScrollElasticityAutomatic;
//        self.scrollView.usesPredominantAxisScrolling = NO;
//        self.scrollView.verticalLineScroll = 10;
//        self.scrollView.horizontalLineScroll = 10;
//        self.scrollView.verticalPageScroll = 10;
//        self.scrollView.horizontalPageScroll = 10;
        
//        self.scrollView.hasVerticalRuler = YES;
        // 显示滑动条
        self.scrollView.hasVerticalScroller = YES;

//        self.scrollView.hasHorizontalRuler = YES;
        self.scrollView.hasHorizontalScroller = YES;
        
        [self addSubview:self.scrollView];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.scrollView.contentView);
            make.width.mas_greaterThanOrEqualTo(700);
//            make.height.mas_greaterThanOrEqualTo(800);
            
            make.width.height.equalTo(self.scrollView.contentView).priorityLow();
        }];
        
        
        [self initBaseInfoView];
        [self initMobileprovisionView];
        [self initOtherView];
        [self initAppStoreView];
        [self initFirView];
        [self initBuglyView];
        
        
//        self.contentView.wantsLayer = YES;
//        self.contentView.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
//
//        self.baseInfoView.wantsLayer = YES;
//        self.baseInfoView.layer.backgroundColor = [NSColor orangeColor].CGColor;
//
//        self.mobileprovisionView.wantsLayer = YES;
//        self.mobileprovisionView.layer.backgroundColor = [NSColor orangeColor].CGColor;
//
//        self.otherView.wantsLayer = YES;
//        self.otherView.layer.backgroundColor = [NSColor orangeColor].CGColor;
//
//        self.appStoreView.wantsLayer = YES;
//        self.appStoreView.layer.backgroundColor = [NSColor orangeColor].CGColor;
//
//        self.firView.wantsLayer = YES;
//        self.firView.layer.backgroundColor = [NSColor orangeColor].CGColor;
//
//        self.buglyView.wantsLayer = YES;
//        self.buglyView.layer.backgroundColor = [NSColor orangeColor].CGColor;
    }
    return self;
}

- (void)initBaseInfoView {
    self.baseInfoView = [NSView new];
    [self.contentView addSubview:self.baseInfoView];
    [self.baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(10);
        make.trailing.equalTo(self.contentView).offset(-10);
    }];
    
    self.projectNameTF = [NSTextField new];
    self.projectNameTF.placeholderString = @"项目名称, 只是这里给你分辨而已, 跟真正项目没有什么关系";
    [self.baseInfoView addSubview:self.projectNameTF];
    [self.projectNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.baseInfoView);
        make.width.mas_equalTo(400);
        make.height.mas_equalTo(40);
    }];
    
    self.convenientBtn = [NSButton buttonWithTitle:@"导入项目" target:self action:@selector(respondsToConvenientConfig:)];
    [self.baseInfoView addSubview:self.convenientBtn];
    [self.convenientBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.projectNameTF.mas_right).offset(10);
        make.centerY.equalTo(self.projectNameTF);
    }];
    
    self.doneBtn = [NSButton buttonWithTitle:@"完成编辑" target:self action:@selector(respondsToDone:)];
    [self.baseInfoView addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.convenientBtn.mas_right).offset(10);
        make.centerY.equalTo(self.projectNameTF);
    }];
    
    
    self.targetDescriptTF = [NSTextField labelWithString:@"项目的target"];
    [self.baseInfoView addSubview:self.targetDescriptTF];
    [self.targetDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.projectNameTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.projectNameTF);
    }];
    
    self.currentTargetTF = [NSTextField new];
    self.currentTargetTF.placeholderString = @"当前选中的target";
    [self.baseInfoView addSubview:self.currentTargetTF];
    [self.currentTargetTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.targetDescriptTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.projectNameTF);
    }];
    
    self.targetBtn = [[NSPopUpButton alloc] initWithFrame:CGRectZero pullsDown:YES];
    [self.targetBtn setTarget:self];
    [self.targetBtn setAction:@selector(respondsToTarget:)];
    
    [self.baseInfoView addSubview:self.targetBtn];
    [self.targetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTargetTF.mas_right).offset(10);
        make.centerY.equalTo(self.currentTargetTF);
    }];
    
    self.bundleIdTF = [NSTextField new];
    self.bundleIdTF.placeholderString = @"项目的id";
    [self.baseInfoView addSubview:self.bundleIdTF];
    [self.bundleIdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentTargetTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.projectNameTF);
    }];
    
    self.xcodeprojPathTF = [NSTextField new];
    self.xcodeprojPathTF.placeholderString = @"项目路径( .xcodeproj )";
    [self.baseInfoView addSubview:self.xcodeprojPathTF];
    [self.xcodeprojPathTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bundleIdTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.projectNameTF);
    }];
    
    self.xcworkspacePathTF = [NSTextField new];
    self.xcworkspacePathTF.placeholderString = @"项目路径( .xcworkspace )";
    [self.baseInfoView addSubview:self.xcworkspacePathTF];
    [self.xcworkspacePathTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xcodeprojPathTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.projectNameTF);
    }];
    
    self.teamIdTF = [NSTextField new];
    self.teamIdTF.placeholderString = @"项目的团队id";
    [self.baseInfoView addSubview:self.teamIdTF];
    [self.teamIdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xcworkspacePathTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.projectNameTF);
        
        // 最后一个, 跟父视图底部
        make.bottom.equalTo(self.baseInfoView.mas_bottom).offset(-10);
    }];
    
    
    // 不应该在这里配置, 而是直接外面选Debug打包还是Release就行了
//    self.releaseBtn = [NSButton checkboxWithTitle:@"Release (打包模式)" target:self action:@selector(respondsToRelease:)];
//    [self.baseInfoView addSubview:self.releaseBtn];
//    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.teamIdTF.mas_bottom).offset(10);
//        make.leading.equalTo(self.targetDescriptTF);
//
//        // 最后一个, 跟父视图底部
//        make.bottom.equalTo(self.baseInfoView.mas_bottom).offset(-10);
//    }];
    
    
}

- (void)initMobileprovisionView {
    self.mobileprovisionView = [NSView new];
    [self.contentView addSubview:self.mobileprovisionView];
    [self.mobileprovisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.baseInfoView);
    }];
    
    self.automaticBtn = [NSButton checkboxWithTitle:@"Automatic (签名模式) " target:self action:@selector(respondsToAutomatic:)];
    // 不给用户改, 改就去项目改, 然后再次读一遍配置
    self.automaticBtn.enabled = NO;
    [self refreshMobileprovisionView];
}

- (void)initOtherView {
    self.otherView = [NSView new];
    [self.contentView addSubview:self.otherView];
    [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileprovisionView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.baseInfoView);
    }];
    
    self.generateDSYMBtn = [NSButton checkboxWithTitle:@"Generate dSYM" target:self action:@selector(respondsToGenerateDSYM:)];
    [self.otherView addSubview:self.generateDSYMBtn];
    [self.generateDSYMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherView).offset(10);
        make.left.equalTo(self.otherView);
    }];
    
    self.buildSavePathDescriptTF = [NSTextField labelWithString:@"构建项目数据保存路径"];
    [self.otherView addSubview:self.buildSavePathDescriptTF];
    [self.buildSavePathDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.generateDSYMBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.otherView);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    
    self.buildSavePathTF = [NSTextField new];
    self.buildSavePathTF.placeholderString = @"构建项目数据保存路径";
    [self.otherView addSubview:self.buildSavePathTF];
    [self.buildSavePathTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildSavePathDescriptTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.buildSavePathDescriptTF);
    }];
    
    self.projectPlistpPathDescriptTF = [NSTextField labelWithString:@"项目的plist文件路径"];
    [self.otherView addSubview:self.projectPlistpPathDescriptTF];
    [self.projectPlistpPathDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildSavePathTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.buildSavePathDescriptTF);
    }];
    
    self.projectPlistpPathTF = [NSTextField new];
    self.projectPlistpPathTF.placeholderString = @"项目的plist文件路径";
    [self.otherView addSubview:self.projectPlistpPathTF];
    [self.projectPlistpPathTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.projectPlistpPathDescriptTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.buildSavePathDescriptTF);
        
        make.bottom.equalTo(self.otherView).offset(-10);
    }];
    
}

- (void)initAppStoreView {
    self.appStoreView = [NSView new];
    [self.contentView addSubview:self.appStoreView];
    [self.appStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.baseInfoView);
    }];
    
    self.upAppStoreBtn = [NSButton checkboxWithTitle:@"上传到App Store" target:self action:@selector(respondsToUpAppStore:)];
    [self.appStoreView addSubview:self.upAppStoreBtn];
    [self.upAppStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appStoreView).offset(10);
        make.leading.equalTo(self.appStoreView);
    }];
    
    self.appStoreDescriptTF = [NSTextField labelWithString:@"上传 .ipa 到 App Store, 需要的配置"];
    [self.appStoreView addSubview:self.appStoreDescriptTF];
    [self.appStoreDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upAppStoreBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.appStoreView);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    
    self.appleIdTF = [NSTextField new];
    self.appleIdTF.placeholderString = @"apple id";
    [self.appStoreView addSubview:self.appleIdTF];
    [self.appleIdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appStoreDescriptTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.appStoreDescriptTF);
    }];
    
    self.appleIdPwdTF = [NSTextField new];
    self.appleIdPwdTF.placeholderString = @"apple id password";
    [self.appStoreView addSubview:self.appleIdPwdTF];
    [self.appleIdPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appleIdTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.appStoreDescriptTF);
        
        make.bottom.equalTo(self.appStoreView).offset(-10);
    }];
    
}

- (void)initFirView {
    self.firView = [NSView new];
    [self.contentView addSubview:self.firView];
    [self.firView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appStoreView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.baseInfoView);
    }];
    
    self.upFirBtn = [NSButton checkboxWithTitle:@"上传到Fir" target:self action:@selector(respondsToUpFir:)];
    [self.firView addSubview:self.upFirBtn];
    [self.upFirBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firView).offset(10);
        make.leading.equalTo(self.firView);
    }];
    
    self.firDescriptTF = [NSTextField labelWithString:@"上传 .ipa 到 fir 需要的配置"];
    [self.firView addSubview:self.firDescriptTF];
    [self.firDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upFirBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.firView);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    
    self.firTokenTF = [NSTextField new];
    self.firTokenTF.placeholderString = @"fir token";
    [self.firView addSubview:self.firTokenTF];
    [self.firTokenTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firDescriptTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.firDescriptTF);
        
        make.bottom.equalTo(self.firView).offset(-10);
    }];
    
}

- (void)initBuglyView {
    self.buglyView = [NSView new];
    [self.contentView addSubview:self.buglyView];
    [self.buglyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.baseInfoView);
        
        make.bottom.equalTo(self.contentView);
    }];
    
    self.buglyUpDSYMBtn = [NSButton checkboxWithTitle:@"上传到Bugly" target:self action:@selector(respondsToUpBugly:)];
    [self.buglyView addSubview:self.buglyUpDSYMBtn];
    [self.buglyUpDSYMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buglyView).offset(10);
        make.leading.equalTo(self.buglyView);
    }];
    
    self.buglyDescriptTF = [NSTextField labelWithString:@"上传 dSYM 到 Bugly 需要的配置"];
    [self.buglyView addSubview:self.buglyDescriptTF];
    [self.buglyDescriptTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buglyUpDSYMBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.buglyView);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    
    self.buglyAppIdTF = [NSTextField new];
    self.buglyAppIdTF.placeholderString = @"Bugly App Id";
    [self.buglyView addSubview:self.buglyAppIdTF];
    [self.buglyAppIdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buglyDescriptTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.buglyDescriptTF);
    }];
    
    self.buglyAppKeyTF = [NSTextField new];
    self.buglyAppKeyTF.placeholderString = @"Bugly App Key";
    [self.buglyView addSubview:self.buglyAppKeyTF];
    [self.buglyAppKeyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buglyAppIdTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.buglyDescriptTF);
    }];
    
    self.buglyAppVersionTF = [NSTextField new];
    self.buglyAppVersionTF.placeholderString = @"Bugly App Version";
    [self.buglyView addSubview:self.buglyAppVersionTF];
    [self.buglyAppVersionTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buglyAppKeyTF.mas_bottom).offset(10);
        make.leading.trailing.height.equalTo(self.buglyDescriptTF);
        
        make.bottom.equalTo(self.buglyView).offset(-10);
    }];
    
}

- (void)refreshMobileprovisionView {
    // 移除所有
    NSArray *arr = self.mobileprovisionView.subviews.copy;
    for (NSView *view in arr) {
        [view removeFromSuperview];
    }
    [self.mobileprovisionView addSubview:self.automaticBtn];
    
    [self.mobileprovisionArrView removeAllObjects];
    
    if (self.automaticBtn.state == NSControlStateValueOn || self.mobileprovisionModelArr.count == 0) {
        // 自动模式下, 不用描述文件
        [self.automaticBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mobileprovisionView).offset(10);
            make.left.equalTo(self.mobileprovisionView);
            make.bottom.equalTo(self.mobileprovisionView).offset(-10);
        }];
        
    }else {
        
        [self.automaticBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mobileprovisionView).offset(10);
            make.left.equalTo(self.mobileprovisionView);
        }];
        
        for (int i = 0; i < self.mobileprovisionModelArr.count; i++) {
            XQEditVCProfileModel *model = self.mobileprovisionModelArr[i];
            
            XQEditMobileprovisionView *emView = [XQEditMobileprovisionView new];
            [self.mobileprovisionView addSubview:emView];
            [self.mobileprovisionArrView addObject:emView];
            
            emView.mobileprovisionDescriptTF.stringValue = model.bundleId;
            emView.mobileprovisionDevTF.stringValue = model.dev ? model.dev : @"";
            emView.mobileprovisionDisTF.stringValue = model.dis ? model.dis : @"";
            
            // 获取上一个
            XQEditMobileprovisionView *oEMView = nil;
            if (i != 0) {
                oEMView = self.mobileprovisionArrView[i - 1];
            }
            
            if (i == 0) {
                [emView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.automaticBtn.mas_bottom).offset(10);
                    make.leading.trailing.equalTo(self.mobileprovisionView);
                }];
                
            }else {
                [emView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(oEMView.mas_bottom).offset(10);
                    make.leading.trailing.equalTo(self.mobileprovisionView);
                }];
            }
            
            
            // 最后一个
            if (i == self.mobileprovisionModelArr.count - 1) {
                [emView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (!oEMView) {
                        make.top.equalTo(self.automaticBtn.mas_bottom).offset(10);
                    }else {
                        make.top.equalTo(oEMView.mas_bottom).offset(10);
                    }
                    
                    make.leading.trailing.equalTo(self.mobileprovisionView);
                    make.bottom.equalTo(self.mobileprovisionView).offset(-10);
                }];
            }
            
        }
        
        
    }
    
}

#pragma mark - responds

- (void)respondsToConvenientConfig:(NSButton *)sender {
    [self.delegate editView:self didSelectConvenientConfig:sender];
}

- (void)respondsToDone:(NSButton *)sender {
    [self.delegate editView:self didSelectSaveConfig:sender];
}

- (void)respondsToTarget:(NSPopUpButton *)sender {
    [self.delegate editView:self didSelectChangeTarget:sender];
}

- (void)respondsToRelease:(NSButton *)sender {
    
}

- (void)respondsToAutomatic:(NSButton *)sender {
    [self refreshMobileprovisionView];
}

- (void)respondsToGenerateDSYM:(NSButton *)sender {
    
}

- (void)respondsToUpAppStore:(NSButton *)sender {
    
}

- (void)respondsToUpFir:(NSButton *)sender {
    
}

- (void)respondsToUpBugly:(NSButton *)sender {
    
}





#pragma mark - set

- (void)setMobileprovisionModelArr:(NSArray<XQEditVCProfileModel *> *)mobileprovisionModelArr {
    _mobileprovisionModelArr = mobileprovisionModelArr;
    [self refreshMobileprovisionView];
}

#pragma mark - get

- (NSMutableArray<XQEditMobileprovisionView *> *)mobileprovisionArrView {
    if (!_mobileprovisionArrView) {
        _mobileprovisionArrView = [NSMutableArray array];
    }
    return _mobileprovisionArrView;
}

@end
