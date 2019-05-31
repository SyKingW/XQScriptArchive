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

#import "XQMobileprovision.h"

@interface XQEditVC () <XQEditViewDelegate>

/** <#note#> */
@property (nonatomic, strong) XQEditView *editView;

/**
 app tagets
 */
@property (nonatomic, strong) NSMutableArray <PBXTarget *> *appTargetsArr;

/**
 当前 app tagets
 */
@property (nonatomic, strong) PBXTarget *cAppTargets;

/**
 描述文件
 */
@property (nonatomic, strong) XQMobileprovision *mobileprovision;

@end

@implementation XQEditVC

/**
 出现错误: NSNib _initWithNibNamed:bundle:optio 找不到 nib
 是因为调用 self.view 的时候, 如果 self.view 为 nil 在这个方法中, 父类默认去加载nib, 所以如果 nibName 为 nil 情况下, 获取不到 xib, 就直接报错了
 
 如果在 self.view 中 loadView
 */
- (void)loadView {
    NSLog(@"%s", __func__);
    
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
            _editView = [[XQEditView alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
            [self setValue:_editView forKey:@"view"];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.editView.delegate = self;
    
//    NSData *data = [NSData dataWithContentsOfFile:@"/Users/wangxingqian/Desktop/Blog/XQScriptArchive/XQArchiveDemo/XQArchiveDemo.xcodeproj/xcshareddata/xcschemes/XQArchiveDemo.xcscheme"];
    
//    NSData *data = [NSData dataWithContentsOfFile:@"/Users/wangxingqian/Desktop/Blog/XQScriptArchive/XQArchiveDemo/XQArchiveDemo.xcodeproj/xcshareddata/xcschemes/XQArchiveDemo.xcscheme"];
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/wangxingqian/Desktop/Blog/XQScriptArchive/XQArchiveProject/XQArchiveProject/Info.plist"];
    
    
    NSLog(@"%@", [XQXMLParser jsonStringForXMLData:data error:nil]);
}

- (void)initUI {
    self.editView.projectNameTF.stringValue = self.archiveModel.configModel.xq_name ? self.archiveModel.configModel.xq_name : @"";
    self.editView.bundleIdTF.stringValue = self.archiveModel.configModel.bundleId ? self.archiveModel.configModel.bundleId : @"";
    self.editView.currentTargetTF.stringValue = self.archiveModel.configModel.schemeName ? self.archiveModel.configModel.schemeName : @"";
    self.editView.xcodeprojPathTF.stringValue = self.archiveModel.configModel.xcodeprojPath ? self.archiveModel.configModel.xcodeprojPath : @"";
    self.editView.xcworkspacePathTF.stringValue = self.archiveModel.configModel.xcworkspacePath ? self.archiveModel.configModel.xcworkspacePath : @"";
    self.editView.teamIdTF.stringValue = self.archiveModel.configModel.teamId ? self.archiveModel.configModel.teamId : @"";
    self.editView.releaseBtn.state = [self.archiveModel.configModel.archiveMode isEqualToString:XQ_Archive_Release] ? NSControlStateValueOn : NSControlStateValueOff;
    self.editView.generateDSYMBtn.state = [self.archiveModel.configModel.generateDSYM isEqualToString:XQ_Archive_on] ? NSControlStateValueOn : NSControlStateValueOff;
    
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
        NSString *value = self.archiveModel.devPlistModel.provisioningProfiles[key];
        XQMobileprovisionModel *model = [XQMobileprovisionModel new];
        model.Name = value;
        
        model.Entitlements = [XQEntitlementsModel new];
        model.Entitlements.applicationIdentifier = key;
        [muArr addObject:model];
    }
    
    self.editView.mobileprovisionModelArr = muArr;
}


- (void)updateData {
    [self refreshTarget];
    [self refreshMobileprovision];
}

- (void)refreshTarget {
    [self.appTargetsArr removeAllObjects];
    
    NSFileManager *f = [NSFileManager defaultManager];
    
    // 解析项目 .pbxproj
    NSString *pbxprojPath = [self.editView.xcodeprojPathTF.stringValue stringByAppendingPathComponent:@"project.pbxproj"];
    
    if ([f fileExistsAtPath:pbxprojPath]) {
        [[PBXProjParser sharedInstance] parseProjectWithPath:pbxprojPath];
        
        for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets) {
            NSLog(@"target: %@", target.rawData);
            
            /**
             target.productType
             com.apple.product-type.application: app
             com.apple.product-type.app-extension: extension
             */
            NSString *productType = target.rawData[@"productType"];
            
            // 是app
            if ([productType isEqualToString:XQ_ProductType_Application]) {
                
                [self.appTargetsArr addObject:target];
                
                
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
                self.editView.currentTargetTF.stringValue = name ? name : @"";
                self.editView.projectNameTF.stringValue = name ? name : @"";
                
                // 这里可能拿到的是 Debug, 不过我感觉无所谓吧...
                XCBuildConfiguration *bc = target.buildConfigurationList.buildConfigurations.firstObject;
                if (bc) {
                    NSLog(@"bc: %@", bc.rawData);
                    
                    // "PRODUCT_BUNDLE_IDENTIFIER" = "xxx";
                    NSString *bundleId = [bc getBuildSetting:@"PRODUCT_BUNDLE_IDENTIFIER"];
                    self.editView.bundleIdTF.stringValue = bundleId ? bundleId : @"";
                    
                    // "CODE_SIGN_STYLE" = Automatic; or Manual;
                    NSString *codeSignStyle = [bc getBuildSetting:@"CODE_SIGN_STYLE"];
                    self.archiveModel.devPlistModel.signingStyle = codeSignStyle;
                    self.archiveModel.disPlistModel.signingStyle = codeSignStyle;
                    
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
                
            }else if ([productType isEqualToString:XQ_ProductType_AppExtension]) {
                // 扩展
                
            }
            
        }
        
    }else {
        NSLog(@"pbxproj no exist: %@", pbxprojPath);
    }
}

- (void)refreshMobileprovision {
    // 获取 mobileprovision name
    NSError *error = nil;
    NSString *bundleId = self.editView.bundleIdTF.stringValue;
    if (bundleId) {
        // 解析 mobileprovision
        XQMobileprovision *model = [XQMobileprovision getSystemMobileprovisionsCollectionWithBundleId:bundleId error:&error];
    }
}


#pragma mark - responds

- (IBAction)respondsToDone:(id)sender {
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

#pragma mark - get set

- (NSMutableArray<PBXTarget *> *)appTargetsArr {
    if (!_appTargetsArr) {
        _appTargetsArr = [NSMutableArray new];
    }
    return _appTargetsArr;
}

@end
