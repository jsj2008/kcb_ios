//
//  CarNkController.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/20.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "CarNkController.h"
#import "CarModelController.h"

@interface CarNkController ()

@end

@implementation CarNkController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCustomNavigationTitle:@"获取排量"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)index{
    cell.textLabel.text = self.dataSource[index.row][@"value"];
    cell.textLabel.font = V3_36PX_FONT;
    cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
    l.text = @"请选择年款";
    
    return l;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarModelController *mvc = [[CarModelController alloc]init];
    mvc.needHome = self.needHome;
    mvc.saveCarInfo = self.saveCarInfo;
    mvc.icon = self.icon;
    mvc.car = self.car;
    mvc.level = self.level;
    mvc.clpp1 = _clpp1;
    mvc.seriesId = self.seriesId;
    mvc.pqlvalue = self.pqlvalue;
    mvc.line = self.line;
    mvc.nkvalue = self.dataSource[indexPath.row][@"value"];
    
    [self.navigationController pushViewController:mvc animated:YES];
}

@end
