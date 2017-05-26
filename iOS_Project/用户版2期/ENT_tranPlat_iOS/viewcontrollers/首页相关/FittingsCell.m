//
//  FittingsCell.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/4.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "FittingsCell.h"
#import "CaluteView.h"
#import "UILabel+Custom.h"

@implementation FittingsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kWhiteColor;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 750*x_6_plus, 48*x_6_plus)];
        _nameLabel.font = V3_38PX_FONT;
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 590*x_6_plus, 40*y_6_SCALE)];
        _contentLabel.font = V3_32PX_FONT;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = kTextGrayColor;
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 182*x_6_plus, 182*y_6_plus)];
        _rV = [UIButton buttonWithType:UIButtonTypeCustom];
        _rV.frame = CGRectMake(0, 0, 49*x_6_plus, 36*y_6_plus);
        [_rV setImage:[UIImage imageNamed:@"滑动-L"] forState:UIControlStateNormal];
        [_rV setImage:[UIImage imageNamed:@"滑动-R"] forState:UIControlStateSelected];
        [_icon addBorderWithWidth:1 color:[UIColor colorWithHex:0xcccccc]];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240*x_6_plus, 60*y_6_plus)
                                             text:@"x1"
                                             font:V3_36PX_FONT
                                        textColor:kTextGrayColor];
        _numLabel.textAlignment = NSTextAlignmentRight;
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240*x_6_plus, 60*y_6_plus)
                                             text:@""
                                             font:V3_42PX_FONT
                                        textColor:kTextOrangeColor];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        
        _numLabel.hidden = _priceLabel.hidden = YES;
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_numLabel];
        [self.contentView addSubview:_rV];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_price) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[_price floatValue]];
        _priceLabel.hidden = NO;
    }else{
        _priceLabel.hidden = YES;
    }
    
    if (_num) {
        _numLabel.text = [NSString stringWithFormat:@"x%@",_num];
        _numLabel.hidden = NO;
    }else{
        _numLabel.hidden = YES;
    }
    _icon.origin = CGPointMake(48*x_6_plus, 32*y_6_plus);
    _rV.origin = CGPointMake(APP_WIDTH-_rV.width-48*x_6_plus, 0);
    _rV.centerY = self.contentView.centerY;
    _nameLabel.origin = CGPointMake(_icon.right+22*x_6_plus, 44*y_6_plus);
    _stateLabel.origin = CGPointMake(_nameLabel.right+10*x_6_SCALE, 0);
    _stateLabel.centerY = _nameLabel.centerY;
    _contentLabel.origin = CGPointMake(_nameLabel.x, _nameLabel.bottom+15*y_6_plus);
    
    _priceLabel.origin = CGPointMake(self.contentView.width-40*x_6_plus-_priceLabel.width, _nameLabel.y);
    _numLabel.origin = CGPointMake(_priceLabel.x, _priceLabel.bottom);
}

- (void)configCellWithDic:(NSDictionary *)dic{
    [_stateLabel removeFromSuperview];
    _groupid = dic[@"groupid"];
    _merid = dic[@"merid"];
    _typeId = dic[@"serid"];
    _serviceName = dic[@"serName"];
    _nameLabel.text = [dic[@"groupname"] analysisConvertToString];
    _groupname = [dic[@"groupname"] analysisConvertToString];
    _nameLabel.width = [_nameLabel getTextWidth];
    NSURL *url = [NSURL URLWithString:dic[@"url"]];
    
    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    if (![dic[@"quality"] isEqualToString:@"null"]) {
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 58*x_6_SCALE, 20*y_6_SCALE)];
        _stateLabel.font = V3_24PX_FONT;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = kGreenColor;
        
        _stateLabel.text = dic[@"quality"];
        [_stateLabel sizeToFit];
        _stateLabel.width += 20*x_6_plus;
        _stateLabel.height += 20*y_6_plus;
        _stateLabel.origin = CGPointMake(_nameLabel.right+13*x_6_plus, 0);

        [_stateLabel addBorderWithWidth:1 color:[UIColor colorWithHex:0xcccccc]];
        [self.contentView addSubview:_stateLabel];
    }
    if ([dic[@"volume"] isLegal]) {
        _volume = dic[@"volume"];
        _contentLabel.text = [NSString stringWithFormat:@"%@(%@)",dic[@"name"],dic[@"volume"]];
    }else{
        _volume = @"";
        _contentLabel.text = dic[@"name"];
    }
}
- (void)UconfigCellWithDic:(NSDictionary *)dic{
    _rV.hidden=YES;
    [_stateLabel removeFromSuperview];
    _typeId = dic[@"id"];
   // _priceLabel.text=dic[@"dj"];
   // _serviceName = dic[@"componentName"];
    _nameLabel.text = [dic[@"componetBrand"] analysisConvertToString];
    _nameLabel.width = [_nameLabel getTextWidth];
    if (![dic[@"quality"] isEqualToString:@"null"] && [dic.allKeys containsObject:@"quality"]) {
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 58*x_6_SCALE, 20*y_6_SCALE)];
        _stateLabel.font = V3_22PX_FONT;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = kGreenColor;
        
        _stateLabel.text = dic[@"quality"];
        [_stateLabel sizeToFit];
        _stateLabel.width += 18*x_6_plus;
        _stateLabel.height += 18*y_6_plus;
        _stateLabel.origin = CGPointMake(_nameLabel.right+13*x_6_plus, 0);
        
        [_stateLabel addBorderWithWidth:1 color:[UIColor colorWithHex:0xcccccc]];
        [self.contentView addSubview:_stateLabel];
    }
    if ([dic[@"volume"] isLegal]) {
        _contentLabel.text = [NSString stringWithFormat:@"%@(%@)",dic[@"componentName"],dic[@"volume"]];
    }else{
        _contentLabel.text = dic[@"componentName"];
    }
    NSURL *url = [NSURL URLWithString:dic[@"url"]];
    
    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"]];
}
- (void)setPrice:(NSNumber *)price{
    _price = price;
    [self setNeedsLayout];
}

- (void)setNum:(NSNumber *)num{
    _num = num;
    [self setNeedsLayout];
}

@end
