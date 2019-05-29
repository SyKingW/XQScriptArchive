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

#import "XQTestVC.h"

#import "XQArchiveProjectModel.h"

#import "XQHomePageItem.h"
#import "XQHomePageAddItem.h"

#define XQ_VC_ADD @"add"


@interface ViewController () <NSCollectionViewDelegate, NSCollectionViewDataSource>

@property (weak) IBOutlet NSCollectionView *collectionView;

@property (weak) IBOutlet NSCollectionViewFlowLayout *flowLayout;

/** <#note#> */
@property (nonatomic, strong) NSMutableArray <XQArchiveProjectModel *> *dataArr;

@end

@implementation ViewController

#pragma mark - Cycle life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[[NSNib alloc] initWithNibNamed:XQ_XQHomePageItem_Item bundle:nil] forItemWithIdentifier:XQ_XQHomePageItem_Item];
    [self.collectionView registerNib:[[NSNib alloc] initWithNibNamed:XQ_XQHomePageAddItem_item bundle:nil] forItemWithIdentifier:XQ_XQHomePageAddItem_item];
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_changeInfo:) name:Notification_XQArchiveConfigModel_ChangeInfo object:nil];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    NSLog(@"%s", __func__);
}

#pragma mark - Other Method

- (void)getData {
    NSError *error = nil;
    self.dataArr = [XQArchiveProjectModel getLocalDataArrWithError:&error].mutableCopy;
    if (error) {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
    }
    
    // 添加
    XQArchiveProjectModel *model = [XQArchiveProjectModel new];
    model.xq_id = XQ_VC_ADD;
    [self.dataArr addObject:model];
    
    [self.collectionView reloadData];
}

- (void)addProject {
    NSError *error = nil;
    XQArchiveProjectModel *model = [XQArchiveProjectModel createProjectWithError:&error];
    if (error) {
        [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
        return;
    }
    
    [self.dataArr insertObject:model atIndex:0];
    
    NSSet *set = [NSSet setWithObject:[NSIndexPath indexPathForItem:0 inSection:0]];
    [self.collectionView insertItemsAtIndexPaths:set];
}

#pragma mark - responds

- (IBAction)respondsToTest:(NSButton *)sender {
    XQTestVC *vc = [[XQTestVC alloc] initWithNibName:@"XQTestVC" bundle:nil];
    [self presentViewControllerAsModalWindow:vc];
}

#pragma mark - Notification

- (void)notification_changeInfo:(NSNotification *)sender {
    [self getData];
}

#pragma mark - NSCollectionViewDataSource

// 分区
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    NSLog(@"%s", __func__);
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%s", __func__);
    return self.dataArr.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    XQArchiveProjectModel *model = self.dataArr[indexPath.item];
    XQ_WS(weakSelf);
    
    if ([model.xq_id isEqualToString:XQ_VC_ADD]) {
        XQHomePageAddItem *item = [collectionView makeItemWithIdentifier:XQ_XQHomePageAddItem_item forIndexPath:indexPath];
        item.callback = ^{
            [weakSelf addProject];
        };
        return item;
    }
    
    XQHomePageItem *item = [collectionView makeItemWithIdentifier:XQ_XQHomePageItem_Item forIndexPath:indexPath];
    item.archiveModel = model;
    
    item.callback = ^(XQHomePageItem *item, XQHomePageItemTap tapType) {
        switch (tapType) {
            case XQHomePageItemTapBuild: {
                [item.archiveModel build];
            }
                break;
                
            case XQHomePageItemTapBuildXcarchive: {
                [item.archiveModel terminate];
            }
                break;
                
            case XQHomePageItemTapIpa: {
                
            }
                break;
                
            case XQHomePageItemTapDYSM: {
                
            }
                break;
                
            case XQHomePageItemTapDelete:{
                if ([item.archiveModel deleteModel]) {
                    [weakSelf.dataArr removeObject:item.archiveModel];
                    [weakSelf.collectionView reloadData];
                }else {
                    [XQAlertSystem alertErrorWithWithWindow:self.view.window domain:@"删除失败" code:100 userInfo:nil callback:nil];
                }
                
            }
                break;
                
            default:
                break;
        }
    };
    
    return item;
}

#pragma mark - get

- (NSMutableArray<XQArchiveProjectModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
















