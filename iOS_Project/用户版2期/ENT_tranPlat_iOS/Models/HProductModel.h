//
//  HProductModel.h
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/12.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BaseEntity.h"

@interface HProductModel : BaseEntity

@property (nonatomic, strong)NSString *componentId;
@property (nonatomic, strong)NSString *componentName;
@property (nonatomic, strong)NSString *componentNum;
@property (nonatomic, strong)NSString *weight;
@property (nonatomic, strong)NSString *volume;
@property (nonatomic, strong)NSString *componetBrand;
@property (nonatomic, strong)NSString *dj;
@property (nonatomic, strong)NSString *salePrice;
@property (nonatomic, strong)NSString *componentUrl;

@end
