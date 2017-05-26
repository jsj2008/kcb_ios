//
//  OrderDetailCell.m
//  Merchant
//
//  Created by Wendy on 16/1/12.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGFloat leftMargin = 10;
        CGFloat margin = 10;
        CGFloat height = 88;
        CGFloat imgWidth = 50;
        [self.contentView addLineWithFrame:CGRectMake(0, 0, APP_WIDTH, 1) lineColor:kLineColor];
        
        _iconView= [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, (height-imgWidth)/2, imgWidth, imgWidth)];
        _iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _iconView.layer.borderWidth = 1;
        _iconView.layer.cornerRadius = 2;
        [self.contentView addSubview:_iconView];
        
        _mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right +margin, 10, 200, height/2 )];
        _mainLabel.numberOfLines = 0;
        _mainLabel.font = V3_34PX_FONT;
        [self.contentView addSubview:_mainLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mainLabel.left, height/2-5, self.width, height/2)];
        _subTitleLabel.font = V3_30PX_FONT;
        [self.contentView addSubview:_subTitleLabel];
        
        _rightLable = [[UILabel alloc] initWithFrame:CGRectMake(APP_WIDTH-85, _mainLabel.top, 75, height/2)];
        _rightLable.adjustsFontSizeToFitWidth =YES;
        _rightLable.textAlignment = NSTextAlignmentRight;
        _mainLabel.right = _rightLable.left;
        [self.contentView addSubview:_rightLable];
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

- (void)setRightLabelPrice:(CGFloat)price amount:(NSString *)amount{
    
    NSString *priceStr = [NSNumber numberWithFloat:price].stringValue;
    
    NSString *string = [NSString stringWithFormat:@"¥%@x%@", priceStr,amount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0X949694 } range:NSMakeRange(0, string.length)];
    
    [attributedString addAttributes:@{ NSFontAttributeName: V3_36PX_FONT, NSForegroundColorAttributeName: kColor0XFF9418 } range:NSMakeRange(0, priceStr.length + 1)];
    self.rightLable.attributedText = attributedString;
}
@end