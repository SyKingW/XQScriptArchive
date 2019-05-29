//
//  XQArchiveModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/29.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQArchiveModel : NSObject

/** model 唯一的 id */
@property (nonatomic, copy) NSString *xq_id;
/** model 的名称 */
@property (nonatomic, copy) NSString *xq_name;
/** model 路径 */
@property (nonatomic, copy) NSString *xq_path;

/**
 删除model
 */
- (BOOL)deleteModel;

@end

NS_ASSUME_NONNULL_END
