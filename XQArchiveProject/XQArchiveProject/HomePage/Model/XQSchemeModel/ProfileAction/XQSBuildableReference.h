//
//  XQSBuildableReference.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSBuildableReference : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, copy) NSString *BuildableName;
/** 对于 project.pbxproj 里面 target 的 id */
@property (nonatomic, copy) NSString *BlueprintIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSString *BuildableIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSString *BlueprintName;
/** <#note#> */
@property (nonatomic, copy) NSString *ReferencedContainer;

/*
{
    "BuildableName" : "XQArchiveDemo.app",
    "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
    "BuildableIdentifier" : "primary",
    "BlueprintName" : "XQArchiveDemo",
    "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
}
*/
 
@end

NS_ASSUME_NONNULL_END
