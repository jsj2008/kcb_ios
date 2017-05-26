//
//  HomeOrderCell.m
//  Merchant
//
//  Created by Wendy on 15/12/30.
//  Copyright © 2015年 tranPlat. All rights reserved.
//

#import "HomeOrderCell.h"

@implementation HomeOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGFloat leftM = 15;
        UIImageView *serImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dd_list_icon"]];
        serImg.frame = CGRectMake(10, 5, 10, 15);
        [self.contentView addSubview:serImg];
        _serverTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(serImg.right +5, 0, self.width/2, 25)];
        _serverTypeLab.text = @"保养";
        _serverTypeLab.textColor = kColor0X39B44A;
        _serverTypeLab.font = V3_38PX_FONT;
        [self.contentView addSubview:_serverTypeLab];
        
//        _orderTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(_serverTypeLab.right+10, 0, APP_WIDTH -_serverTypeLab.right -20 , 25)];
//        _orderTimeLab.textColor = [UIColor lightGrayColor];
//        _orderTimeLab.textAlignment = NSTextAlignmentRight;
//        _orderTimeLab.font = V3_32PX_FONT;
//        [self.contentView addSubview:_orderTimeLab];
        
        [self.contentView addLineWithFrame:CGRectMake(0, 24, APP_WIDTH, 1) lineColor:kLineColor];
        
        CGFloat topM = 25;
        _modelsLab = [[UILabel alloc] initWithFrame:CGRectMake(leftM, topM, APP_WIDTH-leftM, 25)];
        _modelsLab.text = @"保养车型:";
        _modelsLab.font = V3_36PX_FONT;
        [self.contentView addSubview:_modelsLab];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(APP_WIDTH-130, 0, 120 , 25)];
        _statusLab.textColor = kColor0X39B44A;
        _statusLab.textAlignment = NSTextAlignmentRight;
        _statusLab.font = V3_36PX_FONT;
        [self.contentView addSubview:_statusLab];

        
        _mobileLab = [[UILabel alloc] initWithFrame:CGRectMake(leftM, _modelsLab.bottom, self.right-leftM, 25)];
        _mobileLab.font = V3_36PX_FONT;

        _mobileLab.text = @"手机号码:";
        [self.contentView addSubview:_mobileLab];
        
        _amountLab = [[UILabel alloc] initWithFrame:CGRectMake(leftM, _mobileLab.bottom, self.right-leftM, 25)];
        _amountLab.font = V3_36PX_FONT;

        _amountLab.text = @"订单金额:";
        [self.contentView addSubview:_amountLab];

        _appointmentLab = [[UILabel alloc] initWithFrame:CGRectMake(leftM, _amountLab.bottom, self.right-leftM, 25)];
        _appointmentLab.font = V3_36PX_FONT;
        _appointmentLab.text = @"预约时间:";
        [self.contentView addSubview:_appointmentLab];
        
        _actionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_actionBtn addBorderWithWidth:0.8 color:kColor0X39B44A corner:2];
        [_actionBtn setTitleColor:kColor0X39B44A];
        _actionBtn.showsTouchWhenHighlighted = YES;
        _actionBtn.frame = CGRectMake(APP_WIDTH-95, 0, 90, 25);
        _actionBtn.titleLabel.font = V3_36PX_FONT;
        
//        _actionBtn.centerX = _statusLab.centerX;
        _actionBtn.centerY = _appointmentLab.centerY-5;
        _actionBtn.hidden = YES;
        [self.contentView addSubview:_actionBtn];
        
        _comsumerLabel = [[UILabel alloc] initWithFrame:_actionBtn.frame];
        _comsumerLabel.textColor = kColor0XFF9418;
        _comsumerLabel.textAlignment = NSTextAlignmentRight;
        _comsumerLabel.font = V3_34PX_FONT;
        _comsumerLabel.hidden = YES;
        [self.contentView addSubview:_comsumerLabel];
        
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellComsumerLab:(NSString *)value{
    _comsumerLabel.hidden = NO;
    _actionBtn.hidden = YES;
    if (value.integerValue == 1) {
        _comsumerLabel.text = @"消费码未验证";
    }else{
        _comsumerLabel.text =  @"消费码已验证";
    }
}
- (void)setCellStatusLab:(NSString *)value{
    if (value.intValue == 1) {
        [_actionBtn setTitle:@"确认接单"];
        _actionBtn.hidden = NO;
        
    }else{
        _actionBtn.hidden = YES;
        
    }
    self.statusLab.text = [Utils getStatusNameType:2 statusId:value];
}
- (void)setCellMobileLab:(NSString *)value{
    NSString *string = [NSString stringWithFormat:@"手机号码：%@", value];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X949694 } range:NSMakeRange(0, 5)];
    
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X666666 } range:NSMakeRange(5, string.length - 5)];
    self.mobileLab.attributedText = attributedString;
}
- (void)setCellModelsLab:(NSString *)value{
    NSString *string = [NSString stringWithFormat:@"保养车型：%@", value];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X949694 } range:NSMakeRange(0, 5)];
    
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X666666 } range:NSMakeRange(5, string.length - 5)];
    self.modelsLab.attributedText = attributedString;
}

- (void)setCellAmountLab:(NSString *)value{
    NSString *string = [NSString stringWithFormat:@"订单金额：%@元", value];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X949694 } range:NSMakeRange(0, 5)];
    
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X666666 } range:NSMakeRange(5, string.length - 5)];
    self.amountLab.attributedText = attributedString;
}

- (void)setCellAppointmentLab:(NSString *)value{
    NSString *string = [NSString stringWithFormat:@"预约时间：%@", value];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X949694 } range:NSMakeRange(0, 5)];
    
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X666666 } range:NSMakeRange(5, string.length - 5)];
    self.appointmentLab.attributedText = attributedString;
}

@end
