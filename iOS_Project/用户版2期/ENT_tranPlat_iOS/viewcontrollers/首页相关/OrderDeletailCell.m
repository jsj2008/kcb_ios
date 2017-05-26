
//
//  OrderDeletailCell.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/21.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "OrderDeletailCell.h"

@implementation OrderDeletailCell
//{
//    UILabel *_serviceLabel;
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        _serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130*x_6_plus, 48*y_6_plus)];
//        _serviceLabel.font = WY_FONT_SIZE(30);
//        _serviceLabel.width = 900*x_6_plus;
//        _serviceLabel.textColor = kTextGrayColor;
//        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 950*x_6_plus, 48*y_6_plus)];
        _contentLabel.font = WY_FONT_SIZE(30);
        _contentLabel.width = 900*x_6_plus;
        _contentLabel.textColor = kTextGrayColor;
        _contentLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _contentLabel.origin = CGPointMake(30*x_6_plus, 0);
    _contentLabel.height = [_contentLabel getTextHeight];
    _contentLabel.centerY = self.contentView.boundsCenter.y;
}

//- (void)setServiceName:(NSString *)serviceName{
//    _serviceLabel.text = serviceName;
//    _serviceLabel.width = [_serviceLabel getTextWidth];
//    
//    [self setNeedsLayout];
//}

+ (CGFloat)getRowHeight:(NSString *)text{
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 950*x_6_plus, CGFLOAT_MAX)];
    l.font = V3_30PX_FONT;
    l.text = text;
    CGFloat h = [l getTextHeight];
    h += 26*2*y_6_plus;
    
    return h;
}

@end
