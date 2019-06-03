//
//  XQSchemeBaseModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeBaseModel : NSObject <YYModel>

/** <#note#> */
@property (nonatomic, copy) NSDictionary *rawData;

@end

NS_ASSUME_NONNULL_END
