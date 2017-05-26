//
//  OrderPayViewController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/11.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "OrderPayViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderWaitViewController.h"
#import "OrderContentController.h"
#import "OrderMessController.h"
#import "UILabel+Custom.h"
#import "OrderMessController.h"
#import "MineViewController.h"

@interface OrderPayViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *footerView;
@property (nonatomic, strong) UIScrollView *bodyView;
@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation OrderPayViewController
{
    UILabel *_statusLabel;
    UILabel *_subLabel;
    UILabel *_orderNoLabel;
    UILabel *_timeLabel;
    UILabel *_outLetLabel;
    UILabel *_addressLabel;
    UILabel *_phoneLabel;
    NSString *_stu;
    
    NSInteger _status;
    NSTimer *_timer;
    NSInteger _second;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavTitle:@"订单支付"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self gotoAlipay];
}

- (void)configUI:(NSInteger )status{
    _second = 0;
    [self.view addSubview:self.scrollView];
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50*y_6_plus, APP_WIDTH, 50*y_6_plus)];
    _statusLabel.textColor = kTextOrangeColor;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font = V3_50PX_FONT;
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _statusLabel.bottom+30*y_6_plus, APP_WIDTH-80*x_6_plus, 30*y_6_plus)];
    _subLabel.textColor = [UIColor colorWithHex:0x555555];
    _subLabel.font = V3_38PX_FONT;
    _subLabel.numberOfLines = 0;
    _subLabel.centerX = self.scrollView.boundsCenter.x;
    _subLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.scrollView addSubview:_statusLabel];
    [self.scrollView addSubview:_subLabel];
    [self.scrollView addSubview:self.bodyView];
    [self.view addSubview:self.footerView];
    self.bodyView.y = _subLabel.bottom+40*y_6_plus;

    self.footerView.y = self.view.height-136*y_6_plus;
    if (status == 6001) {
        self.footerView.enabled = YES;
    }else{
        [UITools showIndicatorToView:self.view];
        if (status == 9000) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:2.f
                                                      target:self
                                                    selector:@selector(requestData)
                                                    userInfo:nil
                                                     repeats:YES];
            [_timer fire];
        }else{
            self.footerView.enabled = YES;
            [UITools hideHUDForView:self.view];
        }
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            if (status == 9000) {
//                [self requestData];
//            }else{
//                self.footerView.enabled = YES;
//                [UITools hideHUDForView:self.view];
//            }
//        });
    }
}

- (UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y, APP_WIDTH, APP_HEIGHT-APP_VIEW_Y+APP_NAV_HEIGHT)];
    
    return _scrollView;
}

- (UIButton *)footerView{
    if (_footerView) {
        return _footerView;
    }
    _footerView = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerView.enabled = NO;
    _footerView.frame = CGRectMake(0, 0, APP_WIDTH, 136*y_6_plus);
    _footerView.backgroundColor = COLOR_NAV;
    [_footerView setTitle:@"完成"];
    [_footerView setTitleColor:kWhiteColor];
    __block __typeof(self) weakSelf = self;
    [_footerView addActionBlock:^(id weakSender) {
        if (_status == 1 || _status == 2 || _status == 3) {
            if (!weakSelf.res) {
                OrderContentController *ovc = [[OrderContentController alloc] init];
                ovc.orderNo = _orderNo;
                ovc.orderId = _orderId;
                
                OrderMessController *ov = [[OrderMessController alloc] init];
                ov.demandType = DemandAll;
                
                BOOL res = NO;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[GuideViewController class]]) {
                        res = YES;
                    }
                }
                [weakSelf.navigationController setViewControllers:@[res?self.navigationController.viewControllers[1]:self.navigationController.viewControllers[0],ov,ovc] animated:YES];
            }else{
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[OrderMessController class]]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                        break;
                    }
                }
            }
        }else{
            if (!self.res) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[OrderMessController class]]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                        break;
                    }
                }
            }
        }
        
        if (_status == 5 || _status == 6) {
            if (self.res) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    return _footerView;
}

- (UIScrollView *)bodyView{
    if (_bodyView) {
        return _bodyView;
    }
    _bodyView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 320*y_6_plus)];
    _bodyView.backgroundColor = kWhiteColor;
    _orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*x_6_plus, 25*
                                                              y_6_plus, APP_WIDTH, 38*y_6_plus) text:[NSString stringWithFormat:@"订单编号：%@",_orderNo]
                                              font:V3_36PX_FONT
                                         textColor:kTextGrayColor];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNoLabel.x,
                                                           _orderNoLabel.bottom+20*y_6_plus, _orderNoLabel.width, _orderNoLabel.height)
                                           text:[NSString stringWithFormat:@"预约时间：%@",_bookingTime]
                                           font:V3_36PX_FONT
                                      textColor:kTextGrayColor];
    _outLetLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNoLabel.x,
                                                             _timeLabel.bottom+20*y_6_plus, _orderNoLabel.width, _orderNoLabel.height)
                                             text:[NSString stringWithFormat:@"预约门店：%@",_merchant]
                                             font:V3_36PX_FONT
                                        textColor:kTextGrayColor];
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNoLabel.x,
                                                              _outLetLabel.bottom+20*y_6_plus, _orderNoLabel.width, _orderNoLabel.height)
                                              text:[NSString stringWithFormat:@"门店地址：%@",_merchantAddress]
                                              font:V3_36PX_FONT
                                         textColor:kTextGrayColor];
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNoLabel.x,
                                                            _addressLabel.bottom+20*y_6_plus, _orderNoLabel.width, _orderNoLabel.height)
                                            text:[NSString stringWithFormat:@"联系电话：%@",_merchantPhone]
                                            font:V3_36PX_FONT
                                       textColor:kTextGrayColor];
    
    [_bodyView addSubview:_orderNoLabel];
    [_bodyView addSubview:_timeLabel];
    [_bodyView addSubview:_outLetLabel];
    [_bodyView addSubview:_addressLabel];
    [_bodyView addSubview:_phoneLabel];
    
    return _bodyView;
}

-(void)gotoAlipay{
    /*=========== =================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivatekey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = _orderNo;
    order.productName = [NSString stringWithFormat:@"车辆保养订单"]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"保养订单"]; //商品描述
    order.amount = [NSString stringWithFormat:@"0.01"];; //商品价格
    order.notifyURL = @"http://106.2.222.108:18080/m_order/AlipayBackkcbuss"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"ENT";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    ENTLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivatekey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payUrlOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [self configUI:[resultDic[@"resultCode"] integerValue]];
            
            if ([resultDic[@"resultCode"] integerValue] == 9000) {
                [self getPayStatus:1];      //订单支付成功
            }else if ([resultDic[@"resultCode"] integerValue] == 8000){
                [self getPayStatus:2];      //订单处理中
            }else if ([resultDic[@"resultCode"] integerValue] == 4000){
                [self getPayStatus:5];      //订单支付失败
            }else if ([resultDic[@"resultCode"] integerValue] == 6001){
                [self getPayStatus:3];      //订单中途取消
            }else if ([resultDic[@"resultCode"] integerValue] == 6002){
                [self getPayStatus:6];      //网络连接错误
            }else{
                [self getPayStatus:5];      //其他异常
            }
        }];
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic){
//            [self configUI];
//
//            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
//                [self getPayStatus:1];      //订单支付成功
//            }else if ([resultDic[@"resultStatus"] integerValue] == 8000){
//                [self getPayStatus:2];      //订单处理中
//            }else if ([resultDic[@"resultStatus"] integerValue] == 4000){
//                [self getPayStatus:5];      //订单支付失败
//            }else if ([resultDic[@"resultStatus"] integerValue] == 6001){
//                [self getPayStatus:3];      //订单中途取消
//            }else if ([resultDic[@"resultStatus"] integerValue] == 6002){
//                [self getPayStatus:6];      //网络连接错误
//            }else{
//                [self getPayStatus:5];      //其他异常
//            }
//        }];
    }
}

- (void)getPayStatus:(NSInteger)status{
    _status = status;
    switch (status) {
        case 1:
            _statusLabel.text = @"订单支付成功";
            _subLabel.text = @"您的预约已成功,返回首页点击“我的-我的订单”查询订单详细";
            break;
        case 2:
            _statusLabel.text = @"订单正在处理中";
            _subLabel.text = @"预约订单正在处理,返回首页点击“我的-我的订单”查询订单处理结果";
            break;
        case 3:
            _statusLabel.text = @"订单支付已取消";
            _subLabel.text = @"您已取消支付该订单,返回首页点击“我的-我的订单”找到该订单继续支付";
            break;
        case 4:
            _statusLabel.text = @"订单支付失败";
            _subLabel.text = @"订单预约失败，订单支付结果验证失败";
            break;
        case 5:
            _statusLabel.text = @"订单支付失败";
            _subLabel.text = @"您的预约未成功,请与客服人员联系";
            break;
        case 6:
            _statusLabel.text = @"订单支付失败";
            _subLabel.text = @"您的预约未成功,支付过程中网络连接异常，请稍后重试";
            break;
        
        default:
            break;
    }
    
    _subLabel.height = [_subLabel getTextHeight];
    self.bodyView.y = _subLabel.bottom+40*y_6_plus;
    self.footerView.y = self.view.height-136*y_6_plus;
}

- (void)requestData{
    _second ++;
    MKNetworkOperation *operation = [[NetworkEngine sharedNetwork] operationWithPath:@"m_order/getOrderStatus" params:@{@"head":@{@"version":@"1"},@"body":@{@"orderId":_orderId}} httpMethod:@"POST"];
    operation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *resposeStr = completedOperation.responseString;
        DDLogDebug(@">>>>>>>>>>url->%@\n>>>>>>>>>>resposeString->%@\n===================",completedOperation.url,resposeStr);
        id responseDic = completedOperation.responseJSON;
        if ([responseDic[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            [_timer invalidate];
            [self request_flag];
        }else{
            if (_second == 30) {
                [UITools alertWithMsg:@"您的订单支付异常，请联系客服"];
                [_timer invalidate];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DDLogError(error.description,nil);
        [_timer invalidate];
    }];
   
    [[NetworkEngine sharedNetwork] enqueueOperation:operation];
}

- (void)request_flag{
    [[NetworkEngine sharedNetwork] postBody:@{@"orderId":_orderId,@"orderNo":_orderNo,@"flag":@"1"} apiPath:kOrderDetailURL hasHeader:YES finish:^(ResultState state, id resObj) {
        self.footerView.enabled = YES;
        
        [UITools hideHUDForView:self.view];
    } failed:^(NSError *error) {
        self.footerView.enabled = YES;
        [UITools hideHUDForView:self.view];
    }];
}

- (void)goBackPage:(UIButton *)button{
    if (_commplete) {
        _commplete();
    }
    [super goBackPage:button];
}

@end
