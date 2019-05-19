//
//  XQTestVC.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/17.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQTestVC.h"
#import <XQProjectTool/XQTask.h>
#import "XQArchiveTask.h"

#import <XQProjectTool/XQOpenPanel.h>
#import <XQProjectTool/XQAlertSystem.h>

@interface XQTestVC ()

@end

@implementation XQTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
}

#pragma mark - responds

- (IBAction)respondsToExecuteShell:(id)sender {
    
    [[XQTask manager] xq_executeBinShWithCmd:@"/Users/wangxingqian/Desktop/XQTestDemo/XQArchiveDemo/xq_test.sh"];
    
    
    return;
    
    [XQOpenPanel beginSheetModalWithWindow:self.view.window configPanel:^(NSOpenPanel *openPanel) {
        openPanel.allowedFileTypes = @[@"sh"];
    } openCallback:^(NSString *path) {
        [[XQTask manager] xq_executeBinShWithCmd:path];
    } cancelCallback:nil];
}

- (IBAction)respondsToAppleScript:(id)sender {
    return;
    [XQOpenPanel beginSheetModalWithWindow:self.view.window openCallback:^(NSString *path) {
        if ([path hasSuffix:@".sh"]) {
            [[XQTask manager] xq_appleScriptWithUrl:[NSURL fileURLWithPath:path]];
        }else {
            [XQAlertSystem alertErrorWithWithWindow:self.view.window domain:@"只能执行 .sh 文件" code:0 userInfo:nil callback:^(NSInteger index) {
                
            }];
        }
        
    } cancelCallback:^{
        
    }];
    
}

@end
