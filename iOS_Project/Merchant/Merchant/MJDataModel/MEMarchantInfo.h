//
//  MEMarchantInfo.h
//  Merchant
//
//  Created by Wendy on 16/1/11.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Info;
@interface MEMarchantInfo : NSObject

@property (nonatomic, strong) Info *info;

@property (nonatomic, copy) NSString *orderSize;

@end
@interface Info : NSObject

@property (nonatomic, copy) NSString *cname;

@property (nonatomic, copy) NSString *abname;

@property (nonatomic, copy) NSString *form_num;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *hpl;

@property (nonatomic, copy) NSString *account_type;

@property (nonatomic, copy) NSString *isclose;

@property (nonatomic, copy) NSString *logo_pic;

@property (nonatomic, copy) NSString *open_time;

@property (nonatomic, copy) NSString *telno;

@property (nonatomic, copy) NSString *close_time;

@property (nonatomic, copy) NSString *phone_no;

@property (nonatomic, copy) NSString *city_id;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *describe_m;

@property (nonatomic, copy) NSString *contacts;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *pay_account;

@property (nonatomic, copy) NSString *jwd;
@end
