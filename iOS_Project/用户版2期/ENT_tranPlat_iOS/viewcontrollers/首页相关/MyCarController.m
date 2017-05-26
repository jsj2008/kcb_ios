//
//  MyCarController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/5.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "MyCarController.h"
#import "CarTypeCell.h"
#import "CarBrandController.h"
#import "EiddtingViewController.h"

@interface MyCarController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *footerView;
@property (nonatomic, strong)NSMutableArray *cars;

@end

static NSString *cellId = @"cellId";

@implementation MyCarController
{
    CarTypeCell *_tempCell;      //缓存默认btn
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kPostCarModelAdded object:nil];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareData];
    [self setNavTitle:@"我的车型"];
}

- (void)prepareData{
    NSArray *arr = [[DataBase sharedDataBase]userCarsByUserId:APP_DELEGATE.userId];
    if (!arr.count) {
        [UITools alertWithMsg:@"您还没有添加车辆，请先添加车辆" viewController:self confirmAction:^{
            CarBrandController *cvc = [[CarBrandController alloc]init];
            cvc.needHome = YES;
            [self.navigationController pushViewController:cvc animated:YES];
        } cancelAction:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    _cars = [arr mutableCopy];

    [self.tableView reloadData];
}

- (void)configUI{
    [self.view addSubview:self.tableView];

}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y-APP_STATUS_BAR_HEIGHT, self.view.width,
                                                              APP_HEIGHT-APP_NAV_HEIGHT+APP_STATUS_BAR_HEIGHT)
                                             style:UITableViewStyleGrouped];
    [_tableView registerClass:[CarTypeCell class] forCellReuseIdentifier:cellId];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = self.footerView;
    _tableView.rowHeight = 120*y_6_SCALE;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    return _tableView;
}

- (UIButton *)footerView{
    NSArray *arr = [[DataBase sharedDataBase] userCarsByUserId:APP_DELEGATE.userId];
    if (arr.count >= 5 || !arr.count) {
        return nil;
    }
    if (_footerView) {
        return _footerView;
    }
    
    _footerView = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerView.bounds = CGRectMake(0, 60*y_6_SCALE, self.view.width, 44*y_6_SCALE);
    _footerView.centerX = self.tableView.boundsCenter.x;
    [_footerView setTitle:@"添加"];
    [_footerView setTitleColor:kWhiteColor];
    _footerView.backgroundColor = COLOR_NAV;
    __weak __typeof(self)weakSelf = self;
    [_footerView addActionBlock:^(id weakSender) {
        CarBrandController *cvc = [[CarBrandController alloc]init];
        [weakSelf.navigationController pushViewController:cvc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    return _footerView;
}

- (void)refreshView:(BOOL)b{
    [_cars removeAllObjects];
    NSArray *arr = [[DataBase sharedDataBase] userCarsByUserId:APP_DELEGATE.userId];
    [_cars addObjectsFromArray:arr];
    if (_cars.count >= 5) {
        if (b) {
            CarInfo *car = arr.lastObject;
            BOOL res = NO;
            while (!res) {
                res = [NSKeyedArchiver archiveRootObject:car toFile:LOCAL_PATH_P];
            }
        }
        self.tableView.tableFooterView = nil;
    }else if(!_cars.count){
        self.tableView.tableFooterView = nil;
        [UITools alertWithMsg:@"您还没有添加车辆，请先添加车辆" viewController:self confirmAction:^{
            CarBrandController *cvc = [[CarBrandController alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        } cancelAction:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        if (b) {
            CarInfo *car = arr.lastObject;
            BOOL res = NO;
            while (!res) {
                res = [NSKeyedArchiver archiveRootObject:car toFile:LOCAL_PATH_P];
            }
        }
        self.tableView.tableFooterView = self.footerView;
    }
    [self.tableView reloadData];
}

- (void)refreshView{
    [_cars removeAllObjects];
    NSArray *arr = [[DataBase sharedDataBase] userCarsByUserId:APP_DELEGATE.userId];
    [_cars addObjectsFromArray:arr];
    if (_cars.count >= 5) {
        CarInfo *car = arr.lastObject;
        BOOL res = NO;
        while (!res) {
            res = [NSKeyedArchiver archiveRootObject:car toFile:LOCAL_PATH_P];
        }
        self.tableView.tableFooterView = nil;
    }else if(!_cars.count){
        self.tableView.tableFooterView = nil;
        [UITools alertWithMsg:@"您还没有添加车辆，请先添加车辆" viewController:self confirmAction:^{
            CarBrandController *cvc = [[CarBrandController alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        } cancelAction:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        CarInfo *car = arr.lastObject;
        BOOL res = NO;
        while (!res) {
            res = [NSKeyedArchiver archiveRootObject:car toFile:LOCAL_PATH_P];
        }
        self.tableView.tableFooterView = self.footerView;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cars.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section != _cars.count-1 ? CGFLOAT_MIN : 20*y_6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10*y_6_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CarTypeCell alloc]init];
    }
    [cell configCellWithCar:_cars[indexPath.section]];

    __weak __typeof(cell) weakCell = cell;
    cell.commplete = ^(OpertionStyle style){
        CarInfo *car = _cars[indexPath.section];
        if (style == OpertionEditting) {
            EiddtingViewController *evc = [[EiddtingViewController alloc]init];
            CarInfo *car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
            if ([car.hphm isLegal]) {
                if ([car.hphm isEqualToString:weakCell.hphm]) {
                    evc.res = YES;
                }
            }else{
                if ([car.carId isEqualToString:weakCell.car.carId]) {
                    evc.res = YES;
                }
            }
            
            evc.carInfo = weakCell.car;
            [self.navigationController pushViewController:evc animated:YES];
        }else if(style == OpertionDelete){
            if ([car.hphm isLegal]) {
                [[DataBase sharedDataBase] deleteCARINFOByHphm:car.hphm andUserId:APP_DELEGATE.userId];
            }else{
                [[DataBase sharedDataBase] deleteCarInfoByCarId:car.carId andUserId:APP_DELEGATE.userId];
            }
            NSArray *arr = [[DataBase sharedDataBase] userCarsByUserId:APP_DELEGATE.userId];
            CarInfo *car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
            if (car) {
                if ([car.carId isEqualToString:weakCell.car.carId] || ([car.hphm isEqualToString:weakCell.hphm] && ![car.hphm isEqualToString:@""])) {
                    if (arr.count) {
                        BOOL res = NO;
                        while (!res) {
                            res = [NSKeyedArchiver archiveRootObject:arr[0] toFile:LOCAL_PATH_P];
                        }
                    }else{
                        NSFileManager *m = [NSFileManager defaultManager];
                        NSError *error = nil;
                        BOOL res = NO;
                        while (!res) {
                            res = [m removeItemAtPath:LOCAL_PATH_P error:&error];
                        }
                    }
                }
            }
            
            [self refreshView:NO];
        }else{
            if (![car.carId isLegal]) {
                [UITools alertWithMsg:@"请先完善车型信息" viewController:self action:^{
                    EiddtingViewController *evc = [[EiddtingViewController alloc]init];
                    evc.carInfo = weakCell.car;
                    [self.navigationController pushViewController:evc animated:YES];
                }];
            }else{
                CarInfo *car = _cars[indexPath.section];
                BOOL res = NO;
                while (!res) {
                    res = [NSKeyedArchiver archiveRootObject:car toFile:LOCAL_PATH_P];
                }
                _tempCell.selectV.selected = NO;
                weakCell.selectV.selected = YES;
                _tempCell = weakCell;
            }
        }
    };
    CarInfo *car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
    if (car) {
        if ([car.carId isEqualToString:cell.car.carId]) {
            cell.selectV.selected = YES;
            _tempCell = cell;
        }else{
            cell.selectV.selected = NO;
        }
    }else{
        if (indexPath.section == 0) {
            cell.selectV.selected = YES;
            _tempCell = cell;
        }else{
            cell.selectV.selected = NO;
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 338*y_6_plus;
}

- (void)goBackPage:(UIButton *)button{
//    if (!_cars.count) {
//        [UITools alertWithMsg:@"您还没有添加车辆，请先添加车辆" viewController:self confirmAction:^{
//            CarBrandController *cvc = [[CarBrandController alloc]init];
//            [self.navigationController pushViewController:cvc animated:YES];
//        } cancelAction:^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//    }
    if (_commplete) {
        _commplete();
    }
    [super goBackPage:button];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
