//
//  XQSchemeBuildActionModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSBuildActionEntries.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeBuildActionModel : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, assign) BOOL parallelizeBuildables;
/** <#note#> */
@property (nonatomic, assign) BOOL buildImplicitDependencies;
/** <#note#> */
@property (nonatomic, strong) XQSBuildActionEntries *BuildActionEntries;

/*
{
    "parallelizeBuildables" : "YES",
    "buildImplicitDependencies" : "YES",
    "BuildActionEntries" : {
        "BuildActionEntry" : {
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
    }
}
 */

@end

NS_ASSUME_NONNULL_END
