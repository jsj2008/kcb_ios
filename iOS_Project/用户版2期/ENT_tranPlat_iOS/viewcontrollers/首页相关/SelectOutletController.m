
//
//  SelectOutletController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/4.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "SelectOutletController.h"
#import "OutDetailViewController.h"
#import "OutletCell.h"
#import "FilterView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "LocationManager.h"
//#import "UITableView+FDTemplateLayoutCell.h"

#define headerViewHeight 108*y_6_plus

static UIView *displayView = nil;

@implementation SelectItemViewSegment
{
    UIButton *_tempBtn;
}

+ (SelectItemViewSegment *)shareWithDisplayView:(UIView *)view{
    SelectItemViewSegment *seg = [[self alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, headerViewHeight)];
    displayView = view;
    
    return seg;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *titleArr = @[@"距离",@"服务",@"人气"];
        for (int i = 0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat w = self.width/2;
            btn.frame = CGRectMake(i*w/3, 0, w/3
                                   , self.height);
            btn.titleLabel.font=  V3_38PX_FONT;
            _tempBtn = btn;
            btn.tag = i;
            [btn addTarget:self.delegate action:@selector(click:)];
            [btn setTitle:titleArr[i]];
            [btn setImage:[UIImage imageNamed:@"sj"] forState:UIControlStateNormal];
            [btn setBackgroundColor:kClearColor
                           forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHex:0xe5e5e5]
                           forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithHex:0x666666]];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.width, 0, btn.imageView.width);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.width, 0, -btn.titleLabel.width);
            
            [self addSubview:btn];
        }
        
    }
    
    return self;
}

- (void)click:(UIButton *)sender{
    _tempBtn.selected = NO;
    sender.selected = YES;
    _tempBtn = sender;
    
    if (_commplete) {
        _commplete(sender.tag);
    }
}


@end
@interface SelectOutletController ()<UITableViewDataSource,UITableViewDelegate
>

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

static NSString *cellId = @"cellId";

@implementation SelectOutletController
{
    NSInteger _page;
    NSString *_order;
    SelectItemViewSegment *seg;
    UITextField *_seachText;
    UIImageView *_icon;
    UILabel *_alertLabel;
    
    NSString *_code;
    NSString *_coorinate;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCustomNavigationTitle:@"选择门店"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [UITools showIndicatorToView:self.view];
    [self requestData:MJRefreshTypeNone];
}

- (void)configUI{
    _order = @"j";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    _dataSource = [NSMutableArray array];
    _searchResults = [NSMutableArray array];
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH/2, APP_WIDTH/378*300/2)];
    _icon.center = self.view.boundsCenter;
    _icon.image = [UIImage imageNamed:@"没有新订单图标"];
    _icon.hidden = YES;
    _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _icon.bottom+50*y_6_plus, APP_WIDTH, 34*y_6_plus)];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.font = V3_38PX_FONT;
    _alertLabel.textColor = kTextGrayColor;
    _alertLabel.text = @"没有相关服务的商户哦，亲";
    _alertLabel.hidden = YES;
    
    [self.view addSubview:_icon];
    [self.view addSubview:_alertLabel];
}

- (UIView *)headerView{
    
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y, self.view.width, headerViewHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    seg = [SelectItemViewSegment shareWithDisplayView:self.view];
    __block __typeof(self) weakSelf = self;
    seg.commplete = ^(SearchType type){
        switch (type) {
            case SearchInDistance:
                _order = @"j";
                
                break;
            case SearchInService:
                _order = @"h";
                
                break;
            case SearchInPopularity:
                _order = @"d";
                
                break;
            default:
                break;
        }
        [weakSelf requestData:MJRefreshTypeHeader];
    };
    
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(505*x_6_plus+20*x_6_plus, 20*y_6_plus, 450*x_6_plus, (108-40)*y_6_plus)];
    //_mySearchBar.centerY = self.boundsCenter.y;
    _mySearchBar.delegate = self;
    _mySearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_mySearchBar addBorderWithWidth:0 color:kLineGrayColor corner:2];
    [_mySearchBar setPlaceholder:@"搜索门店"];
//    UILabel *lane=[[UILabel alloc]initWithFrame:CGRectMake(0,headerViewHeight, self.view.width, 20*y_6_plus)];
//    lane.backgroundColor=COLOR_VIEW_CONTROLLER_BG;
//    [_headerView addSubview:lane];
    [_headerView addSubview:seg];
    [_headerView addSubview:_mySearchBar];
    return _headerView;
}
#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (!_searchResults) {
//        _searchResults = [[NSMutableArray alloc]init];
//    }
//    [_searchResults removeAllObjects];
    _searchResults = [[NSMutableArray alloc]init];
    if (searchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:_mySearchBar.text]) {
        for (int i=0; i<_dataSource.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:_dataSource[i][@"name"]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_dataSource[i][@"name"]];
                NSRange titleResult=[tempPinYinStr rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_searchResults addObject:_dataSource[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_dataSource[i][@"name"]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [_searchResults addObject:_dataSource[i]];
                }
            }
            else {
                NSRange titleResult=[_dataSource[i][@"name"] rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_searchResults addObject:_dataSource[i]];
                }
            }
        }
    } else if (_mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:_mySearchBar.text]) {
        for (NSDictionary *dic in _dataSource) {
            NSString *tempStr=dic[@"name"];
            NSRange titleResult=[tempStr rangeOfString:_mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [_searchResults addObject:dic];
                
            }
        }
    }
    if(_mySearchBar.text.length<=0){
        _searchResults=_dataSource;
    }
    [_tableView reloadData];
    NSLog(@"%@",_searchResults);
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,APP_VIEW_Y+headerViewHeight+20*y_6_plus, self.view.width, APP_HEIGHT-
                                                              APP_NAV_HEIGHT-headerViewHeight+20*y_6_plus)];
    _tableView.backgroundColor = kClearColor;
    [_tableView registerClass:[OutletCell class] forCellReuseIdentifier:cellId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    _tableView.header.updatedTimeHidden = YES;
    _tableView.footer.hidden = YES;
    
   // self.tableView.tableHeaderView = self.headerView;
    return _tableView;
}

- (void)headerRefreshing{
    _page = 1;
    [self requestData:MJRefreshTypeHeader];
}

- (void)footerRefreshing{
    _page += 1;
    [self requestData:MJRefreshTypeFooter];
}

- (void)requestData:(MJRefreshType)refreshType{
    _icon.hidden = _alertLabel.hidden = YES;
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    NSString *code = [u objectForKey:KEY_CITY_ADCODE_IN_USERDEFAULT];
    _coorinate = [NSString stringWithFormat:@"%f,%f",_coori2D.longitude,_coori2D.latitude];
    [[NetworkEngine sharedNetwork] postBody:@{@"cityCode":code,@"coordinate":((int)_coori2D.latitude == 0 && (int)_coori2D.longitude == 0)?@"null":_coorinate,@"serids":_serids,@"page":[NSString stringWithFormat:@"%@",@(_page)],@"rows":@"10",@"order":_order} apiPath:kNearbyMerURL hasHeader:YES finish:^(ResultState state, id resObj) {
        [UITools hideHUDForView:self.view];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (refreshType != MJRefreshTypeFooter) {
            [self.dataSource removeAllObjects];
        }
        
        if (state == StateSucceed) {
            [self.dataSource addObjectsFromArray:resObj[@"body"][@"merList"]];
            _searchResults=_dataSource;
            
            self.tableView.footer.hidden = [[resObj[@"body"][@"merList"] analysisConvertToArray] count] < 10;
            if (!self.dataSource.count) {
                _icon.hidden = _alertLabel.hidden = NO;
            }else{
                _icon.hidden = _alertLabel.hidden = YES;
            }
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        if (!self.dataSource.count) {
            _icon.hidden = _alertLabel.hidden = NO;
        }else{
            _icon.hidden = _alertLabel.hidden = YES;
        }
        [UITools hideHUDForView:self.view];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (286+38)*y_6_plus;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //    cell.fd_enforceFrameLayout = NO;        // Enable to use "-sizeThatFits:"
    if (!cell) {
        cell = [[OutletCell alloc]init];
    }
    cell.rV.hidden = YES;
    
    [cell configCellWithDic:self.searchResults[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OutDetailViewController *ovc = [[OutDetailViewController alloc]init];
    
    ovc.jwd = self.searchResults[indexPath.row][@"jwd"];
    ovc.distancce = self.searchResults[indexPath.row][@"distance"];
    ovc.merid = self.searchResults[indexPath.row][@"id"];
    [self.navigationController pushViewController:ovc animated:YES];
}


@end