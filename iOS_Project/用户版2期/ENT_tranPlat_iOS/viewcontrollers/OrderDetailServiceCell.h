//
//  OrderDetailServiceCell.h
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/28.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailServiceCell : UITableViewCell

@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSNumber *serviceId;
@property (nonatomic, strong) NSString *price;

@end
