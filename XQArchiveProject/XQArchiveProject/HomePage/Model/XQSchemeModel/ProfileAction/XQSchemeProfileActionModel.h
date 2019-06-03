//
//  XQSchemeProfileActionModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSBuildableProductRunnable.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeProfileActionModel : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, assign) BOOL shouldUseLaunchSchemeArgsEnv;
/** <#note#> */
@property (nonatomic, copy) NSString *savedToolIdentifier;
/** <#note#> */
@property (nonatomic, strong) XQSBuildableProductRunnable *BuildableProductRunnable;
/** <#note#> */
@property (nonatomic, assign) BOOL debugDocumentVersioning;
/** <#note#> */
@property (nonatomic, assign) BOOL useCustomWorkingDirectory;
/** <#note#> */
@property (nonatomic, copy) NSString *buildConfiguration;

/*
{
    "shouldUseLaunchSchemeArgsEnv" : "YES",
    "savedToolIdentifier" : "",
    "BuildableProductRunnable" : {
        "BuildableReference" : {
            "BuildableName" : "XQArchiveDemo.app",
            "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
            "BuildableIdentifier" : "primary",
            "BlueprintName" : "XQArchiveDemo",
            "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
        },
        "runnableDebuggingMode" : "0"
    },
    "debugDocumentVersioning" : "YES",
    "useCustomWorkingDirectory" : "NO",
    "buildConfiguration" : "Release"
}
*/

@end

NS_ASSUME_NONNULL_END
