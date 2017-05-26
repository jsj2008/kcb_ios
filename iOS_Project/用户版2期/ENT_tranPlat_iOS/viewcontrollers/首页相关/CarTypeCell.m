//
//  CarTypeCell.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/5.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "CarTypeCell.h"

@implementation CarTypeCell
{
    UILabel *_nameLabel;
    UIImageView *_icon;
    UILabel *_typeLabel;
    UILabel *_timeLabel;                    //登机时间
    UILabel *_stateLabel;
    
    UILabel *_fitLabel;
    
    UIButton *_editBtn;
    UIButton *_deleteBtn;
    
    UIView *_line1;
    UIView *_line2;
    UIView *_line3;
    UIView *_line4;
    UIView *_line5;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat h = 22*y_6_SCALE;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 550*x_6_plus, h)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = FONT_SIZE(42, x_6_plus);
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 182*x_6_plus, 182*4/5*y_6_plus)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [_icon addBorderWithWidth:1 color:[UIColor colorWithHex:0xcccccc]];
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 580*x_6_plus, 38*y_6_plus)];
        _typeLabel.font = V3_30PX_FONT;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 580*x_6_plus, 38*y_6_plus)];
        _timeLabel.font = V3_30PX_FONT;

        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 182*x_6_plus, 50*y_6_plus)];
        _stateLabel.font = FONT_SIZE(13, x_6_SCALE);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor redColor];
        
        _selectV = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectV addActionBlock:^(id weakSender) {
            _selectV.selected = !_selectV.selected;
            if (_commplete) {
                _commplete(OpertionConfig);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [_selectV setBackgroundImage:[UIImage imageNamed:@"sel02"] forState:UIControlStateNormal];
        [_selectV setBackgroundImage:[UIImage imageNamed:@"sel01"] forState:UIControlStateSelected];
        _selectV.frame = CGRectMake(0, 0, 20*y_6_SCALE, 20*y_6_SCALE);
        _fitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170*x_6_plus, 40*y_6_plus)];
        _fitLabel.text = @"设为默认";
        _fitLabel.font = FONT_SIZE(36, x_6_plus);
    //     _fitLabel.textColor = FONT_SIZE(36, x_6_plus);
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"edit"]  forState:UIControlStateNormal];
        
        [_editBtn addActionBlock:^(id weakSender) {
            if (_commplete) {
                _commplete(OpertionEditting);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        _editBtn.titleLabel.font = FONT_SIZE(15, x_6_SCALE);
        [_editBtn setTitleColor:kTextGrayColor];
        _editBtn.frame = CGRectMake(0, 0, 60*x_6_SCALE, h);
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn addActionBlock:^(id weakSender) {
            if (_commplete) {
                _commplete(OpertionDelete);
            }
        } forControlEvents:UIControlEventTouchUpInside];

        [_deleteBtn setImage:[UIImage imageNamed:@"del"]  forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = FONT_SIZE(15, x_6_SCALE);
        [_deleteBtn setTitleColor:kTextGrayColor];
        _deleteBtn.frame = CGRectMake(0, 0, 60*x_6_SCALE, h);
        
        _line1 = [self.contentView addLineWithFrame:CGRectMake(0, 0, APP_WIDTH, .5f) lineColor:kLineGrayColor];
        //_line2 = [self.contentView addLineWithFrame:CGRectMake(0, 0, .5f, 95*y_6_SCALE) lineColor:kLineGrayColor];
        _line3 = [self.contentView addLineWithFrame:CGRectMake(0, 0, APP_WIDTH, .5f) lineColor:kLineGrayColor];
        _line4 = [self.contentView addLineWithFrame:CGRectMake((1080-310)*x_6_plus, 20*y_6_plus, .5f,310*y_6_plus ) lineColor:kLineGrayColor];
        _line5 = [self.contentView addLineWithFrame:CGRectMake((1080-310+310/2)*x_6_plus, (350/2+20+20)*y_6_plus ,1, 100*y_6_plus) lineColor:kLineGrayColor];
 
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_typeLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_stateLabel];
        [self.contentView addSubview:_selectV];
        [self.contentView addSubview:_fitLabel];
        [self.contentView addSubview:_editBtn];
        [self.contentView addSubview:_deleteBtn];
        
        [self.contentView addSubview:_line1];
        //[self.contentView addSubview:_line2];
        [self.contentView addSubview:_line3];
        [self.contentView addSubview:_line4];
        [self.contentView addSubview:_line5];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _icon.origin = CGPointMake(40*x_6_plus, 55*y_6_plus);
    _nameLabel.origin = CGPointMake(_icon.right+35*x_6_plus, _icon.y);
    _typeLabel.origin = CGPointMake(_nameLabel.x, _nameLabel.bottom);
    _timeLabel.origin = CGPointMake(_nameLabel.x, _typeLabel.bottom+2*y_6_plus);
    
    _stateLabel.origin = CGPointMake(_icon.x, _icon.bottom+35*y_6_plus);
    _stateLabel.centerX = _icon.centerX;

    _line1.origin = CGPointMake(0, 0);
    _line3.origin = CGPointMake(0, self.contentView.height-1);
    _line4.height = self.contentView.height-80*y_6_plus;
    _line4.origin = CGPointMake(self.contentView.width-80*x_6_plus-_editBtn.width*2, 40*y_6_plus);
    
    _selectV.frame = CGRectMake(_line4.x+40*x_6_plus, _icon.y, 60*x_6_plus, 60*y_6_plus);
    _fitLabel.origin = CGPointMake(_selectV.right+20*x_6_plus, 0);
    _fitLabel.centerY = _selectV.centerY;
    
    _editBtn.frame = CGRectMake(_selectV.x-20*x_6_plus, _selectV.bottom+60*y_6_plus, 120*x_6_plus, 120*y_6_plus);
    _deleteBtn.frame = CGRectMake(self.contentView.width-20*x_6_plus-_editBtn.width, _editBtn.y, _editBtn.width, _editBtn.height);
    _line5.origin = CGPointMake(_deleteBtn.x-18*x_6_plus, _editBtn.y-(_line5.height-_editBtn.height)/2);
    
    _nameLabel.width = _line4.x-_nameLabel.x-20*x_6_plus;
}

- (void)configCellWithCar:(CarInfo *)car{
    _car = car;
    _hphm = car.hphm;
    if ([car.clpp1 isLegal]&&![car.clpp1 isEqualToString:@"(null)"]&&[car.line isLegal]&&![car.line isEqualToString:@"(null)"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@-%@",car.clpp1,car.line];
    }else{
        if (([car.clpp1 isLegal]&&[car.clpp1 isEqualToString:@"(null)"])||![car.clpp1 isLegal]) {
            _nameLabel.text = car.line;
        }else{
            _nameLabel.text = car.clpp1;
        }
    }
    _nameLabel.height = [_nameLabel getTextHeight];
    _typeLabel.text = [car.detailDes isLegal]&&![car.detailDes isEqualToString:@"(null)"]?car.detailDes:@"";
    if (car.clsbdh.length >= 3) {
        NSString *urlstr = [NSString stringWithFormat:@"http://idc.pic-01.956122.com/allPic/CarLogo/%@.jpg", [[car.clsbdh substringToIndex:3] uppercaseString]];
        
        [_icon setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"home_car_brand_default"]];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:car.icon] placeholderImage:[UIImage imageNamed:@"home_car_brand_default"]];
    }
    _stateLabel.text = car.vehiclestatus;
    if ([car.pql isLegal] && [car.nk isLegal] && ![car.pql isEqualToString:@"(null)"] && ![car.nk isEqualToString:@"(null)"]) {
        _timeLabel.text = [NSString stringWithFormat:@"%@ %@",car.pql,car.nk];
    }else{
        _timeLabel.text = @"";
    }
    _stateLabel.width = [_stateLabel.text getTextWidthWithFont:FONT_SIZE(13, x_6_SCALE) height:22*y_6_SCALE]+6;
    [_stateLabel addBorderWithWidth:1 color:kLineGrayColor];
   
}
@end
