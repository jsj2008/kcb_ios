//
//  AppDelegate.m
//  Merchant
//
//  Created by Wendy on 15/12/16.
//  Copyright © 2015年 tranPlat. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "LoginViewController.h"
#import "WZGuideViewController.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import "XMLDictionary.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    NSLog(@"===%f====",    [[UIScreen mainScreen] bounds].size.width);
    [self configureAPIKey];
    [self enableIQKeyboardManager];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserAccount];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserPassword];
    if (account.length > 0 && password.length > 0) {//免登录
        //恢复登录信息
        ApplicationDelegate.accountId = account;
        ApplicationDelegate.shareLoginData = [Utils readArchiverDocumentWithFileName:kLoginUserData];
        [self loadHomeView];
    }else{
        [self setLoginViewController];
    }
    [self registerRemoteNotification];
    [self.window makeKeyAndVisible];
//    [self showGuideView];
    [self checkAppUpdate];
    return YES;
}
- (void)showGuideView{
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [WZGuideViewController show];
    }
}
- (void)registerRemoteNotification
{
#if TARGET_IPHONE_SIMULATOR
#else
    NSString *strDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceTokenKey];
    
    if (strDeviceToken && strDeviceToken.length > 0) {
        // user had registered notification.
        return;
    }
    
    if (IsIOS8) {
        UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:types
                                                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types =
        (UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound
         | UIRemoteNotificationTypeAlert);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
#endif /* if TARGET_IPHONE_SIMULATOR */
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *strDeviceToken = [deviceToken.description stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@",strDeviceToken);
    [[NSUserDefaults standardUserDefaults] setObject:strDeviceToken forKey:DeviceTokenKey];

}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge ++;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;

}
- (void)loadHomeView{
    _tabBarController = [[TabBarController alloc] init];
    _tabBarController.delegate = self;
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:_tabBarController];
    rootController.navigationBarHidden = YES;
    _menuController = rootController;
    
    LeftViewController *leftController = [[LeftViewController alloc] init];
    rootController.leftController = leftController;
    
//    RightViewController *rightController = [[RightViewController alloc] init];
//    rootController.rightController = rightController;
    
    [self goBackHomeView];
    
}

- (void)setLoginViewController
{
    // notee 界面加载时的动画
    CATransition *animation = [CATransition animation];
    
    animation.duration            = 0.25;
    animation.timingFunction      = UIViewAnimationCurveEaseInOut;
    animation.type                = kCATransitionFade;
    animation.removedOnCompletion = YES;
    [[self.window layer] addAnimation:animation forKey:@"animation"];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)goBackHomeView
{
    //动画效果
//    CATransition *animation = [CATransition animation];
//    
//    animation.duration            = 0.25;
//    animation.timingFunction      = UIViewAnimationCurveEaseInOut;
//    animation.type                = kCATransitionMoveIn;
//    animation.subtype             = kCATransitionFromRight;
//    animation.removedOnCompletion = YES;
//    [[self.window layer] addAnimation:animation forKey:@"animation"];
    
    CATransition *animation = [CATransition animation];
    
    animation.duration            = 0.25;
    animation.timingFunction      = UIViewAnimationCurveEaseInOut;
    animation.type                = kCATransitionMoveIn;
    animation.subtype             = kCATransitionFromLeft;
    animation.removedOnCompletion = YES;
    [[self.window layer] addAnimation:animation forKey:@"animation"];

    
    self.window.rootViewController = self.menuController;
    
    ApplicationDelegate.menuController.tap.enabled = NO;
    [ApplicationDelegate.menuController showRootController:YES];
    ApplicationDelegate.showingRootController = YES;

}
- (void)pushViewController:(UIViewController *)viewController
{
    CATransition *animation = [CATransition animation];
    
    animation.duration            = 0.25;
    animation.timingFunction      = UIViewAnimationCurveEaseInOut;
    animation.type                = kCATransitionMoveIn;
    animation.subtype             = kCATransitionFromRight;
    animation.removedOnCompletion = YES;
    [[self.window layer] addAnimation:animation forKey:@"animation"];
    
    self.window.rootViewController = viewController;
}

- (void)popViewController
{
    CATransition *animation = [CATransition animation];
    
    animation.duration            = 0.25;
    animation.timingFunction      = UIViewAnimationCurveEaseInOut;
    animation.type                = kCATransitionMoveIn;
    animation.subtype             = kCATransitionFromLeft;
    animation.removedOnCompletion = YES;
    [[self.window layer] addAnimation:animation forKey:@"animation"];
    
    self.window.rootViewController = self.menuController;
    [self.menuController showLeftController:NO];
}

- (void)enableIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

#pragma mark - TabbarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    TabBarController * bar = (TabBarController *)tabBarController;
    if (tabBarController.selectedIndex == 3 && bar.needSettingManHour) {
        [UIHelper alertWithTitle:@"温馨提示" msg:@"请设置您的服务项目及其工时费" viewController:viewController action:^{
        }];
        return NO;
    }
    return YES;
}


#pragma mark - 检测是否有软件更新
- (void)checkAppUpdate{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url=[NSURL URLWithString:kHttpAppUpdate];
        NSString *str4 = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithXMLString:str4];
        NSLog(@"软件更新的xml数据:%@",dict);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self dealCheckAppUpdate:dict];
        });
    });
    
}
- (void)dealCheckAppUpdate:(id)responseObject{
    if (responseObject) {
        NSString *vnum = responseObject[@"version"];
        NSString *appstoreUrl = responseObject[@"appurl_ios"];
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if (![vnum compare:currentVersion] == NSOrderedSame) {
            //非强制
            RIButtonItem *cancleItem = [RIButtonItem itemWithLabel:@"取消"
                                                              type:RIButtonItemType_Cancel
                                                            action:^{
                                                                //
                                                            }];
            RIButtonItem *confirmItem = [RIButtonItem itemWithLabel:@"升级"
                                                               type:RIButtonItemType_Destructive
                                                             action:^{
                                                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
                                                             }];
            BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"温馨提示"
                                                                        message:@"有新的版本，是否升级"
                                                                 viewController:self.window.rootViewController];
            [alert addButtons:@[cancleItem,confirmItem]];
            [alert show];
        }else{
            //没升级
//            [UIHelper alertWithMsg:@"该版本已是最新版本"];
        }
        
    }else{
        [UIHelper alertWithMsg:kNetworkErrorDesp];
    }
}
@end
