//
//  XQSchemeTestActionModel.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSMacroExpansion.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSchemeTestActionModel : XQSchemeBaseModel


/** <#note#> */
@property (nonatomic, strong) XQSMacroExpansion *MacroExpansion;
/** <#note#> */
@property (nonatomic, assign) BOOL shouldUseLaunchSchemeArgsEnv;
/** <#note#> */
@property (nonatomic, copy) NSDictionary *AdditionalOptions;
/** <#note#> */
@property (nonatomic, copy) NSString *selectedDebuggerIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSString *selectedLauncherIdentifier;
/** <#note#> */
@property (nonatomic, copy) NSDictionary *Testables;
/** <#note#> */
@property (nonatomic, copy) NSString *buildConfiguration;


/*
{
    "MacroExpansion" : {
        "nodeValue" : "",
        "BuildableReference" : {
            "BuildableName" : "XQArchiveDemo.app",
            "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
            "BuildableIdentifier" : "primary",
            "BlueprintName" : "XQArchiveDemo",
            "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
        }
    },
    "shouldUseLaunchSchemeArgsEnv" : "YES",
    "AdditionalOptions" : {
 
    },
    "selectedDebuggerIdentifier" : "Xcode.DebuggerFoundation.Debugger.LLDB",
    "selectedLauncherIdentifier" : "Xcode.DebuggerFoundation.Launcher.LLDB",
    "Testables" : {
 
    },
    "buildConfiguration" : "Debug"
}
 */

@end

NS_ASSUME_NONNULL_END
