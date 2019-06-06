//
//  XQProjectVC.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/4.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQProjectVC.h"
#import <Masonry/Masonry.h>
#import <XQProjectTool/XQCommonHeader.h>
#import <XQProjectTool/XQAlertSystem.h>

#import "XQArchiveProjectModel.h"

#import "XQHomePageItem.h"
#import "XQHomePageAddItem.h"


#import "XQTestScrollViewVC.h"

#define XQ_VC_ADD @"add"

@interface XQProjectVC () <NSCollectionViewDelegate, NSCollectionViewDataSource>

@property (weak) IBOutlet NSCollectionView *collectionView;

@property (weak) IBOutlet NSCollectionViewFlowLayout *flowLayout;

/** <#note#> */
@property (nonatomic, strong) NSMutableArray <XQArchiveProjectModel *> *dataArr;

/** <#note#> */
@property (nonatomic, strong) NSMutableString *tempText;

@end

@implementation XQProjectVC

#pragma mark - life Cycle

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



#pragma mark - Notification

- (void)notification_changeInfo:(NSNotification *)sender {
    [self getData];
}

#pragma mark - NSCollectionViewDataSource

// 分区
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
                if (!weakSelf.tempText) {
                    weakSelf.tempText = [NSMutableString new];
                }
                
                NSError *error = nil;
                
                [item.archiveModel buildReleaseWithError:&error outLogHandle:^(NSString * _Nonnull log) {
                    [weakSelf.tempText appendString:log];
                } errorLogHandle:^(NSString * _Nonnull log) {
                    [weakSelf.tempText appendString:log];
                } terminationHandler:^(NSTask * _Nonnull task) {
                    
                    NSFileManager *f = [NSFileManager defaultManager];
                    NSString *path = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
                    path = [path stringByAppendingPathComponent:@"xq_test123.txt"];
                    if ([f fileExistsAtPath:path]) {
                        [f removeItemAtPath:path error:nil];
                    }
                    
                    if (![f createFileAtPath:path contents:[weakSelf.tempText dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
                        [XQAlertSystem alertErrorWithWithWindow:self.view.window domain:@"写入失败" code:1000 userInfo:nil callback:nil];
                    }
                    
                }];
                
                if (error) {
                    [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
                }else {
                    // 改变视图
                    
                }
                
            }
                break;
                
            case XQHomePageItemTapBuildDebug:{
                NSError *error = nil;
                [item.archiveModel buildDebugWithError:&error outLogHandle:^(NSString * _Nonnull log) {
                    [weakSelf.tempText appendString:log];
                } errorLogHandle:^(NSString * _Nonnull log) {
                    [weakSelf.tempText appendString:log];
                } terminationHandler:^(NSTask * _Nonnull task) {
                    
                }];
                if (error) {
                    [XQAlertSystem alertErrorWithWithWindow:self.view.window error:error callback:nil];
                }else {
                    // 改变视图
                    
                }
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

















