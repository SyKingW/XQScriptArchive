//
//  XQEditVC.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQEditVC.h"
#import <XQProjectTool/XQOpenPanel.h>
#import <XQProjectTool/XQAlertSystem.h>
#import <XQProjectTool/XQXMLParser.h>
#import <Masonry/Masonry.h>

#import "XQEditView.h"
#import "XQArchiveProjectModel.h"
#import "XQXMLParser.h"
#import "PBXProjectManager.h"
#import "XQSchemeModel.h"
#import "XQEditVCProfileModel.h"

@interface XQEditVC () <XQEditViewDelegate>

/** <#note#> */
@property (nonatomic, strong) XQEditView *editView;

/**
 app tagets
 */
@property (nonatomic, strong) NSMutableArray <PBXTarget *> *appTargetsArr;

/** <#note#> */
@property (nonatomic, copy) NSArray <XQSchemeModel *> *schemeArr;

/**
 当前 app tagets
 */
@property (nonatomic, strong) PBXTarget *cAppTargets;

/** <#note#> */
@property (nonatomic, strong) XQSchemeModel *cSchemeModel;

@end

@implementation XQEditVC

/**
 出现错误: NSNib _initWithNibNamed:bundle:optio 找不到 nib
 是因为调用 self.view 的时候, 如果 self.view 为 nil 在这个方法中, 父类默认去加载nib, 所以如果 nibName 为 nil 情况下, 获取不到 xib, 就直接报错了
 
 如果在 self.view 中 loadView
 */
- (void)loadView {
    NSLog(@"%s", __func__);
    
    [super loadView];
    return;
    
    /**
     考虑用runtime解决
     
     设置大小问题
     
     1. 给接口, 设置一个全局大小
     
     2. 用已有的 window 作为大小, 不超过这个
     self.presentingViewController: 跳转过来的时候这个会有值
     self.parentViewController: 作为 childViewController, 这个会有值
     
     3. 没有任何东西的时候, 那么自己给一个默认值 300 x 300
     
     
     */
    
    if (self.nibName.length != 0) {
        [super loadView];
    }else {
        if (!_editView) {
            _editView = [[XQEditView alloc] initWithFrame:NSMakeRect(0, 0, 700, 800)];
            [self setValue:_editView forKey:@"view"];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.editView.delegate = self;
    
    [self updateData];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    // 滚动要那么麻烦吗??? 官方接口呢？？
    NSRect rect = self.editView.scrollView.contentView.bounds;
    CGFloat y = self.editView.scrollView.documentView.bounds.size.height - rect.size.height;
    if (y > 0) {
        rect.origin.y = y;
        self.editView.scrollView.contentView.bounds = rect;
    }
}

- (void)initUI {
    if (!_editView) {
        _editView = [[XQEditView alloc] initWithFrame:NSMakeRect(0, 0, 700, 800)];
        [self.view addSubview:self.editView];
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    self.editView.projectNameTF.stringValue = self.archiveModel.configModel.xq_name ? self.archiveModel.configModel.xq_name : @"";
    self.editView.bundleIdTF.stringValue = self.archiveModel.configModel.bundleId ? self.archiveModel.configModel.bundleId : @"";
    self.editView.currentTargetTF.stringValue = self.archiveModel.configModel.schemeName ? self.archiveModel.configModel.schemeName : @"";
    self.editView.xcodeprojPathTF.stringValue = self.archiveModel.configModel.xcodeprojPath ? self.archiveModel.configModel.xcodeprojPath : @"";
    self.editView.xcworkspacePathTF.stringValue = self.archiveModel.configModel.xcworkspacePath ? self.archiveModel.configModel.xcworkspacePath : @"";
    self.editView.teamIdTF.stringValue = self.archiveModel.configModel.teamId ? self.archiveModel.configModel.teamId : @"";
    self.editView.releaseBtn.state = [self.archiveModel.configModel.archiveMode isEqualToString:XQ_Archive_Release] ? NSControlStateValueOn : NSControlStateValueOff;
    self.editView.generateDSYMBtn.state = [self.archiveModel.configModel.generateDSYM isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.editView.automaticBtn.state = [self.archiveModel.devPlistModel.signingStyle isEqualToString:XQ_ArchivePlist_SigningStyle_Automatic] ? NSControlStateValueOn : NSControlStateValueOff;
    [self.editView refreshMobileprovisionView];
    
    self.editView.buildSavePathTF.stringValue = self.archiveModel.configModel.buildPath ? self.archiveModel.configModel.buildPath : @"";
    self.editView.projectPlistpPathTF.stringValue = self.archiveModel.configModel.projectPlistPath ? self.archiveModel.configModel.projectPlistPath : @"";
    
    self.editView.appleIdTF.stringValue = self.archiveModel.configModel.appleId ? self.archiveModel.configModel.appleId : @"";
    self.editView.appleIdPwdTF.stringValue = self.archiveModel.configModel.appleIdPwd ? self.archiveModel.configModel.appleIdPwd : @"";
    self.editView.upAppStoreBtn.state = [self.archiveModel.configModel.upAppStore isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.editView.firTokenTF.stringValue = self.archiveModel.configModel.firToken ? self.archiveModel.configModel.firToken : @"";
    self.editView.upFirBtn.state = [self.archiveModel.configModel.upFir isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.editView.buglyAppIdTF.stringValue = self.archiveModel.configModel.buglyAppId ? self.archiveModel.configModel.buglyAppId : @"";
    self.editView.buglyAppKeyTF.stringValue = self.archiveModel.configModel.buglyAppKey ? self.archiveModel.configModel.buglyAppKey : @"";
    self.editView.buglyAppVersionTF.stringValue = self.archiveModel.configModel.buglyAppVersion ? self.archiveModel.configModel.buglyAppVersion : @"";
    self.editView.buglyUpDSYMBtn.state = [self.archiveModel.configModel.buglyUploadDSYM isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *key in self.archiveModel.devPlistModel.provisioningProfiles.allKeys) {
        XQEditVCProfileModel *pModel = [XQEditVCProfileModel new];
        pModel.bundleId = key;
        pModel.dev = self.archiveModel.devPlistModel.provisioningProfiles[key];
        pModel.dis = self.archiveModel.disPlistModel.provisioningProfiles[key];
        [muArr addObject:pModel];
    }
    
    self.editView.mobileprovisionModelArr = muArr;
}


- (void)updateData {
    if (self.editView.xcodeprojPathTF.stringValue.length == 0) {
        return;
    }
    
    NSFileManager *f = [NSFileManager defaultManager];
    
    /*
     先获取项目的 scheme, 反正没有 shceme 就算给出 target 也无法打包
     直接用XCode却可以, 真的坑.
     */
    
    NSError *error = nil;
    NSString *schemePath = [self.editView.xcodeprojPathTF.stringValue stringByAppendingPathComponent:@"xcshareddata/xcschemes"];
    NSArray *arr = [f contentsOfDirectoryAtPath:schemePath error:&error];
    
    if (error) {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
        return;
    }
    
    NSMutableArray <XQSchemeModel *> *schemeArr = [NSMutableArray array];
    for (NSString *name in arr) {
        XQSchemeModel *sModel = [XQSchemeModel schemeModelWithFilePath:[schemePath stringByAppendingPathComponent:name]];
        if (!sModel) {
            continue;
        }
        
        [schemeArr addObject:sModel];
    }
    
    self.schemeArr = schemeArr;
    
    
    // 解析项目 .pbxproj
    NSString *pbxprojPath = [self.editView.xcodeprojPathTF.stringValue stringByAppendingPathComponent:@"project.pbxproj"];
    
    if ([f fileExistsAtPath:pbxprojPath]) {
        [[PBXProjParser sharedInstance] parseProjectWithPath:pbxprojPath];
        self.appTargetsArr = [[PBXProjParser sharedInstance].project xq_getAppTargets].mutableCopy;
        
        [self refreshTarget];
    }else {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window domain:@"项目路径错误" code:10000 userInfo:nil callback:nil];
    }
}

- (void)refreshTarget {
    
    if (self.schemeArr.count == 0) {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window domain:@"不存在Scheme, 先在利用XCode创建一下Scheme" code:10000 userInfo:nil callback:nil];
        return;
    }
    
    [self.editView.targetBtn removeAllItems];
    [self.editView.targetBtn addItemWithTitle:@"切换Scheme"];
    self.cSchemeModel = nil;
    if (self.archiveModel.configModel.schemeName) {
        for (XQSchemeModel *sModel in self.schemeArr) {
            if ([sModel.xq_schemeName isEqualToString:self.archiveModel.configModel.schemeName]) {
                self.cSchemeModel = sModel;
                continue;
            }
            [self.editView.targetBtn addItemWithTitle:sModel.xq_schemeName];
        }
    }
    
    if (!self.cSchemeModel) {
        self.cSchemeModel = self.schemeArr.firstObject;
    }
    
    
    
    self.cAppTargets = nil;
    for (PBXTarget *target in self.appTargetsArr) {
        if ([[target objectId] isEqualToString:self.cSchemeModel.LaunchAction.BuildableProductRunnable.BuildableReference.BlueprintIdentifier]) {
            self.cAppTargets = target;
            break;
        }
    }
    
    if (!self.cAppTargets) {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window domain:[NSString stringWithFormat:@"找不到 %@ 对于的 target", self.cSchemeModel.xq_schemeName] code:10000 userInfo:nil callback:nil];
        return;
    }
    
    [self refreshWithTarget:self.cAppTargets scheme:self.cSchemeModel];
}

- (void)refreshWithTarget:(PBXTarget *)target scheme:(XQSchemeModel *)scheme {
    if (!target || !scheme) {
        return;
    }
    
    // scheme name
//    NSString *name = [target getName];
    NSString *name = scheme.xq_schemeName;
    self.editView.currentTargetTF.stringValue = name ? name : @"";
    self.editView.projectNameTF.stringValue = name ? name : @"";
    
    // 这里可能拿到的是 Debug, 不过这些数据无所谓, 一般开发和生产配置都一样的
    XCBuildConfiguration *bc = target.buildConfigurationList.buildConfigurations.firstObject;
    if (bc) {
        
        // "PRODUCT_BUNDLE_IDENTIFIER" = "xxx";
        NSString *bundleId = [bc getBuildSetting:@"PRODUCT_BUNDLE_IDENTIFIER"];
        self.editView.bundleIdTF.stringValue = bundleId ? bundleId : @"";
        
        // "CODE_SIGN_STYLE" = Automatic; or Manual;
        NSString *codeSignStyle = [bc getBuildSetting:@"CODE_SIGN_STYLE"];
        self.archiveModel.devPlistModel.signingStyle = [codeSignStyle lowercaseString];
        self.archiveModel.disPlistModel.signingStyle = [codeSignStyle lowercaseString];
        
        self.editView.automaticBtn.state = [self.archiveModel.devPlistModel.signingStyle isEqualToString:XQ_ArchivePlist_SigningStyle_Automatic] ? NSControlStateValueOn : NSControlStateValueOff;
        [self.editView refreshMobileprovisionView];
        
        // "DEVELOPMENT_TEAM" = xxx;
        NSString *team = [bc getBuildSetting:@"DEVELOPMENT_TEAM"];
        self.editView.teamIdTF.stringValue = team ? team : @"";
        
        // "INFOPLIST_FILE" = "XQTestDemo/Info.plist";
        NSString *infoPlist = [bc getBuildSetting:@"INFOPLIST_FILE"];
        NSMutableArray *pathArr = [self.editView.xcodeprojPathTF.stringValue componentsSeparatedByString:@"/"].mutableCopy;
        [pathArr removeLastObject];
        [pathArr addObject:infoPlist];
        NSString *plistPath = [pathArr componentsJoinedByString:@"/"];
        self.editView.projectPlistpPathTF.stringValue = plistPath;
    }
    
    
    NSMutableArray *profileMuArr = [NSMutableArray array];
    // 自身的描述
    XQEditVCProfileModel *pModel = [XQEditVCProfileModel new];
    pModel.bundleId = [target xq_getbundleId];
    pModel.dev = [target xq_getDevProfileName];
    pModel.dis = [target xq_getDisProfileName];
    
    [profileMuArr addObject:pModel];
    
    NSArray *arr = [target xq_getExtensionTargets];
    for (PBXTarget *eTarget in arr) {
        // 自身的描述
        XQEditVCProfileModel *pModel = [XQEditVCProfileModel new];
        pModel.bundleId = [eTarget xq_getbundleId];
        pModel.dev = [eTarget xq_getDevProfileName];
        pModel.dis = [eTarget xq_getDisProfileName];
        
        [profileMuArr addObject:pModel];
    }
    
    
    
    self.editView.mobileprovisionModelArr = profileMuArr;
    
    // 是否存在自定义ipa名称
    if (scheme.ArchiveAction.customArchiveName.length == 0) {
        self.archiveModel.configModel.customIpaName = scheme.xq_schemeName;
    }else {
        self.archiveModel.configModel.customIpaName = scheme.ArchiveAction.customArchiveName;
    }
}

- (void)saveConfig {
    self.archiveModel.configModel.xq_name = self.editView.projectNameTF.stringValue;
    self.archiveModel.configModel.bundleId = self.editView.bundleIdTF.stringValue;
    self.archiveModel.configModel.schemeName = self.editView.currentTargetTF.stringValue;
    self.archiveModel.configModel.xcodeprojPath = self.editView.xcodeprojPathTF.stringValue;
    self.archiveModel.configModel.xcworkspacePath = self.editView.xcworkspacePathTF.stringValue;
    self.archiveModel.configModel.teamId = self.editView.teamIdTF.stringValue;
    self.archiveModel.configModel.archiveMode = self.editView.releaseBtn.state == NSControlStateValueOn ? XQ_Archive_Release : XQ_Archive_Debug;
    self.archiveModel.configModel.generateDSYM = self.editView.generateDSYMBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.configModel.buildPath = self.editView.buildSavePathTF.stringValue;
    self.archiveModel.configModel.projectPlistPath = self.editView.projectPlistpPathTF.stringValue;
    
    self.archiveModel.configModel.appleId = self.editView.appleIdTF.stringValue;
    self.archiveModel.configModel.appleIdPwd = self.editView.appleIdPwdTF.stringValue;
    self.archiveModel.configModel.upAppStore = self.editView.upAppStoreBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.configModel.firToken = self.editView.firTokenTF.stringValue;
    self.archiveModel.configModel.upFir = self.editView.upFirBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.configModel.buglyAppId = self.editView.buglyAppIdTF.stringValue;
    self.archiveModel.configModel.buglyAppKey = self.editView.buglyAppKeyTF.stringValue;
    self.archiveModel.configModel.buglyAppVersion = self.editView.buglyAppVersionTF.stringValue;
    self.archiveModel.configModel.buglyUploadDSYM = self.editView.buglyUpDSYMBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.disPlistModel.teamID = self.editView.teamIdTF.stringValue;
    
    NSMutableDictionary *devDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *disDic = [NSMutableDictionary dictionary];
    for (XQEditMobileprovisionView *pView in self.editView.mobileprovisionArrView) {
        if (!pView.mobileprovisionDescriptTF.stringValue) {
            continue;
        }
        
        if (pView.mobileprovisionDevTF.stringValue) {
            [devDic addEntriesFromDictionary:@{pView.mobileprovisionDescriptTF.stringValue:pView.mobileprovisionDevTF.stringValue}];
        }
        
        if (pView.mobileprovisionDisTF.stringValue) {
            [disDic addEntriesFromDictionary:@{pView.mobileprovisionDescriptTF.stringValue:pView.mobileprovisionDisTF.stringValue}];
        }
        
    }
    
    // 是否存在自定义ipa名称
    if (self.cSchemeModel.ArchiveAction.customArchiveName.length == 0) {
        self.archiveModel.configModel.customIpaName = self.cSchemeModel.xq_schemeName;
    }else {
        self.archiveModel.configModel.customIpaName = self.cSchemeModel.ArchiveAction.customArchiveName;
    }
    
    self.archiveModel.devPlistModel.provisioningProfiles = devDic;
    self.archiveModel.disPlistModel.provisioningProfiles = disDic;
    
    [self.archiveModel save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_XQArchiveConfigModel_ChangeInfo object:nil];
    [self dismissController:nil];
}

#pragma mark - XQEditViewDelegate

- (void)editView:(XQEditView *)editView didSelectConvenientConfig:(NSButton *)sender {
    [XQOpenPanel beginSheetModalWithWindow:self.view.window configPanel:^(NSOpenPanel *openPanel) {
        openPanel.canCreateDirectories = NO;
        openPanel.canChooseFiles = NO;
    } openCallback:^(NSString *path) {
        NSLog(@"path: %@", path);
        
        
        NSFileManager *f = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *arr = [f contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
            return;
        }
        
        BOOL xcodeproj = NO;
        BOOL xcworkspace = NO;
        
        for (NSString *name in arr) {
            if ([name hasSuffix:@".xcworkspace"]) {
                self.editView.xcworkspacePathTF.stringValue = [path stringByAppendingPathComponent:name];
                xcworkspace = YES;
            }else if ([name hasSuffix:@".xcodeproj"]) {
                self.editView.xcodeprojPathTF.stringValue = [path stringByAppendingPathComponent:name];
                xcodeproj = YES;
            }
        }
        
        [self updateData];
        
    } cancelCallback:nil];
}

- (void)editView:(XQEditView *)editView didSelectSaveConfig:(NSButton *)sender {
    [self saveConfig];
}

- (void)editView:(XQEditView *)editView didSelectChangeTarget:(NSPopUpButton *)sender {
    self.editView.currentTargetTF.stringValue = sender.selectedItem.title ? sender.selectedItem.title : @"";
    self.archiveModel.configModel.schemeName = sender.selectedItem.title;
    [self refreshTarget];
}

#pragma mark - get set

- (NSMutableArray<PBXTarget *> *)appTargetsArr {
    if (!_appTargetsArr) {
        _appTargetsArr = [NSMutableArray new];
    }
    return _appTargetsArr;
}

@end











