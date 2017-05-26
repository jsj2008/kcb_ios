//
//  BillSearchController.m
//  Merchant
//
//  Created by Wendy on 16/1/27.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import "BillSearchController.h"
#import "CustomInputView.h"
#import "DateSelectView.h"
#import "BillSearchCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MEBillList.h"
#import "ABBDropDatepickerView.h"
#import "OrderDetailController.h"
#import "CustomMJRefreshGifFooter.h"
#import "CustomMJRefreshGifHeader.h"

@interface BillSearchController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentPages;
    NSInteger currentRefreshType;
    NSMutableArray *_sortLetterArray;
    
    BOOL showHud;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ABBDropDatepickerView *startTime;
@property (nonatomic, strong) ABBDropDatepickerView *endTime;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, copy) NSString * price;

@property (nonatomic, strong) UILabel *incomeLabel;
@end

@implementation BillSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    self.view.backgroundColor = kColorBackgroud;
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    _sortLetterArray = [[NSMutableArray alloc]initWithCapacity:0];
    //上拉刷新
    self.tableView.mj_header = [CustomMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshBillManageListHeader)];
    
    //下拉加载更多
    self.tableView.mj_footer = [CustomMJRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshBillManageListFooter)];
    
    [self timeControlInit];//请求数据
    [self createTabelFooterView];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _startTime.picker.datePickerMode = UIDatePickerModeDate;
    _endTime.picker.datePickerMode = UIDatePickerModeDate;
}
- (void)buildUI{
    [self setNavTitle:@"账单查询"];
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, self.view.width, self.view.height - APP_NAV_HEIGHT - APP_STATUS_BAR_HEIGHT-APP_TAB_HEIGHT-170) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self createTableHeaderView];
}
- (void)createTabelFooterView{
    _incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.height - APP_NAV_HEIGHT - APP_STATUS_BAR_HEIGHT-APP_TAB_HEIGHT- 40, APP_WIDTH-40, 40)];
//    _incomeLabel.text = [NSString stringWithFormat:@"+%@",_price];
    _incomeLabel.textAlignment = NSTextAlignmentRight;
    _incomeLabel.font = V3_42PX_FONT;
    _incomeLabel.textColor = kColor0XFF9418;
    [self.view addSubview:_incomeLabel];
}
- (void)createTableHeaderView{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, APP_WIDTH, 170)];
    backView.backgroundColor = [UIColor whiteColor];
    
    __weak __typeof(self)weakSelf = self;
    
//    _startTime = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40) title:@"起止时间：" placeholder:@"" value:@""];
//    [_startTime setRightImage:@"list_mingxi02"];
//    _startTime.commplete = ^{
//        [[DateSelectView sharedDateSelectView].datePicker setDatePickerMode:UIDatePickerModeDate];
//        [[DateSelectView sharedDateSelectView] showWithCompletion:^(NSDate *date)
//         {
//             NSString *text = [date stringWithDateFormat:DateFormatWithYearMonthDay];
//             [weakSelf.startTime setTextField:text];
//         }];
//    };
    _startTime = [[ABBDropDatepickerView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    [_startTime setDateTitle:@"起止时间："];
    _startTime.commplete = ^(id string){
    };

    [backView addSubview:_startTime];
    
    //结束时间
//    _endTime = [[CustomInputView alloc] initWithFrame:CGRectMake(0, _startTime.bottom, APP_WIDTH, 40) title:@"终止时间：" placeholder:@"" value:@""];
//    [_endTime setRightImage:@"list_mingxi02"];
//    _endTime.commplete = ^{
//        [[DateSelectView sharedDateSelectView].datePicker setDatePickerMode:UIDatePickerModeDate ];
//        [[DateSelectView sharedDateSelectView] showWithCompletion:^(NSDate *date)
//         {
//             NSString *text = [date stringWithDateFormat:DateFormatWithYearMonthDay];
//             [weakSelf.endTime setTextField:text];
//         }];
//        
//    };
    _endTime = [[ABBDropDatepickerView alloc] initWithFrame:CGRectMake(0, _startTime.bottom, APP_WIDTH, 40)];
    [_endTime setDateTitle:@"终止时间："];
    _endTime.commplete = ^(id string){
    };

    [backView addSubview:_endTime];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(15, _endTime.bottom+40, APP_WIDTH-30, 40);
    [searchBtn setTitle:@"查询"];
    [searchBtn setTitleColor:kColor0X39B44A];
    [searchBtn addBorderWithWidth:0.8 color:kColor0X39B44A corner:2];
    [searchBtn addTarget:self action:@selector(btnAction:)];
    [backView addSubview:searchBtn];
    
    [self.view addSubview:backView];
}
- (void)timeControlInit{
    NSString *startTimeTmp = [[NSDate date] stringWithDateFormat:DateFormatWithYearMonth];
    NSString *endTimeTmp = [[NSDate date] stringWithDateFormat:DateFormatWithYearMonthDay];
//    [_startTime setTextField:[NSString stringWithFormat:@"%@-01",startTimeTmp]];
    _startTime.textField.text = [NSString stringWithFormat:@"%@-01",startTimeTmp];
//    [_endTime setTextField:endTimeTmp];
    _endTime.textField.text = endTimeTmp;
    currentPages = 1;
    showHud = YES;
    [self requestBill:currentPages];
    
}
- (void)refreshBillManageListHeader{
    currentRefreshType = RefreshTypeHeader;
    currentPages = 1;
    showHud = NO;
    [self requestBill:currentPages];
}
- (void)refreshBillManageListFooter{
    currentRefreshType = RefreshTypeFooter;
    currentPages ++;
    showHud = NO;
    [self requestBill:currentPages];
}
- (void)btnAction:(UIButton *)sender{
    if ([_startTime.textField.text compare:_endTime.textField.text] == NSOrderedDescending) {
        [UIHelper showText:@"终止时间不能小于起止时间" ToView:self.view];
        return;
    }
    currentPages = 1;
    showHud = YES;
    [self requestBill:currentPages];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestBill:(NSInteger)page{
    NSInteger merchantId = ApplicationDelegate.shareLoginData.userdata.mid;
    NSDictionary *dict = @{@"merid":[NSNumber numberWithInteger:merchantId].stringValue,
                           @"page":[NSNumber numberWithInteger:page].stringValue,
                           @"rows":@"10",
                           @"stime":BLANK(_startTime.textField.text),
                           @"etime":BLANK(_endTime.textField.text)
                           };
    MBProgressHUD *hudview;
    if (showHud) {
        hudview = [[MBProgressHUD alloc] initWithView:self.view];
        hudview.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_icon"]];
        hudview.mode = MBProgressHUDModeCustomView;
        hudview.color = [UIColor clearColor];
        hudview.customView.size = CGSizeMake(50, 50);
        [self startAnimation:hudview.customView];
        [self.view addSubview:hudview];
        [hudview show:YES];

    }
    [AFNHttpRequest afnHttpRequestUrlNonHub:kHttpMybill param:dict success:^(id responseObject) {
        if (showHud) {
            [hudview hide:YES];
        }

        [self endRefresh];
        if (currentPages == 1) {
            [self.dataArray removeAllObjects];
        }
        if (kRspCode(responseObject) == 0) {
            NSDictionary *pBizCustomDict = responseObject[@"body"];
            MEBillList * billList  = [MEBillList mj_objectWithKeyValues:pBizCustomDict];
            NSArray *list = billList.myBill;
            _price = billList.sumPrice;
            if(list.count == 0 && currentPages >1){
                currentPages --;
            }
            [self.dataArray addObjectsFromArray:list];
            [self dealDataForSection];

        }else{
            _incomeLabel.text = @"";
            [UIHelper alertWithMsg:kRspMsg(responseObject)];
            if(currentRefreshType == RefreshTypeFooter && currentPages > 1){
                currentPages --;
            }
        }


    } failure:^(NSError *error) {
        if (showHud) {
            [hudview hide:YES];
        }
        _incomeLabel.text = @"";
        [UIHelper alertWithMsg:kNetworkErrorDesp];
        if(currentRefreshType == RefreshTypeFooter && currentPages > 1){
            currentPages --;
        }
        [self endRefresh];

    } view:self.view];
}
- (void)endRefresh{
    if (currentRefreshType == RefreshTypeHeader) {
        [self.tableView.mj_header endRefreshing];
    }else if(currentRefreshType == RefreshTypeFooter){
        [self.tableView.mj_footer endRefreshing];
    }

}
- (void)dealDataForSection{
    [_dataDict removeAllObjects];
    
    for (Mybill *item in self.dataArray) {
        NSString *time = item.successTime.length >10 ?[item.successTime substringToIndex:10]:@"";
        item.sectionTime = time;
    }
    
    
    [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(Mybill *obj1, Mybill *obj2) {
        return [obj1.successTime compare:obj2.successTime];
    }];
    
    for (Mybill *item in self.dataArray) {
        
        NSMutableArray *letterArray = [_dataDict objectForKey:item.sectionTime];
        
        if (!letterArray) {
            letterArray = [NSMutableArray array];
            [_dataDict setObject:letterArray
                          forKey:item.sectionTime];
        }
        
        [letterArray addObject:item];
    }

    [_sortLetterArray removeAllObjects];
    NSArray *array = [[_dataDict allKeys] sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    [_sortLetterArray addObjectsFromArray:array];
    
    if (_sortLetterArray.count == 0) {
        [self showEmptyView:YES];
    }else{
        [self showEmptyView:NO];
        [self.tableView reloadData];
    }
}

- (void)showEmptyView:(BOOL)show{
    if (show) {
        UILabel *emptyView = [[UILabel alloc] initWithFrame:self.tableView.frame];
        emptyView.text = @"没有账单哦，亲";
        emptyView.textAlignment = NSTextAlignmentCenter;
        emptyView.textColor = kColorOX555555;
        self.tableView.tableHeaderView = [self createEmptyView];
        _incomeLabel.text = @"";

    }else{
        self.tableView.tableHeaderView = nil;
        _incomeLabel.text = [NSString stringWithFormat:@"+%@",_price?_price:@""];

    }
}
- (UIView *)createEmptyView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 129, 100)];
    imgView.centerX = view.centerX;
    imgView.centerY = view.centerY - 40;
    imgView.image = [UIImage imageNamed:@"noOrder"];
    UILabel *emptyView = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 20, view.width, 40)];
    emptyView.backgroundColor = [UIColor whiteColor];
    emptyView.text = @"没有账单哦，亲";
    emptyView.textAlignment = NSTextAlignmentCenter;
    emptyView.textColor = kColorOX555555;
    
    [view addSubview:imgView];
    [view addSubview:emptyView];
    return view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.width-20, 29)];
    label.text = _sortLetterArray[section];
    label.font = V3_32PX_FONT;
    label.textColor = kColor0X666666;
    [view addSubview:label];
    [view addLineWithFrame:CGRectMake(label.left, label.bottom, label.width, 1) lineColor:kLineColor];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sortLetterArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataDict[_sortLetterArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BillSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[BillSearchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSArray *array = _dataDict[_sortLetterArray[indexPath.section]];
    Mybill *item = array[indexPath.row];
    
    cell.titleLabel.text = item.carName;
    [cell.button setBackgroundColor:kColor0X39B44A];
    [cell.button setTitle:item.serviceName];
    cell.amountLabel.text = item.sr;
    
    cell.button.imageEdgeInsets = UIEdgeInsetsMake(0, -cell.button.imageView.x, 0, 0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = _dataDict[_sortLetterArray[indexPath.section]];
    Mybill *item = array[indexPath.row];

    OrderDetailController *orderDetail = [[OrderDetailController alloc] init];
    orderDetail.commplete = ^(id string){
    };
    orderDetail.orderId = item.ids;
    orderDetail.orderNo = item.orderNo;
    orderDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

#pragma mark -  MBHud动画
- (void)startAnimation:(UIView *)imageView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = .4f;
    animation.fromValue = [NSNumber numberWithFloat:M_PI/5];
    animation.toValue = [NSNumber numberWithFloat:-M_PI/5];
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = YES;
    
    [imageView.layer addAnimation:animation forKey:nil];
    
}
@end
