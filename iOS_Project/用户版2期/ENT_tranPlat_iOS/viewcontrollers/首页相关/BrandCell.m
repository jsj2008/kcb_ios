//
//  BrandCell.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/29.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "BrandCell.h"

@implementation BrandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*x_6_plus, 100*4/5*x_6_plus)];
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 830*x_6_plus, 50*y_6_plus)];
        _contentLabel.font = V3_38PX_FONT;
        _contentLabel.textColor = [UIColor colorWithHex:0x666666];
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _icon.origin = CGPointMake(40*x_6_plus, 0);
    _icon.centerY = self.contentView.boundsCenter.y;
    _contentLabel.origin = CGPointMake(_icon.right+40*x_6_plus, 0);
    _contentLabel.centerY = self.contentView.boundsCenter.y;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
