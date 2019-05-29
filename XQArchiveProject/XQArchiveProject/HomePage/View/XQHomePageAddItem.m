//
//  XQHomePageAddItem.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/27.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQHomePageAddItem.h"

@interface XQHomePageAddItem ()

@end

@implementation XQHomePageAddItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
//    self.view.layer.backgroundColor = [NSColor redColor].CGColor;
    self.view.layer.borderWidth = 5;
    self.view.layer.borderColor = [NSColor lightGrayColor].CGColor;;
}

#pragma mark - responds

- (IBAction)respondsToAdd:(NSButton *)sender {
    if (self.callback) {
        self.callback();
    }
}

@end
