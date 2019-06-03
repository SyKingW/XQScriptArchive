//
//  XQSchemeModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import <YYModel/YYModel.h>

#import "XQSchemeAnalyzeActionModel.h"
#import "XQSchemeArchiveActionModel.h"
#import "XQSchemeProfileActionModel.h"
#import "XQSchemeLaunchActionModel.h"
#import "XQSchemeTestActionModel.h"
#import "XQSchemeBuildActionModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeModel : XQSchemeBaseModel

/** 其实就是文件名, 不带 .xcscheme */
@property (nonatomic, copy) NSString *xq_schemeName;

/** <#note#> */
@property (nonatomic, strong) XQSchemeAnalyzeActionModel *AnalyzeAction;
/** <#note#> */
@property (nonatomic, strong) XQSchemeArchiveActionModel *ArchiveAction;
/** <#note#> */
@property (nonatomic, strong) XQSchemeProfileActionModel *ProfileAction;
/** <#note#> */
@property (nonatomic, strong) XQSchemeLaunchActionModel *LaunchAction;
/** <#note#> */
@property (nonatomic, strong) XQSchemeTestActionModel *TestAction;
/** <#note#> */
@property (nonatomic, strong) XQSchemeBuildActionModel *BuildAction;

/** <#note#> */
@property (nonatomic, copy) NSString *version;
/** <#note#> */
@property (nonatomic, copy) NSString *LastUpgradeVersion;

/**
 传入.xcscheme文件路径, 获取model
 */
+ (XQSchemeModel *)schemeModelWithFilePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

/*
{
    "AnalyzeAction" : {
        "buildConfiguration" : "Debug"
    },
    "ArchiveAction" : {
        "revealArchiveInOrganizer" : YES,
        "buildConfiguration" : "Release"
    },
    "ProfileAction" : {
        "savedToolIdentifier" : "",
        "buildConfiguration" : "Release",
        "BuildableProductRunnable" : {
            "BuildableReference" : {
                "BuildableName" : "XQArchiveDemo.app",
                "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
                "BuildableIdentifier" : "primary",
                "BlueprintName" : "XQArchiveDemo",
                "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
            },
            "runnableDebuggingMode" : 0
        },
        "shouldUseLaunchSchemeArgsEnv" : YES,
        "useCustomWorkingDirectory" : NO,
        "debugDocumentVersioning" : YES
    },
    "LaunchAction" : {
        "BuildableProductRunnable" : {
            "BuildableReference" : {
                "BuildableName" : "XQArchiveDemo.app",
                "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
                "BuildableIdentifier" : "primary",
                "BlueprintName" : "XQArchiveDemo",
                "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
            },
            "runnableDebuggingMode" : 0
        },
        "AdditionalOptions" : {
            
        },
        "ignoresPersistentStateOnLaunch" : NO,
        "debugServiceExtension" : "internal",
        "debugDocumentVersioning" : YES,
        "selectedDebuggerIdentifier" : "Xcode.DebuggerFoundation.Debugger.LLDB",
        "selectedLauncherIdentifier" : "Xcode.DebuggerFoundation.Launcher.LLDB",
        "useCustomWorkingDirectory" : NO,
        "launchStyle" : "0",
        "allowLocationSimulation" : YES,
        "buildConfiguration" : "Release"
    },
    "version" : "1.3",
    "LastUpgradeVersion" : 1020,
    "TestAction" : {
        "MacroExpansion" : {
            "BuildableReference" : {
                "BuildableName" : "XQArchiveDemo.app",
                "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
                "BuildableIdentifier" : "primary",
                "BlueprintName" : "XQArchiveDemo",
                "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
            }
        },
        "shouldUseLaunchSchemeArgsEnv" : YES,
        "AdditionalOptions" : {
            
        },
        "selectedDebuggerIdentifier" : "Xcode.DebuggerFoundation.Debugger.LLDB",
        "selectedLauncherIdentifier" : "Xcode.DebuggerFoundation.Launcher.LLDB",
        "Testables" : {
            
        },
        "buildConfiguration" : "Debug"
    },
    "BuildAction" : {
        "BuildActionEntries" : {
            "BuildActionEntry" : {
                "BuildableReference" : {
                    "BuildableName" : "XQArchiveDemo.app",
                    "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
                    "BuildableIdentifier" : "primary",
                    "BlueprintName" : "XQArchiveDemo",
                    "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
                },
                "buildForAnalyzing" : YES,
                "buildForTesting" : YES,
                "buildForArchiving" : YES,
                "buildForRunning" : YES,
                "buildForProfiling" : YES"
            }
        },
        "parallelizeBuildables" : YES,
        "buildImplicitDependencies" : YES
    }
}

*/

