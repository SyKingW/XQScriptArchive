//
//  XQLabel.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/31.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQLabel.h"

@implementation XQLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [NSColor clearColor];
        self.bordered = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


@end
