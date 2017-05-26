//
//  MaintenanceController.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 16/1/4.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "MaintenanceController.h"
#import "EiddtingViewController.h"
#import "MaintenanceItemCell.h"
#import "SelectMaintenanceController.h"
#import "SelectOutletController.h"
#import "ConfirmOrderController.h"
#import "CarPartListController.h"
#import "MyCarController.h"
#import "ABBCalendarView.h"
#import "CaluteView.h"
#import "FittingsCell.h"
#import "MaintenanServiceCell.h"
#import "MaintenanceCalendarCell.h"
#import "CarInfo.h"
#import "HCarModel.h"
#import "MaintenanceHeaderCell.h"
#import "ABBDropDatepickerView.h"
#import "LocationManager.h"
#import "NetworkConnect.h"

@implementation UILabel (custom)

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        self.textColor = textColor;
        self.font = font;
    }
    
    return self;
}

@end
@interface MaintenanceController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,ABBCalendarDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *costView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectItems;
@property (nonatomic, strong) NSMutableDictionary *chantInfo;

@end

static NSString *serviceCellId = @"serviceCellId";
static NSString *ItemCellId = @"ItemCellId";
static NSString *fittingsCellId = @"fittingsCellId";
static NSString *calendarcellId = @"calendarcellId";
static NSString *headerCellId = @"headerCellId";

#define sectionHeaderHeight (88*y_6_plus)
#define sectionFooterHeight (92*y_6_plus)

@implementation MaintenanceController
{
    NSArray *_itemSource;
    NSMutableArray *_serviceArr;
    CGFloat _totalPrice;
    BOOL _folding;
    BOOL _showingFooter;
    
    NSString *_serId;                   //车型ID
    NSString *_bookingTime;             //预约日期
    NSString *_merchantId;              //商户ID
    NSString *_merchantName;            //商户名称
    NSString *_merchantPhoto;           //商户头像
    NSString *_merchantPhone;           //商户电话
    NSString *_merchantMoible;          //商户座机
    NSString *_merchantAddress;         //商户地址
    NSString *_merchantDistance;        //商户距离
    NSNumber *_level;                   //商户星级
    NSString *_chanelId;                //配件商Id
    HCarModel *_carModel;               //汽车信息
    
    CarInfo *_car;
    BOOL _jiesuanAble;
    UILabel *_nameLabel;
    UILabel *_distanceLabel;
    UILabel *_timeLabel;
    UILabel *_priceLabel;
    ABBCalendarView *_calendarV;
    NSDate *_selectDate;
    ABBDropDatepickerView *_dropTime;
    NSString *_locateCity;
    BOOL _shown;
    BOOL _locationSucceed;
    BOOL _cilckConfirm;             //定位点没点击确认
    NSString *_ADCode;
    NSString *_cityCode;
    
    NetworkEngine *_ntEngine;
    CLLocationCoordinate2D _coori2D;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __block __typeof(self) weakSelf = self;
    _ntEngine.reachabilityChangedHandler = ^(NetworkStatus nt){
        if (nt == NotReachable) {
            [UITools hideHUDForView:weakSelf.view];
            [UITools alertWithMsg:@"当前网络不可用,请确保网络通畅"];
        }else{
            [weakSelf location];
        }
    };
    [self setCustomNavigationTitle:@"常规保养"];
    [self loadCarType];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _ntEngine.reachabilityChangedHandler = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initOutlet:) name:kPostOutlet object:nil];
    [self initSource];
    [self configUI];
    [self location];
}

//#pragma mark Reachability related
//
//-(void) reachabilityChanged:(NSNotification*) notification
//{
//    Reachability *reachability = [notification object];
//    if([reachability currentReachabilityStatus] == NotReachable){
//        [self location];
//    }else{
//        [UITools alertWithMsg:@"当前网络不可用,请确保网络通畅"];
//    }
//}
//
- (void)location{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [UITools alertWithMsg:@"请到“设置-隐私-定位服务-开车邦”打开定位功能"];
        _shown = YES;
        [self.tableView reloadData];
        
        return ;
    }
//    if (!_ntEngine.isReachable) {
//        [UITools alertWithMsg:@"当前网络不可用,请确保网络通畅"];
//        return ;
//    }
    if (![NetworkConnect connectedToNetwork]) {
        [UITools alertWithMsg:@"当前网络不可用,请确保网络通畅"];
        
        return ;
    }
    [UITools showIndicatorToView:self.view];
    [[LocationManager shareLocationManager] getCurrentCitySearchFinishDone:^(NSString *city, NSString *code, CLLocationCoordinate2D coorinate) {
        [UITools hideHUDForView:self.view];
        _shown = YES;
        if ([city isLegal]) {
            _locationSucceed = YES;
            _coori2D = coorinate;
            if ([city rangeOfString:@"市"].location != NSNotFound && [city rangeOfString:@"市"].location == city.length-1) {
                city = [city substringToIndex:city.length-1];
            }
            NSString *u_city_name = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
            if ([u_city_name isEqualToString:city]) {
                _locateCity = city;
                [self.tableView reloadData];
            }else{
                [UITools alertWithMsg:[NSString stringWithFormat:@"当前定位到%@,是否需要切换",city] viewController:self confirmAction:^{
                    {                               //原来的值先保存一下
                        _cilckConfirm = YES;
                        NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
                        _ADCode = [u objectForKey:KEY_CITY_ADCODE_IN_USERDEFAULT];
                        _cityCode = [u objectForKey:KEY_CITY_CODE_IN_USERDEFAULT];
                    }
                    _locateCity = city;
                    
                    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
                    NSData *resourceData = [NSData dataWithContentsOfFile:resourcePath];
                    SBJsonParser *parser = [[SBJsonParser alloc] init];
                    NSDictionary *resourceDict = [parser objectWithData:resourceData];
                    for (NSDictionary *cityDic in resourceDict[@"pl"]) {
                        NSRange range = [cityDic[@"list"][0][@"name"] rangeOfString:city];
                        if (range.location != NSNotFound) {
                            [[NSUserDefaults standardUserDefaults] setObject:cityDic[@"list"][0][@"adCode"] forKey:KEY_CITY_ADCODE_IN_USERDEFAULT];
                            [[NSUserDefaults standardUserDefaults] setObject:cityDic[@"list"][0][@"cityCode"] forKey:KEY_CITY_CODE_IN_USERDEFAULT];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            break ;
                        }
                    }
                    [self.tableView reloadData];
                    [self requestData:_serId];
                } cancelAction:^{
                    _locateCity = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
                    [self.tableView reloadData];
                }];
            }
        }
        [self.tableView reloadData];
        [self requestData:_serId];
    } searchFailedDone:^{
        [self.tableView reloadData];
        [self requestData:_serId];
        _shown = YES;
    }];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    _dropTime = [[ABBDropDatepickerView alloc] init];
    
    __block __typeof(self) weakSelf = self;
    _dropTime.commplete = ^(NSString *dateString){
        _bookingTime = dateString;
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:_dropTime];
}

- (void)initSource{
    [self initCarInfo];
    _ntEngine = [NetworkEngine sharedNetwork];
    _serviceArr = [@[] mutableCopy];
    _jiesuanAble = YES;
    _serId = @"8";
    _shown = NO;
    _selectDate = [NSDate date];
    _showingFooter = YES;
    _totalPrice = 0;
    _folding = YES;
    _selectItems = [@[] mutableCopy];
    _itemSource = @[@{@"icon":@"bangyang_01",@"content":@"选择服务项目(小保养)"},
                    @{@"icon":@"bangyang_02",@"content":@"选择门店"},
                    @{@"icon":@"bangyang_03",@"content":@"选择预约安装时间"}];
}

- (void)requestData:(NSString *)serId{
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_CITY_ADCODE_IN_USERDEFAULT];
    [_ntEngine postBody:@{@"carid":self.carId?self.carId:@"",@"serids":serId,@"cityCode":code} apiPath:kFittingMessURL hasHeader:YES finish:^(ResultState state, id resObj) {
        [UITools hideHUDForView:self.view];
        if (state == StateSucceed) {
            _jiesuanAble = YES;
            if (!_dataSource) {
                _dataSource = [NSMutableArray array];
            }
            [_dataSource removeAllObjects];
            [self changeWithData:[resObj[@"body"][@"serComList"] analysisConvertToArray]];      //更换数据员
            if (!_chantInfo) {
                _chantInfo = [@{} mutableCopy];
            }
            [_chantInfo removeAllObjects];
            _chantInfo = [NSMutableDictionary dictionaryWithDictionary:[resObj[@"body"] analysisConvertToDict]];
            [self calculatePrice];
            [self.tableView reloadData];
        }else{
            if ([resObj[@"head"][@"rspCode"] isEqualToString:@"-1"]) {
                _jiesuanAble = NO;
                [self.dataSource removeAllObjects];
                [self calculatePrice];
                [self.tableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        [UITools hideHUDForView:self.view];
    }];
}

- (void)changeWithData:(NSArray *)data{
    for (NSDictionary *dic in data) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (NSDictionary *dic0 in dictionary[@"comList"]) {
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic0];
            [mDic setObject:@(1) forKey:@"account"];
            [mDic setObject:dic[@"serName"] forKey:@"serName"];
            [mDic setObject:dic[@"serid"] forKey:@"serid"];
            _chanelId = [dic0[@"merid"] analysisConvertToString];
            
            [self.dataSource addObject:mDic];
        }
    }
    //过滤id一样的配件
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *d in self.dataSource) {
        NSString *key = [NSString stringWithFormat:@"%@",d[@"id"]];
        NSMutableArray *arr = tempDic[key];
        if (!arr) {
            arr = [NSMutableArray array];
        }
        [arr addObject:d];
        [tempDic setObject:arr forKey:key];
    }
    [self.dataSource removeAllObjects];
    for (NSMutableArray *arr in tempDic.allValues) {
        [self.dataSource addObject:arr[0]];
    }
}

- (void)refreshPriceView{
    NSString *total = [NSString stringWithFormat:@"合计:¥%.2f(不含工时费)",_totalPrice];
    
    NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc]initWithString:total];
    [mAtt addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xff7a19],NSFontAttributeName:V3_48PX_FONT} range:NSMakeRange(3, total.length - 10)];
    [mAtt addAttributes:@{NSFontAttributeName:V3_30PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 3)];
    [mAtt addAttributes:@{NSFontAttributeName:V3_30PX_FONT} range:NSMakeRange(total.length-7, 7)];
    
    _priceLabel.attributedText = mAtt;
}

- (void)calculatePrice{
    _totalPrice = 0.f;
    for (NSDictionary *dic in self.dataSource) {
        _totalPrice += [dic[@"price"] floatValue];
    }
    NSString *total = nil;
    if (!self.dataSource.count) {
        _totalPrice = 0.f;
        total = @"合计:--(不含工时费)";
    }else{
        total = [NSString stringWithFormat:@"合计:¥%.2f(不含工时费)",_totalPrice];
    }
    
    NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc]initWithString:total];
    [mAtt addAttributes:@{NSForegroundColorAttributeName:kTextOrangeColor,NSFontAttributeName:V3_48PX_FONT} range:NSMakeRange(3, total.length - 10)];
    [mAtt addAttributes:@{NSFontAttributeName:V3_30PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 3)];
    [mAtt addAttributes:@{NSFontAttributeName:V3_30PX_FONT} range:NSMakeRange(total.length-7, 7)];
    
    _priceLabel.attributedText = mAtt;
}

- (void)initCarInfo{
    CarInfo *car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
    if (car) {
        _car = car;
    }else{  //该车被取消绑定了
        NSArray *arr = [[DataBase sharedDataBase] userCarsByUserId:APP_DELEGATE.userId];
        NSLog(@"===%lu===",(unsigned long)arr.count);
        
        _car = arr[0];
        BOOL res = NO;
        while (!res) {
            res = [NSKeyedArchiver archiveRootObject:_car toFile:LOCAL_PATH_P];
        }
    }
    self.carId = _car.carId;
    _carModel = [[HCarModel alloc]init];
    _carModel.LicenseCode = _car.hphm;
//    _carModel.carName = _car.clpp1;
    _carModel.carModelId = _carId;
    _carModel.carName = [NSString stringWithFormat:@"%@-%@ %@ %@T %@",_car.clpp1,_car.line,_car.nk,_car.pql,_car.detailDes];
    _carModel.clsbdh = _car.clsbdh;
    _carModel.runTime = _car.ccdjrq;
    _carModel.travelMileage = nil;
}

- (void)initOutlet:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    MaintenanceItemCell *cell = (MaintenanceItemCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.contentLabel.hidden = YES;
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]] && obj.tag != 999) {
            [obj removeFromSuperview];
        }
    }];
    UILabel *l = [[UILabel alloc] init];
    l.text = dic[@"name"];
    l.textAlignment = NSTextAlignmentCenter;
    l.font = V3_36PX_FONT;
    l.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    l.textColor = [UIColor colorWithHex:0x777777];
    [l sizeToFit];
    l.width += 50*x_6_plus;
    l.height += 25*y_6_plus;
    [l addBorderWithWidth:1 color:[UIColor colorWithHex:0xf5f5f5] roundingCorners:UIRectCornerAllCorners cornerRadius:5];
    l.centerY = cell.contentView.boundsCenter.y;
    l.x = cell.contentLabel.x;
    [cell.contentView addSubview:l];

    _merchantId = dic[@"id"];
    _merchantName = dic[@"name"];
    _merchantPhone = dic[@"phone_no"];
    _merchantPhoto = dic[@"logo_pic"];
    _merchantAddress = dic[@"address"];
    _merchantDistance = dic[@"distance"];
    _merchantMoible = dic[@"telno"];
    _level = dic[@"level"];
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y, self.view.width, APP_HEIGHT-APP_NAV_HEIGHT-
                                                              APP_STATUS_BAR_HEIGHT-self.footerView.height+APP_STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MaintenanServiceCell class] forCellReuseIdentifier:serviceCellId];
    [_tableView registerClass:[MaintenanceItemCell class] forCellReuseIdentifier:ItemCellId];
    [_tableView registerClass:[FittingsCell class] forCellReuseIdentifier:fittingsCellId];
    [_tableView registerClass:[MaintenanceHeaderCell class] forCellReuseIdentifier:headerCellId];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    return _tableView;
}

- (UIView *)footerView{
    if (_footerView) {
        return _footerView;
    }
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, APP_HEIGHT-44*y_6_SCALE+APP_STATUS_BAR_HEIGHT, APP_WIDTH, 144*y_6_plus)];
    _footerView.backgroundColor = kWhiteColor;
    UIButton *jiesuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jiesuanBtn addActionBlock:^(id weakSender) {
        if (!_jiesuanAble) {
            [UITools alertWithMsg:@"没有配件信息，不能结算哦！"];
            return ;
        }
        ConfirmOrderController *cvc = [[ConfirmOrderController alloc]init];
        cvc.dataArr = self.dataSource;
        cvc.serids = _serId;
        cvc.totalPrice = _totalPrice;
        cvc.bookingTime = _bookingTime;
        cvc.merchantId = _merchantId;
        cvc.carModel = _carModel;
        cvc.chanelId = _chanelId;
        cvc.merchantAddress = _merchantAddress;
        cvc.merchantName = _merchantName;
        cvc.merchantPhone = _merchantPhone;
        cvc.merchantImage = _merchantPhoto;
        cvc.merchantDistance = _merchantDistance;
        cvc.chantInfo = _chantInfo;
        cvc.score = _level;
        
        if (![_merchantId isLegal]) {
            [UITools alertWithMsg:@"请选择商户"];
        }else if(![_bookingTime isLegal]){
            [UITools alertWithMsg:@"请设置预约时间"];
        }else{
            [self.navigationController pushViewController:cvc animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [jiesuanBtn setTitle:@"去结算"];
    [jiesuanBtn setTitleColor:kWhiteColor];
    jiesuanBtn.backgroundColor = [UIColor colorWithHex:0xff7a19];
    jiesuanBtn.frame = CGRectMake(_footerView.width-80*x_6_SCALE, 0, 80*x_6_SCALE, _footerView.height);
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_footerView.width-jiesuanBtn.width-10*x_6_SCALE-200*x_6_SCALE, 0, 200*x_6_SCALE, _footerView.height)];
    _priceLabel.textColor = [UIColor colorWithHex:0x666666];
    _priceLabel.centerY = _footerView.boundsCenter.y;
    _priceLabel.font = V3_46PX_FONT;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    
    ZKButton *kfButton =[ZKButton blockButtonWithFrame:CGRectMake(0, 58*y_6_plus, 162*x_6_plus, _footerView.height-116*y_6_plus) type:UIButtonTypeSystem title:@"客服" backgroundImage:nil andBlock:^(ZKButton *button) {
        [UITools alertWithMsg:@"是否拨打客服电话 4000956122" viewController:self confirmAction:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://4000956122"]]];
        } cancelAction:nil];
//        NSLog(@"在线客服");
        
    }];
    kfButton.centerY = _priceLabel.centerY;
    [kfButton setImage:[UIImage imageNamed:@"custom_service"] forState:UIControlStateNormal];
    kfButton.titleLabel.font = V3_32PX_FONT;
    [kfButton setTitleColor:[UIColor colorWithHex:0x666666]];
   
   
    
    NSString *total = [NSString stringWithFormat:@"合计:¥--(不含工时费)"];
    
    NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc]initWithString:total];
    [mAtt addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:V3_46PX_FONT} range:NSMakeRange(3, total.length - 10)];
    [mAtt addAttributes:@{NSFontAttributeName:V3_30PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 3)];
    [mAtt addAttributes:@{NSFontAttributeName:V3_30PX_FONT} range:NSMakeRange(total.length-7, 7)];
    _priceLabel.attributedText = mAtt;
    [_footerView addSubview:kfButton];
    [_footerView addSubview:_priceLabel];
    [_footerView addSubview:jiesuanBtn];
    
    return _footerView;
}

- (void)loadCarType{
    UIButton *carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carTypeBtn.frame = CGRectMake(self->_navigationImgView.width-40*x_6_plus-116*x_6_plus*2/3, 0, 116*x_6_plus*2/3, 72*y_6_plus*2/3);
    carTypeBtn.centerY = self->_navigationImgView.boundsCenter.y;
    [carTypeBtn setBackgroundImage:[UIImage imageNamed:@"车型图标"] forState:UIControlStateNormal];
    [self->_navigationImgView addSubview:carTypeBtn];
    
    [carTypeBtn addActionBlock:^(id weakSender) {
        MyCarController *mvc = [[MyCarController alloc]init];
        mvc.commplete = ^{
            CarInfo *car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
            NSString *name = nil;
            if (![car.carId isEqualToString:self.carId]) {
                if ([car.line isLegal]) {
                    name = [NSString stringWithFormat:@"%@ %@",car.line,car.detailDes];
                }else{
                    name = [car.clpp1 stringByAppendingString:car.hpzlname];
                }
                _nameLabel.text = name;
                _distanceLabel.text = @"行驶里程：";
                _timeLabel.text = [NSString stringWithFormat:@"上路时间：%@",car.ccdjrq];
                self.carId = car.carId;
                [self initCarInfo];
                [UITools showIndicatorToView:self.view];
                [self requestData:_serId];
            }
        };
        [self.navigationController pushViewController:mvc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)createHeaderView:(UIView *)superView{
    CGFloat h = sectionHeaderHeight/3;
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22*y_6_plus, superView.width, h)
                                                  text:@"道奇－酷威2013款2.4L 尊尚版"
                                                  font:FONT_SIZE(22, x_6_SCALE)
                                             textColor:[UIColor blackColor]];
    
    _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _nameLabel.bottom, APP_WIDTH/2, h)
                                                      text:@"行驶里程：35000"
                                                      font:FONT_SIZE(15, x_6_SCALE)
                                                 textColor:[UIColor blackColor]];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_distanceLabel.right, _nameLabel.bottom, APP_WIDTH/2, h)
                                             text:@"上路时间：2011年12月"
                                             font:FONT_SIZE(15, x_6_SCALE)
                                        textColor:[UIColor blackColor]];
    _timeLabel.backgroundColor = kWhiteColor;
    
    UILabel *discribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _timeLabel.bottom, superView.width, h)
                                                      text:@"准确的填写行驶里程及上路时间能够更准确多棒您匹配所需服务"
                                                      font:FONT_SIZE(12, x_6_SCALE)
                                                 textColor:[UIColor blackColor]];
    
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    discribeLabel.textAlignment = NSTextAlignmentCenter;
    NSString *name = [NSString stringWithFormat:@"%@ %@",_car.clpp1,_car.hpzlname];
    _nameLabel.text = name;
//    distanceLabel.text = _car
    _timeLabel.text = _car.ccdjrq;
    
    [superView addSubview:_nameLabel];
    [superView addSubview:_distanceLabel];
    [superView addSubview:_timeLabel];
    [superView addSubview:discribeLabel];
}

- (void)refreshHeaderView{
    [self initCarInfo];
    NSString *name = [_car.clpp1 stringByAppendingString:_car.hpzlname];
    _nameLabel.text = name;
    _distanceLabel.text = @"行驶里程：";
    _timeLabel.text = [NSString stringWithFormat:@"上路时间：%@",_car.ccdjrq];
}

- (void)refreshBodyView{
    [self.tableView reloadData];
}

#pragma mark - ABBCalendarViewDelegate
- (void)calendar:(ABBCalendarView *)calendar didSelectDate:(NSDate *)date{
    _selectDate = date;
    _bookingTime = [date stringWithDateFormat:DateFormatWithYearMonthDay];
    _folding = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_shown) {
            return _locationSucceed?138*y_6_plus:238*y_6_plus;
        }
        
        return 138*y_6_plus;
    }else if (section == 1) {
        return sectionHeaderHeight;
    }else if (section == 2){
        return 20*y_6_plus;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 1) {
        return _folding ? CGFLOAT_MIN : 360;
    }
    
    return _showingFooter ? sectionFooterHeight : CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 235*y_6_plus;
    }else if (indexPath.section == 1){
        return 138*y_6_plus;
    }
    
    return 250*y_6_plus;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_shown) {
            if (!_locationSucceed) {
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, (138+100)*y_6_plus)];
                headerView.backgroundColor = kWhiteColor;
                
                UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 100*y_6_plus)];
                l.backgroundColor = [UIColor colorWithHex:0xff7914];
                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(40*x_6_plus, 0, 50*x_6_plus, 50*x_6_plus)];
                icon.image = [UIImage imageNamed:@"定位失败提示图标"];
                icon.centerY = l.boundsCenter.y;
                [l addSubview:icon];
                
                UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(icon.right+20*x_6_plus, 0, APP_WIDTH, 100*y_6_plus)];
                loc.backgroundColor = kTextOrangeColor;
                loc.text = @"定位失败，将为您推荐默认设置城市范围内的服务。";
                loc.font = V3_36PX_FONT;
                loc.textColor = kWhiteColor;
                [l addSubview:loc];
                [headerView addSubview:l];
                
                UILabel *serviceCity = [[UILabel alloc] initWithFrame:CGRectMake(40*x_6_plus, loc.bottom, tableView.width, 138*y_6_plus)];
                serviceCity.font = V3_38PX_FONT;
                serviceCity.backgroundColor = kWhiteColor;
                NSString *city = ![_locateCity isLegal]?[[NSUserDefaults standardUserDefaults]objectForKey:KEY_CITY_NAME_IN_USERDEFAULT]:_locateCity;
                serviceCity.text = [NSString stringWithFormat:@"服务城市：%@",city];
                NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:serviceCity.text];
                [mStr addAttributes:@{NSFontAttributeName:V3_38PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 5)];
                [mStr addAttributes:@{NSFontAttributeName:V3_36PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(5, serviceCity.text.length-5)];
                serviceCity.attributedText = mStr;
                [serviceCity addLineWithFrame:CGRectMake(0, serviceCity.height-1, serviceCity.width, 1) lineColor:kLineGrayColor];
                [headerView addSubview:serviceCity];
                
                return headerView;
            }else{
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 138*y_6_plus)];
                headerView.backgroundColor = kWhiteColor;
                UILabel *serviceCity = [[UILabel alloc] initWithFrame:CGRectMake(40*x_6_plus, 0, tableView.width, 138*y_6_plus)];
                serviceCity.font = V3_38PX_FONT;
                serviceCity.backgroundColor = kWhiteColor;
                NSString *city = ![_locateCity isLegal]?[[NSUserDefaults standardUserDefaults]objectForKey:KEY_CITY_NAME_IN_USERDEFAULT]:_locateCity;
                serviceCity.text = [NSString stringWithFormat:@"服务城市：%@",city];
                NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:serviceCity.text];
                [mStr addAttributes:@{NSFontAttributeName:V3_38PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 5)];
                [mStr addAttributes:@{NSFontAttributeName:V3_36PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(5, serviceCity.text.length-5)];
                serviceCity.attributedText = mStr;
                [serviceCity addLineWithFrame:CGRectMake(0, serviceCity.height-1, serviceCity.width, 1) lineColor:kLineGrayColor];
                [headerView addSubview:serviceCity];
                
                return headerView;
            }
        }else{
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 138*y_6_plus)];
            headerView.backgroundColor = kWhiteColor;
            UILabel *serviceCity = [[UILabel alloc] initWithFrame:CGRectMake(40*x_6_plus, 0, tableView.width, 138*y_6_plus)];
            serviceCity.font = V3_38PX_FONT;
            serviceCity.backgroundColor = kWhiteColor;
//            NSString *city = ![_locateCity isLegal]?[[NSUserDefaults standardUserDefaults]objectForKey:KEY_CITY_NAME_IN_USERDEFAULT]:_locateCity;
            serviceCity.text = @"服务城市：正在为您获取当前城市..";
            NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:serviceCity.text];
            [mStr addAttributes:@{NSFontAttributeName:V3_38PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, 5)];
            [mStr addAttributes:@{NSFontAttributeName:V3_36PX_FONT,NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(5, serviceCity.text.length-5)];
            serviceCity.attributedText = mStr;
            [serviceCity addLineWithFrame:CGRectMake(0, serviceCity.height-1, serviceCity.width, 1) lineColor:kLineGrayColor];
            [headerView addSubview:serviceCity];
            
            return headerView;
        }
    }
    if (section == 1) {
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, sectionHeaderHeight)
                                              text:@"准确填写行驶里程及上路时间，可更准确的帮您匹配所需服务"
                                              font:V3_30PX_FONT
                                         textColor:[UIColor colorWithHex:0xff7a19]];
        l.textAlignment = NSTextAlignmentCenter;
        
        return l;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1 && !_folding) {
         _calendarV = [[ABBCalendarView alloc]initWithStartDay:startSunday frame:CGRectMake(0, 0, APP_WIDTH, 300)];
        _calendarV.monthShowing = _selectDate;
        _calendarV.selectedDate = _selectDate;
        _calendarV.delegate = self;
        
        return _calendarV;
    }else if (section > 1){
        if (_showingFooter) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, sectionFooterHeight)];
            view.backgroundColor = kWhiteColor;
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.width-36*x_6_plus-300*x_6_plus, 0, 300*x_6_plus, view.height)];
            priceLabel.tag = section+999;
            priceLabel.centerY = view.boundsCenter.y;
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.text = @"￥--x1";
            
            if (self.dataSource.count) {
                NSNumber *count = self.dataSource[section-2][@"account"];
                priceLabel.text = [NSString stringWithFormat:@"￥%.2fx%ld",[self.dataSource[section-2][@"price"] floatValue],(long)[count integerValue]];
                NSRange range = [priceLabel.text rangeOfString:@"x"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:priceLabel.text];
                [str addAttributes:@{NSFontAttributeName:V3_40PX_FONT,NSForegroundColorAttributeName:kTextOrangeColor} range:NSMakeRange(0, range.location)];
                [str addAttributes:@{NSForegroundColorAttributeName:kTextGrayColor,NSFontAttributeName:V3_36PX_FONT} range:NSMakeRange(range.location, priceLabel.text.length-range.location)];
                priceLabel.attributedText = str;
            }
            
            [view addSubview:priceLabel];
            
            CaluteView *cv=  [CaluteView shareCaluteView];
            __weak __typeof(cv) weakCV = cv;
            cv.block1 = ^(NSInteger n){
                for (UIView *subV in weakCV.superview.subviews) {
                    if ([subV isKindOfClass:[UILabel class]]) {
                        UILabel *l = (UILabel *)subV;
                        l.text = [NSString stringWithFormat:@"￥%.2fx%ld",[self.dataSource[section-2][@"price"] floatValue],(long)n];
                        NSRange range = [l.text rangeOfString:@"x"];
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:priceLabel.text];
                        [str addAttributes:@{NSFontAttributeName:V3_40PX_FONT,NSForegroundColorAttributeName:kTextOrangeColor} range:NSMakeRange(0,range.location)];
                        [str addAttributes:@{NSForegroundColorAttributeName:kTextGrayColor,NSFontAttributeName:V3_36PX_FONT} range:NSMakeRange(range.location, priceLabel.text.length-range.location)];
                        priceLabel.attributedText = str;
                        
                        NSMutableDictionary *dic = [self.dataSource[section-2] mutableCopy];
                        [dic setObject:@(n) forKey:@"account"];
                        [self.dataSource replaceObjectAtIndex:section-2 withObject:dic];
                    }
                }
                _totalPrice = _totalPrice+[self.dataSource[section-2][@"price"] floatValue];
                [self refreshPriceView];
            };
            cv.block2 = ^(NSInteger n){
                for (UIView *subV in weakCV.superview.subviews) {
                    if ([subV isKindOfClass:[UILabel class]]) {
                        UILabel *l = (UILabel *)subV;
                        l.text = [NSString stringWithFormat:@"￥%.2fx%ld",[self.dataSource[section-2][@"price"] floatValue],(long)n];
                        NSRange range = [l.text rangeOfString:@"x"];
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:priceLabel.text];
                        [str addAttributes:@{NSFontAttributeName:V3_40PX_FONT,NSForegroundColorAttributeName:kTextOrangeColor} range:NSMakeRange(0, range.location)];
                        [str addAttributes:@{NSForegroundColorAttributeName:kTextGrayColor,NSFontAttributeName:V3_36PX_FONT} range:NSMakeRange(range.location, l.text.length-range.location)];
                        priceLabel.attributedText = str;
                        
                        NSMutableDictionary *dic = [self.dataSource[section-2] mutableCopy];
                        [dic setObject:@(n) forKey:@"account"];
                        [self.dataSource replaceObjectAtIndex:section-2 withObject:dic];
                    }
                }
                _totalPrice = _totalPrice-[self.dataSource[section-2][@"price"] floatValue];
                [self refreshPriceView];
            };
            cv.n = self.dataSource[section-2][@"account"];
            cv.origin = CGPointMake(priceLabel.x-cv.width, 0);
            cv.centerY = view.boundsCenter.y;
            [view addSubview:cv];
            
            return view;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MaintenanceHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellId];
        if (!cell) {
            cell = [[MaintenanceHeaderCell alloc]init];
        }
        NSString *name = nil;
        if ([_car.line isLegal]) {
            name = [NSString stringWithFormat:@"%@-%@ %@ %@T",_car.clpp1,_car.line,_car.nk,_car.pql];
        }else{
            name = _car.clpp1;
        }
        cell.subNameLabel.text = _car.detailDes;
        cell.nameLabel.text = name;
        cell.timeLabel.text = [NSString stringWithFormat:@"上路时间：%@",_car.xslsj?_car.xslsj:@"--"];
        cell.distanceLabel.text =[NSString stringWithFormat:@"行驶里程：%@",_car.xslc?_car.xslc:@"--"];
        cell.block = ^{
            EiddtingViewController *evc = [[EiddtingViewController alloc]init];
            evc.res = YES;
            evc.commplete = ^{
                _car = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_PATH_P];
                [tableView reloadData];
            };
            evc.carInfo = _car;
            [self.navigationController pushViewController:evc animated:YES];
        };
        
        _nameLabel = cell.nameLabel;
        _timeLabel = cell.timeLabel;
        _distanceLabel = cell.distanceLabel;

        return cell;
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            MaintenanServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceCellId];
            if (!cell) {
                cell = [[MaintenanServiceCell alloc]init];
            }
            [cell configCellWithDic:_itemSource[indexPath.row]];
            
            if (!_selectItems.count) {
                cell.contentLabel.hidden = NO;
                cell.res = YES;
            }else{
                [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[UILabel class]] && obj.tag != 999) {
                        [obj removeFromSuperview];
                    }
                }];
               
                for (int i = 0 ; i < _selectItems.count; i++) {
                    UILabel *l = [[UILabel alloc]init];
                    l.textAlignment = NSTextAlignmentCenter;
                    l.text = _selectItems[i][@"name"];
                    l.font = V3_36PX_FONT;
                    [l sizeToFit];
                    l.width += 50*x_6_plus;
                    l.height += 25*y_6_plus;
                    l.x = cell.contentLabel.x;
                    l.centerY = cell.boundsCenter.y;
                    [l addBorderWithWidth:1 color:[UIColor colorWithHex:0xf5f5f5] roundingCorners:UIRectCornerAllCorners cornerRadius:5];
                    l.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
                    l.textColor = [UIColor colorWithHex:0x777777];
                    [cell.contentView addSubview:l];

                    CGFloat x = 0.0f;
                    cell.contentLabel.hidden = YES;
                    for (UIView *subV in cell.contentView.subviews) {
                        if (subV.hidden) {
                            continue;
                        }
                        if ([subV isKindOfClass:[UILabel class]]) {
                            x = x > subV.right ? x : subV.right;
                        }
                    }
                    if (x && i != 0) {
                        l.x = x+40*x_6_plus;
                    }
                }
            }
            
            return cell;
        }else{
            MaintenanceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemCellId];
            if (!cell) {
                cell = [[MaintenanceItemCell alloc]init];
            }
            if (indexPath.row == 1) {
                [cell configCellWithDic:_itemSource[indexPath.row]];
                
                if ([_merchantName isLegal]) {
                    cell.contentLabel.hidden = YES;
                }else{
                    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[UILabel class]] && obj.tag != 999) {
                            [obj removeFromSuperview];
                        }
                    }];
                    cell.contentLabel.hidden = NO;
                }
            }else{
                if (indexPath.row == 2) {
                    [cell configCellWithDic:_itemSource[indexPath.row]];
                    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[UILabel class]] && obj.tag != 999) {
                            [obj removeFromSuperview];
                        }
                    }];
                    if (![_bookingTime isLegal]) {
                        cell.contentLabel.hidden = NO;
                    }else{
                        cell.contentLabel.hidden = YES;
                        UILabel *l = [[UILabel alloc]init];
                        l.textAlignment = NSTextAlignmentCenter;
                        l.text = _bookingTime;
                        l.font = V3_36PX_FONT;
                        [l sizeToFit];
                        l.width += 50*x_6_plus;
                        l.height += 25*y_6_plus;
                        l.x = cell.contentLabel.x;
                        l.centerY = cell.contentView.boundsCenter.y;
                        [l addBorderWithWidth:1 color:[UIColor colorWithHex:0xf5f5f5] roundingCorners:UIRectCornerAllCorners cornerRadius:5];
                        l.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
                        l.textColor = [UIColor colorWithHex:0x777777];
                        [cell.contentView addSubview:l];

                    }
                }
            }
            
//            [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj isKindOfClass:[UILabel class]] && obj.tag != 999) {
//                    [obj removeFromSuperview];
//                }
//            }];
//            cell.contentLabel.hidden = NO;
//            [cell configCellWithDic:_itemSource[indexPath.row]];
//            
//            if (indexPath.row == 1 && [_merchantName isLegal]) {
////                if (![_merchantName isLegal]) {
////                    cell.contentLabel.size = CGSizeMake(854*x_6_plus, 60*y_6_plus);
////                    c
////                }
//                cell.contentLabel.text = _merchantName;
//                [cell.contentLabel sizeToFit];
//                cell.contentLabel.width += 18*x_6_plus;
//                cell.contentLabel.height += 18*y_6_plus;
//                cell.backgroundColor = [UIColor colorWithHex:0x999999];
//            }else{
//                if (_bookingTime && indexPath.row == 2) {
//                    cell.contentLabel.text = _bookingTime;
//                }
//            }
            
            return cell;
        }
    }
    
    FittingsCell *cell = [tableView dequeueReusableCellWithIdentifier:fittingsCellId];
    if (!cell) {
        cell = [[FittingsCell alloc]init];
    }
    cell.delegate = self;
    [cell configCellWithDic:self.dataSource[indexPath.section-2]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SelectMaintenanceController *svc = [[SelectMaintenanceController alloc]init];
            svc.selectItems = [_selectItems mutableCopy];
            svc.commplete = ^(NSMutableArray *arr){
                NSMutableString *serids = [NSMutableString string];
                for (NSDictionary *dic in arr) {
                    [serids appendFormat:@",%@",dic[@"id"]];
                }
                NSString *serId = [serids substringWithRange:NSMakeRange(1, serids.length-1)];
                [UITools hideHUDForView:self.view];
                [self requestData:serId];
                _serId = serId;
                _selectItems = arr;
            };
            [self.navigationController pushViewController:svc animated:YES];
        }else if (indexPath.row == 1){
            SelectOutletController *svc = [[SelectOutletController alloc]init];
            svc.coori2D = _coori2D;

            svc.serids = _serId;
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            [_dropTime dropDownButtonClicked];
//            _folding = !_folding;
//            [tableView reloadData];
        }
    }
}

#pragma mark -------------------- MGSwipeTableCellDelegate ---------------------

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings{
    swipeSettings.transition = MGSwipeTransitionStatic;
    expansionSettings.buttonIndex = -1;
    expansionSettings.fillOnTrigger = YES;
    FittingsCell *fCell = (FittingsCell *)cell;
    if (direction == MGSwipeDirectionRightToLeft) {
        fCell.rV.selected = YES;
        NSMutableArray *mArr = [NSMutableArray array];
        
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeBtn setImage:[UIImage imageNamed:@"baoyang_change"] forState:UIControlStateNormal];
        changeBtn.frame = CGRectMake(0, 0, 158*x_6_plus, 273*y_6_plus);
        changeBtn.backgroundColor = COLOR_NAV;
        [mArr addObject:changeBtn];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"baoyang_del"] forState:UIControlStateNormal];
        deleteBtn.frame = CGRectMake(0, 0, 158*x_6_plus, 273*y_6_plus);
        deleteBtn.backgroundColor = [UIColor colorWithHex:0xcccccc];
        [mArr addObject:deleteBtn];

        return mArr;
    }else{
        fCell.rV.selected = NO;
    }
    
    return nil;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FittingsCell *fCell = (FittingsCell *)cell;
 
    if (direction == MGSwipeDirectionRightToLeft && index == 1) {
        if ([fCell.typeId isEqual:@(8)]) {
            int n = 0;
            for (int i = 0; i<self.dataSource.count ; i++) {
                if ([fCell.groupid integerValue] == [self.dataSource[i][@"groupid"] integerValue]) {
                    n++;
                }
            }
            if (n <= 1) {
                [UITools alertWithMsg:@"您不能删！！"];
                return NO;
            }
            
        }else{
            for (NSDictionary *dic in _selectItems) {
                if ([dic[@"id"] isEqual:fCell.typeId]) {
                    [_selectItems removeObject:dic];
                    NSMutableArray *arr = [[_serId componentsSeparatedByString:@","] mutableCopy];
                    [arr removeObject:[NSString stringWithFormat:@"%@",fCell.typeId]];
                    NSMutableString *mStr = [[NSMutableString alloc]init];
                    for (NSString *Id in arr) {
                        [mStr appendFormat:@",%@",Id];
                    }
                   _serId = [mStr substringWithRange:NSMakeRange(1, mStr.length-1)];
                    
                    break;
                }
            }
        }
        NSInteger n = [self.dataSource[indexPath.section-2][@"account"] integerValue];
        CGFloat price = [self.dataSource[indexPath.section-2][@"price"] floatValue];
        _totalPrice -= price*n;
        
        [self.dataSource removeObjectAtIndex:indexPath.section-2];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshPriceView];
        {  //解决刷新时保养cell UI问题
            if (_selectItems.count > 1) {
                if ([[_selectItems[0][@"name"] analysisConvertToString] length] <= [[_selectItems[1][@"name"] analysisConvertToString] length]) {
                    NSDictionary *dic = _selectItems[0];
                    [_selectItems replaceObjectAtIndex:0 withObject:_selectItems[1]];
                    [_selectItems replaceObjectAtIndex:1 withObject:dic];
                }
            }
            [self.tableView reloadData];
        }
        
    }else if (direction == MGSwipeDirectionRightToLeft && index == 0){
        
        CarPartListController *cvc = [[CarPartListController alloc]init];
        cvc.carid = _car.carId;
        cvc.volume = fCell.volume;
        cvc.merid = fCell.merid;
        cvc.groupid = fCell.groupid;
        
        NSInteger n = [self.dataSource[indexPath.section-2][@"account"] integerValue];
        CGFloat price = [self.dataSource[indexPath.section-2][@"price"] floatValue];

        cvc.commplete = ^(NSDictionary *dic){
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:dic];
            [md setObject:@(1) forKey:@"account"];
            [md setObject:fCell.serviceName forKey:@"serName"];
            [md setObject:fCell.typeId forKey:@"serid"];
            [md setObject:fCell.groupname forKey:@"groupname"];
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.dataSource replaceObjectAtIndex:indexPath.section-2 withObject:md];
            
            _totalPrice -= n*price;
            CGFloat p = [self.dataSource[indexPath.section-2][@"price"] floatValue];
            _totalPrice += p;

            [self.tableView reloadData];
            [self refreshPriceView];
        };
        [self.navigationController pushViewController:cvc animated:YES];
    }

    return YES;
}

- (void)gobackPage{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GuideViewController class]]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            return ;
        }
    }
    if (_cilckConfirm) {
        NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
        [u setObject:_ADCode forKey:KEY_CITY_ADCODE_IN_USERDEFAULT];
        [u setObject:_cityCode forKey:KEY_CITY_CODE_IN_USERDEFAULT];
        [u synchronize];
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
