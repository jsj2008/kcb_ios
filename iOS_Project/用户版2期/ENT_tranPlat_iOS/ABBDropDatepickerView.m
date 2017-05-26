//
//  ABBDropDatepickerView.m
//  ReimbursementForABB
//
//  Created by Crystal on 15/11/9.
//  Copyright © 2015年 wendy. All rights reserved.
//

#import "ABBDropDatepickerView.h"
#define kRightImageWidth 20
#define kRightImageHeight 20

@interface ABBDropDatepickerView(){
    UIWindow *containerWindow;
    UILabel *settingLab;
    UIImageView *rightImageView;
}
@property (nonatomic, strong) UIView *datePickerBackView;
@property (nonatomic, strong) UIButton *tableContainer;


@end
@implementation ABBDropDatepickerView
{
    NSDate *_date;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _date = [NSDate dateWithTimeIntervalSinceNow:1*24*60*60];
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownButtonClicked:)];
//        [self addGestureRecognizer:gesture];
        
        CGFloat margin = 15;
        settingLab = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 110, self.height)];
        settingLab.textColor = [UIColor colorWithHex:0x666666];
        settingLab.font = V3_36PX_FONT;
        [self addSubview:settingLab];

        containerWindow = [UIApplication sharedApplication].keyWindow;

        _textField = [[UITextField alloc] initWithFrame:CGRectMake(settingLab.right, 0, 0, frame.size.height)];
        _textField.enabled = NO;
        _textField.font = V3_36PX_FONT;
        _textField.textColor = [UIColor colorWithHex:0x666666];

        [self addSubview:_textField];
        
        rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width- kRightImageWidth -margin, (self.height-kRightImageHeight)/2, kRightImageWidth, kRightImageHeight)];
        rightImageView.image = [UIImage imageNamed:@"time02"];
        rightImageView.userInteractionEnabled = YES;
        rightImageView.contentMode = UIViewContentModeCenter;
        _textField.right = rightImageView.left;
//        [self addSubview:rightImageView];
        [self addLineWithFrame:CGRectMake(margin, self.height-1, self.width-2*margin, 1) lineColor:kLineGrayColor];
        
        _tableContainer = [[UIButton alloc] initWithFrame:containerWindow.frame];
        _tableContainer.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        [_tableContainer addTarget:self action:@selector(tableContainerTapped:)];
    }
    return self;
}

- (void)tableContainerTapped:(id)sender
{
    [self updateDropDownTable:NO];
}

- (void)dropDownButtonClicked
{
    [self.superview.superview endEditing:YES];
    [self setNeedsLayout];
    [self updateDropDownTable:YES];
    [self datePickerWillShow];
}

- (void)updateDropDownTable:(BOOL)visible{
    if (visible) {
        [containerWindow addSubview:_tableContainer];
        [_tableContainer addSubview:[self datePickerBackView]];
    } else {
        [self  close];
    }
}

- (void)setDateTitle:(NSString *)title{
    settingLab.text = title;
}

//获取当前后n个月
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}

-(UIView *)datePickerBackView{
    if (_datePickerBackView) {
        return _datePickerBackView;
    }
    
    _datePickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, containerWindow.width, 260)];
    _datePickerBackView.height = 260;
    _datePickerBackView.y = APP_HEIGHT;
    _datePickerBackView.backgroundColor = [UIColor whiteColor];
    
    _picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, containerWindow.width, 216)];
    NSDate *tomrrow = [NSDate dateWithTimeIntervalSinceNow:1*24*60*60];
    _picker.minimumDate = tomrrow;
    _picker.maximumDate = [self getPriousorLaterDateFromDate:[NSDate date] withMonth:1];
    _picker.datePickerMode = UIDatePickerModeDate;
    if (_type.intValue == 1) {
        _picker.datePickerMode = UIDatePickerModeTime;
    }
    _picker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CH"];
    
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.width,44)];
//    toolbar.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *spaceLeft =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
//UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceLeft.width = 0;
//    
//    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(10, 0, 60, 30);
//    [btn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-4"] forState:UIControlStateNormal];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor]];
//    [btn addTarget:self action:@selector(close)];
//    
//    UIBarButtonItem *left        = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
//    UIBarButtonItem *space       =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
//                                   UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(10, 0, 60, 30);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"完成11"] forState:UIControlStateNormal];
//    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor]];
//    [rightBtn addTarget:self action:@selector(isOK)];
//    
//    UIBarButtonItem *right       = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    
//    UIBarButtonItem *spaceRight  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
//                                   UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceRight.width             = 0;
//    toolbar.items                = [NSArray arrayWithObjects:left,space,right, nil];
    UIToolbar *toolbar           = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               _datePickerBackView.width,
                                                                               44)];
    toolbar.barTintColor = COLOR_NAV;
    UIBarButtonItem *spaceLeft   =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceLeft.width              = 10;
    toolbar.backgroundColor      = COLOR_NAV;
    toolbar.tintColor = COLOR_NAV;
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
//    [btn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-4"] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(close)];
    UIBarButtonItem *left        = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *space       =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"完成11"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(isOK)];
    
    UIBarButtonItem *right       = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *spaceRight  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceRight.width             = 10;
    toolbar.items                = [NSArray arrayWithObjects:spaceLeft,left,space,right, spaceRight,nil];
    
    [_datePickerBackView addSubview:toolbar];
    [_datePickerBackView addSubview:_picker];
    
    return _datePickerBackView;
}

- (void)close{
    [self datePickerWillHidden];
}

- (void)isOK{
    self.selectDate = [[_picker date] stringWithDateFormat:DateFormatWithYearMonthDay];
    _date = _picker.date;
    if (_commplete) {
        _commplete(self.selectDate);
    }
//    _textField.text = [[_picker date]stringWithDateFormat:DateFormatWithYearMonthDay];
//    
//
//    if (_picker.datePickerMode == UIDatePickerModeTime) {
//        _textField.text = [[_picker date]stringWithDateFormat:DateFormatWithTime];
//
//    }
    [self datePickerWillHidden];
}

- (void)datePickerWillShow{
    
    [UIView animateWithDuration:.23f animations:^{
        _tableContainer.hidden = NO;
        self.datePickerBackView.y = containerWindow.height - self.datePickerBackView.height;
        self.picker.date = _date;
    }];
}

- (void)datePickerWillHidden{
    [UIView animateWithDuration:.23 animations:^{
        _tableContainer.hidden = YES;
        self.datePickerBackView.y = containerWindow.height;
        [_tableContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_tableContainer removeFromSuperview];

    }];
}
//- (void)dealloc{
//    [_tableContainer removeFromSuperview];
//}
@end
