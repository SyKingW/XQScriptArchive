//
//  XQSBuildActionEntries.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSBuildableReference.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSBuildActionEntries : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, assign) BOOL buildForRunning;
/** <#note#> */
@property (nonatomic, assign) BOOL buildForTesting;
/** <#note#> */
@property (nonatomic, assign) BOOL buildForAnalyzing;
/** <#note#> */
@property (nonatomic, strong) XQSBuildableReference *BuildableReference;
/** <#note#> */
@property (nonatomic, assign) BOOL buildForProfiling;
/** <#note#> */
@property (nonatomic, assign) BOOL buildForArchiving;

/*
{
    "buildForRunning" : "YES",
    "buildForTesting" : "YES",
    "buildForAnalyzing" : "YES",
    "BuildableReference" : {
        "BuildableName" : "XQArchiveDemo.app",
        "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
        "BuildableIdentifier" : "primary",
        "BlueprintName" : "XQArchiveDemo",
        "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
    },
    "buildForProfiling" : "YES",
    "buildForArchiving" : "YES"
}
*/

@end

NS_ASSUME_NONNULL_END
