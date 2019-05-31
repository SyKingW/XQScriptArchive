//
//  XQHomePageItem.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQHomePageItem.h"
#import "XQArchiveProjectModel.h"
#import "XQEditVC.h"

@interface XQHomePageItem ()

@property (weak) IBOutlet NSTextField *nameLab;

@end

@implementation XQHomePageItem


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    self.nameLab.stringValue = self.archiveModel.xq_name ? self.archiveModel.xq_name : @"未命名";
    
    self.view.wantsLayer = YES;
    self.view.layer.borderWidth = 5;
    self.view.layer.borderColor = [NSColor lightGrayColor].CGColor;
}

- (void)setArchiveModel:(XQArchiveProjectModel *)archiveModel {
    _archiveModel = archiveModel;
    self.nameLab.stringValue = [NSString stringWithFormat:@"%@(%@)", self.archiveModel.configModel.xq_name ? self.archiveModel.configModel.xq_name : @"未命名", self.archiveModel.configModel.bundleId];
}

#pragma mark - responds

- (IBAction)respondsToEdit:(NSButton *)sender {
//    XQEditVC *vc = [[XQEditVC alloc] initWithNibName:@"XQEditVC" bundle:nil];
    XQEditVC *vc = [XQEditVC new];
    vc.archiveModel = self.archiveModel;
    
    [self presentViewControllerAsModalWindow:vc];
}

- (IBAction)respondsToBuild:(NSButton *)sender {
    if (self.callback) {
        self.callback(self, XQHomePageItemTapBuild);
    }
}

- (IBAction)respondsToBuildXcarchive:(NSButton *)sender {
    if (self.callback) {
        self.callback(self, XQHomePageItemTapBuildXcarchive);
    }
}

- (IBAction)respondsToUpIpa:(NSButton *)sender {
    if (self.callback) {
        self.callback(self, XQHomePageItemTapIpa);
    }
}

- (IBAction)respondsToUpDSYM:(NSButton *)sender {
    if (self.callback) {
        self.callback(self, XQHomePageItemTapDYSM);
    }
}

- (IBAction)respondsToDel:(id)sender {
    if (self.callback) {
        self.callback(self, XQHomePageItemTapDelete);
    }
}

@end

















