//
//  OrderDetailInfoCell.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/27.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "OrderDetailInfoCell.h"

@implementation OrderDetailInfoCell
{
    UILabel *_nameLabel;
    UIButton *_icon;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHex:0x666666];
        _nameLabel.font = V3_38PX_FONT;
        
        _icon = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon.frame = CGRectMake(0, 0, 52*x_6_plus, 76*y_6_plus);
        [_icon addActionBlock:^(id weakSender) {
            if (_commplete) {
                _commplete();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_icon];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _nameLabel.frame = CGRectMake(40*x_6_plus, 0, 800*x_6_plus, self.contentView.height);
    _nameLabel.centerY = self.contentView.boundsCenter.y;
    _icon.origin = CGPointMake(self.contentView.width-40*x_6_plus-_icon.width, 0);
    _icon.centerY = self.contentView.boundsCenter.y;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name{
    _nameLabel.text = name;
}

- (void)setImg:(UIImage *)img{
    [_icon setBackgroundImage:img forState:UIControlStateNormal];
}

@end
