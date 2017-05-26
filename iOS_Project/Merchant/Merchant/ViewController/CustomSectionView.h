//
//  CustomSectionView.h
//  CLEnterpriseIM
//
//  Created by Wendy on 14-8-7.
//  Copyright (c) 2014年 cooperLink. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomSectionViewDelegate;
@interface CustomSectionView : UIView
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *foldBtn;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL opened;
@property (nonatomic, assign) id <CustomSectionViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id<CustomSectionViewDelegate>)delegate  showArrow:(BOOL)show;
@end

@protocol CustomSectionViewDelegate <NSObject>

@optional
- (void)CustomSectionView:(CustomSectionView *)sectionView sectionClosed:(NSInteger)section;
- (void)CustomSectionView:(CustomSectionView *)sectionView sectionOpened:(NSInteger)section;
@end
