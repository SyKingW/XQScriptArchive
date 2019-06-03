//
//  XQSchemeArchiveActionModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeArchiveActionModel : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, assign) BOOL revealArchiveInOrganizer;
/** <#note#> */
@property (nonatomic, copy) NSString *buildConfiguration;
/** 自定义的 archiveName */
@property (nonatomic, copy) NSString *customArchiveName;

/*
{
    "revealArchiveInOrganizer" : "YES",
    "buildConfiguration" : "Release",
    "customArchiveName" : "XQArchiveHaHa"
}
 */

@end

NS_ASSUME_NONNULL_END
