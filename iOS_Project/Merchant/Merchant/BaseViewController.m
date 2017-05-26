//
//  CommonViewController.m
//  RongChuang
//
//  Created by 叶落风逝 on 15/3/23.
//  Copyright (c) 2015年 pinksun. All rights reserved.


#import "BaseViewController.h"


@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 去掉导航栏底部的黑线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = kColor0X39B44A;

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, V3_60PX_FONT, NSFontAttributeName, nil]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backEvent:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];

    if (IsIOS7) {
        self.edgesForExtendedLayout                         = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars               = NO;
        self.modalPresentationCapturesStatusBarAppearance   = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets           = NO;
    }
    
    
    _endEditControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    _endEditControl.backgroundColor = [UIColor clearColor];
    [_endEditControl addTarget:self action:@selector(endEditEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_endEditControl];
    _endEditControl.hidden = YES;

}
- (void)endEditEvent
{
    [self.view endEditing:YES];
}

// 添加导航右侧按钮
- (void)addRightBarButtonWith:(NSString *)title action:(SEL)action imageName:(NSString *)imageName
{
    UIBarButtonItem *rightBarButton = nil;

    if (imageName  && [UIImage imageNamed:imageName]) {
        rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:action];
    }

    if (title && [title isKindOfClass:[NSString class]] && [title length]) {
        if (rightBarButton) {
            rightBarButton.title = title;
        } else {
            rightBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
        }
    }

    if (rightBarButton) {
        [rightBarButton setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }
                                      forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

#pragma mark --返回事件
- (void)backEvent:(UIBarButtonItem *)paramItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavTitle:(NSString *)title{
    self.navigationItem.title = title;
}
@end

