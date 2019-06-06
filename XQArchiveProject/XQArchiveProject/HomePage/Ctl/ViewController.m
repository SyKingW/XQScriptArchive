//
//  ViewController.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/17.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <XQProjectTool/XQCommonHeader.h>
#import <XQProjectTool/XQAlertSystem.h>

#import "XQProjectVC.h"
#import "XQDoneTaskVC.h"
#import "XQTaskVC.h"

#import "XQTestVC.h"

#import "XQArchiveProjectModel.h"

#import "XQTestScrollViewVC.h"

#import "XQUserNotification.h"

@interface ViewController ()

@property (weak) IBOutlet NSButton *projectBtn;
@property (weak) IBOutlet NSButton *taskingBtn;
@property (weak) IBOutlet NSButton *doneTaskBtn;

@property (weak) IBOutlet NSView *contentView;

/** <#note#> */
@property (nonatomic, strong) XQProjectVC *pVC;
/** <#note#> */
@property (nonatomic, strong) XQTaskVC *tVC;
/** <#note#> */
@property (nonatomic, strong) XQDoneTaskVC *dVC;

/** <#note#> */
@property (nonatomic, assign) NSUInteger index;

@end

@implementation ViewController

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pVC = [[XQProjectVC alloc] initWithNibName:@"XQProjectVC" bundle:nil];
    self.tVC = [[XQTaskVC alloc] initWithNibName:@"XQTaskVC" bundle:nil];
    self.dVC = [[XQDoneTaskVC alloc] initWithNibName:@"XQDoneTaskVC" bundle:nil];
    
    [self addChildViewController:self.pVC];
    [self addChildViewController:self.tVC];
    [self addChildViewController:self.dVC];
    
    self.index = 100;
    [self changeProjectView];
}

#pragma mark - Other Method

- (void)xq_removeSubViews {
    NSArray *arr = self.contentView.subviews.copy;
    for (NSView *view in arr) {
        [view removeFromSuperview];
    }
}

- (void)changeProjectView {
    if (self.index == 0) {
        return;
    }
    
    self.index = 0;
    
    [self xq_removeSubViews];
    [self.contentView addSubview:self.pVC.view];
    [self.pVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)changeTaskView {
    if (self.index == 1) {
        return;
    }
    
    self.index = 1;
    
    [self xq_removeSubViews];
    [self.contentView addSubview:self.tVC.view];
    [self.tVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)changeDoneTaskView {
    if (self.index == 2) {
        return;
    }
    
    self.index = 2;
    
    [self xq_removeSubViews];
    [self.contentView addSubview:self.dVC.view];
    [self.dVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - responds

- (IBAction)respondsToTest:(NSButton *)sender {
//    XQTestVC *vc = [[XQTestVC alloc] initWithNibName:@"XQTestVC" bundle:nil];
    XQTestVC *vc = [XQTestVC new];
    [self presentViewControllerAsModalWindow:vc];
}

- (IBAction)respondsToProject:(NSButton *)sender {
    [self changeProjectView];
}

- (IBAction)respondsToExecutingTask:(NSButton *)sender {
    [self changeTaskView];
    
    return;
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"title";
    content.subtitle = @"subtitle";
    content.body = @"body";
    NSString *iden = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970];
    [XQUserNotification addTimeIntervalNotificationWithIdentifier:iden timeInterval:1 content:content repeats:NO withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
        }else {
            NSLog(@"添加成功");
        }
    }];
    
    
    // 获取未触发的通知
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"%@", requests);
    }];
    
    // 获取已显示, 但用户还没点的通知
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"%@", requests);
    }];
    
    
}

- (IBAction)respondsToDoneTask:(NSButton *)sender {
    [self changeDoneTaskView];
}

@end
















