//
//  MineDetailCell.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/14.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "MineDetailCell.h"

@implementation MineDetailCell
{
    UIImageView *_icon;
    UILabel *_nameLabel;
    UIImageView *_rV;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc]init];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = V3_38PX_FONT;
        _nameLabel.textColor = [UIColor colorWithHex:0x666666];
        _rV = [[UIImageView alloc]init];
        _rV.image = [UIImage imageNamed:@"list_righticon"];
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_rV];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _icon.frame = CGRectMake(10*x_6_SCALE, 0, 20*x_6_SCALE, 20*x_6_SCALE);
    _icon.centerY = self.contentView.boundsCenter.y;
    
    _nameLabel.frame = CGRectMake(_icon.right+20*x_6_SCALE, 0, 160*x_6_SCALE, 22);
    _nameLabel.centerY = self.contentView.boundsCenter.y;
    
    _rV.frame  =CGRectMake(self.contentView.width-30*x_6_SCALE, 0, 24*x_6_plus, 38*y_6_plus);
    _rV.centerY = self.contentView.boundsCenter.y;
}

- (void)configCellWithDic:(NSDictionary *)dic{
    _icon.image = [UIImage imageNamed:dic[@"icon"]];
    _nameLabel.text = dic[@"name"];
}

@end
