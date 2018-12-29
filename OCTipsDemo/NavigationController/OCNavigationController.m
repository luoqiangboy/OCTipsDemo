//
//  OCNavigationController.m
//  OCTipsDemo
//
//  Created by Mini-LuoQiang on 2018/12/29.
//  Copyright © 2018年 Sniper. All rights reserved.
//

#import "OCNavigationController.h"

@interface OCNavigationController ()

@end

@implementation OCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     开启右滑返回功能 返回主页屏幕卡死处理方案
     */
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    return [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 屏蔽调用rootViewController的滑动返回手势
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}


@end
