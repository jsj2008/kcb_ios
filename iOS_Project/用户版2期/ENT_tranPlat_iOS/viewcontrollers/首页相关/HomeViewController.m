//
//  HomeViewController.m
//  ENT_tranPlat_iOS
//
//  Created by yanyan on 14-7-14.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//

#import "HomeViewController.h"
#import "MyCarController.h"
#import "EiddtingViewController.h"
#import "CarDisplacementController.h"
#import "CycleScrollView.h"
#import "ItemsView.h"
#import "ActivityView.h"
#import "MyViewLayout.h"
#import "ItemViewCell.h"
#import "ServiceCell.h"
#import "RecommendMer.h"
#import "LocationManager.h"
#import "OutDetailViewController.h"

/////////////


#import "CarInfoScrollView.h"
#import "HomeWeatherView.h"
#import "TestNetworkViewController.h"
#import "ZhaohuiViewController.h"
#import "InformationCenterListViewController.h"
#import "ZijiayouViewController.h"
#import "ScanViewController.h"
#import "BaoyangSelectCarViewController.h"
#import "BaoxianSelectCarViewController.h"
#import "BaiduMobAdView.h"
#import "BaiduMobSspBannerDelegateProtocol.h"
#import "BaiduMobSspBannerView.h"
#import "MyAFNetWorkingRequest.h"
#import "SHModel.h"
#import "BaoYangModel.h"
#import "InfoTableViewCell.h"
#import "InfoViewController.h"
#import "UserCarViewController.h"
#import "RescueViewController.h"

#import "NewSetCityViewController.h"

@interface HomeViewController ()<
MenuViewDelegate,
CarInfoScrollViewDelegate,
DriverViewDelegate,
AdvertisementImageViewDelegate,
UIAlertViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
BaiduMobSspDelegate,
UITableViewDataSource,
UITableViewDelegate,
ItemViewDelegate,
ActivityViewDelegate
>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *serviceData;
@property (nonatomic, strong)CycleScrollView *adView;
@property (nonatomic, strong)NSMutableArray *adMuarray;
@property (nonatomic, strong)NSMutableArray *adPushMuarray;
@end

@implementation HomeViewController
{
    UIView *_locationView;
    UIView *_msgView;
    NSMutableArray *_dataSource;
    UILabel *cityL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self setBackButtonHidden:YES];
    [self setCustomNavigationTitle:@"开车邦"];
    [self loadNavComponents];
    [self getAdvertisement];
    [self configCity];
    
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [self requestDataWithCode:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_ADCODE_IN_USERDEFAULT]];
//    });
    //获取广告
    
}

#pragma mark -广告
- (void)getAdvertisement{
    NSString *cityName  = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    if ([cityName isEqualToString:@""]) {
        [self performSelector:@selector(getAdvertisement) withObject:nil afterDelay:1*10.0f];
        return;
    }
    
    MKNetworkEngine *en = [[MKNetworkEngine alloc] initWithHostName:NET_ADDR_CMS_956122];
    MKNetworkOperation *op = [en operationWithPath:@"Cms/dataview/dataview_findFreeAdpostionByCityName.action" params:[NSDictionary dictionaryWithObjectsAndKeys:cityName, @"param", @"58", @"cid", nil] httpMethod:@"POST"];
    ENTLog(@"%@",op.url);

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *reqStr = completedOperation.responseString;
        reqStr = [reqStr substringFromIndex:5];
        reqStr = [reqStr substringToIndex:reqStr.length - 1];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *responseArr = [parser objectWithString:reqStr];
        _adMuarray =[[NSMutableArray alloc]init];
        _adPushMuarray =[[NSMutableArray alloc]init];
        for (int i=0;i<responseArr.count;i++) {
            CircleScrollPictureModel *model0 = [[CircleScrollPictureModel alloc]init];
            model0.imageUrl = responseArr[i][@"img"];
            model0.linkUrl = responseArr[i][@"href"];
            [_adMuarray addObject:model0];
            i++;
        }
         _adView.imageArray=_adMuarray;

       
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self performSelector:@selector(getAdvertisement) withObject:nil afterDelay:1*10.0f];
        
    }];
    [en enqueueOperation:op];
}

#pragma mark -

- (void)configCity{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    NSString *c = [u objectForKey:KEY_CITY_ADCODE_IN_USERDEFAULT];
    NSString *cityName = [u objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    if (![cityName isLegal] || ![c isLegal]) {
        [UITools alertWithMsg:@"定位失败，请选择城市"];
        [self getinCity];
    }else{
        [self requestDataWithCode:c];
    }
}

- (void)configUI{
    CGFloat y = 0;
  //  y = 387*y_6_plus;
    y += [self createHeaderView:y];
    y += [self createMiddleView:y];
    [self createBottomView:y];
    [self.scrollView autoContentSize];
   
}
- (CGFloat)createHeaderView:(CGFloat)y{
    [self.view addSubview:self.scrollView];
    for (UIView *v in _adView.subviews) {
        [v removeFromSuperview];
    }
    
    _adView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 387*y_6_plus) cycleDirection:CycleScrollDirectionHorizontal pictures:nil didScrollBlock:^(NSInteger index) {
        
 
        
    }];
    _adMuarray =[[NSMutableArray alloc]init];
    _adView.delegate=self;
    [self.scrollView addSubview:_adView];
    
    return _adView.height;
}
-(void)cycleScrollView:(CycleScrollView *)cycleScrollView didSelectImageView:(NSInteger)index{
    if (!cycleScrollView.imageArray.count) {
        return ;
    }
    AdvertisementViewController *advertiseVC = [[AdvertisementViewController alloc] init];
    CircleScrollPictureModel *model0 = [[CircleScrollPictureModel alloc]init];
    model0=cycleScrollView.imageArray[index];
    
    advertiseVC.url=model0.linkUrl;
    [self.navigationController pushViewController:advertiseVC animated:YES];
    

}

- (CGFloat)createMiddleView:(CGFloat)y{
    ItemsView *itemV = [ItemsView shareWithItems:@[@"自助保养",@"超值洗车",@"换轮胎",
                                                   @"保险比价",@"旧车评估",@"救援服务"]
                                        pictures:@[@"自助保养-默认图标",@"超值洗车-默认图标",@"换轮胎-默认",
                                                   @"保险比价-默认",@"旧车评估-默认",@"救援服务-默认"]
                                       selectPic:@[@"自助保养-交互效果",@"超值洗车-交互",@"换轮胎-交互",@"保险比价-交互",@"旧车评估-交互",@"救援服务-交互"]
                                     lineSpacing:50*y_6_plus
                                     itemSpacing:124*x_6_plus
                                      edgeInsets:UIEdgeInsetsMake((80-25)*y_6_plus, (114-62)*x_6_plus, (80-25)*y_6_plus, (114-62)*x_6_plus)];
    itemV.delegate = self;
    itemV.origin = CGPointMake(0, y+30*y_6_plus);
    [self.scrollView addSubview:itemV];
    
    ActivityView *av = [[ActivityView alloc]initWithFrame:CGRectMake(0, itemV.bottom+30*y_6_plus, self.view.width, 400*y_6_plus)];
    av.delegate = self;
    av.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:av];
    
    return itemV.height+av.height;
}

- (void)createBottomView:(CGFloat)y{
    self.tableView.origin = CGPointMake(0, y+100*y_6_plus);
    self.tableView.height = 76*y_6_SCALE;
    [self.scrollView addSubview:self.tableView];
}

- (void)setServiceData:(NSMutableArray *)serviceData{
    if (!serviceData.count) {
        self.tableView.height = 76*y_6_SCALE;

        return;
    }
    _serviceData = serviceData;
    if (_serviceData.count >= 5) {
        self.tableView.size = CGSizeMake(APP_WIDTH, self.tableView.rowHeight*5+38*y_6_SCALE);
    }else{
        self.tableView.size = CGSizeMake(APP_WIDTH, self.tableView.rowHeight*serviceData.count+38*y_6_SCALE);
    }
    
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 0)];
    [_tableView registerClass:[ServiceCell class] forCellReuseIdentifier:@"serviceCellId"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.rowHeight = 300*y_6_plus;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    return _tableView;
}

- (UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, APP_NAV_HEIGHT+APP_STATUS_BAR_HEIGHT, APP_WIDTH, APP_HEIGHT-APP_NAV_HEIGHT-APP_TAB_HEIGHT)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    
    return _scrollView;
}

- (void)loadNavComponents{
    
    _locationView = [[UIView alloc] initWithFrame:CGRectMake(30*PX_X_SCALE, 0, (60 + 50)*PX_X_SCALE, _navigationImgView.height)];
    [_navigationImgView addSubview:_locationView];
    UITapGestureRecognizer *locaitonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSetCity:)];
    [_locationView addGestureRecognizer:locaitonTap];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_locationView.height - 40*PX_X_SCALE)/2, 40*x_6_plus, 50*y_6_plus)];
    [imgView setImage:[UIImage imageNamed:@"定位图标"]];
    imgView.centerY = _locationView.centerY;
    [imgView setUserInteractionEnabled:YES];
    [_locationView addSubview:imgView];
    cityL = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10*PX_X_SCALE, 0, 185*PX_X_SCALE, _locationView.height)];
    [cityL convertNewLabelWithFont:FONT_NOMAL textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    NSString *cityName  = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([cityName isEqualToString:@""]) {
        cityL.text = @"...";
    }else{
        cityL.text = cityName;
        [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"zhuanshu"];
    }
    [_locationView addSubview:cityL];
    
    
    UIButton *carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carTypeBtn.frame = CGRectMake(self->_navigationImgView.width-40*x_6_plus-116*x_6_plus*2/3, 0, 116*x_6_plus*2/3, 72*y_6_plus*2/3);
    carTypeBtn.centerY = self->_navigationImgView.boundsCenter.y;
    [carTypeBtn setBackgroundImage:[UIImage imageNamed:@"车型图标"] forState:UIControlStateNormal];
    [self->_navigationImgView addSubview:carTypeBtn];
    
    [carTypeBtn addActionBlock:^(id weakSender) {
        if (!APP_DELEGATE.loginSuss) {
            [self goToLoginPage];
            return ;
        }
        MyCarController *mvc = [[MyCarController alloc]init];
        [self.navigationController pushViewController:mvc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
//    [_msgView addSubview:carTypeBtn];
}

#pragma mark - network method
- (void)requestDataWithCode:(NSString *)code{
    [[NetworkEngine sharedNetwork] postBody:@{@"cityCode":code,@"order":@"h",@"page":@"1",@"rows":@"10"} apiPath:kRecommnedMerURL hasHeader:YES finish:^(ResultState state, id resObj) {
            if (state == StateSucceed) {
                if (!_dataSource) {
                    _dataSource = [NSMutableArray array];
                }
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[resObj[@"body"][@"merList"] analysisConvertToArray]];
                self.serviceData = _dataSource;
                [self.tableView reloadData];
                [self.scrollView autoContentSize];
            }
        } failed:^(NSError *error) {

        }];
}

#pragma mark - event method
- (void)tapSetCity:(UITapGestureRecognizer*)tap{
    [self getinCity];
}

- (void)getinCity{
    //NewCityChangeViewController *setCityVC = [[NewCityChangeViewController alloc] init];
    NewSetCityViewController *setCityVC = [[NewSetCityViewController alloc] init];
    setCityVC.block = ^(NSString *code){
        [self requestDataWithCode:code];
    };
    // CitySetViewController *setCityVC = [[CitySetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setCityVC];
    if (iOS7) {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, APP_WIDTH, 20)];
        statusBarView.backgroundColor = COLOR_NAV;
        [nav.navigationBar addSubview:statusBarView];
    }
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Baidu iad Delegate
- (NSString *)baiduMobSspApplicationKey{
    return  @"2083889";
}

#pragma mark - ItemsViewDelegate && ActivityViewDelegate
- (void)ItemsView:(ItemsView *)ItemsView didSelectedItemAtPath:(NSInteger)path{
    if (!APP_DELEGATE.loginSuss) {
        [self goToLoginPage];
        return ;
    }
    BasicViewController *vc = [[BasicViewController alloc]init];
    NSArray *arr = nil;
    switch (path) {
        case BusinessMaintenace:
        {
            APP_DELEGATE.serviceType = Manintenance;
            arr = [[DataBase sharedDataBase]userCarsByUserId:APP_DELEGATE.userId];
            CarInfo *car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
            if (car) {
                if ([car.carId isLegal] && ![car.carId isEqualToString:@"(null)"]) {
                    vc = [[MaintenanceController alloc]init];
                }else{
                    [UITools alertWithMsg:[NSString stringWithFormat:@"您的“%@”需要完善车型信息",car.clpp1] viewController:self action:^{
                        CarDisplacementController *mvc = [[CarDisplacementController alloc] init];
                        mvc.car = car;
                        mvc.needHome = YES;
                        [self.navigationController pushViewController:mvc animated:YES];
                    }];
                }
            }else{
                if (arr.count) {
                    BOOL res = NO;
                    while (!res) {
                        res = [NSKeyedArchiver archiveRootObject:arr[0] toFile:LOCAL_PATH_P];
                    }
//                    vc = [[MaintenanceController alloc]init];
                    CarInfo *c = [[DataBase sharedDataBase]userCarsByUserId:APP_DELEGATE.userId][0];
                    [UITools alertWithMsg:[NSString stringWithFormat:@"您的“%@”需要完善车型信息",c.clpp1] viewController:self action:^{
                        
                        CarDisplacementController *mvc = [[CarDisplacementController alloc] init];
                        mvc.needHome = YES;
                        mvc.car = [[DataBase sharedDataBase] userCarsByUserId:APP_DELEGATE.userId][0];
                        [self.navigationController pushViewController:mvc animated:YES];
                    }];
                    
                }else{
                    [self.navigationController pushViewController:[[MyCarController alloc]init] animated:YES];
                    return;
                }
            }
        }
            break;
        case BusinessWashCar:
            [UITools alertWithMsg:@"该地区暂不支持该项服务"];

            return;
        case BusinessChangeTire:
            
            [UITools alertWithMsg:@"该地区暂不支持该项服务"];
            return;
        case BusinessAssurance:
            
            vc = [[BaoxianSelectCarViewController alloc]init];
            
             break;
        case BusinessUserCar:
             //vc = [[RescueViewController alloc]init];
            vc = [[UserCarViewController alloc]init];
            break;
        case BusinessHelpeService:
            
           vc = [[RescueViewController alloc]init];
          //  [UITools alertWithMsg:@"该地区暂不支持该项服务"];
            break;
        
            return;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)activityView:(ActivityView *)activityView DidSelectItemAtPath:(NSInteger)path{
    [UITools alertWithMsg:@"该地区暂不支持该项服务"];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count>5?5:_dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300*y_6_plus;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, APP_WIDTH, 38*y_6_SCALE)];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APP_WIDTH, 38*y_6_SCALE)];
    l.text = @"金牌服务";
    l.font = FONT_SIZE(15, x_6_SCALE);
    l.textColor = COLOR_NAV;
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(APP_WIDTH-35*x_6_plus-20*x_6_plus, 0, 20*x_6_plus, 34*y_6_plus)];
    icon.centerY = l.centerY;
    icon.image = [UIImage imageNamed:@"更多图标"];
    
    UILabel *l0 = [[UILabel alloc]initWithFrame:CGRectMake(icon.x-100*x_6_plus, 0, 100*x_6_plus, 38*y_6_SCALE)];
    l0.centerY = l.centerY;
    l0.text = @"更多";
    l0.font = FONT_SIZE(15, x_6_SCALE);
    l0.textColor = COLOR_NAV;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = headerV.bounds;
    [btn addActionBlock:^(id weakSender) {
        RecommendMer *rvc = [[RecommendMer alloc]init];
        [self.navigationController pushViewController:rvc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [btn addLineWithFrame:CGRectMake(0, btn.height-1, btn.width, 1) lineColor:kLineGrayColor];
    
    [headerV addSubview:l];
    [headerV addSubview:l0];
    [headerV addSubview:icon];
    [headerV addSubview:btn];
    
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38*y_6_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"servieCellId"];
    if (!cell) {
        cell = [[ServiceCell alloc] init];
    }
    [cell configCellWithDic:_dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OutDetailViewController *ovc = [[OutDetailViewController alloc]init];
    
    ovc.jwd = _dataSource[indexPath.row][@"jwd"];
    ovc.merid = _dataSource[indexPath.row][@"id"];
    ovc.hiddenFooter = YES;
    [self.navigationController pushViewController:ovc animated:YES];
}

@end
