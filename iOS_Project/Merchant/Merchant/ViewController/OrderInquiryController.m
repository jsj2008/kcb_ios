//
//  OrderInquiryController.m
//  Merchant
//
//  Created by Wendy on 16/1/4.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import "OrderInquiryController.h"
#import "CustomTextField.h"
#import "CustomInputView.h"
//#import "YZKSelectTableView.h"
#import "DateSelectView.h"
#import "MELoginData.h"
#import "OrderManageController.h"
#import "ABBDropDatepickerView.h"

typedef NS_ENUM(NSInteger, ButtonType) {
    SeletctEventStatus = 21,
    SeletctEventAppraise
};

@interface OrderInquiryController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    NSString *statusValue;
    NSString *appraiseValue;
    UIView          *_pickerBgView;
    NSInteger currentSelectTag;


}
@property (nonatomic,strong) UITextField *orderTextfiled;
//@property (nonatomic,strong) CustomInputView *startTime;
//@property (nonatomic,strong) CustomInputView *endTime;
@property (nonatomic,strong)ABBDropDatepickerView *startTime;
@property (nonatomic,strong)ABBDropDatepickerView *endTime;
//@property (nonatomic,strong) CustomInputView *appointmentTime;
@property (nonatomic,strong) CustomInputView *statusTime;
@property (nonatomic,strong) CustomInputView *appraiseTime;
@property (nonatomic,strong) NSMutableArray *statusArray;
@property (nonatomic,strong) NSArray *appraiseArray;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation OrderInquiryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"订单查询"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroud;
    [self buildNavigationRightItem];
    [self buildUI];
    [self buildData];
}
- (void)buildData{
    statusValue = @"";
    appraiseValue = @"";
    
    NSArray *array = ApplicationDelegate.shareLoginData.userdata.order;
    self.statusArray = [[NSMutableArray alloc] initWithArray:array];
    
    self.appraiseArray = @[@"全部",@"好",@"中",@"差"];
}
- (void)buildNavigationRightItem{
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 55, 25);
    [btn addBorderWithWidth:1 color:RGB(140, 198, 142) corner:1];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    btn.titleLabel.font = V3_36PX_FONT;
    [btn setTitleColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(searchOrder)];
    
    UIBarButtonItem *right        = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;

}
- (void)buildUI{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 65)];
    topView.backgroundColor = RGB(249, 249, 249);
    _orderTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(20,18 , APP_WIDTH-40, 30)];
    _orderTextfiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入订单号" attributes:@{NSFontAttributeName: V3_36PX_FONT}];
    [topView addSubview:_orderTextfiled];
    _orderTextfiled.borderStyle = UITextBorderStyleRoundedRect;
    _orderTextfiled.delegate = self;
    [self.view addSubview:topView];
    
    UIView *bottomView =  [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom+10, APP_WIDTH, 160)];
    bottomView.backgroundColor = RGB(249, 249, 249);
    CGFloat cellHeigth = 40;
    //开始时间
    __weak __typeof(self)weakSelf = self;

//    _startTime = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, cellHeigth) title:@"开始时间：" placeholder:@"" value:@""];
//    _startTime.commplete = ^{
//        [weakSelf.view endEditing:YES];
//        [[DateSelectView sharedDateSelectView].datePicker setDatePickerMode:UIDatePickerModeDate];
//        [[DateSelectView sharedDateSelectView] showWithCompletion:^(NSDate *date)
//         {
//             NSString *text = [date stringWithDateFormat:DateFormatWithYearMonthDay];
//             [weakSelf.startTime setTextField:text];
//         }];
//
//    };
    _startTime = [[ABBDropDatepickerView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, cellHeigth)];
    [_startTime setDateTitle:@"开始时间"];
    _startTime.commplete = ^(id string){
        [weakSelf datePickerWillHidden];
    };

    [bottomView addSubview:_startTime];

    
    //结束时间
//    _endTime = [[CustomInputView alloc] initWithFrame:CGRectMake(0, _startTime.bottom, APP_WIDTH, cellHeigth) title:@"结束时间：" placeholder:@"" value:@""];
//    _endTime.commplete = ^{
//        [weakSelf.view endEditing:YES];
//        [[DateSelectView sharedDateSelectView].datePicker setDatePickerMode:UIDatePickerModeDate];
//
//        [[DateSelectView sharedDateSelectView] showWithCompletion:^(NSDate *date)
//         {
//             NSString *text = [date stringWithDateFormat:DateFormatWithYearMonthDay];
//             [weakSelf.endTime setTextField:text];
//         }];
//
//    };
    _endTime = [[ABBDropDatepickerView alloc] initWithFrame:CGRectMake(0, _startTime.bottom, APP_WIDTH, cellHeigth)];
    [_endTime setDateTitle:@"结束时间："];
    _endTime.commplete = ^(id string){
        [weakSelf datePickerWillHidden];
    };
    [bottomView addSubview:_endTime];

//    //预约时间
//    _appointmentTime = [[CustomInputView alloc]initWithFrame:CGRectMake(0, _endTime.bottom, APP_WIDTH, cellHeigth) title:@"预约时间：" placeholder:@"" value:@""];
//    _appointmentTime.commplete = ^{
//        [[DateSelectView sharedDateSelectView] showWithCompletion:^(NSDate *date)
//         {
//             NSString *text = [date stringWithDateFormat:DateFormatWithDateAndMinite];
//             [weakSelf.appointmentTime setTextField:text];
//         }];
//
//    };
//    [bottomView addSubview:_appointmentTime];

    //订单状态
    _statusTime = [[CustomInputView alloc]initWithFrame:CGRectMake(0, _endTime.bottom, APP_WIDTH, cellHeigth) title:@"订单状态：" placeholder:@"" value:@"全部"];
    _statusTime.commplete = ^{
        currentSelectTag = SeletctEventStatus;
        [weakSelf datePickerWillShow];
        
    };

    [_statusTime setRightImage:@"xlz"];
    [bottomView addSubview:_statusTime];
    
    //评价状态
    _appraiseTime = [[CustomInputView alloc] initWithFrame: CGRectMake(0, _statusTime.bottom, APP_WIDTH, cellHeigth)title:@"评价状态：" placeholder:@"" value:@"全部"];
    [_appraiseTime setRightImage:@"xlz"];
    _appraiseTime.commplete = ^{
        currentSelectTag = SeletctEventAppraise;
        [weakSelf datePickerWillShow];
        
    };
    [bottomView addSubview:_appraiseTime];
    [self.view addSubview:bottomView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchOrder{
    [self.view endEditing:YES];
//    if (_startTime.textField.text.length == 0 && _endTime.textField.text.length == 0 && _orderTextfiled.text.length == 0) {
//        [UIHelper alertWithMsg:@"请至少输入一个查询条件"];
//        return;
//    }
    OrderManageController  *orderManage = [[OrderManageController alloc] init];
    orderManage.isFromSearch = YES;
    orderManage.startTime = BLANK(_startTime.textField.text);
    orderManage.endTime = BLANK(_endTime.textField.text);
    orderManage.statusValue = BLANK(statusValue);
    orderManage.appraiseValue = BLANK(appraiseValue);
    orderManage.orderNo = BLANK(_orderTextfiled.text);
    [self.navigationController pushViewController:orderManage animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - popview代理

-(UIView *)pickerBgView
{
    if (_pickerBgView) {
        _pickerView.tag = currentSelectTag;
        [_pickerView reloadAllComponents];

        return _pickerBgView;
    }
    
    _pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 260)];
    _pickerBgView.height = 260;
    _pickerBgView.y = self.view.height;
    _pickerBgView.backgroundColor = [UIColor whiteColor];
    _pickerBgView.tag = currentSelectTag;
    // 构建一个picker view
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.tag = currentSelectTag;
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView reloadAllComponents];
    [_pickerBgView addSubview:_pickerView];
    
    UIToolbar *toolbar           = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               _pickerBgView.width,
                                                                               44)];
    UIBarButtonItem *spaceLeft   =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceLeft.width              = -10;
    toolbar.backgroundColor      = [UIColor lightGrayColor];
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-4"] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(close)];
    UIBarButtonItem *left        = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *space       =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"完成11"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(isOK)];
    
    UIBarButtonItem *right       = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *spaceRight  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceRight.width             = -10;
    toolbar.items                = [NSArray arrayWithObjects:spaceLeft,left,space,right,spaceRight, nil];
    
    [_pickerBgView addSubview:toolbar];
    
    return _pickerBgView;
}
- (void)close{
    [self datePickerWillHidden];
}
- (void)isOK{
    if(self.pickerView.tag == SeletctEventStatus){
        
        OrderStatus *model = self.statusArray[[self.pickerView selectedRowInComponent:0]];
        statusValue = model.status;
        [_statusTime setTextField:model.value];

        
    }else if(self.pickerView.tag == SeletctEventAppraise){
        [_appraiseTime setTextField:self.appraiseArray[[self.pickerView selectedRowInComponent:0]]];
        NSInteger value = [self.pickerView selectedRowInComponent:0];
        if (value == 0) {
            appraiseValue = @"";
        }else if(value == 1){
            appraiseValue = @"2";
        }else if(value == 2){
            appraiseValue = @"1";
        }else{
            appraiseValue = @"0";
        }
        

    }
    [self datePickerWillHidden];
}
- (void)datePickerWillShow{
    [self.view endEditing:YES];
    
    [self.view addSubview:self.pickerBgView];
    [UIView animateWithDuration:.3 animations:^{
        self.pickerBgView.y = self.view.height - self.pickerBgView.height;
    }];
}

- (void)datePickerWillHidden{
    [UIView animateWithDuration:.3 animations:^{
        self.pickerBgView.y = self.view.height;
    } completion:^(BOOL finished) {
        [self.pickerBgView removeFromSuperview];
    }];
}
#pragma mark dataSouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag == SeletctEventStatus){
        return self.statusArray.count;
    }
    else if(pickerView.tag == SeletctEventAppraise){
        return self.appraiseArray.count;
    }
    return 0;
}
#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == SeletctEventStatus){
        OrderStatus * item = self.statusArray[row];
        return item.value;
    }else if(pickerView.tag == SeletctEventAppraise){
        return self.appraiseArray[row];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}
#pragma mark UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _orderTextfiled) {
        [self datePickerWillHidden];
    }
}
@end
