//
//  UIWindow+Hierarchy.m
//  IOS-Categories
//
//  Created by Jakey on 15/1/16.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIWindow+Hierarchy.h"

@implementation UIWindow (Hierarchy)
- (UIViewController *)topMostController
{
    UIViewController *topController = [self rootViewController];

    //  Getting topMost ViewController
    while ([topController presentedViewController]) topController = [topController presentedViewController];

    //  Returning topMost ViewController
    return topController;
}

- (UIViewController *)m_currentViewController;
{
    UIViewController *currentViewController = [self topMostController];

    while ([currentViewController isKindOfClass:[UINavigationController class]] || [currentViewController isKindOfClass:[UITabBarController class]]) {
        if ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)currentViewController topViewController]) {
            currentViewController = [(UINavigationController *)currentViewController topViewController];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]] && [(UITabBarController *)currentViewController selectedViewController]) {
            currentViewController = [(UITabBarController *)currentViewController selectedViewController];
        }
    }
    return currentViewController;
}
@end
