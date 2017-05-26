//
//  BaseViewController.h
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/7.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    UIImageView *_navImgView;
    UIView      *_contentView;
    UILabel     *_titleLabel;
    UIButton    *_backButton;
    UIButton    *_rightBtn;
}
//设置导航标题
- (void)setNavTitle:(NSString *)title;

//@property (nonatomic,readonly) UIView *navigationBar;

//隐藏NavigationBar,默认不隐藏
//@property (nonatomic,assign) BOOL hidesNavBarWhenPushed;

//隐藏返回按钮,默认不隐藏
@property (nonatomic,assign) BOOL backButtonHidden;
@property (nonatomic, assign) BOOL rightBtnHidden;

//返回上级界面，backButton的点击事件
- (void)goBackPage:(UIButton *)button;

- (void)rightAction;

@end
