//
//  ServiceCell.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/2/23.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "ServiceCell.h"
#import "CWStarRateView.h"

@implementation ServiceCell
{
    UIImageView *_icon;
    UILabel *_nameLabel;
    UILabel *_addressLabel;
    UILabel *_starLevelLabel;
    UILabel *_favorLabel;
    CWStarRateView *_startView;
    UIView *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 240*x_6_plus, 240*y_6_plus)];
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 680*x_6_plus, 50*y_6_plus)];
        _nameLabel.font = V3_36PX_FONT;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#7acdd6"];
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 680*x_6_plus, 40*y_6_plus)];
        _addressLabel.font = V3_30PX_FONT;
        _addressLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _starLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 680*x_6_plus, 40*y_6_plus)];
        _starLevelLabel.font = V3_30PX_FONT;
        _starLevelLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _favorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 680*x_6_plus, 40*y_6_plus)];
        _favorLabel.font = V3_34PX_FONT;
        _favorLabel.textColor = [UIColor colorWithHexString:@"#e94d00"];
        
        _startView=[[CWStarRateView alloc]initWithFrame:CGRectMake(0, 0, 270*x_6_plus, 50*y_6_plus) numberOfStars:5];
        _startView.userInteractionEnabled = NO;
        _line = [self.contentView addLineWithFrame:CGRectMake(0, 0, APP_WIDTH, .5f) lineColor:kLineGrayColor];
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_addressLabel];
//        [self.contentView addSubview:_starLevelLabel];
        [self.contentView addSubview:_favorLabel];
        [self.contentView addSubview:_startView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _icon.origin = CGPointMake(50*x_6_plus, 0);
    _icon.centerY = self.contentView.boundsCenter.y;
    _nameLabel.origin = CGPointMake(_icon.right+45*x_6_plus, _icon.y);
    _addressLabel.origin = CGPointMake(_nameLabel.x, _nameLabel.bottom+15*y_6_plus);
//    _starLevelLabel.origin = CGPointMake(_nameLabel.x, _addressLabel.bottom+10*y_6_plus);
    _startView.origin = CGPointMake(_nameLabel.x, _addressLabel.bottom+15*y_6_plus);
    _favorLabel.origin = CGPointMake(_nameLabel.x, _startView.bottom+25*y_6_plus);
    _line.frame = CGRectMake(_icon.x, self.contentView.height-1, self.contentView.width-_icon.x*2, 1);
}

- (void)configCellWithDic:(NSDictionary *)dic{
    NSURL *url = [NSURL URLWithString:dic[@"logo_pic"]];
    
    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _nameLabel.text = dic[@"name"];
    _addressLabel.text  =dic[@"address"];
    _startView.scorePercent = [dic[@"level"] floatValue]/5;
//    _starLevelLabel.text = dic[@"level"];
    _favorLabel.text = [NSString stringWithFormat:@"好评率%@%@",dic[@"hpl"],@"%"];
}

@end
