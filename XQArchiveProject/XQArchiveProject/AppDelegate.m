//
//  AppDelegate.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/17.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSDictionary *dic = @{
                          @"1":@"1",
                          @"2":@(1),
                          @"3":@(YES),
                          };
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"test.plist"];
    
    path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"XQArchiveProject/xq_shell_config/E855E29C-5A8A-4503-8AB7-A3E6ADE1E3DC/xq_dis_exportOptions.plist"];
    
//    path = @"/Users/wangxingqian/Library/XQArchiveProject/xq_shell_config/E855E29C-5A8A-4503-8AB7-A3E6ADE1E3DC/xq_dis_exportOptions.plist";
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingSortedKeys error:nil];
//    if ([[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil]) {
//        NSLog(@"写入成功");
//    }else {
//        NSLog(@"写入失败");
//    }
    
//    NSError *error = nil;
//    [dic writeToURL:[NSURL fileURLWithPath:path] error:&error];
//    if (!error) {
//        NSLog(@"写入成功");
//    }else {
//        NSLog(@"写入失败: %@", error);
//    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    NSLog(@"%s", __func__);
    // 表示当前是没有window的
    if (!flag) {
        // 获取其中的window, 设到最前
        [sender.windows.firstObject makeKeyAndOrderFront:nil];
    }
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}




@end
