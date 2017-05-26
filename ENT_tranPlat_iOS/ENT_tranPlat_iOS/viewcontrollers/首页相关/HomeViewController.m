//
//  HomeViewController.m
//  ENT_tranPlat_iOS
//
//  Created by yanyan on 14-7-14.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//

#import "HomeViewController.h"
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
UITableViewDelegate
>
{
    NSMutableDictionary             *_carNetStatusDict;
    
    UIImagePickerController         *_pickerVC;
    UIScrollView                    *_rootScrollView;
    UIView                          *_locationView;
    UIView                          *_msgView;
    
    
    UIView                          *_topFuncBgView;
    UIView                          *_netUnavailibleView;
    CarInfoScrollView               *_carInfoScrollView;
    UIView                          *_advertisementView;
    //BaiduMobSspBannerView           *_bannerView;
    UITableView                     *_mokuaiBgViewAfterCarView;
    int                             _height1;
}

@property(nonatomic,assign)     NSInteger               selectIndex;
@property(nonatomic,strong)     NSDictionary            *dataDic;
@property (nonatomic, retain)   NSString                *appUpdateUrlString;//appStore更新地址
@property (nonatomic, retain)   NSMutableArray          *cars;//当前用户所有车
@property (nonatomic, retain)   NSMutableDictionary     *carPeccancyRecordDict;//车辆违章记录字典
@property (nonatomic, retain)   NSMutableDictionary     *carZhaohuiDict;//车辆召回信息字典
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,assign)  NSInteger     number;





@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)addHuodongViewWithFrame:(CGRect)frame imageName:(NSString*)imgName imgHeight:(CGFloat)imgh title:(NSString*)title subTitle:(NSString*)subtitle space:(CGFloat)space onView:(UIView*)bgView selector:(SEL)selector{
    
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [bgView addSubview:v];
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:LGRectMake(30, (frame.size.height/PX_X_SCALE - imgh)/2, imgh, imgh)];
    [logoImgView setImage:[UIImage imageNamed:imgName]];
    [logoImgView setUserInteractionEnabled:YES];
    [v addSubview:logoImgView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:LGRectMake(logoImgView.r + 40, logoImgView.t + 5, v.w - logoImgView.r - 10, 30)];
    
    if ([title rangeOfString:@"自驾游"].location == NSNotFound){
        if (iPhone4) {
            [lable setFrame:LGRectMake(logoImgView.r + 40, logoImgView.t - 10, v.w - logoImgView.r - 10, 30)];
            
        }else{
            [lable setFrame:LGRectMake(logoImgView.r + 40, logoImgView.t - 5, v.w - logoImgView.r - 10, 30)];
            
        }
    }
    
    [lable convertNewLabelWithFont:FONT_NOMAL textColor:COLOR_NAV textAlignment:NSTextAlignmentLeft];
    [lable setText:title];
    [v addSubview:lable];
    
    lable = [[UILabel alloc] initWithFrame:LGRectMake(lable.l, lable.b + space, v.w - lable.l - 30, 24)];
    [lable convertNewLabelWithFont:FONT_NOTICE textColor:COLOR_FONT_NOTICE textAlignment:NSTextAlignmentCenter];
    if ([title rangeOfString:@"自驾游"].location != NSNotFound) {
        [lable setTextAlignment:NSTextAlignmentLeft];
    }
    [lable setText:subtitle];
    [lable setSize:[subtitle sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.width, 1000)]];
    lable.numberOfLines = 0;
    [v addSubview:lable];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [v addGestureRecognizer:tap];
}

-(void)loadView_
{
    
    _topFuncBgView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_VIEW_Y, APP_WIDTH, (APP_WIDTH*157/457))];
    [_topFuncBgView setBackgroundColor:COLOR_NAV];
    [self.view addSubview:_topFuncBgView];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:LGRectMake((_topFuncBgView.w/3 - 170)/2,(_topFuncBgView.h - 136)/2 + 20, 170, 136)];//170*136
    [imgView setImage:[UIImage imageNamed:@"home_bijia_logo.png"  ]];
    [_topFuncBgView addSubview:imgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:LGRectMake(0, 0, _topFuncBgView.w/2, _topFuncBgView.h)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(bijia) forControlEvents:UIControlEventTouchUpInside];
    [_topFuncBgView addSubview:btn];
    
    imgView = [[UIImageView alloc] initWithFrame:LGRectMake(_topFuncBgView.w/3 + (_topFuncBgView.w/3 - 170)/2,(_topFuncBgView.h - 136)/2 + 20, 170, 136)];//170*136
    [imgView setImage:[UIImage imageNamed:@"home_car.png"  ]];
    [_topFuncBgView addSubview:imgView];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:LGRectMake(_topFuncBgView.w/3, 0, _topFuncBgView.w/3, _topFuncBgView.h)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(oldcar) forControlEvents:UIControlEventTouchUpInside];
    [_topFuncBgView addSubview:btn];
    
    imgView = [[UIImageView alloc] initWithFrame:LGRectMake(_topFuncBgView.w/3*2 + (_topFuncBgView.w/3 - 170)/2,(_topFuncBgView.h - 136)/2 + 20, 170, 136)];//170*136
    [imgView setImage:[UIImage imageNamed:@"home_by.png"  ]];
    [_topFuncBgView addSubview:imgView];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:LGRectMake(_topFuncBgView.w/3*2, 0, _topFuncBgView.w/3*2, _topFuncBgView.h)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(baoyangClicked) forControlEvents:UIControlEventTouchUpInside];
    [_topFuncBgView addSubview:btn];
    
    
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topFuncBgView.bottom, APP_WIDTH, APP_HEIGHT - APP_TAB_HEIGHT - _topFuncBgView.height - APP_NAV_HEIGHT)];
    _rootScrollView.bounces = YES;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_rootScrollView];
    
    
    
    
    
    
    //netunavailible
    _netUnavailibleView = [[UIView alloc] initWithFrame:LGRectMake(0, 30, APP_PX_WIDTH, 80)];
    _netUnavailibleView.backgroundColor = [UIHelper getColor:@"#ffeda3"];
    [_rootScrollView addSubview:_netUnavailibleView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRetryNetwork)];
    [_netUnavailibleView addGestureRecognizer:tap];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:LGRectMake(20, 20, 40, 40)];
    [imgV setImage:[UIImage imageNamed:@"warn_logo.png"]];
    [_netUnavailibleView addSubview:imgV];
    UILabel *l = [[UILabel alloc] initWithFrame:LGRectMake(imgV.r + 20, 20, _netUnavailibleView.w, _netUnavailibleView.h - 40)];
    l.text = @"当前网络状态不佳，请检查您的网络";
    [l convertNewLabelWithFont:FONT_NOTICE textColor:COLOR_FONT_NOMAL textAlignment:NSTextAlignmentLeft];
    [_netUnavailibleView addSubview:l];
    [self loadNetUnavailableView:NO];
    
    //车辆信息
    CGFloat height = CAR_INFO_SCROLL_VIEW_HEIGHT;
    _carInfoScrollView = [[CarInfoScrollView alloc] initWithFrame:LGRectMake(0,30, APP_PX_WIDTH, height)];
    _carInfoScrollView.scroll_delegate = self;
    [_rootScrollView addSubview:_carInfoScrollView];
    
    
    _advertisementView = [[UIView alloc] initWithFrame:LGRectMake(0, _carInfoScrollView.t + CAR_INFO_SCROLL_VIEW_HEIGHT*PX_X_SCALE/PX_Y_SCALE + 20, APP_PX_WIDTH, 130)];
    [_advertisementView setBackgroundColor:[UIColor whiteColor]];
    [_rootScrollView addSubview:_advertisementView];
    [self showAdvertisementWithData:nil];
    
    
    
    //________________1
   
//    
//    _mokuaiBgViewAfterCarView = [[UITableView alloc] initWithFrame:BGRectMake(0, _advertisementView.b + 20, APP_PX_WIDTH,( self.datas.count*90+60))];
//    
//    _mokuaiBgViewAfterCarView.delegate = self;
//    _mokuaiBgViewAfterCarView.dataSource = self;
//    _mokuaiBgViewAfterCarView.showsVerticalScrollIndicator =NO;
//    _mokuaiBgViewAfterCarView.scrollEnabled=NO;
//    
//    UIImageView *firstView = [UIImageView backgroudTwoLineImageViewWithPXX:0 y: 0 width:APP_PX_WIDTH height:70];
//    firstView.backgroundColor=[UIColor whiteColor];
//    UILabel *titileLabel = [[UILabel alloc] initWithFrame:LGRectMake(20, 30, firstView.w, 30)];
//    titileLabel.font = SYS_FONT_SIZE(36)  ;
//    [titileLabel setText:@"邦推荐"];
//    titileLabel.textColor=COLOR_NAV;
//    [firstView addSubview:titileLabel];
//    
//    _mokuaiBgViewAfterCarView.tableHeaderView = firstView;
//    _mokuaiBgViewAfterCarView.backgroundColor = [UIColor whiteColor];
//
//    [_rootScrollView addSubview:_mokuaiBgViewAfterCarView];
//    
//    [_mokuaiBgViewAfterCarView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"Info"];
    if (_mokuaiBgViewAfterCarView.bottom > _rootScrollView.height) {
        [_rootScrollView setContentSize:CGSizeMake(APP_WIDTH, _mokuaiBgViewAfterCarView.bottom)];
    }

    
    
}
-(void)createBangTuiJian
{
    
    _mokuaiBgViewAfterCarView = [[UITableView alloc] initWithFrame:BGRectMake(0, _advertisementView.b + 20, APP_PX_WIDTH,( self.datas.count*90)/PX_Y_SCALE+70)];
    
    _mokuaiBgViewAfterCarView.delegate = self;
    _mokuaiBgViewAfterCarView.dataSource = self;
    _mokuaiBgViewAfterCarView.showsVerticalScrollIndicator =NO;
    _mokuaiBgViewAfterCarView.scrollEnabled=NO;
    
    UIImageView *firstView = [UIImageView backgroudTwoLineImageViewWithPXX:0 y: 0 width:APP_PX_WIDTH height:70];
    firstView.backgroundColor=[UIColor whiteColor];
    UILabel *titileLabel = [[UILabel alloc] initWithFrame:LGRectMake(20, 30, firstView.w, 30)];
    titileLabel.font = SYS_FONT_SIZE(36)  ;
    [titileLabel setText:@"邦推荐"];
    titileLabel.textColor=COLOR_NAV;
    [firstView addSubview:titileLabel];
    
    _mokuaiBgViewAfterCarView.tableHeaderView = firstView;
    _mokuaiBgViewAfterCarView.backgroundColor = [UIColor whiteColor];
    
    [_rootScrollView addSubview:_mokuaiBgViewAfterCarView];
    
    [_mokuaiBgViewAfterCarView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"Info"];

    if (_mokuaiBgViewAfterCarView.bottom > _rootScrollView.height) {
        [_rootScrollView setContentSize:CGSizeMake(APP_WIDTH, _mokuaiBgViewAfterCarView.bottom)];
    }

}

- (void)loadNavComponents{
    
    _locationView = [[UIView alloc] initWithFrame:CGRectMake(30*PX_X_SCALE, 0, (60 + 50)*PX_X_SCALE, _navigationImgView.height)];
    [_navigationImgView addSubview:_locationView];
    UITapGestureRecognizer *locaitonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSetCity:)];
    [_locationView addGestureRecognizer:locaitonTap];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_locationView.height - 40*PX_X_SCALE)/2, 40*PX_X_SCALE, 40*PX_X_SCALE)];
    [imgView setImage:[UIImage imageNamed:@"location_logo_white"]];
    [imgView setUserInteractionEnabled:YES];
    [_locationView addSubview:imgView];
    UILabel *cityL = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10*PX_X_SCALE, 0, 100*PX_X_SCALE, _locationView.height)];
    [cityL convertNewLabelWithFont:FONT_NOMAL textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    NSString *cityName  = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    if ([cityName isEqualToString:@""]) {
        cityL.text = @"...";
        [self tapSetCity:nil];
    }else{

              cityL.text = cityName;


    }
    //[cityL setSize:[cityL.text sizeWithFont:cityL.font constrainedToSize:CGSizeMake(1000, 30)]];
    [_locationView addSubview:cityL];
    
    
    _msgView = [[UIView alloc] initWithFrame:CGRectMake(APP_WIDTH - 30*PX_X_SCALE - _navigationImgView.height, 0, _navigationImgView.height, _navigationImgView.height)];
    _msgView.backgroundColor = [UIColor clearColor];
    [_navigationImgView addSubview:_msgView];
    
    UIImageView *msgLogoImgV = [[UIImageView alloc] initWithFrame:CGRectMake((_msgView.width - 33*PX_X_SCALE)/2, (_msgView.height - 33*PX_X_SCALE)/2, 33*PX_X_SCALE, 33*PX_X_SCALE)];
    [msgLogoImgV setUserInteractionEnabled:YES];
    [msgLogoImgV setImage:[UIImage imageNamed:@"scanning.png"]];
    [_msgView addSubview:msgLogoImgV];
    
    UIButton *msgB = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgB setFrame:_msgView.bounds];
    [msgB addTarget:self action:@selector(saomiao)forControlEvents:UIControlEventTouchUpInside];
    [_msgView addSubview:msgB];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // NSLog(@"%@",_datas.count);
    return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"Info";
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    
    SHModel *model = _datas[indexPath.row];
    //  NSLog(@"%@",_datas);
    
    cell.ycmodel=model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    InfoViewController *deta=[[InfoViewController alloc]init];
    
    BaoYangModel *model = _datas[indexPath.row];
    deta.model = model;
    [self.navigationController pushViewController:deta animated:YES];
    
    
    
}
- (void)rmNavComponents{
    [_locationView removeFromSuperview];
    _locationView = nil;
    [_msgView removeFromSuperview];
    _msgView = nil;
}

- (void)reloadNavComponents{
    if (_locationView && _msgView) {
        [self rmNavComponents];
    }
    [self loadNavComponents];
}

- (void)loadNetUnavailableView:(BOOL)load{
    _netUnavailibleView.hidden = !load;
    
    if (load) {
        [_carInfoScrollView setFrame:LGRectMake(_carInfoScrollView.l, _netUnavailibleView.b, _carInfoScrollView.w, _carInfoScrollView.h)];
    }else{
        [_carInfoScrollView setFrame:LGRectMake(_carInfoScrollView.l, 30, _carInfoScrollView.w, _carInfoScrollView.h)];
    }
    [_advertisementView setFrame:BGRectMake(0, _carInfoScrollView.t + CAR_INFO_SCROLL_VIEW_HEIGHT*PX_X_SCALE/PX_Y_SCALE + 20, _advertisementView.w, _advertisementView.h)];
    
   // [_mokuaiBgViewAfterCarView setFrame:BGRectMake(0, _advertisementView.b + 20, APP_PX_WIDTH, 500)];
    
//    if (_mokuaiBgViewAfterCarView.bottom > _rootScrollView.height) {
//        [_rootScrollView setContentSize:CGSizeMake(APP_WIDTH, _mokuaiBgViewAfterCarView.bottom)];
//    }else{
//        [_rootScrollView setContentSize:CGSizeMake(APP_WIDTH, APP_HEIGHT - APP_NAV_HEIGHT - APP_TAB_HEIGHT)];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(citySetChanged) name:NOTIFICATION_CITY_SET_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appUpdate:) name:NOTIFICATION_APP_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPushIds:) name:NOTIFICATION_PUSH_REGIST_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:NOTIFICATION_FETCH_MESSAGES_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAdPage) name:NOTIFICATION_PUSH_LAUNCH_AD_PAGE object:nil];
    
    //初始化界面
    _carNetStatusDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    //    [self download];
    [self loadView_];
    [self download];
    
    [self reloadAllFromNet];
}


-(void)download{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *cityName  = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    [bodyDict setObject:@"17" forKey:@"typeId"];
    [bodyDict setObject:cityName forKey:@"city"];
    [bodyDict setObject:@"1" forKey:@"recommend"];
    [BLMHttpTool postWithURL:@"http://buss.956122.com/getShopInfo.do?" params:bodyDict success:^(id json) {
        //        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~json:%@",json);
        int num = [[json objectForKey:@"code"]intValue];
        
        if (num==1) {
            _datas =[NSMutableArray array];
            NSArray *array=json[@"msg"];
            _number =array.count;
            //  NSLog(@"%@",array);
            for (NSDictionary *dic2 in array ) {
                
                SHModel *model= [SHModel  modelWithDic:dic2];
                
                [_datas addObject:model];
                
                
            }
            [self createBangTuiJian];
            [_mokuaiBgViewAfterCarView reloadData];
            
            
            
        }else{
            
            
        }
        
        
    } failure:^(NSError *error) {
      //  NSLog(@"%@",error);
      
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self setBackButtonHidden:YES];
    [self setCustomNavigationTitle:@"开车邦"];
    [self loadNavComponents];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *cityName  = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    if ([cityName isEqualToString:@""]) {
        [self tapSetCity:nil];
    }
    
    if (!_netUnavailibleView.hidden) {//上次未加载成功
        [self reloadAllFromNet];
    }else{//上次加载成功
        if ([Helper netAvailible]) {//当前网络可用，可用则load相关
            [self reloadCarsView];
            [self reloadPeccancyInfoView];
        }else{//当前网络不可用，加载不可用界面
            [self loadNetUnavailableView:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self rmNavComponents];
}

#pragma mark-   事件

- (void)pushAdPage{
    AdvertisementViewController *advertiseVC = [[AdvertisementViewController alloc] init];
    advertiseVC.url = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LAUNCH_IMAGE_AD_URL];
    [self.navigationController pushViewController:advertiseVC animated:YES];
}

- (void)bijia{
    
    if (!APP_DELEGATE.loginSuss) {
        [self goToLoginPage];
        return;
    }
    BaoxianSelectCarViewController *bxscVC = [[BaoxianSelectCarViewController alloc] init];
    [self.navigationController pushViewController:bxscVC animated:YES];
    
}
-(void)oldcar{
    if (!APP_DELEGATE.loginSuss) {
        [self goToLoginPage];
        return;
    }
//    CommonWebViewController *cwVC = [[CommonWebViewController alloc] init];
//    cwVC.url = [NSURL URLWithString:@"http://buss.956122.com/eval/index.html"];
//    cwVC.web_title = @"二手车估值";
    UserCarViewController *cwVC = [[UserCarViewController alloc] init];

  
    [self.navigationController pushViewController:cwVC animated:YES];
    
}

- (void)zijiayouClicked{
    
    //    [self.view showAlertText:@"该地区尚无服务商，请后续关注"];
    ZijiayouViewController *zjyVC = [[ ZijiayouViewController alloc] init];
    [self.navigationController pushViewController:zjyVC animated:YES];
    
}



- (void)meirongClicked{
    [self.view showAlertText:@"该地区尚无商户入驻，请后续关注"];
}

- (void)xicheClicked{
    [self.view showAlertText:@"该地区尚无商户入驻，请后续关注"];
    
}
- (void)luntaiClicked{
    [self.view showAlertText:@"该地区尚无商户入驻，请后续关注"];
    
}


- (void)gaizhuangClicked{
    [self.view showAlertText:@"该地区尚无商户入驻，请后续关注"];
    
}

- (void)kuaixiuClicked{
    [self.view showAlertText:@"该地区尚无商户入驻，请后续关注"];
    
}
- (void)baoyangClicked{
    //    [self.view showAlertText:@"该地区尚无商户入驻，请后续关注"];
    BaoyangSelectCarViewController *baoyangVC = [[BaoyangSelectCarViewController alloc] init];
    [self.navigationController pushViewController:baoyangVC animated:YES];
}



- (void)citySetChanged{
    //获取天气情况
    //[self getWeatherCondition];
    //[self getXianxingMsg];
    
    //上传城市与车辆品牌信息-用于车友圈好友推荐
    [NETHelper chatModifyCityAndCars];
}

- (void)loadMsgsFromServer{
    [NETHelper fetchNotifycations];
}

- (void)reloadCarsView{//从DB直接load数据。（数据一定在其他位置改动了DB，故不需重新从网络请求）
    //车信息
    NSArray *array = [[DataBase sharedDataBase] selectCarByUserId:APP_DELEGATE.userId];
    self.cars = [[NSMutableArray alloc] initWithArray:array];
    
    //刷新显示车
    [_carInfoScrollView reloadCars:self.cars];
}

- (void)reloadPeccancyInfoView{//从DB直接load数据。（数据一定在其他位置改动了DB，故不需重新从网络请求）。网络请求的判断基于：超时自动加载与无数据加载
    
    //违章信息
    self.carPeccancyRecordDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (CarInfo *car in self.cars) {
        //获取车辆违章记录
        NSArray *carPeccancyRecors = [[DataBase sharedDataBase] selectCarPeccancyRecordByUserId:APP_DELEGATE.userId andHphm:car.hphm];
        if ([carPeccancyRecors count]) {
            CarPeccancyRecord *record = [carPeccancyRecors lastObject];
            [self.carPeccancyRecordDict setObject:record forKey:car.hphm];
        }
    }
    
    //刷新显示违章记录
    //--刷新显示车辆违章记录
    for (CarInfo *car in self.cars) {
        CarPeccancyRecord *record = [self.carPeccancyRecordDict objectForKey:car.hphm];
        BOOL needLoad_net = NO;
        if (record) {//超时加载
            CGFloat timeinterval = [[NSDate date] timeIntervalSinceDate:[record.jdcwf_gxsj date]];
            if (timeinterval > 10*60.0f) {
                needLoad_net = YES;
            }
        }else{//无数据加载
            needLoad_net = YES;
        }
        //以上判断数据需要网络加载，以下判断是否已经加载失败
        NSString *carNetStatus = [_carNetStatusDict objectForKey:car.hphm];
        if (needLoad_net) {
            if ([carNetStatus isEqualToString:PECCANCY_NET_STATUS_FAILED]) {
                needLoad_net = NO;
            }
        }
        
        if (needLoad_net) {
            //车辆绑定成功 可查询违法记录
            if (car && ([car.vehiclestatus rangeOfString:@"成功"].location != NSNotFound)) {
                [self netGetPeccancyRecord:car];
            }
        }else{
            [_carInfoScrollView reloadPeccancy:car.hphm];
        }
    }
}

- (void)tapRetryNetwork{
    TestNetworkViewController *tnvc = [[TestNetworkViewController alloc] init];
    [self.navigationController pushViewController:tnvc animated:YES];
}


- (void)reloadAllFromNet{
    if ([Helper netAvailible]) {
        [self loadNetUnavailableView:NO];
        //网络请求->登陆
        if (self.doLoginNetWork) {
            [self login];
        }else{
            [self loadMsgsFromServer];
        }
        //获取广告内容
        [self getAdvertisement];
        //获取天气情况
        //[self getWeatherCondition];
        //获取限行信息
        //[self getXianxingMsg];
        //获取召回信息
        NSArray *array = [[DataBase sharedDataBase] selectCarByUserId:APP_DELEGATE.userId];
        for (CarInfo *car in array) {
            [self netGetZhaohuiMsgWithVin:car.clsbdh];
        }
        //检测更新
        [NETHelper checkAppUpdate];
        //发送百度推送id、channel
        [self sendPushIds:nil];
        //上传城市与车辆品牌信息-用于车友圈好友推荐
        [NETHelper chatModifyCityAndCars];
        //下载launch页的广告图
        //[self asynchronousDownloadLanchImage];
        
        //         [self download];
        
        [self reloadCarsView];
        [self reloadPeccancyInfoView];
        
    }else{
        [self loadNetUnavailableView:YES];
    }
}

#pragma mark- 扫描

- (void)pickerGoBack{
    [self dismissModalViewControllerAnimated:YES];
}




- (void)saomiao{
    
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
    
    
    
}

#define SAOMIAO_VIEW_HEIGHT         100
- (void)ssssssaomiao{
    
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.showsCameraControls = NO;
        _pickerVC.cameraViewTransform = CGAffineTransformScale(_pickerVC.cameraViewTransform, 1.7, 1.7);
        
        
        UIImageView *coverContentImageView = [[UIImageView alloc] initWithFrame:LGRectMake(0, (_pickerVC.cameraOverlayView.h - SAOMIAO_VIEW_HEIGHT)/2, _pickerVC.cameraOverlayView.w, SAOMIAO_VIEW_HEIGHT)];
        coverContentImageView.backgroundColor = [UIColor redColor];
        coverContentImageView.alpha = 0.5;
        [_pickerVC.cameraOverlayView addSubview:coverContentImageView];
        
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setFrame:CGRectMake(8, 8, 30, 30)];
        [backButton setTitle:@"取消" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pickerGoBack) forControlEvents:UIControlEventTouchUpInside];
        [_pickerVC.cameraOverlayView addSubview:backButton];
        
        UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePhotoButton setFrame:BGRectMake((_pickerVC.cameraOverlayView.w - 80)/2, _pickerVC.cameraOverlayView.h - 80, 80, 80)];
        [takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
        [takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [takePhotoButton setBackgroundColor:[UIColor yellowColor]];
        [takePhotoButton addTarget:_pickerVC action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [_pickerVC.cameraOverlayView addSubview:takePhotoButton];
        
        [self presentViewController:_pickerVC animated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    CGFloat bili = originalImage.size.height/picker.cameraOverlayView.height;
    CGFloat width = originalImage.size.width;
    CGFloat height = SAOMIAO_VIEW_HEIGHT*bili;
    CGFloat y = (originalImage.size.height - height)/2;
    
    
    
    
    UIImage *smallImage = [self getImageFromImage:originalImage subImageRect:CGRectMake(0, y, width, height)];
    
    UIImageWriteToSavedPhotosAlbum(smallImage, nil, nil, nil);
    
    
    
    [self netOCRImageWithimage:smallImage];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



//图片裁剪
-(UIImage *)getImageFromImage:(UIImage*)superImage subImageRect:(CGRect)subImageRect {
    
    superImage = [self fixOrientation:superImage];
    CGImageRef subImageRef = CGImageCreateWithImageInRect(superImage.CGImage, subImageRect);
    UIGraphicsBeginImageContext(subImageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextRotateCTM(context,M_PI/2);
    CGContextDrawImage(context, CGRectMake(0, 0, 10, 10), subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef] ;//]scale:1 orientation:UIImageOrientationRight];
    
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return returnImage;
}





- (void)netOCRImageWithimage:(UIImage*)image{
    
    //image = [UIImage imageNamed:@"tongshoujixiangce.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *imgStr = [imageData base64Encoding];
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyDict setObject:@"iPhone" forKey:@"fromdevice"];
    [bodyDict setObject:@"10.10.10.0" forKey:@"clientip"];//默认值10.10.10.0
    [bodyDict setObject:@"Recognize" forKey:@"detecttype"];
    [bodyDict setObject:@"CHN_ENG" forKey:@"languagetype"];
    [bodyDict setObject:@"1" forKey:@"imagetype"];//2是原图，1是base64图
    [bodyDict setObject:imgStr forKey:@"image"];
    
    MKNetworkEngine *en = [[MKNetworkEngine alloc] initWithHostName:@"apis.baidu.com" apiPath:@"apistore/idlocr/ocr" customHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:@"b428ff0698d4974665f0d6de693f9b40", @"apikey",  nil]];//@"application/x-www-form-urlencoded", @"Content-Type",
    MKNetworkOperation *op = [en operationWithPath:@"" params:bodyDict httpMethod:@"POST"];
    ENTLog(@"OCR解析：%@", op.url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *responseStr = completedOperation.responseString;
        if (responseStr) {
            responseStr = [responseStr stringReplaceFromUnicode];
            responseStr = [responseStr stringDecode];
            ENTLog(@"OCR解析：%@", responseStr);
        }
        [UIAlertView alertTitle:@"" msg:responseStr];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ENTLog(@"OCR解析：%@", error);
    }];
    [en enqueueOperation:op];
    
}

#pragma mark- Baidu iad Delegate
- (NSString *)baiduMobSspApplicationKey{
    return  @"2007798";//
}

- (UIViewController *)viewController
{
    return self.tabBarController;
}

#pragma mark Ad Request Lifecycle Notifications
- (void)baiduMobSspDidReceiveAd:(BaiduMobSspBannerView *)baiduMobSspBannerView{
    
}

- (void)baiduMobSspDidFailToReceiveAd:(BaiduMobSspBannerView *)baiduMobSspBannerView{
    
}

- (void)baiduMobSspPresent:(BaiduMobSspBannerView *)baiduMobSspBannerView{
    [_advertisementView setFrame:BGRectMake(0, _carInfoScrollView.t + CAR_INFO_SCROLL_VIEW_HEIGHT*PX_X_SCALE/PX_Y_SCALE + 20, APP_PX_WIDTH, 130*2/3)];
    [_mokuaiBgViewAfterCarView setFrame:BGRectMake(0, _advertisementView.b + 20, APP_PX_WIDTH, 280)];
    
    if (_mokuaiBgViewAfterCarView.bottom > _rootScrollView.height) {
        [_rootScrollView setContentSize:CGSizeMake(APP_WIDTH, _mokuaiBgViewAfterCarView.bottom)];
    }else{
        [_rootScrollView setContentSize:CGSizeMake(APP_WIDTH, APP_HEIGHT - APP_NAV_HEIGHT - APP_TAB_HEIGHT)];
    }
}

#pragma mark collect infomation
-(NSArray*) keywords{
    NSArray* keywords = [NSArray arrayWithObjects:@"测试ent",@"关键词", nil];
    return keywords;
}

-(NSString*) userCity{
    return @"测试城市ent";
}





#pragma mark- CarInfoScrollView Delegate
- (void)carInfoScrollViewDidTapForAdd{
    if (!APP_DELEGATE.loginSuss) {
        [self goToLoginPage];
        return;
    }
    CarBindViewController *carbindVC = [[CarBindViewController alloc] init];
    [self.navigationController pushViewController:carbindVC animated:YES];
}

- (void)carInfoScrollView:(CarInfoScrollView *)scrollView car:(NSString *)hphm didRespondAction:(Action)action{
    
    if (!APP_DELEGATE.loginSuss) {
        [self goToLoginPage];
        return;
    }
    if (action == actionEnterPeccancyRecord) {
        CarInfo *car = [[[DataBase sharedDataBase] selectCarByUserId:APP_DELEGATE.userId andHphm:hphm] lastObject];
        //绑定成功-才能查看
        if (car && ([car.vehiclestatus rangeOfString:@"成功"].location != NSNotFound)) {
            CarPeccancyRecord *peccancyRecord = [[[DataBase sharedDataBase] selectCarPeccancyRecordByUserId:APP_DELEGATE.userId andHphm:hphm] lastObject];
            NSArray *pmsArr = [Helper carPeccancyMsgAnalysis:peccancyRecord.jdcwf_detail withHphm:car.hphm];
            if (pmsArr.count != 0) {//有为法记录才能查看
                PeccancyRecordViewController *prvc = [[PeccancyRecordViewController alloc] initWithHphm:hphm];
                [self.navigationController pushViewController:prvc animated:YES];
            }
            
        }
        
    }else if (action == actionEnterCarInfo) {
        //查看车辆信息
        CarInfoViewController *vc = [[CarInfoViewController alloc] initWithHphm:hphm];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (action == actionLogoChange) {
        
    }else if (action == actionEnterZhaohui) {
        ZhaohuiViewController *zvc = [[ZhaohuiViewController alloc] init];
        zvc.hphm = hphm;
        [self.navigationController pushViewController:zvc animated:YES];
    }
}


#pragma mark- 广告
/************************************广告**********************************************/
- (void)advertisementImageView:(AdvertisementImageView *)aImageView didTapedWithImgsrc:(NSString *)imgsrc andHref:(NSString *)href{
    //    if (!APP_DELEGATE.loginSuss) {
    //        [self goToLoginPage];
    //        return;
    //    }
    AdvertisementViewController *advertiseVC = [[AdvertisementViewController alloc] init];
    advertiseVC.url = href;
    [self.navigationController pushViewController:advertiseVC animated:YES];
}

- (void)showAdvertisementWithData:(NSMutableDictionary*)dict{
    
    for (UIView *v in _advertisementView.subviews) {
        [v removeFromSuperview];
    }
    
    AdvertisementScrollView *asV = [[AdvertisementScrollView alloc] initWithFrame:_advertisementView.bounds dataDict:dict andDelegate:self];
    [_advertisementView addSubview:asV];
}

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
        NSMutableDictionary *advertiseHrefWithImgsrcDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (NSDictionary *dict in responseArr) {
            NSString *href = [dict analysisStrValueByKey:@"href"];
            NSString *img = [dict analysisStrValueByKey:@"img"];
            [advertiseHrefWithImgsrcDict setObject:href forKey:img];
        }
        [self showAdvertisementWithData:advertiseHrefWithImgsrcDict];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self performSelector:@selector(getAdvertisement) withObject:nil afterDelay:1*10.0f];
        
    }];
    [en enqueueOperation:op];
}
#if use_xian_xing_tianqi
#pragma mark- 限行
/***********************************限行**********************************************/
- (void)getXianxingMsg{
    //{"StartDate":"","EndDate":"","SpecialDate":{"2015/04/16":"1,2","2015/04/23":"0,1"},"Monday":false,"Tuesday":"3,3","Wednesday":false,"Thursday":"4,5","Friday":false,"Saturday":"6,7","Sunday":false}
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    if ([cityName isEqualToString:@""]) {
        [self performSelector:@selector(getXianxingMsg) withObject:nil afterDelay:1*10.0f];
        return;
    }
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"cms.956122.com"];
    MKNetworkOperation *op = [engine operationWithPath:@"jgrules/j_getJgrulesByCity.action" params:[NSDictionary dictionaryWithObjectsAndKeys:cityName, @"city", nil] httpMethod:@"POST"];
    ENTLog(@"%@", op.url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        ENTLog(@"%@", completedOperation.responseString);
        NSDictionary *resDict = [parser objectWithString:completedOperation.responseString];
        Xianxing *xianxing = nil;
        if (!resDict) {//无维护数据，认为不限行
            xianxing = [[Xianxing alloc] initWithStartDate:@"2011/04/14" endDate:@"2112/04/14" specialDate:@"{}" monday:@"false" tuesday:@"false" wednesday:@"false" thursday:@"false" friday:@"false" saturday:@"false" sunday:@"false"];
        }else{
            NSString *start = [resDict analysisStrValueByKey:@"StartDate"];
            NSString *end = [resDict analysisStrValueByKey:@"EndDate"];
            NSString *special = [NSString stringWithFormat:@"%@", [resDict objectForKey:@"SpecialDate"]];
            NSString *mon = [resDict analysisStrValueByKey:@"Monday"];
            NSString *tues = [resDict analysisStrValueByKey:@"Tuesday"];
            NSString *wed = [resDict analysisStrValueByKey:@"Wednesday"];
            NSString *thur = [resDict analysisStrValueByKey:@"Thursday"];
            NSString *fri = [resDict analysisStrValueByKey:@"Friday"];
            NSString *sat = [resDict analysisStrValueByKey:@"Saturday"];
            NSString *sun = [resDict analysisStrValueByKey:@"Sunday"];
            xianxing = [[Xianxing alloc] initWithStartDate:start endDate:end specialDate:special monday:mon tuesday:tues wednesday:wed thursday:thur friday:fri saturday:sat sunday:sun];
        }
        //写数据库
        [xianxing addToDB];
        //刷新页面
        [_weatherView reloadXianxing];
        [_carInfoScrollView reloadOther:nil];//重新加载所有车辆的限行标志
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ENTLog(@"%@", @"限行信息加载失败");
        [self performSelector:@selector(getXianxingMsg) withObject:nil afterDelay:1*10.0f];
        
    }];
    [engine enqueueOperation:op];
    
}

#pragma mark- 天气
/***********************************天气**********************************************/
- (void)getWeatherCondition{
    NSString *cityName  = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULT];
    if ([cityName isEqualToString:@""]) {
        [self performSelector:@selector(getWeatherCondition) withObject:nil afterDelay:1*10.0f];
        return;
    }
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"cms.956122.com"];
    MKNetworkOperation *op = [engine operationWithPath:@"weather/weather.action" params:[NSDictionary dictionaryWithObjectsAndKeys:cityName, @"cityName", nil] httpMethod:@"POST"];
    ENTLog(@"%@", op.url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *resDict = [parser objectWithString:completedOperation.responseString];
        if (!resDict) {
            ENTLog(@"%@", @"天气情况加载失败");
            [self performSelector:@selector(getWeatherCondition) withObject:nil afterDelay:1*10.0f];
            return ;
        }
        NSArray *results = [resDict objectForKey:@"results"];
        NSDictionary *firstDict = [results objectAtIndex:0];
        NSArray *msgarr = [firstDict objectForKey:@"index"];
        NSDictionary *xicheDict = [msgarr objectAtIndex:1];
        NSString *xiche = [xicheDict objectForKey:@"zs"];
        
        NSArray *weatherArr= [firstDict objectForKey:@"weather_data"];
        NSDictionary *weatherDict = [weatherArr objectAtIndex:0];
        NSString *weather = [weatherDict objectForKey:@"weather"];
        NSString *temp = [weatherDict objectForKey:@"temperature"];
        NSString *picUrl = [weatherDict objectForKey:@"dayPictureUrl"];
        Weather *wea = [[Weather alloc] initWithTemp:temp des:weather detail:@"" logoUrl:picUrl xiche:xiche updateTime:[[NSDate date] string] other:@""];
        //写数据库
        [wea updateToDB];
        //刷新界面
        [_weatherView reloadWeather];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ENTLog(@"%@", @"天气情况加载失败");
        [self performSelector:@selector(getWeatherCondition) withObject:nil afterDelay:1*10.0f];
    }];
    [engine enqueueOperation:op];
}
#endif

#pragma mark- 召回
/***********************************召回**********************************************/


- (void)netGetZhaohuiMsgWithVin:(NSString*)vin{
    MKNetworkEngine *en = [[MKNetworkEngine alloc] initWithHostName:NET_ADDR_CMS_956122];
    MKNetworkOperation *op = [en operationWithPath:@"recall/r_findbyvn.action" params:[NSDictionary dictionaryWithObjectsAndKeys:vin, @"vin", nil] httpMethod:@"POST"];
    ENTLog(@"%@", op.url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *reqStr = completedOperation.responseString;
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *responseArr = [parser objectWithString:reqStr];
        if ([responseArr count]) {
            NSDictionary *dict = [responseArr lastObject];
            ZhaohuiMsg *zhaohui = nil;
            if (!dict) {
                //返回-1，无召回信息
                zhaohui = [[ZhaohuiMsg alloc] initWithBrand:@""cartype:@"" dealway:@"" id_fanhui:@"" method:@"" period:@"" reason:@"无召回信息" result:@"" clsbdh:vin];
            }else{
                
                NSString *brand = [dict analysisStrValueByKey:@"brand"];
                NSString *cartype = [dict analysisStrValueByKey:@"cartype"];
                NSString *dealway = [dict analysisStrValueByKey:@"dealway"];
                NSString *id__ = [dict analysisStrValueByKey:@"id"];
                NSString *method = [dict analysisStrValueByKey:@"method"];
                NSString *period = [dict analysisStrValueByKey:@"period"];
                NSString *reason = [dict analysisStrValueByKey:@"reason"];
                NSString *result = [dict analysisStrValueByKey:@"result"];
                
                zhaohui = [[ZhaohuiMsg alloc] initWithBrand:brand cartype:cartype dealway:dealway id_fanhui:id__ method:method period:period reason:reason result:result clsbdh:vin];
            }
            //写数据库
            [zhaohui updateToDB];
            //刷新界面
            [_carInfoScrollView reloadOther:nil];
            
        }else{
            ZhaohuiMsg *zhaohui = [[ZhaohuiMsg alloc] initWithBrand:@""cartype:@"" dealway:@"" id_fanhui:@"" method:@"" period:@"" reason:@"无召回信息" result:@"" clsbdh:vin];
            //写数据库
            [zhaohui updateToDB];
            //刷新界面
            [_carInfoScrollView reloadOther:nil];
        }
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ZhaohuiMsg *zhaohui = [[ZhaohuiMsg alloc] initWithBrand:@""cartype:@"" dealway:@"" id_fanhui:@"" method:@"" period:@"" reason:@"召回信息加载失败" result:@"" clsbdh:vin];
        //写数据库
        [zhaohui updateToDB];
        //刷新界面
        [_carInfoScrollView reloadOther:nil];
        
    }];
    [en enqueueOperation:op];
    
}

#pragma mark- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == TAG_ALERT_APP_NEW_VERSION_YES) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appUpdateUrlString]];//@"h ttps://itunes.apple.com/cn/app/wan-zhuan-quan-cheng/id692579125?mt=8"
        }
    }
}

#pragma mark- notifications!!
- (void)appUpdate:(NSNotification*)notify{
    
    if ([self.navigationController.visibleViewController isKindOfClass:[UITabBarController class]]) {
        if (notify.userInfo) {//获取版本信息-网络请求成功
            
            self.appUpdateUrlString = [notify.userInfo objectForKey:@"url"];
            NSString *version = [notify.userInfo objectForKey:@"version"];
            if (![self.appUpdateUrlString isEqualToString:@""] && ![version isEqualToString:@""]) {//需要更新
                
                if([version length] == 3 ){
                    version = [NSString stringWithFormat:@"%@.%@.%@", [version substringToIndex:1],[version substringWithRange:NSMakeRange(1, 1)],[version substringFromIndex:2]];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[NSString stringWithFormat:@"已发布新版本%@，是否更新？", version] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alert.tag = TAG_ALERT_APP_NEW_VERSION_YES;
                [alert show];
            }
        }
        
    }
}

- (void)didReceiveNewMessage:(NSNotification*)notify{
    NSString *resMark = [notify.userInfo objectForKey:@"responseMark"];
    if ([resMark isEqualToString:NOTIFICATION_FETCH_MESSAGES_FINISHED]) {
        [self reloadNavComponents];
    }
    
}

#pragma mark- button clicks!!!
- (void)tapSetCity:(UITapGestureRecognizer*)tap{
    CitySetViewController *setCityVC = [[CitySetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setCityVC];
    if (iOS7) {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, APP_WIDTH, 20)];
        statusBarView.backgroundColor = COLOR_NAV;
        [nav.navigationBar addSubview:statusBarView];
    }
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}




#pragma mark- 网络请求
- (void)login{
    
    //获取到当前活跃用户
    UserInfo *activeUser = [[[DataBase sharedDataBase] selectActiveUser] lastObject];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:@"alogin" forKey:@"action"];
    [dict setObject:activeUser.userName forKey:@"username"];
    [dict setObject:activeUser.password forKey:@"password"];
    
    [[Network sharedNetwork] postBody:dict isResponseJson:YES doShowIndicator:NO callBackWithObj:nil onCompletion:^(PostResult result, id requestObj, NSObject *callBackObj) {
        NSDictionary *resDict = (NSDictionary*)requestObj;
        if (result == postSucc) {
            NSString *conResult = [resDict objectForKey:@"result"];
            if ([conResult isEqualToString:@"success"]) {
                //登录成功
                APP_DELEGATE.loginSuss = YES;
                UserInfo *userFromDB = [[[DataBase sharedDataBase] selectActiveUser] lastObject];
                APP_DELEGATE.userName =userFromDB.userName;
                APP_DELEGATE.userId = userFromDB.userId;
                
                //更新user数据库
                UserInfo *user = [Helper loginAnalysisUser:resDict withUserId:activeUser.userId userName:activeUser.userName andPassword:activeUser.password];
                [user update];
                
                //删除当前用户下所有driver,数据库添加服务器返回的driver
                NSArray *drivers = [Helper loginAnalysisDriver:resDict withUserId:activeUser.userId];
                [drivers updateDriversAfterLogin];
                
                //删除当前用户下所有car,数据库添加服务器返回的car
                NSArray *cars = [Helper loginAnalysisCarInfo:resDict withUserId:activeUser.userId];
                [cars updateCarsAfterLogin];
                
                //刷新
                [self reloadCarsView];
                
                [self.view showAlertText:@"网络登录成功"];
                
                [NETHelper asynchronousDownloadPhotoImage];
                
                
                
                
                [self loadMsgsFromServer];
                
            }else if ([conResult isEqualToString:@"fail"]){
                
                //************        改                 ************************************/
                [self.view showAlertText:@"网络登录失败，当前为无网络登录状态"];
                
                NSString *reason1 = [resDict objectForKey:@"reason"];
                ENTLog(@"登录失败：%@",reason1);
            }
            
        }else{
            [self.view showAlertText:@"网络登录失败，当前为无网络登录状态"];
            
            ENTLog(@"登录失败：%@",(NSString*)requestObj);
        }
        
    } onError:^(NSString *errorStr) {
        [self loadNetUnavailableView:YES];
        [self.view showAlertText:errorStr];
        
    }];
    
}

- (void)netGetPeccancyRecord:(CarInfo*)car{
    
    [_carNetStatusDict removeObjectForKey:car.hphm];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:@"list" forKey:@"action"];
    [dict setObject:car.hpzl forKey:@"hpzl"];
    [dict setObject:car.hphm forKey:@"hphm"];
    
    [[Network sharedNetwork] postBody:dict isResponseJson:YES doShowIndicator:NO  callBackWithObj:car onCompletion:^(PostResult result, id requestObj, NSObject *callBackObj) {
        if (result == postSucc) {
            
            SBJsonWriter *writer = [[SBJsonWriter alloc] init];
            NSString *jsonStr = [writer stringWithObject:requestObj];
            CarPeccancyRecord *carpr = [[CarPeccancyRecord alloc] initWithHpzl:((CarInfo*)callBackObj).hpzl hphm:((CarInfo*)callBackObj).hphm jdcwf_detail:jsonStr jdcwf_gxsj:[[NSDate date]string] andUserId:APP_DELEGATE.userId];
            //ok写入数据库
            [carpr update];
            
            [_carNetStatusDict setObject:PECCANCY_NET_STATUS_SUCC forKey:car.hphm];
        }else{
            [_carNetStatusDict setObject:PECCANCY_NET_STATUS_FAILED forKey:car.hphm];
            
            [self.view showAlertText:[NSString stringWithFormat:@"车辆违章信息查询失败,%@", requestObj]];
        }
        //更新界面显示
        [self reloadPeccancyInfoView];
    } onError:^(NSString *errorStr) {
        [self.view showAlertText:errorStr];
        
        //[_carNetStatusDict setObject:PECCANCY_NET_STATUS_FAILED forKey:car.hphm];
        //更新界面显示
        //[self reloadPeccancyInfoView];
        [self loadNetUnavailableView:YES];
    }];
}

- (void)sendPushIds:(NSNotification*)notify{
    if (!APP_DELEGATE.loginSuss) {
        return;
    }
    NSString *bpush_userid = nil;
    NSString *bpush_channelid = nil;
    if (notify == nil) {//主动调用
        if (!APP_DELEGATE.bpushUserId || !APP_DELEGATE.bpushChannelId) {
            return;
        }else{
            bpush_userid = APP_DELEGATE.bpushUserId;
            bpush_channelid = APP_DELEGATE.bpushChannelId;
        }
    }else{
        bpush_userid = [notify.userInfo objectForKey:KEY_BPUSH_USER_ID];
        bpush_channelid = [notify.userInfo objectForKey:KEY_BPUSH_CHANNEL_ID];
    }
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyDict setObject:@"updatebdinf" forKey:@"action"];
    [bodyDict setObject:APP_DELEGATE.userName forKey:@"username"];
    [bodyDict setObject:bpush_userid forKey:@"bduserid"];
    [bodyDict setObject:bpush_channelid forKey:@"bdchannelid"];
    [[Network sharedNetwork] postBody:bodyDict isResponseJson:NO doShowIndicator:NO callBackWithObj:nil onCompletion:^(PostResult result, id requestObj, NSObject *callBackObj) {
        //不处理返回结果
    } onError:^(NSString *errorStr) {
        [self performSelector:@selector(sendPushIds:) withObject:nil afterDelay:1*10.0f];
        
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
