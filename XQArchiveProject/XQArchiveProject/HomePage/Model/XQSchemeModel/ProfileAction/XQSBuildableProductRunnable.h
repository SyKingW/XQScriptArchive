//
//  XQSBuildableProductRunnable.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSBuildableReference.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSBuildableProductRunnable : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, strong) XQSBuildableReference *BuildableReference;
/** <#note#> */
@property (nonatomic, assign) NSInteger runnableDebuggingMode;

/*
{
    "BuildableReference" : {
        "BuildableName" : "XQArchiveDemo.app",
        "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
        "BuildableIdentifier" : "primary",
        "BlueprintName" : "XQArchiveDemo",
        "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
    },
    "runnableDebuggingMode" : "0"
}
 */

@end

NS_ASSUME_NONNULL_END
