//
//  CarBrandController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/7.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "CarBrandController.h"
#import "CarLineController.h"
#import "BrandCell.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface CarBrandController ()<UISearchBarDelegate,UISearchDisplayDelegate
>{
 NSMutableArray *_searchResults;
}


@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableDictionary *oriMArr;
@property (nonatomic, strong) NSMutableArray *keysArr;

@end

static NSString *cellId = @"cellId";

@implementation CarBrandController
{
    NSMutableArray *_sectionArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCustomNavigationTitle:@"获取车辆品牌"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _datas=[[NSMutableArray alloc]init];
    _keysArr = [NSMutableArray array];
    _oriMArr = [NSMutableDictionary dictionary];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:[BrandCell class] forCellReuseIdentifier:cellId];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = kClearColor;
}

- (UIView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 165*y_6_plus)];
//    UISearchBar *seachBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 1000*x_6_plus, 125*y_6_plus)];
//    seachBar.placeholder = @"请输入您的车辆品牌车系";
//    seachBar.barTintColor = kClearColor;
//    seachBar.center = _headerView.boundsCenter;
    _mySearchBar  = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 125*y_6_plus)];
    _mySearchBar.center = _headerView.boundsCenter;
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"请输入您的车型"];
    _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    _searchDisplayController.active = NO;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    [_headerView addSubview:_mySearchBar];
    
    
    return _headerView;
}

- (void)requestData:(MJRefreshType)refreshType{
    [UITools showIndicatorToView:self.view];
    [[NetworkEngine sharedNetwork] postBody:nil apiPath:kCarPlateURl hasHeader:NO finish:^(ResultState state, id resObj) {
        [UITools hideHUDForView:self.view];
        [self.tableView.header endRefreshing];
        if (state == StateSucceed) {
            
            if (refreshType != MJRefreshTypeFooter) {
                [self.oriMArr removeAllObjects];
                [self.keysArr removeAllObjects];
            }
          
            NSArray *obj = [resObj[@"body"][0][@"brindlist"] analysisConvertToArray];
            for (NSDictionary  *dic in obj) {
                NSMutableArray *letterArr = [self.oriMArr objectForKey:dic[@"firstZm"]];
                if (!letterArr) {
                    letterArr = [NSMutableArray array];
                    [self.oriMArr setValue:letterArr forKey:dic[@"firstZm"]];
                }
                [letterArr addObject:dic];
                [_datas addObject:dic];
            }
            NSArray *keys = [self.oriMArr.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            [self.keysArr addObjectsFromArray:keys];
            
            _sectionArr = [@[@"*"] mutableCopy];
            
            for (NSString *key in keys) {
                [_sectionArr addObject:key];
            }
            [_sectionArr addObject:@"*"];
       
           // _datas= [[NSMutableArray alloc]arrayByAddingObject:self.oriMArr.allKeys];
            
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        [UITools hideHUDForView:self.view];
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
    return [(NSArray *)self.oriMArr[self.keysArr[section]] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    }else {
    return self.oriMArr.allKeys.count;
    }
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _sectionArr;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keysArr[section];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger count = 0;
    
    for(NSString *character in _sectionArr)
    {
        if([character isEqualToString:title])
        {
            return count-1;
        }
        count ++;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BrandCell alloc]init];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *dic = _searchResults[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://idc.pic-01.956122.com/allPic/CarLogo/%@",dic[@"logo"]]];
        [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home_car_brand_default"]];
        cell.contentLabel.text = dic[@"brandName"];
        
        
    }else{
        NSDictionary *dic = self.oriMArr[self.keysArr[indexPath.section]][indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://idc.pic-01.956122.com/allPic/CarLogo/%@",dic[@"logo"]]];
        [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home_car_brand_default"]];
        cell.contentLabel.text = dic[@"brandName"];
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarLineController *clv = [[CarLineController alloc]init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        clv.saveCarInfo = self.saveCarInfo;
        clv.icon = [NSString stringWithFormat:@"http://idc.pic-01.956122.com/allPic/CarLogo/%@",_searchResults[indexPath.row][@"logo"]];
        clv.Id = _searchResults[indexPath.row][@"id"];
        clv.clpp1 = _searchResults[indexPath.row][@"brandName"];
        clv.needHome = self.needHome;
        
    }else{
        clv.needHome = self.needHome;
    clv.saveCarInfo = self.saveCarInfo;
    clv.icon = [NSString stringWithFormat:@"http://idc.pic-01.956122.com/allPic/CarLogo/%@",self.oriMArr[self.keysArr[indexPath.section]][indexPath.row][@"logo"]];
    clv.Id = self.oriMArr[self.keysArr[indexPath.section]][indexPath.row][@"id"];
    clv.clpp1 = self.oriMArr[self.keysArr[indexPath.section]][indexPath.row][@"brandName"];
    }
    [self.navigationController pushViewController:clv animated:YES];
}
#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchResults = [[NSMutableArray alloc]init];
    if (_mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:_mySearchBar.text]) {
        for (int i=0; i<_datas.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:_datas[i][@"brandName"]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_datas[i][@"brandName"]];
                NSRange titleResult=[tempPinYinStr rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_searchResults addObject:_datas[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_datas[i][@"brandName"]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [_searchResults addObject:_datas[i]];
                }
            }
            else {
                NSRange titleResult=[_datas[i][@"brandName"] rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_searchResults addObject:_datas[i]];
                }
            }
        }
    } else if (_mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:_mySearchBar.text]) {
        for (NSDictionary *dic in _datas) {
            NSString *tempStr=dic[@"brandName"];
            NSRange titleResult=[tempStr rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [_searchResults addObject:dic];
            }
        }
    }
}

- (void)goBackPage:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
