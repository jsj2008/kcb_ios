//
//  ItemsView.h
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 15/12/23.
//  Copyright © 2015年 ___ENT___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsView;
@protocol ItemViewDelegate <NSObject>

- (void)ItemsView:(ItemsView *)ItemsView didSelectedItemAtPath:(NSInteger)path;

@end
@interface ItemsView : UIView

@property (nonatomic, weak) id<ItemViewDelegate>delegate;

+(ItemsView *)shareWithItems:(NSArray *)items
                    pictures:(NSArray *)pics
                   selectPic:(NSArray *)selectPic
                 lineSpacing:(CGFloat)lineSpace
                 itemSpacing:(CGFloat)intemSpace
                  edgeInsets:(UIEdgeInsets)inset;


@end
