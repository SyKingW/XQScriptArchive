//
//  ViewController.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/17.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "ViewController.h"
#import "XQTestVC.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - responds

- (IBAction)respondsToTest:(NSButton *)sender {
    XQTestVC *vc = [[XQTestVC alloc] initWithNibName:@"XQTestVC" bundle:nil];
    [self presentViewControllerAsModalWindow:vc];
}

@end
















