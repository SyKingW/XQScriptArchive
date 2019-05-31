//
//  XQEditView.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XQEditMobileprovisionView.h"
#import "XQMobileprovisionModel.h"

@class XQEditView;

NS_ASSUME_NONNULL_BEGIN

@protocol XQEditViewDelegate <NSObject>

- (void)editView:(XQEditView *)editView didSelectConvenientConfig:(NSButton *)sender;

@end

@interface XQEditView : NSView

/** <#note#> */
@property (nonatomic, weak) id <XQEditViewDelegate> delegate;

/**
 基础滚动视图
 */
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSView *contentView;

@property (nonatomic, strong) NSView *baseInfoView;
/**
 项目名称, 与配置无关, 单纯一个名称而已
 */
@property (nonatomic, strong) NSTextField *projectNameTF;
@property (nonatomic, strong) NSButton *convenientBtn;
@property (nonatomic, strong) NSButton *doneBtn;

/**
 项目有多个target, 这个是选择某个target的
 */
@property (nonatomic, strong) NSTextField *currentTargetTF;
@property (nonatomic, strong) NSButton *targetBtn;
@property (nonatomic, strong) NSTextField *targetDescriptTF;

@property (nonatomic, strong) NSTextField *bundleIdTF;
@property (nonatomic, strong) NSTextField *xcodeprojPathTF;
@property (nonatomic, strong) NSTextField *xcworkspacePathTF;
@property (nonatomic, strong) NSTextField *teamIdTF;

@property (nonatomic, strong) NSButton *releaseBtn;

@property (nonatomic, strong) NSView *mobileprovisionView;
@property (nonatomic, strong) NSButton *automaticBtn;
/**
 选择证书视图, 如是自动模式, 则这个会默认会没有
 app 和 extension 需要选
 */
@property (nonatomic, strong) NSMutableArray <XQEditMobileprovisionView *> *mobileprovisionArrView;
/** 设置这个, mobile view 就刷新 mobile view */
@property (nonatomic, copy) NSArray <XQMobileprovisionModel *> *mobileprovisionModelArr;


@property (nonatomic, strong) NSView *otherView;
@property (nonatomic, strong) NSTextField *buildSavePathDescriptTF;
@property (nonatomic, strong) NSButton *generateDSYMBtn;
@property (nonatomic, strong) NSTextField *buildSavePathTF;
@property (nonatomic, strong) NSTextField *projectPlistpPathDescriptTF;
@property (nonatomic, strong) NSTextField *projectPlistpPathTF;

@property (nonatomic, strong) NSView *appStoreView;
@property (nonatomic, strong) NSTextField *appStoreDescriptTF;
@property (nonatomic, strong) NSTextField *appleIdTF;
@property (nonatomic, strong) NSTextField *appleIdPwdTF;
@property (nonatomic, strong) NSButton *upAppStoreBtn;

@property (nonatomic, strong) NSView *firView;
@property (nonatomic, strong) NSTextField *firDescriptTF;
@property (nonatomic, strong) NSTextField *firTokenTF;
@property (nonatomic, strong) NSButton *upFirBtn;

@property (nonatomic, strong) NSView *buglyView;
@property (nonatomic, strong) NSTextField *buglyDescriptTF;
@property (nonatomic, strong) NSTextField *buglyAppIdTF;
@property (nonatomic, strong) NSTextField *buglyAppKeyTF;
@property (nonatomic, strong) NSTextField *buglyAppVersionTF;
@property (nonatomic, strong) NSButton *buglyUpDSYMBtn;

@end

NS_ASSUME_NONNULL_END
