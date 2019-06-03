//
//  XQSchemeLaunchActionModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSBuildableProductRunnable.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeLaunchActionModel : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, strong) XQSBuildableProductRunnable *BuildableProductRunnable;
/** <#note#> */
@property (nonatomic, copy) NSString *selectedLauncherIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSString *buildConfiguration;
/** <#note#> */
@property (nonatomic, copy) NSDictionary *AdditionalOptions;
/** <#note#> */
@property (nonatomic, assign) BOOL useCustomWorkingDirectory;
/** <#note#> */
@property (nonatomic, assign) BOOL ignoresPersistentStateOnLaunch;
/** <#note#> */
@property (nonatomic, assign) BOOL allowLocationSimulation;
/** <#note#> */
@property (nonatomic, copy) NSString *debugServiceExtension;
/** <#note#> */
@property (nonatomic, assign) NSInteger launchStyle;
/** <#note#> */
@property (nonatomic, assign) BOOL debugDocumentVersioning;
/** <#note#> */
@property (nonatomic, copy) NSString *selectedDebuggerIdentifier;

/*
{
    "BuildableProductRunnable" : {
        "BuildableReference" : {
            "BuildableName" : "XQArchiveDemo.app",
            "nodeValue" : "",
            "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
            "BuildableIdentifier" : "primary",
            "BlueprintName" : "XQArchiveDemo",
            "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
        },
        "nodeValue" : "",
        "runnableDebuggingMode" : "0"
    },
    "selectedLauncherIdentifier" : "Xcode.DebuggerFoundation.Launcher.LLDB",
    "buildConfiguration" : "Release",
    "AdditionalOptions" : {
 
    },
    "useCustomWorkingDirectory" : "NO",
    "ignoresPersistentStateOnLaunch" : "NO",
    "allowLocationSimulation" : "YES",
    "debugServiceExtension" : "internal",
    "launchStyle" : "0",
    "debugDocumentVersioning" : "YES",
    "selectedDebuggerIdentifier" : "Xcode.DebuggerFoundation.Debugger.LLDB"
}
 */

@end

NS_ASSUME_NONNULL_END
