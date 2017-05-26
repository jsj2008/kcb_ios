//
//  CustomInputView.m
//  Merchant
//
//  Created by Wendy on 16/1/6.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import "CustomInputView.h"
#define kRightImageWidth 20
#define kRightImageHeight 20

@interface CustomInputView ()
{
    UIImageView *rightImageView;
    UILabel *textField;
}
@end
@implementation CustomInputView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat margin = 15;
        
        //左侧view
        UILabel *settingLab = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 110, self.height)];
        settingLab.text = title;
        settingLab.textColor = kColor0X666666;
        settingLab.font = V3_36PX_FONT;
        [self addSubview:settingLab];
        
        textField = [[UILabel alloc] initWithFrame:CGRectMake(settingLab.right, 0, 0, frame.size.height)];
        textField.font = V3_36PX_FONT;
        textField.textColor = kColor0X666666;
        textField.text = text;
        [self addSubview:textField];
        
        
        rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width- kRightImageWidth -margin, (self.height-kRightImageHeight)/2, kRightImageWidth, kRightImageHeight)];
        rightImageView.image = [UIImage imageNamed:@"time02"];
        rightImageView.userInteractionEnabled = YES;
        rightImageView.contentMode = UIViewContentModeCenter;
        textField.right = rightImageView.left;
        [self addSubview:rightImageView];
        
        
        [self addLineWithFrame:CGRectMake(margin, self.height-1, self.width-2*margin, 1) lineColor:kLineColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

- (void)setRightImage:(NSString *)image{
    rightImageView.image = [UIImage imageNamed:image];
}

- (void)click{
    if (_commplete) {
        _commplete();
    }
}

- (void)setTextField:(NSString *)text{
    textField.text = text;
    self.text = text;
}
@end
