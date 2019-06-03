//
//  XQSchemeModel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/6/3.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQSchemeModel.h"
#import <XQProjectTool/XQXMLParser.h>
#import <YYModel/YYModel.h>

@implementation XQSchemeModel

+ (XQSchemeModel *)schemeModelWithFilePath:(NSString *)path {
    if (!path || ![path hasSuffix:@".xcscheme"]) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    
    NSDictionary *dic = [XQXMLParser dictionaryForXMLData:data error:nil];
    if (!dic || !dic[@"Scheme"]) {
        return nil;
    }
    
    XQSchemeModel *model = [XQSchemeModel yy_modelWithDictionary:dic[@"Scheme"]];
    
    model.xq_schemeName = [[path componentsSeparatedByString:@"/"].lastObject componentsSeparatedByString:@"."].firstObject;
    
    // 原始值赋值 ?? 是否有更快速的方法...
    model.rawData = dic;
    model.AnalyzeAction.rawData = dic[@"AnalyzeAction"];
    model.ArchiveAction.rawData = dic[@"ArchiveAction"];
    
    model.ProfileAction.rawData = dic[@"ProfileAction"];
    model.ProfileAction.BuildableProductRunnable.rawData = dic[@"ProfileAction"][@"BuildableProductRunnable"];
    model.ProfileAction.BuildableProductRunnable.BuildableReference.rawData = dic[@"ProfileAction"][@"BuildableProductRunnable"][@"BuildableReference"];
    
    model.LaunchAction.rawData = dic[@"LaunchAction"];
    model.LaunchAction.BuildableProductRunnable.rawData = dic[@"LaunchAction"][@"BuildableProductRunnable"];
    model.LaunchAction.BuildableProductRunnable.BuildableReference.rawData = dic[@"LaunchAction"][@"BuildableProductRunnable"][@"BuildableReference"];
    
    model.TestAction.rawData = dic[@"TestAction"];
    model.TestAction.MacroExpansion = dic[@"TestAction"][@"MacroExpansion"];
    model.TestAction.MacroExpansion.BuildableReference = dic[@"TestAction"][@"MacroExpansion"][@"BuildableReference"];
    
    model.BuildAction.rawData = dic[@"BuildAction"];
    model.BuildAction.BuildActionEntries.rawData = dic[@"BuildAction"][@"BuildActionEntries"];
    model.BuildAction.BuildActionEntries.BuildableReference.rawData = dic[@"BuildAction"][@"BuildActionEntries"][@"BuildableReference"];
    
    return model;
}

@end
