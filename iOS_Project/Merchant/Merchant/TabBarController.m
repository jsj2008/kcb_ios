//
//  TabBarController.m
//  Merchant_tranPlat_iOS
//
//  Created by xinpenghe on 15/12/11.
//  Copyright © 2015年 xinpenghe. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "OrderManageController.h"
#import "CustomerManageController.h"
#import "BillManageController.h"
#import "ServiceSettingController.h"
#import "BillSearchController.h"
#import "MESettingList.h"
#import <MJExtension.h>
#import <MJRefresh.h>
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent     = NO;
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [self createCustomTabBarVC];
    [self requestServiceSetting];
    
}
- (void)requestServiceSetting{
    NSInteger merid = ApplicationDelegate.shareLoginData.userdata.mid;
    NSDictionary *param = @{@"merid":[NSNumber numberWithInteger:merid].stringValue};
    [AFNHttpRequest afnHttpRequestUrlNonHub:kHttpSettingList param:param success:^(id responseObject){
        if (kRspCode(responseObject) == 0) {
            NSArray *settingList = responseObject[@"body"][@"settingList"];
            NSArray   * settingArray =[MESettingList mj_objectArrayWithKeyValuesArray:settingList];
            if ([self unSettingService:settingArray]) {
                _needSettingManHour = YES;
                
                [UIHelper alertWithTitle:@"温馨提示" msg:@"请设置您的服务项目及其工时费" viewController:self action:^{
                    self.selectedIndex=3;
                }];
            }else if([self unSettingManHour:settingArray]){
                _needSettingManHour = YES;
                [UIHelper alertWithTitle:@"温馨提示" msg:@"请设置您的服务项目及其工时费" viewController:self action:^{
                    self.selectedIndex=3;
                }];


            }
        }
    } failure:^(NSError *error) {
    } view:self.view ];
}





//是否存在没有工时费的服务项目
- (BOOL)unSettingManHour:(NSArray   *)settingArray{
    for (MESettingList *msg in settingArray) {
        if (msg.lm==nil) {
            return false;
        }
        for (Lm  *lm in msg.lm) {
            if (lm.mid!=nil&&lm.mid.length!=0) {
                if (lm.price.floatValue == 0) {
                    return true;
                }
            }
        }
    }
    return false;

}

//是否没有设置服务项目
 -(BOOL)unSettingService:(NSArray   *)settingArray{
     if (settingArray==nil) {
         return false;
     }
     for (MESettingList *msg in settingArray) {
         if (msg.lm==nil) {
             return false;
         }
         for (Lm  *lm in msg.lm) {
             if (lm.mid!=nil&&lm.mid.length!=0) {
                 return false;
             }
         }
     }
     return true;
 }
- (void)createCustomTabBarVC
{
    //设置选中状态和非选中的字体大小和颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#3d4245"], NSForegroundColorAttributeName, V3_28PX_FONT, NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColor0X39B44A, NSForegroundColorAttributeName, V3_28PX_FONT, NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    
    CATransition *animation = [CATransition animation];
    animation.duration            = 0.25;
    animation.timingFunction      = UIViewAnimationCurveEaseInOut;
    animation.type                = kCATransitionFade;
    animation.removedOnCompletion = YES;
    
    CGFloat offset = 3;
    //首页
    HomeViewController *homeV = [[HomeViewController alloc] init];
    UINavigationController *homeNa = [[UINavigationController alloc] initWithRootViewController:homeV];
    homeNa.tabBarItem.title = @"首页";
    [homeNa.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -offset)];
    homeNa.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset, 0, offset, 0);
    homeNa.tabBarItem.image = [[UIImage imageNamed:@"menu_icon01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNa.tabBarItem.selectedImage = [[UIImage imageNamed:@"menu_icon01 hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //订单管理
    OrderManageController *orderMc = [[OrderManageController alloc] init];
    UINavigationController *orderMVN = [[UINavigationController alloc] initWithRootViewController:orderMc];
    [orderMVN.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -offset)];
    orderMVN.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset, 0, offset, 0);
    orderMVN.tabBarItem.title = @"订单管理";
    orderMVN.tabBarItem.image = [[UIImage imageNamed:@"menu_icon02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderMVN.tabBarItem.selectedImage = [[UIImage imageNamed:@"menu_icon02 hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //账单
    BillSearchController *billMc = [[BillSearchController alloc] init];
    UINavigationController *purchaseVN = [[UINavigationController alloc] initWithRootViewController:billMc];
    purchaseVN.tabBarItem.title = @"账单管理";
    [purchaseVN.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -offset)];
    purchaseVN.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset, 0, offset, 0);
    purchaseVN.tabBarItem.image = [[UIImage imageNamed:@"menu_icon03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    purchaseVN.tabBarItem.selectedImage = [[UIImage imageNamed:@"menu_icon03 hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //服务设置
    ServiceSettingController *AccessoriesPc = [[ServiceSettingController alloc] init];
    UINavigationController *clientVN = [[UINavigationController alloc] initWithRootViewController:AccessoriesPc];
    clientVN.tabBarItem.title = @"服务设置";
    [clientVN.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -offset)];
    clientVN.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset, 0, offset, 0);
    clientVN.tabBarItem.image = [[UIImage imageNamed:@"menu_icon04"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    clientVN.tabBarItem.selectedImage = [[UIImage imageNamed:@"menu_icon04 hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
        NSArray *viewControllers = @[homeNa, orderMVN, purchaseVN, clientVN];
    self.viewControllers = viewControllers;
    
}

@end
