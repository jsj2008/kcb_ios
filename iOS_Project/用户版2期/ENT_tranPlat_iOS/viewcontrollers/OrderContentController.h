//
//  OrderContentController.h
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/2/3.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BasicViewController.h"

@interface OrderContentController : BaseViewController

@property (nonatomic, strong)NSString *orderId;
@property (nonatomic, strong)NSString *orderNo;
@property (nonatomic, copy)void(^commplete)(void);
@property (nonatomic, copy)void(^commplete0)(void);

@end
@interface customView : UIView

@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIButton *lBtn;
@property (nonatomic, strong)UIButton *rBtn;

@end