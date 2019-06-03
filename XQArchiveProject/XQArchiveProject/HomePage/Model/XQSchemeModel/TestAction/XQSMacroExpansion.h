//
//  XQSMacroExpansion.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeBaseModel.h"
#import "XQSBuildableReference.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQSMacroExpansion : XQSchemeBaseModel

/** <#note#> */
@property (nonatomic, strong) XQSBuildableReference *BuildableReference;

/*
{
    "BuildableReference" : {
        "BuildableName" : "XQArchiveDemo.app",
        "nodeValue" : "",
        "BlueprintIdentifier" : "A44FCDB1228E37EB003B9C58",
        "BuildableIdentifier" : "primary",
        "BlueprintName" : "XQArchiveDemo",
        "ReferencedContainer" : "container:XQArchiveDemo.xcodeproj"
    }
}
*/
 
@end

NS_ASSUME_NONNULL_END
