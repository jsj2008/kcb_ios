//
//  OrderCommentViewController.h
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/29.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BasicViewController.h"

@interface OrderCommentViewController : BasicViewController

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, copy)void(^commplete)(void);

@end
