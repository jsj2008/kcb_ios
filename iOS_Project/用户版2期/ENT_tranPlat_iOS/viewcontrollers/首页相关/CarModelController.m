
//
//  CarModelController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/8.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "CarModelController.h"
#import "MyCarController.h"
#import "EiddtingViewController.h"
#import "MaintenanceController.h"
#import "NSObject+ModelToDictionary.h"

@interface CarModelController ()

@end

@implementation CarModelController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCustomNavigationTitle:@"车型列表"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self requestData];
}

- (void)requestData{
    [UITools showIndicatorToView:self.view];
    [[NetworkEngine sharedNetwork] postBody:@{@"seriesID":_seriesId,@"nkvalue":_nkvalue,@"pqvalue":_pqlvalue} apiPath:kCarModelLsitURL hasHeader:NO finish:^(ResultState state, id resObj) {
        [UITools hideHUDForView:self.view];
        if (state == StateSucceed) {
            [self.dataSource addObjectsFromArray:resObj[@"body"][0][@"carmodellist"]];
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        [UITools hideHUDForView:self.view];
    }];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)index{
    cell.textLabel.text = self.dataSource[index.row][@"carModelsName"];
    cell.textLabel.font = V3_36PX_FONT;
    cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarInfo *car = nil;
    if (self.car) {
        car = self.car;
    }else{
        car = [[CarInfo alloc] initWithHpzl:@""
                                            hpzlname:_level
                                                hphm:@""
                                              clsbdh:@""
                                               clpp1:_clpp1
                                     vehicletypename:@""
                                          vehiclepic:@""
                                       vehiclestatus:@"未认证"
                                                yxqz:@""
                                              bxzzrq:@""
                                              ccdjrq:@""
                                         vehiclegxsj:[[NSDate date] string]
                                            isupdate:@""
                                          createTime:@""
                                                  zt:@""
                                              sfzmhm:@""
                                                 syr:@""
                                                fdjh:@""
                                            andUseId:APP_DELEGATE.userId];
        
        car.seriesId = self.seriesId;
        car.line = self.line;
        car.icon = self.icon;
    }
    car.detailDes = self.dataSource[indexPath.row][@"carModelsName"];
    car.nk = self.nkvalue;
    car.pql = self.pqlvalue;
    car.carId = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row][@"id"]];
    CarInfo *Info = [[DataBase sharedDataBase] selectCarByCarId:car.carId];
    if (self.saveCarInfo) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshEdittingCar object:nil];
            UIViewController *vc = nil;
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[EiddtingViewController class]]) {
                    vc = controller;
                }
            }
            [self.navigationController popToViewController:vc animated:YES];
    }else{
        
        if (!Info) {
            NSArray *cars = [[DataBase sharedDataBase] selectCarByUserId:APP_DELEGATE.userId andHphm:_car.hphm];
            if (cars.count) {
                [[DataBase sharedDataBase] updateCarInfo:_car];
            }
            [[DataBase sharedDataBase] deleteCarInfoByCarId:_car.carId andUserId:APP_DELEGATE.userId];
            [[DataBase sharedDataBase] inserConfiggingCarInfo:car];
        }else{
            [UITools alertWithMsg:@"您已添加过该辆车,请选择其他车型"];
            return ;
        }
        if (self.needHome) {
            BOOL res = NO;
            while (!res) {
                res = [NSKeyedArchiver archiveRootObject:_car toFile:LOCAL_PATH_P];
            }
            MaintenanceController *mvc = [[MaintenanceController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kPostCarModelAdded object:self.dataSource[indexPath.row]];
            UIViewController *vc = nil;
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MyCarController class]]) {
                    vc = controller;
                }
            }
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

@end
