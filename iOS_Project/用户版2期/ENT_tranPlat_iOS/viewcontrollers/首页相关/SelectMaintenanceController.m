//
//  SelectMaintenanceController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/4.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "SelectMaintenanceController.h"
#import "SelectMaintenanceCell.h"

@interface SelectMaintenanceController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

static NSString *cellId = @"cellId";

@implementation SelectMaintenanceController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setCustomNavigationTitle:@"选择保养服务"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self confgiUI];
    [self prepareData];
}

- (void)prepareData{
    [UITools showIndicatorToView:self.view];
    [[NetworkEngine sharedNetwork] postBody:@{@"serType":[NSString stringWithFormat:@"%ld",(long)APP_DELEGATE.serviceType]} apiPath:kServiceListURL hasHeader:YES finish:^(ResultState state, id resObj) {
        [UITools hideHUDForView:self.view];
        if (state == StateSucceed) {
            _dataSource = [[resObj[@"body"][@"serList"] analysisConvertToArray] mutableCopy];
            [self.tableView reloadData];
        }

    } failed:^(NSError *error) {
        [UITools hideHUDForView:self.view];
    }];
}

- (void)confgiUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y, self.view.width,
                                                              APP_HEIGHT-APP_NAV_HEIGHT)];
    _tableView.backgroundColor = kClearColor;
    [_tableView registerClass:[SelectMaintenanceCell class] forCellReuseIdentifier:cellId];
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = kClearColor;
    _tableView.tableFooterView = footerView;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    return _tableView;
}

- (UIView *)footerView{
    if (_footerView) {
        return _footerView;
    }
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-144*y_6_plus, self.view.width, 144*y_6_plus)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    __weak __typeof(self) weakSelf = self;
    [btn addActionBlock:^(id weakSender) {
        if (!_selectItems.count) {
            [UITools alertWithMsg:@"请至少选择一种保养"];
            return ;
        }
#warning DOIT   需要优化
        if (_selectItems.count > 1) {
            if ([[_selectItems[0][@"name"] analysisConvertToString] length] <= [[_selectItems[1][@"name"] analysisConvertToString] length]) {
                NSDictionary *dic = _selectItems[0];
                [_selectItems replaceObjectAtIndex:0 withObject:_selectItems[1]];
                [_selectItems replaceObjectAtIndex:1 withObject:dic];
            }
        }
        if (_commplete) {
            _commplete(_selectItems);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, _footerView.width, _footerView.height);
    btn.backgroundColor = COLOR_NAV;
    [btn setTitle:@"确定"];
    [btn setTitleColor:kWhiteColor];
    [_footerView addSubview:btn];
    
    
    return _footerView;
}

#pragma mark - UItableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138*y_6_plus;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section<3 ? _dataSource.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 3) {
        SelectMaintenanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SelectMaintenanceCell alloc]init];
        }
        
        [cell configCellWith:self.dataSource[indexPath.row]];
        
        if (_selectItems.count) {                                                   //设置过
            if ([_selectItems containsObject:self.dataSource[indexPath.row]]) {
                cell.rightV.selected = YES;
                cell.icon.selected = YES;
            }else{
                cell.rightV.selected = NO;
                cell.icon.selected = NO;
            }
        }else{                                                                      //还没有设置过
            if ([cell.typeId isEqualToString:@"8"]) {           //小保养
                cell.rightV.selected = YES;
                cell.icon.selected = YES;
                if (![_selectItems containsObject:self.dataSource[indexPath.row]]) {
                    [_selectItems addObject:self.dataSource[indexPath.row]];
                }
            }else{
                cell.rightV.selected = NO;
                cell.icon.selected = NO;
            }
        }

        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectMaintenanceCell *cell = (SelectMaintenanceCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (![_selectItems containsObject:_dataSource[indexPath.row]]) {
        [_selectItems addObject:_dataSource[indexPath.row]];
        cell.rightV.selected = YES;
        cell.icon.selected = YES;
    }else{
        [_selectItems removeObject:_dataSource[indexPath.row]];
        cell.rightV.selected = NO;
        cell.icon.selected = NO;
    }
}

- (void)gobackPage{
    [super gobackPage];
}

@end
