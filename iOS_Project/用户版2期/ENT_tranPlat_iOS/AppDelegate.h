//
//  AppDelegate.h
//  ENT_tranPlat_iOS
//
//  Created by yanyan on 14-7-14.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//
///

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "GuideViewController.h"
#import "TabBarViewController.h"
#import "UserInfo.h"

#import "BPush.h"
#import "JSONKit.h"
#import "Countly.h"
#import "BaiduMobAdSplash.h"


//#import <TencentOpenAPI/TencentOAuth.h>
#import <MobileCoreServices/MobileCoreServices.h>

//typedef enum {
//    baiduMobAdPreparedYES = 1,
//    baiduMobAdPreparedNO = 2,
//    baiduMobAdPreparing = 3
//
//}BaiduMobAdPrepareStatus;

typedef NS_ENUM(NSInteger) {
    Manintenance = 4
}ServiceType;


@interface AppDelegate : UIResponder <
UIApplicationDelegate,
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
CLLocationManagerDelegate,
WXApiDelegate,
//BaiduMobAdViewDelegate
BaiduMobAdSplashDelegate
>{
    
//    BaiduMobAdView *_launchView;
    UIImageView     *_lunchTempImgView;
}

extern NSString *const WATTINGFORPAY;
extern NSString *const WATTINGFORSERVICE;
extern NSString *const WATTINGFORCOMMNET;
extern NSString *const WATTINGFORREFOUND;

@property (copy, nonatomic) void (^reachabilityChangedHandler)(NetworkStatus ns);     //网络状态改变的操作
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) ServiceType serviceType;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TabBarViewController *tabVC;
@property (strong, nonatomic) BaiduMobAdSplash *splash;
@property (nonatomic,copy)   NSString        *orderNo;
@property (nonatomic,copy) NSString    *key;

@property (strong, nonatomic) NSString  *userName;
@property (strong, nonatomic) NSString  *realName;
@property (strong, nonatomic) NSString  *userId;
@property (assign, nonatomic)      BOOL  loginSuss;
@property (assign, nonatomic)      BOOL  firstTimeOnUserPage;


@property (strong, nonatomic) NSString  *bpushUserId;
@property (strong, nonatomic) NSString  *bpushChannelId;


@property (assign, nonatomic)      BOOL    shouldRefreshFriendsList;
@property (assign, nonatomic)      BOOL    shouldRefreshBlogList;



//@property (assign, nonatomic)      BaiduMobAdPrepareStatus    baiduAdPrepareStatus;

//@property (strong, nonatomic)      NSString    *carOwnerName;
//@property (strong, nonatomic)      NSString    *carOwnerIdnum;
//@property (strong, nonatomic)      NSMutableDictionary    *carDealConditionInfoDict;
//@property (strong, nonatomic)   NSString  *xianxing;


@end
