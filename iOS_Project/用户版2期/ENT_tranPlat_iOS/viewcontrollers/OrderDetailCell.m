//
//  OrderDetailCell.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/20.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "OrderDetailCell.h"
#import "UILabel+Custom.h"

@implementation OrderDetailCell
{
    UILabel *_orderNo;
    UILabel *_timeLabel;
    UILabel *_payLabel;
    UILabel *_dispatchLabel;
    UILabel *_totalLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _orderNo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 22*y_6_SCALE)
                                            text:nil
                                            font:WY_FONT_SIZE(30)
                                       textColor:kTextCellGrayColor];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 22*y_6_SCALE)
                                              text:nil
                                              font:WY_FONT_SIZE(30)
                                         textColor:kTextCellGrayColor];
        _payLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 22*y_6_SCALE)
                                             text:nil
                                             font:WY_FONT_SIZE(30)
                                        textColor:kTextCellGrayColor];
        _dispatchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 22*y_6_SCALE)
                                                 text:nil
                                                 font:WY_FONT_SIZE(30)
                                            textColor:kTextCellGrayColor];
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 22*y_6_SCALE)
                                               text:nil
                                               font:WY_FONT_SIZE(30)
                                          textColor:kTextCellGrayColor];
        
        [self.contentView addSubview:_orderNo];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_payLabel];
        [self.contentView addSubview:_dispatchLabel];
        [self.contentView addSubview:_totalLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _orderNo.origin = CGPointMake(40*y_6_plus, 0);
    _timeLabel.origin = CGPointMake(40*y_6_plus, _orderNo.bottom);
    _payLabel.origin = CGPointMake(40*y_6_plus, _timeLabel.bottom);
    if (!_payLabel.hidden) {
        _dispatchLabel.origin = CGPointMake(40*y_6_plus, _payLabel.bottom);
        _totalLabel.origin = CGPointMake(40*y_6_plus, _dispatchLabel.bottom);
    }else{
        _dispatchLabel.origin = CGPointMake(40*y_6_plus, _timeLabel.bottom);
        _totalLabel.origin = CGPointMake(40*y_6_plus, _dispatchLabel.bottom);
    }
}

- (void)configCellWithDic:(NSDictionary *)dic{
    _orderNo.text = [NSString stringWithFormat:@"订单编号：%@",[dic[@"orderNo"] analysisConvertToString]];
    _timeLabel.text = [NSString stringWithFormat:@"订单时间：%@",[dic[@"submitTime"] analysisConvertToString]];
  //  _payLabel.text = [NSString stringWithFormat:@"支付方式：%@",[dic[@"payType"] analysisConvertToString]];
    if ([dic[@"payType"] floatValue] > 0) {
        _payLabel.hidden = NO;
        _payLabel.text=@"支付方式：支付宝支付";
    }else{
        _payLabel.hidden = YES;
        [self setNeedsLayout];
    }
    _dispatchLabel.text = @"配送方式：驾车到店";
    _totalLabel.text = [NSString stringWithFormat:@"服务总额：¥%@",[dic[@"payPrice"] analysisConvertToString]];
}

@end
