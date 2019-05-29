//
//  ProfilesNode.h
//  ProfilesManager
//
//  Created by Jakey on 15/4/30.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//


/**
 wxq: 原地址 https://github.com/shaojiankui/ProfilesManager
 */

#import <Foundation/Foundation.h>

@interface ProfilesNode : NSObject

@property (nonatomic, weak) ProfilesNode *rootNode;

@property (nonatomic, copy) NSArray *childrenNodes;
@property (nonatomic, copy) NSString *key;
//@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSDictionary *extra;
@property (nonatomic, copy) NSString *expirationDate;
@property (nonatomic, copy) NSString *creationDate;

/**
 wxq 是否已过期
 
 YES: 可用
 NO: 过期
 */
@property (nonatomic, assign) BOOL expiration;

- (id)initWithRootNode:(ProfilesNode *)rootNote originInfo:(id)info key:(NSString*)key;

+ (NSString *)xq_base64WithData:(NSData *)data;

@end
