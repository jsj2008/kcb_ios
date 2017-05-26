//  OrderPersonInfoCell.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/6.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "OrderPersonInfoCell.h"

@implementation OrderPersonInfoCell
{
    UILabel *_nameL;
    UILabel *_phoneL;
    
    UIView *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(10*x_6_SCALE, 0, 213*x_6_plus, 76*y_6_plus)];
        _nameL.text = @"* 联系人:";
        _nameL.textColor = [UIColor colorWithHex:0x666666];
        NSMutableAttributedString *s1 = [[NSMutableAttributedString alloc]initWithString:_nameL.text];
        [s1 addAttributes:@{NSFontAttributeName:V3_42PX_FONT} range:NSMakeRange(0, s1.length)];
        [s1 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
        [s1 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(1, s1.length-1)];
        _nameL.attributedText = s1;
        
        _nameF = [[UITextField alloc]initWithFrame:CGRectMake(_nameL.right, 0, 820*x_6_plus, _nameL.height)];

        UserInfo *user = [[[DataBase sharedDataBase] selectUserByName:APP_DELEGATE.userName] lastObject];
        NSMutableAttributedString *nStr = [[NSMutableAttributedString alloc]initWithString:user.realName];
        [nStr addAttributes:@{NSFontAttributeName:V3_42PX_FONT} range:NSMakeRange(0, nStr.length)];
        [nStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xcccccc]} range:NSMakeRange(0, nStr.length)];
//        _nameF.attributedPlaceholder = nStr;
        _nameF.text = user.realName;
        _nameF.font = V3_42PX_FONT;

        _phoneL = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-100*x_6_SCALE-10*x_6_SCALE-60*x_6_SCALE, 0, _nameL.width, _nameL.height)];
        _phoneL.textColor = [UIColor colorWithHex:0x666666];
        _phoneL.text = @"* 手机号:";
        
        NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc]initWithString:_phoneL.text];
        [s2 addAttributes:@{NSFontAttributeName:V3_42PX_FONT} range:NSMakeRange(0, s2.length)];
        [s2 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(1, s2.length-1)];
        [s2 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
        _phoneL.attributedText = s2;
        
        _phoneF = [[UITextField alloc]initWithFrame:CGRectMake(_phoneL.right, 0, _nameF.width, _nameF.height)];
        NSMutableAttributedString *pStr = [[NSMutableAttributedString alloc]initWithString:user.contactNum];
        [pStr addAttributes:@{NSFontAttributeName:V3_42PX_FONT} range:NSMakeRange(0, pStr.length)];
        [pStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xcccccc]} range:NSMakeRange(0, pStr.length)];
//        _phoneF.attributedPlaceholder = pStr;
        _phoneF.text = user.contactNum;
        _phoneF.font = V3_42PX_FONT;
        
        _line = [self.contentView addLineWithFrame:CGRectMake(0, 0, 990*x_6_plus, 1) lineColor:kLineGrayColor];
        
        [self.contentView addSubview:_nameF];
        [self.contentView addSubview:_nameL];
        [self.contentView addSubview:_phoneF];
        [self.contentView addSubview:_phoneL];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _nameL.origin = CGPointMake(36*x_6_plus, 48*y_6_plus);
    _nameF.origin = CGPointMake(_nameL.right+28*x_6_plus, _nameL.y);
    _nameF.centerY = _nameL.centerY;
    
    _line.origin = CGPointMake(39*x_6_plus, _nameL.bottom+25*y_6_plus);
    _phoneL.origin = CGPointMake(_nameL.x, _line.bottom+25*y_6_plus);
    _phoneF.origin = CGPointMake(_nameF.x, _phoneL.y);
    _phoneF.centerY = _phoneL.centerY;
}
@end
