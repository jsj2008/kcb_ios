//
//  NewSetCityViewController.h
//  ENT_tranPlat_iOS
//
//  Created by Lin_LL on 16/2/19.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BaseTableViewController.h"

@interface NewSetCityViewController : BaseTableViewController

@property (nonatomic, copy)void(^block)(NSString *code);

@end
