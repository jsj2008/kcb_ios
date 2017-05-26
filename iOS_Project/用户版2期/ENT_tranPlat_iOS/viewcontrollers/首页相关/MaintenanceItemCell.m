
//
//  MaintenanceItemCell.m
//  ENT_tranPlat_iOS
//
//  Created by ; on 16/1/4.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "MaintenanceItemCell.h"

@implementation MaintenanceItemCell
{
    UIImageView *_icon;
    UIImageView *_rightView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kWhiteColor;
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45*x_6_plus, 45*x_6_plus)];
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 854*x_6_plus, 60*y_6_plus)];
        _contentLabel.font = V3_38PX_FONT;
        _contentLabel.textColor = [UIColor colorWithHex:0x666666];
        _contentLabel.tag = 999;
        _rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24*x_6_plus, 38*y_6_plus)];
        _rightView.image = [UIImage imageNamed:@"list_righticon"];
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_rightView];
    } 
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _icon.x = 40*x_6_plus;
    _icon.centerY = self.contentView.boundsCenter.y;
    _contentLabel.x = _icon.right+22*x_6_plus;
    _contentLabel.centerY = self.contentView.boundsCenter.y;
    _rightView.x = self.contentView.width-50*x_6_plus-_rightView.width;
    _rightView.centerY = self.contentView.boundsCenter.y;
}

- (void)setRes:(NSInteger)res{
//    if (res && [_contentLabel.text isLegal] && _contentLabel.text.length > 6) {
//        NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc]initWithString:_contentLabel.text];
//        [mAtt addAttributes:@{NSFontAttributeName:FONT_SIZE(12, x_6_SCALE)} range:NSMakeRange(6, _contentLabel.text.length-6)];
//        _contentLabel.attributedText = mAtt;
//    }
}

- (void)configCellWithDic:(NSDictionary *)dic{
    _icon.image = [UIImage imageNamed:dic[@"icon"]];
    _contentLabel.text = dic[@"content"];
}

@end
