//
//  OrderPayViewController.h
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/11.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderPayViewController : BaseViewController

@property (nonatomic, strong) NSString *consumerCode;                    //消费吗
@property (nonatomic, strong) NSString *orderId;                         //订单号
@property (nonatomic, strong) NSString *orderNo;                         //订单号
@property (nonatomic, strong) NSString *bookingTime;                     //预约时间
@property (nonatomic, strong) NSString *merchant;                        //预约门店
@property (nonatomic, strong) NSString *merchantAddress;                 //门店地址
@property (nonatomic, strong) NSString *merchantPhone;                   //联系电话
@property (nonatomic, copy)void(^commplete)(void);
@property (nonatomic, assign) BOOL res;

@end
