//
//  OrderManageController.m
//  Merchant
//
//  Created by Wendy on 15/12/18.
//  Copyright © 2015年 tranPlat. All rights reserved.
//

#import "OrderManageController.h"
#import "OrderInquiryController.h"
#import "HomeOrderCell.h"
#import "OrderDetailController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MEOrderList.h"
#import "CustomMJRefreshGifHeader.h"
#import "CustomMJRefreshGifFooter.h"

#define ROWS_PER_PAGE_ORDER @"10"


@interface OrderManageController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPages;
    NSInteger currentRefreshType;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation OrderManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavBarUI];
    //上拉刷新
    self.tableView.mj_header = [CustomMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshOrderManageListHeader)];
    
    //下拉加载更多
    self.tableView.mj_footer = [CustomMJRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshOrderManageListFooter)];
    
    [self buildData];
}
- (void)buildNavBarUI{
    CGFloat height = 0;
    if (_isFromSearch) {
        [self setNavTitle:@"查询结果"];
    }else{
        [self setNavTitle:@"订单管理"];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(orderSearch)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        height = APP_TAB_HEIGHT;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - APP_NAV_HEIGHT - APP_STATUS_BAR_HEIGHT - height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(234, 234, 234);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

}
- (void)buildData{
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    currentPages = 1;
    [self requetOrderListPages:currentPages];

}
- (void)showEmptyView:(BOOL)show{
    if (show) {
        self.tableView.tableHeaderView = [self createEmptyView];
    }else{
        self.tableView.tableHeaderView = nil;
    }
}
- (UIView *)createEmptyView{
    UIView *view = [[UIView alloc] initWithFrame:self.tableView.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 129, 100)];
    imgView.centerX = view.centerX;
    imgView.centerY = view.centerY - 40;
    imgView.image = [UIImage imageNamed:@"noOrder"];
    UILabel *emptyView = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 20, view.width, 40)];
    emptyView.backgroundColor = kColorBackgroud;
    emptyView.text = @"没有相关订单哦，亲";
    emptyView.textAlignment = NSTextAlignmentCenter;
    emptyView.textColor = kColorOX555555;

    [view addSubview:imgView];
    [view addSubview:emptyView];
    return view;
}
- (void)refreshOrderManageListHeader{
    
    currentRefreshType = RefreshTypeHeader;
    currentPages = 1;
    [self requetOrderListPages:currentPages];
}
- (void)refreshOrderManageListFooter{
    currentRefreshType = RefreshTypeFooter;
    currentPages ++;
    [self requetOrderListPages:currentPages];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求接口
- (void)requetOrderListPages:(NSInteger)page{
    NSInteger merchantId =  ApplicationDelegate.shareLoginData.userdata.mid;
    NSDictionary *param = @{@"merchantId":[NSNumber numberWithInteger:merchantId].stringValue,
                            @"page":[NSNumber numberWithInteger:page].stringValue,
                            @"rows":ROWS_PER_PAGE_ORDER,
                            @"role":@"1",
                            @"type":@"-1",
                            @"account":ApplicationDelegate.accountId
                            };
    
    if (_isFromSearch) {
        param = @{@"merchantId":[NSNumber numberWithInteger:merchantId].stringValue,
                  @"submitStartTime":_startTime,
                  @"submitEndTime":_endTime,
                  @"orderNo":_orderNo,
                  @"type":_appraiseValue,
                  @"status":_statusValue,
                  @"page":[NSNumber numberWithInteger:page].stringValue,
                  @"rows":ROWS_PER_PAGE_ORDER,
                  @"role":@"1",
                  @"account":ApplicationDelegate.accountId
                  };
    }
    
    [AFNHttpRequest afnHttpRequestUrlNonHub:kHttpOrderList param:param success:^(id responseObject) {
        
        [self endRefresh];
        
        if (currentPages == 1) {
            [self.dataArray removeAllObjects];
        }
        
        if (kRspCode(responseObject) == 0) {
            NSDictionary *pBizCustomDict = responseObject[@"body"][0];
            NSArray * orderList  = pBizCustomDict[@"orderList"];
            NSArray *list = [MEOrderList mj_objectArrayWithKeyValuesArray:orderList];
            
            if(list.count == 0 && currentPages >1){
                currentPages --;
            }
            [self.dataArray addObjectsFromArray:list];
            
            if (self.dataArray.count > 0) {
                [self showEmptyView:NO];
                [self.tableView reloadData];
            }else{
                [self showEmptyView:YES];
            }
            
        }else{
            [UIHelper alertWithMsg:kRspMsg(responseObject)];
            if(currentRefreshType == RefreshTypeFooter && currentPages > 1){
                currentPages --;
            }
        }
        
    } failure:^(NSError *error) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HomeOrderCell";
    HomeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[HomeOrderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MEOrderList * item = self.dataArray[indexPath.section];
    
    [cell setCellModelsLab:item.carName];
    [cell setCellMobileLab:item.phoneNo];
    [cell setCellAmountLab:[NSString stringWithFormat:@"%.2f",item.payPrice]];
    [cell setCellAppointmentLab:item.bookingTime];
    [cell setCellStatusLab:item.status];
    cell.actionBtn.hidden = YES;

    return cell;
}

- (void)orderSearch{
    OrderInquiryController *orderSc = [[OrderInquiryController alloc] init];
    orderSc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderSc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOrderList *item = self.dataArray[indexPath.section];
    
    OrderDetailController *orderDetail = [[OrderDetailController alloc] init];
    orderDetail.commplete = ^(id string){
        //在订单管理中确认订单后，重新刷新列表；同时也需要更新首页的新订单列表
        [self buildData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:@"1"];//传入参数1，重新刷新首页中的新订单
    };
    orderDetail.orderId = [NSNumber numberWithInteger:item.ids].stringValue;
    orderDetail.orderNo = item.orderNo;
    orderDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
}
@end
