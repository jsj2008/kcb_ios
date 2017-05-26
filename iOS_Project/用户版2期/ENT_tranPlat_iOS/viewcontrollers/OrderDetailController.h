//
//  OrderDetailController.h
//  
//
//  Created by 辛鹏贺 on 16/1/18.
//
//

#import "BaseViewController.h"

@interface OrderDetailController : BaseViewController

@property (nonatomic, strong)NSString *orderId;
@property (nonatomic, strong)NSString *orderNo;
@property (nonatomic, strong)NSMutableDictionary *dataSource;

@property (nonatomic, copy) void(^commplete)(void);
@property (nonatomic, copy) void(^commplete0)(void);

- (void)layoutNeedDispaly;

@end
