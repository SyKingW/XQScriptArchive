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
#import <Masonry/Masonry.h>

#import "XQEditView.h"

#import "XQArchiveProjectModel.h"

#import "XQXMLParser.h"

#import "PBXProjectManager.h"

#import "XQMobileprovision.h"

@interface XQEditVC ()

/** <#note#> */
@property (nonatomic, strong) XQEditView *editView;

@property (weak) IBOutlet NSClipView *clipView;
@property (weak) IBOutlet NSView *contentView;

@property (weak) IBOutlet NSTextField *nameTF;
@property (weak) IBOutlet NSTextField *bundleIdTF;
@property (weak) IBOutlet NSTextField *schemeNameTF;
@property (weak) IBOutlet NSTextField *xcodeprojPathTF;
@property (weak) IBOutlet NSTextField *xcworkspacePathTF;
@property (weak) IBOutlet NSTextField *teamIdTF;
@property (weak) IBOutlet NSTextField *mobileprovisionUUIDTF;
@property (weak) IBOutlet NSButton *releaseBtn;
@property (weak) IBOutlet NSButton *automaticBtn;
@property (weak) IBOutlet NSButton *generateDSYMBtn;


@property (weak) IBOutlet NSTextField *buildSavePathTF;
@property (weak) IBOutlet NSTextField *plistpPathTF;

@property (weak) IBOutlet NSTextField *appleIdTF;
@property (weak) IBOutlet NSTextField *appleIdPwdTF;
@property (weak) IBOutlet NSButton *upAppStoreBtn;

@property (weak) IBOutlet NSTextField *firTokenTF;
@property (weak) IBOutlet NSButton *upFirBtn;

@property (weak) IBOutlet NSTextField *buglyAppIdTF;
@property (weak) IBOutlet NSTextField *buglyAppKeyTF;
@property (weak) IBOutlet NSTextField *buglyAppVersionTF;
@property (weak) IBOutlet NSButton *upBuglyBtn;

@end

@implementation XQEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editView = [XQEditView new];
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    return;
    [self initUI];
}

- (void)initUI {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.clipView);
        // 最小宽高
        make.width.mas_greaterThanOrEqualTo(150);
        make.height.mas_greaterThanOrEqualTo(250);
        
        // 设置等于父视图, 但是, 等级调为低
        make.width.height.equalTo(self.clipView).priorityLow();
    }];
    
    self.nameTF.stringValue = self.archiveModel.configModel.xq_name ? self.archiveModel.configModel.xq_name : @"";
    self.bundleIdTF.stringValue = self.archiveModel.configModel.bundleId ? self.archiveModel.configModel.bundleId : @"";
    self.schemeNameTF.stringValue = self.archiveModel.configModel.schemeName ? self.archiveModel.configModel.schemeName : @"";
    self.xcodeprojPathTF.stringValue = self.archiveModel.configModel.xcodeprojPath ? self.archiveModel.configModel.xcodeprojPath : @"";
    self.xcworkspacePathTF.stringValue = self.archiveModel.configModel.xcworkspacePath ? self.archiveModel.configModel.xcworkspacePath : @"";
    self.teamIdTF.stringValue = self.archiveModel.configModel.teamId ? self.archiveModel.configModel.teamId : @"";
    self.releaseBtn.state = [self.archiveModel.configModel.archiveMode isEqualToString:XQ_Archive_Release] ? NSControlStateValueOn : NSControlStateValueOff;
    self.generateDSYMBtn.state = [self.archiveModel.configModel.generateDSYM isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.buildSavePathTF.stringValue = self.archiveModel.configModel.buildPath ? self.archiveModel.configModel.buildPath : @"";
    self.plistpPathTF.stringValue = self.archiveModel.configModel.projectPlistPath ? self.archiveModel.configModel.projectPlistPath : @"";
    
    self.appleIdTF.stringValue = self.archiveModel.configModel.appleId ? self.archiveModel.configModel.appleId : @"";
    self.appleIdPwdTF.stringValue = self.archiveModel.configModel.appleIdPwd ? self.archiveModel.configModel.appleIdPwd : @"";
    self.upAppStoreBtn.state = [self.archiveModel.configModel.upAppStore isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.firTokenTF.stringValue = self.archiveModel.configModel.firToken ? self.archiveModel.configModel.firToken : @"";
    self.upFirBtn.state = [self.archiveModel.configModel.upFir isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.buglyAppIdTF.stringValue = self.archiveModel.configModel.buglyAppId ? self.archiveModel.configModel.buglyAppId : @"";
    self.buglyAppKeyTF.stringValue = self.archiveModel.configModel.buglyAppKey ? self.archiveModel.configModel.buglyAppKey : @"";
    self.buglyAppVersionTF.stringValue = self.archiveModel.configModel.buglyAppVersion ? self.archiveModel.configModel.buglyAppVersion : @"";
    self.upBuglyBtn.state = [self.archiveModel.configModel.buglyUploadDSYM isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
}

- (void)updateViewWithProjectPath:(NSString *)path {
    NSFileManager *f = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *arr = [f contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
        return;
    }
    
    for (NSString *name in arr) {
        if ([name hasSuffix:@".xcworkspace"]) {
            self.xcworkspacePathTF.stringValue = [path stringByAppendingPathComponent:name];
        }else if ([name hasSuffix:@".xcodeproj"]) {
            self.xcodeprojPathTF.stringValue = [path stringByAppendingPathComponent:name];
            
            // 解析项目 .pbxproj
            NSString *pbxprojPath = [self.xcodeprojPathTF.stringValue stringByAppendingPathComponent:@"project.pbxproj"];
            
            if ([f fileExistsAtPath:pbxprojPath]) {
                [[PBXProjParser sharedInstance] parseProjectWithPath:pbxprojPath];
                
                for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets) {
                    NSLog(@"target: %@", target.rawData);
                    
                    /**
                     target.productType
                     com.apple.product-type.application: app
                     com.apple.product-type.app-extension: extension
                     */
                    // 是app
                    if ([target.rawData[@"productType"] isEqualToString:@"com.apple.product-type.application"]) {
                        
                        for (PBXBuildPhases *buildPhases in target.buildPhases) {
                            
                            /**
                             根据 isa 执行来判断
                             
                             PBXShellScriptBuildPhase: 脚本
                             PBXSourcesBuildPhase: 源码资源
                             PBXFrameworksBuildPhase: framework
                             PBXResourcesBuildPhase: 资源文件
                             PBXCopyFilesBuildPhase: extension (系统默认 name: Embed App Extensions)
                             */
                            if ([[buildPhases getISA] isEqualToString:@"PBXCopyFilesBuildPhase"]) {
                                // 获取到项目依赖的库, 从这里面筛选出来 Extension
                                NSLog(@"buildPhases: %@", buildPhases.rawData);
                                NSLog(@"files: %@", buildPhases.files);
                                for (PBXBuildFile *file in buildPhases.files) {
                                    NSLog(@"file: %@", file.rawData);
                                    NSString *targetId = file.rawData[@"fileRef"];
                                    for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets) {
                                        if ([target.rawData[@"productReference"] isEqualToString:targetId]) {
                                            
                                            // 再判断一下是否是扩展
                                            if ([target.rawData[@"productType"] isEqualToString:@"com.apple.product-type.app-extension"]) {
                                                NSLog(@"找到引用的 target 了: %@", target.rawData);
                                            }
                                            
                                            break;
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        // scheme name
                        NSString *name = [target getName];
                        self.schemeNameTF.stringValue = name ? name : @"";
                        self.nameTF.stringValue = name ? name : @"";
                        
                        // 这里可能拿到的是 Debug, 不过我感觉无所谓吧...
                        XCBuildConfiguration *bc = target.buildConfigurationList.buildConfigurations.firstObject;
                        if (bc) {
                            NSLog(@"bc: %@", bc.rawData);
                            
                            // "PRODUCT_BUNDLE_IDENTIFIER" = "xxx";
                            NSString *bundleId = [bc getBuildSetting:@"PRODUCT_BUNDLE_IDENTIFIER"];
                            self.bundleIdTF.stringValue = bundleId ? bundleId : @"";
                            
                            // "CODE_SIGN_STYLE" = Automatic; or Manual;
                            NSString *codeSignStyle = [bc getBuildSetting:@"CODE_SIGN_STYLE"];
                            self.archiveModel.devPlistModel.signingStyle = codeSignStyle;
                            self.archiveModel.disPlistModel.signingStyle = codeSignStyle;
                            
                            // "DEVELOPMENT_TEAM" = xxx;
                            NSString *team = [bc getBuildSetting:@"DEVELOPMENT_TEAM"];
                            self.teamIdTF.stringValue = team ? team : @"";
                            
                            // "INFOPLIST_FILE" = "XQTestDemo/Info.plist";
                            NSString *infoPlist = [bc getBuildSetting:@"INFOPLIST_FILE"];
                            NSString *plistPath = [path stringByAppendingPathComponent:infoPlist];
                            self.plistpPathTF.stringValue = plistPath;
                            
                            
                            // 获取 mobileprovision name
                            NSError *error = nil;
                            if (bundleId) {
                                // 解析 mobileprovision
                                NSArray <XQMobileprovisionModel *> *arr = [XQMobileprovision getSystemMobileprovisionsWithBundleId:bundleId error:&error];
                                if (error) {
                                    [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
                                }else {
                                    for (XQMobileprovisionModel *model in arr) {
                                        if ([model.Entitlements.apsEnvironment isEqualToString:@"production"]) {
                                            // 系统导出的 plist 是 mobileprovision 的 name
                                            self.mobileprovisionUUIDTF.stringValue = model.Name ? model.Name : @"";
                                            NSLog(@"mobileprovision: %@", model.rawDic);
                                            break;
                                        }
                                        
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                    }else {
                       // 扩展
                    }
                    
                }
                
            }else {
                NSLog(@"pbxproj no exist: %@", pbxprojPath);
            }
            
        }
    }
}

#pragma mark - responds

- (IBAction)respondsToConvenient:(id)sender {
    
    [XQOpenPanel beginSheetModalWithWindow:self.view.window configPanel:^(NSOpenPanel *openPanel) {
        openPanel.canCreateDirectories = NO;
        openPanel.canChooseFiles = NO;
    } openCallback:^(NSString *path) {
        NSLog(@"path: %@", path);
        [self updateViewWithProjectPath:path];
        
    } cancelCallback:nil];
}

- (IBAction)respondsToDone:(id)sender {
    self.archiveModel.configModel.xq_name = self.nameTF.stringValue;
    self.archiveModel.configModel.bundleId = self.bundleIdTF.stringValue;
    self.archiveModel.configModel.schemeName = self.schemeNameTF.stringValue;
    self.archiveModel.configModel.xcodeprojPath = self.xcodeprojPathTF.stringValue;
    self.archiveModel.configModel.xcworkspacePath = self.xcworkspacePathTF.stringValue;
    self.archiveModel.configModel.teamId = self.teamIdTF.stringValue;
    self.archiveModel.configModel.archiveMode = self.releaseBtn.state == NSControlStateValueOn ? XQ_Archive_Release : XQ_Archive_Debug;
    self.archiveModel.configModel.generateDSYM = self.generateDSYMBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.configModel.buildPath = self.buildSavePathTF.stringValue;
    self.archiveModel.configModel.projectPlistPath = self.plistpPathTF.stringValue;
    
    self.archiveModel.configModel.appleId = self.appleIdTF.stringValue;
    self.archiveModel.configModel.appleIdPwd = self.appleIdPwdTF.stringValue;
    self.archiveModel.configModel.upAppStore = self.upAppStoreBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.configModel.firToken = self.firTokenTF.stringValue;
    self.archiveModel.configModel.upFir = self.upFirBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    self.archiveModel.configModel.buglyAppId = self.buglyAppIdTF.stringValue;
    self.archiveModel.configModel.buglyAppKey = self.buglyAppKeyTF.stringValue;
    self.archiveModel.configModel.buglyAppVersion = self.buglyAppVersionTF.stringValue;
    self.archiveModel.configModel.buglyUploadDSYM = self.upBuglyBtn.state == NSControlStateValueOn ? XQ_Archive_on : XQ_Archive_off;
    
    [self.archiveModel save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_XQArchiveConfigModel_ChangeInfo object:nil];
    [self dismissController:nil];
}

@end
