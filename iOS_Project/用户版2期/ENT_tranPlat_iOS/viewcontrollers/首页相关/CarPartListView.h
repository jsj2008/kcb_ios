//
//  CarPartListView.h
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/25.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarPartListView : UIView

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, copy)void(^commplete)(void);
@property (nonatomic, copy)void(^block)(NSString *);

+ (CarPartListView *)sharePartListView;
- (void)showInView:(UIView *)view;

@end
