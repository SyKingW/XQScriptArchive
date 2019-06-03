//
//  XQSchemeBaseModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"


@implementation XQSchemeBaseModel

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    // model to json 时, 原始数据不需要
    return @[
             @"rawData"
             ];
}

@end
