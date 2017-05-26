//
//  OrderDetailController.m
//  
//
//  Created by 辛鹏贺 on 16/1/18.
//
//

#import "OrderDetailController.h"
#import "OrderPayViewController.h"
#import "OrderOutletCell.h"
#import "OrderTypeCell.h"
#import "OrderSelectCell.h"
#import "FittingsCell.h"
#import "OrderDetailCell.h"
#import "OrderPersonMessCell.h"
#import "QRCell.h"
#import "WaitTableViewCell.h"
#import "OrderDetailServiceCell.h"
#import "OrderRefoundController.h"
#import "OrderCommentViewController.h"

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, strong)NSMutableArray *serFeeArr;//机油机滤
//@property (nonatomic, strong)NSMutableArray *subArr;//机油机滤
@property (nonatomic, strong)NSString *status;
@end

static NSString *cellId = @"cellId";
static NSString *personCellId = @"personCellId";
static NSString *outletCellId = @"outletCellId";
static NSString *fittingCellId = @"fittingCellId";
static NSString *serviceCellId = @"serviceCellId";
static NSString *typeCellId = @"typeCellId";
static NSString *selectCellId = @"selectCellId";
static NSString *detailCellId = @"detailCellId";
static NSString *qrCellId = @"qrCellId";

@implementation OrderDetailController
{
    UILabel *_priceLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

- (void)requestData{
    [self.footerView removeFromSuperview];
    [UITools showIndicatorToView:self.view];
    [[NetworkEngine sharedNetwork] postBody:@{@"orderId":_orderId,@"orderNo":_orderNo} apiPath:kOrderDetailURL hasHeader:YES finish:^(ResultState state, id resObj) {
        [UITools hideHUDForView:self.view];
        [self.tableView.header endRefreshing];
        if (state == StateSucceed) {
            [self.dataSource removeAllObjects];
            self.dataSource = [NSMutableDictionary dictionaryWithDictionary:resObj[@"body"][0]];
        
            self.status = self.dataSource[@"order"][@"status"];
            
            [self configUI];
        }
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        [UITools hideHUDForView:self.view];
        [self.tableView.header endRefreshing];
    }];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
    
    NSInteger status = [self.status integerValue];
    if (status == 0 || status == 1 || status == 2 || status == 3) {
        [self createFooterView];
        [self.view addSubview:self.footerView];
        _tableView.height = APP_HEIGHT-APP_VIEW_Y+APP_STATUS_BAR_HEIGHT-self.footerView.height;
    }else{
        _tableView.height = APP_HEIGHT-APP_VIEW_Y+APP_STATUS_BAR_HEIGHT;
    }
}

- (void)createFooterView{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-136*y_6_plus, APP_WIDTH, 136*y_6_plus)];
    _footerView.backgroundColor = kWhiteColor;
    switch ([self.status integerValue]) {
        case 0:
        {
            UIButton *lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lBtn.frame = CGRectMake(10*x_6_plus, 5*y_6_plus, (APP_WIDTH-30*x_6_plus)/2, 136*y_6_plus-10*y_6_plus);
            lBtn.backgroundColor = kTextOrangeColor;
            lBtn.layer.masksToBounds = YES;
            lBtn.layer.cornerRadius = 3;
            [lBtn setTitle:@"取消订单"];
            [lBtn setTitleColor:kWhiteColor];
            [lBtn addActionBlock:^(id weakSender) {
                [UITools alertWithMsg:@"是否确认取消订单" viewController:self confirmAction:^{
                    [UITools showIndicatorToView:self.view];
                    [[NetworkEngine sharedNetwork] postBody:@{@"orderNo":self.orderNo,@"orderId":self.orderId} apiPath:kOrderCancleURL hasHeader:YES finish:^(ResultState state, id resObj) {
                        [UITools hideHUDForView:self.view];
                        if (state == StateSucceed) {
                            if (_commplete) {
                                _commplete();
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failed:^(NSError *error) {
                        [UITools hideHUDForView:self.view];
                    }];
                } cancelAction:nil];
            } forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rBtn.frame = CGRectMake(lBtn.right+10*x_6_plus, 5*y_6_plus, (APP_WIDTH-30*x_6_plus)/2, 136*y_6_plus-10*y_6_plus);
            rBtn.backgroundColor = COLOR_NAV;
            rBtn.layer.masksToBounds = YES;
            rBtn.layer.cornerRadius = 3;
            [rBtn setTitle:@"付款"];
            [rBtn setTitleColor:kWhiteColor];
            [rBtn addActionBlock:^(id weakSender) {
                OrderPayViewController *ovc = [[OrderPayViewController alloc]init];
                ovc.res = YES;
                ovc.bookingTime = self.dataSource[@"order"][@"bookingTime"];
                ovc.merchant = self.dataSource[@"order"][@"merchantName"];
                ovc.merchantAddress = self.dataSource[@"order"][@"merchantAddress"];
                ovc.merchantPhone = self.dataSource[@"order"][@"merchantPhone"];
                ovc.commplete = ^{
                    if (_commplete0) {
                        _commplete0();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                //    ovc.consumerCode = _consumerCode;
                ovc.orderNo = self.orderNo;
                ovc.orderId = self.orderId;
                //    ovc.bookingTime = _bookingTime;
                //    ovc.merchant = _merchantName;
                //    ovc.merchantAddress = _merchantAddress;
                //    ovc.merchantPhone = _merchantPhone;
                
                [self.navigationController pushViewController:ovc animated:YES];
                
            } forControlEvents:UIControlEventTouchUpInside];
            
            [_footerView addSubview:lBtn];
            [_footerView addSubview:rBtn];
            
            break;
        }
        case 1:
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, APP_WIDTH, 136*y_6_plus);
            btn.backgroundColor = kTextOrangeColor;
            [btn setTitle:@"申请退款"];
            [btn setTitleColor:kWhiteColor];
            [btn addActionBlock:^(id weakSender) {
                OrderRefoundController *ovc = [[OrderRefoundController alloc]init];
                ovc.orderId = self.orderId;
                ovc.orderNo = self.orderNo;
                ovc.commplete = ^{
                    if (_commplete) {
                        _commplete();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:ovc animated:YES];
            } forControlEvents:UIControlEventTouchUpInside];
            
            [_footerView addSubview:btn];
            
            break ;
        }
        case 2:
        {
            UIButton *lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lBtn.frame = CGRectMake(10*x_6_plus, 5*y_6_plus, (APP_WIDTH-30*x_6_plus)/2, 136*y_6_plus-10*y_6_plus);
            lBtn.backgroundColor = kTextOrangeColor;
            lBtn.layer.masksToBounds = YES;
            lBtn.layer.cornerRadius = 3;
            [lBtn setTitle:@"申请退款"];
            [lBtn addActionBlock:^(id weakSender) {
                OrderRefoundController *ovc = [[OrderRefoundController alloc]init];
                ovc.orderId = self.orderId;
                ovc.orderNo = self.orderNo;
                ovc.commplete = ^{
                    if (_commplete) {
                        _commplete();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:ovc animated:YES];
            } forControlEvents:UIControlEventTouchUpInside];
            [lBtn setTitleColor:kWhiteColor];
            
            UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rBtn.frame = CGRectMake(lBtn.right+10*x_6_plus, 5*y_6_plus, (APP_WIDTH-30*x_6_plus)/2, 136*y_6_plus-10*y_6_plus);
            rBtn.backgroundColor = COLOR_NAV;
            rBtn.layer.masksToBounds = YES;
            rBtn.layer.cornerRadius = 3;
            [rBtn setTitle:@"确认完成"];
            [rBtn addActionBlock:^(id weakSender) {
                [UITools alertWithMsg:@"是否确认完成订单" viewController:self confirmAction:^{
                    [UITools showIndicatorToView:self.view];
                    [[NetworkEngine sharedNetwork] postBody:@{@"orderNo":self.orderNo,@"orderId":self.orderId} apiPath:kOrderFinishURL hasHeader:YES finish:^(ResultState state, id resObj) {
                        [UITools hideHUDForView:self.view];
                        if (state == StateSucceed) {
                            if (_commplete0) {
                                _commplete0();
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failed:^(NSError *error) {
                        [UITools hideHUDForView:self.view];
                    }];
                } cancelAction:^{
                    
                }];
            } forControlEvents:UIControlEventTouchUpInside];
            [rBtn setTitleColor:kWhiteColor];
            
            [_footerView addSubview:lBtn];
            [_footerView addSubview:rBtn];
            
            break ;
        }
        case 3:
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, APP_WIDTH, 136*y_6_plus);
            btn.backgroundColor = COLOR_NAV;
            [btn setTitle:@"服务评价"];
            [btn addActionBlock:^(id weakSender) {
                OrderCommentViewController *ovc = [[OrderCommentViewController alloc]init];
                ovc.orderId = self.orderId;
                ovc.commplete = ^{
                    if (_commplete) {
                        _commplete();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:ovc animated:YES];
                
            } forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:kWhiteColor];
            
            [_footerView addSubview:btn];
            
            break ;
        }
            
        default:
            break;
    }
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y, APP_WIDTH, APP_HEIGHT-APP_VIEW_Y+APP_STATUS_BAR_HEIGHT)
                                                 style:UITableViewStyleGrouped];
    
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [_tableView registerClass:[WaitTableViewCell class] forCellReuseIdentifier:outletCellId];
    [_tableView registerClass:[OrderPersonMessCell class] forCellReuseIdentifier:personCellId];
    [_tableView registerClass:[FittingsCell class] forCellReuseIdentifier:fittingCellId];
    [_tableView registerClass:[OrderDetailServiceCell class] forCellReuseIdentifier:serviceCellId];
    [_tableView registerClass:[OrderTypeCell class] forCellReuseIdentifier:typeCellId];
    [_tableView registerClass:[OrderSelectCell class] forCellReuseIdentifier:selectCellId];
    [_tableView registerClass:[OrderDetailCell class] forCellReuseIdentifier:detailCellId];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    return _tableView;
}

- (void)headerRefreshing{
//    [self requestData];
}

- (void)layoutNeedDispaly{
    NSInteger status = [self.dataSource[@"order"][@"status"] integerValue];
    if (status == 0 || status == 1 || status == 2 || status == 3) {
        [self.view addSubview:self.footerView];
        _tableView.height = APP_HEIGHT-APP_VIEW_Y+APP_STATUS_BAR_HEIGHT-self.footerView.height;
    }else{
        _tableView.height = APP_HEIGHT-APP_VIEW_Y+APP_STATUS_BAR_HEIGHT;
    }
    [self.footerView removeFromSuperview];
    [self createFooterView];
    [self.view addSubview:self.footerView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSString *status = self.dataSource[@"order"][@"status"];
    if (![status isEqualToString:@"0"] && ![status isEqualToString:@"-1"] ) {
        return 6;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||section == 2) {
        return CGFLOAT_MIN;
    }else {
          return 30*y_6_plus;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSString *status = self.dataSource[@"order"][@"status"];
    if (![status isEqualToString:@"0"] && ![status isEqualToString:@"-1"] ) {
        return section != 5?CGFLOAT_MIN:30*y_6_plus;
    }else{
        return section != 4?CGFLOAT_MIN:30*y_6_plus;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 145*y_6_plus;
        }
        return 180*y_6_plus;
    }else if (indexPath.section == 1){
        return 290*y_6_plus;
    }else if (indexPath.section == 2){
        return 245*y_6_plus;
    }else if (indexPath.section == 3){
        return 104*y_6_plus;
    }else if (indexPath.section == 4){
        NSDictionary *dic = self.dataSource[@"order"];
        if ([dic[@"payType"] floatValue] > 0) {
            return 340*y_6_plus;
        }else{
            return 280*y_6_plus;
        }
    }else if (indexPath.section == 5){
        return 582*y_6_plus;
    }
    
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1 || section == 4 || section == 5) {
        return 1;
    }else if (section == 2){
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.dataSource[@"serviceList"]) {
            [arr addObjectsFromArray:dic[@"suborderdetail"]];
        }
        
        return arr.count;
    }
    
    return [(NSArray *)self.dataSource[@"serviceList"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"订单编号:%@",_orderNo];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
            [str addAttributes:@{NSFontAttributeName:V3_42PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 5)];
            [str addAttributes:@{NSFontAttributeName:V3_42PX_FONT,NSForegroundColorAttributeName:kTextOrangeColor} range:NSMakeRange(5, cell.textLabel.text.length-5)];
            cell.textLabel.attributedText = str;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if(indexPath.row == 1){
            OrderPersonMessCell *cell0 = (OrderPersonMessCell *)[tableView dequeueReusableCellWithIdentifier:personCellId];
            if (!cell0) {
                cell0 = [[OrderPersonMessCell alloc] init];
            }
            cell0.person = [NSString stringWithFormat:@"联系人:%@",self.dataSource[@"order"][@"name"]];
            cell0.phone = [NSString stringWithFormat:@"联系电话:%@",self.dataSource[@"order"][@"phoneNo"]];

        return cell0;
        }
        
    }else if (indexPath.section == 1){
        WaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:outletCellId];
        if (!cell) {
            cell = [[WaitTableViewCell alloc]init];
        }
        [cell configCellWithDic:self.dataSource[@"order"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.section == 2){
        
        FittingsCell *cell = [tableView dequeueReusableCellWithIdentifier:fittingCellId];
        if (!cell) {
            cell = [[FittingsCell alloc]init];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.dataSource[@"serviceList"]) {
            [arr addObjectsFromArray:dic[@"suborderdetail"]];
        }
        NSDictionary *dic=[self.dataSource[@"suborderdetailList"] analysisConvertToArray][indexPath.row];
                            
        [cell UconfigCellWithDic:dic];
        cell.price=arr[indexPath.row][@"salePrice"];
        cell.num = arr[indexPath.row][@"componentNum"];
        cell.rV.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.section == 3){
        OrderDetailServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceCellId];
        if (!cell) {
            cell = [[OrderDetailServiceCell alloc]init];
        }
        if (indexPath.row == 0) {
            cell.hidden = NO;
        }
        cell.serviceId = self.dataSource[@"serviceList"][indexPath.row][@"serviceId"];
        cell.serviceName = self.dataSource[@"serviceList"][indexPath.row][@"serviceName"];
        cell.price = [NSString stringWithFormat:@"%.2f",[self.dataSource[@"serviceList"][indexPath.row][@"workHoursPrice"] floatValue]];

        return cell;
    }else if (indexPath.section == 4){
        OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellId];
        if (!cell) {
            cell = [[OrderDetailCell alloc]init];
        }
        
        [cell configCellWithDic:self.dataSource[@"order"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    QRCell *cell = [tableView dequeueReusableCellWithIdentifier:qrCellId];
    if (!cell) {
        cell = [[QRCell alloc]init];
    }
    
    cell.traN = self.dataSource[@"order"][@"consumer"][0][@"consumerCode"];
    cell.consmueCode = self.dataSource[@"order"][@"consumer"][0][@"consumerCode"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
