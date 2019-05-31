//
//  NSViewController+XQLoadView.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/31.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "NSViewController+XQLoadView.h"
#import "NSObject+XQExchangeIMP.h"

@implementation NSViewController (XQLoadView)

+ (instancetype)xq_new {
    id vc = [self new];
    // 后面如果有需要, 可以考虑不再 load 里面加载, 让人自动去选择是否要切换
    [self exchangeInstanceMethodWithOriginSEL:@selector(loadView) otherSEL:@selector(xq_loadView)];
    return vc;
}

static NSRect xqLoadViewRect_;

+ (void)xq_setLoadViewRect:(NSRect)rect {
    xqLoadViewRect_ = rect;
}

- (void)xq_loadView {
    NSLog(@"11111: %s", __func__);
    if (self.nibName.length != 0) {
        // 已有 nib name 传入, 无需去自己创建 view
        [self xq_loadView];
        return;
    }
    
    NSLog(@"22222: %s, %@, %@", __func__, self, self.nibBundle);
    
    // 这里不能调用 self.view, 系统会判断 self.view 不存在就会调用 loadView, 所以这里调用 self.view 就会陷入死循环
//    NSView *view = [NSView new];
    
}

@end











