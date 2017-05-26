//
//  OrderModel.h
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/12.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BaseEntity.h"
#import "HCarModel.h"
#import "HBookingInfoModel.h"

@interface OrderModel : BaseEntity

/****************基本信息*********************/
@property (nonatomic, strong)NSString *serviceName;
@property (nonatomic, strong)NSString *merchantId;
@property (nonatomic, strong)NSString *merchantName;
@property (nonatomic, strong)NSString *merchantPhone;
@property (nonatomic, strong)NSString *merchantAddress;
@property (nonatomic, strong)NSString *merchantMoible;
@property (nonatomic, strong)NSString *merchantImage;
@property (nonatomic, strong)NSString *channelName;
@property (nonatomic, strong)NSString *channelMobile;
@property (nonatomic, strong)NSString *componentNum;
@property (nonatomic, strong)NSString *serviceNum;
@property (nonatomic, strong)NSString *chanelId;
@property (nonatomic, strong)NSString *payPrice;
@property (nonatomic, strong)NSString *discountPrice;
@property (nonatomic, strong)NSString *totalPrice;
@property (nonatomic, strong)NSString *orderType;
@property (nonatomic, strong)NSString *serviceType;
@property (nonatomic, strong)NSString *payType;
@property (nonatomic, strong)NSString *cityCode;
@property (nonatomic, strong)NSString *payTime;
@property (nonatomic, strong)NSString *serviceId;
@property (nonatomic, strong)NSString *workHoursPrice;

@property (nonatomic, strong)HCarModel *vehicleInfo;            //汽车信息
@property (nonatomic, strong)HBookingInfoModel *bookingInfo;    //预约信息
@property (nonatomic, strong) NSArray *serviceList;             //HServiceModel

@end
