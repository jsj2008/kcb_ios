//
//  MyStoreController.m
//  Merchant
//
//  Created by Wendy on 16/1/18.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import "MyStoreController.h"
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
#import "CWStarRateView.h"
#import "MEMarchantInfo.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "ChangeStoreController.h"
#import "GTMBase64.h"
#import "EditPhotoViewController.h"

#define kStarRateWidth 80

#define kStarRateHeight 40

#define kHeaderViewHeight 200

@interface MyStoreController ()<HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,EditPhotoViewControllerDelegate>

@property (nonatomic, strong) HTHorizontalSelectionList *segment;
@property (nonatomic, strong) UIImageView *storeImgView;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (strong, nonatomic) UILabel *gradeLab;
@property (strong, nonatomic) UILabel *hplLabel;


@property (nonatomic,strong) MEMarchantInfo *merchantInfo;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation MyStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的门店"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, self.view.width, self.view.height - 20- APP_NAV_HEIGHT+64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor =  kColorBackgroud;
    [self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
    [self buildHeaderView];
    [self buildData];
    [self requestMerchantInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMerchantInfo{
    NSInteger merid = ApplicationDelegate.shareLoginData.userdata.mid;
    NSDictionary *param = @{@"merid":[NSNumber numberWithInteger:merid].stringValue};
    [AFNHttpRequest afnHttpRequestUrl:kHttpMerchantInfo param:param success:^(id responseObject){
        if (kRspCode(responseObject) == 0) {
            NSDictionary *body = responseObject[@"body"];
            _merchantInfo = [MEMarchantInfo mj_objectWithKeyValues:body];
            ApplicationDelegate.shareLoginData.userdata.mername = _merchantInfo.info.name;
            ApplicationDelegate.shareLoginData.userdata.logo = _merchantInfo.info.logo_pic;
            
            ApplicationDelegate.shareLoginData.userdata.jwd = _merchantInfo.info.jwd;//便于存取
            
            [Utils saveToArchiverWithObject:ApplicationDelegate.shareLoginData toDocumentWithFileName:kLoginUserData];
            [self buildData];
            [self.tableView reloadData];
        }else{
            [UIHelper alertWithMsg:kRspMsg(responseObject)];
        }
        
    } failure:^(NSError *error) {
        [UIHelper alertWithMsg:kNetworkErrorDesp];
    } view:self.view];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)buildData{
    //图片
    NSString *url = _merchantInfo.info.logo_pic;
    NSLog(@"当前的图片地址:%@",url);
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"shopDefault"] options:SDWebImageRefreshCached];
    
    self.starRateView.scorePercent = _merchantInfo.info.level.floatValue/5;//按百分比
    _gradeLab.text = [NSString stringWithFormat:@"%.1f分",_merchantInfo.info.level.floatValue];
    _hplLabel.text = [NSString stringWithFormat:@"好评率:%@％   共%@个评价",BLANKSPACE(_merchantInfo.info.hpl),BLANKSPACE(_merchantInfo.orderSize)];

    
    NSString *workTime = [NSString stringWithFormat:@"%@~%@",BLANK(_merchantInfo.info.open_time),BLANK(_merchantInfo.info.close_time)];
    if (_merchantInfo.info.open_time == nil) {
        workTime = @"";
    }
    NSString *payType = _merchantInfo.info.account_type;
    self.array = @[@{@"门店名称": BLANK(_merchantInfo.info.name)},
                   @{@"门店地址":BLANK(_merchantInfo.info.address)},
                   @{@"联系人":BLANK(_merchantInfo.info.contacts)},
                   @{@"联系电话":BLANK(_merchantInfo.info.telno)},
                   @{@"手机号码":BLANK(_merchantInfo.info.phone_no)},
                   @{@"支付账号类型":[self getPayNameByType:payType]},
                   @{@"支付账号":BLANK(_merchantInfo.info.pay_account)},
                   @{@"营业时间":workTime},
                   @{@"所属省市":BLANK(_merchantInfo.info.cname)},
                   @{@"服务描述":BLANK(_merchantInfo.info.describe_m)}
                   ];
}
- (NSString *)getPayNameByType:(NSString *)type{
    NSString *ret = @"";
    for (Paytype *item in ApplicationDelegate.shareLoginData.userdata.paytype) {
        if ([type isEqualToString:item.status]) {
            ret = item.value;
            break;
        }
    }
    return ret;
}
//门店图片显示
- (void)buildHeaderView{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_WIDTH)];
    //图片
    _storeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_WIDTH)];
    _storeImgView.image = [UIImage imageNamed:@"shopDefault"];
    _storeImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [_storeImgView addGestureRecognizer:tapGesture];
    [backView addSubview:_storeImgView];
    
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, 0, kStarRateWidth, kStarRateHeight) numberOfStars:5];
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.hasAnimation = YES;
    
    _gradeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.starRateView.right+5, self.starRateView.top, 50, kStarRateHeight)];
    _gradeLab.font = V3_36PX_FONT;
    _gradeLab.centerY = _starRateView.centerY;
    _gradeLab.textColor = [UIColor colorWithHex:0xfbc227];
    
    UIView *gradeBackgroud = [[UIView alloc] initWithFrame:CGRectMake(0, _storeImgView.height-kStarRateHeight, _storeImgView.width, kStarRateHeight)];
    gradeBackgroud.backgroundColor = [UIColor colorWithHex:0x0 alpha:0.5];
    [gradeBackgroud addSubview:_gradeLab];
    [gradeBackgroud addSubview:self.starRateView];
    
    _hplLabel = [[UILabel alloc] initWithFrame:CGRectMake(_gradeLab.right+5, _gradeLab.top, gradeBackgroud.width-_gradeLab.right-15, kStarRateHeight)];
    _hplLabel.textColor = [UIColor colorWithHex:0xfbc227];
    _hplLabel.text = [NSString stringWithFormat:@"好评率:%@ %@个评价",_merchantInfo.info.hpl ,_merchantInfo.orderSize];
    _hplLabel.font = V3_36PX_FONT;
    _hplLabel.textAlignment = NSTextAlignmentRight;
    [gradeBackgroud addSubview:_hplLabel];
    [_storeImgView addSubview:gradeBackgroud];
    self.tableView.tableHeaderView = backView;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 9) {
        CGSize titleSize = [_merchantInfo.info.describe_m boundingRectWithSize:CGSizeMake(APP_WIDTH*0.60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: V3_36PX_FONT} context:nil].size;
        return MAX(titleSize.height, 44);
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = V3_36PX_FONT;
        cell.detailTextLabel.font = V3_36PX_FONT;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = [self.array[indexPath.row] allKeys].lastObject;
        cell.detailTextLabel.text = [self.array[indexPath.row] allValues].lastObject;
        cell.detailTextLabel.numberOfLines = 0;
        if (indexPath.row == 5 ||indexPath.row == 6 || indexPath.row == 8) {
            cell.accessoryType = UITableViewCellAccessoryNone;

        }else if(indexPath.row == 9){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"每日最大接单量";
            cell.detailTextLabel.text = _merchantInfo.info.form_num;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"开店";
            UISwitch *switchCtr = [[UISwitch alloc] init];
            switchCtr.on = _merchantInfo.info.isclose.integerValue ?NO:YES;
            [switchCtr addTarget:self action:@selector(setMerchantOpen:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchCtr;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return;
    }
    if (indexPath.section == 1 &&(indexPath.row == 5 ||indexPath.row == 6 || indexPath.row == 8)) {
        return;
    }
    ChangeStoreController *changeStore = [[ChangeStoreController alloc] init];
    changeStore.changeType = indexPath.section * 10 +indexPath.row;
    changeStore.info = _merchantInfo.info;
    changeStore.commplete = ^{
        [self requestMerchantInfo];
    };
    [self.navigationController pushViewController:changeStore animated:YES];
}
#pragma mark - 处理提交照片
- (void)headerTap:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}
#pragma mark -开店关店设置
- (void)setMerchantOpen:(UISwitch *)sender{
    if (!sender.on) {
        [UIHelper alertWithTitle:@"温馨提示" msg:@"如关店，将无法接收新订单，是否关店？" viewController:self confirmAction:^{
            [self confirmSetMerchangeOpen:sender];
            
        } cancelAction:^{
            sender.on = !sender.on;
        }];
    }else{
        [self confirmSetMerchangeOpen:sender];
    }
    
}
- (void)confirmSetMerchangeOpen:(UISwitch *)sender{
    NSString *isClose = sender.on ? @"0":@"1";
    NSInteger merid = ApplicationDelegate.shareLoginData.userdata.mid;
    NSDictionary *param = @{@"merid":[NSNumber numberWithInteger:merid].stringValue,@"isClose":isClose};
    [AFNHttpRequest afnHttpRequestUrl:KHttpMerSwitch param:param success:^(id responseObject) {
        if (kRspCode(responseObject) == 0) {
            
        }else{
            sender.on = !sender.on;
        }
        
    } failure:^(NSError *error) {
        sender.on = !sender.on;
    } view:self.view];

}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }else{
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *theImage =[info objectForKey:UIImagePickerControllerOriginalImage];
//    CGSize size = theImage.size;
//    NSLog(@"处理前:%f,%f",size.width,size.height);
//    theImage = [self handleImage:theImage];
//    CGSize size1 = theImage.size;
//    NSLog(@"处理前:%f,%f",size1.width,size1.height);
    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
    EditPhotoViewController *epvc = [[EditPhotoViewController alloc] init];
    epvc.image     = theImage;
    epvc.delegate  = self;
    epvc.shapeType = EditShapeTypeSquare;
    [picker pushViewController:epvc animated:YES];
    
}
- (UIImage *)handleImage:(UIImage *)image
{
    image = [image rotateImage];
    image = [image imageCompressForTargetWidth:APP_WIDTH];
    return image;
}
#pragma mark - EditPhotoViewControllerDelegate

- (void)editPhotoViewController:(EditPhotoViewController *)controller didEditImage:(UIImage *)image
{
    CGSize size2 = image.size;
    NSLog(@"处理前:%f,%f",size2.width,size2.height);

    UIImage *theImage = ImageByScalingAndCroppingForSize(image, CGSizeMake(APP_WIDTH, APP_WIDTH));
    CGSize size1 = theImage.size;
    NSLog(@"处理后:%f,%f",size1.width,size1.height);
    
    NSInteger merid = ApplicationDelegate.shareLoginData.userdata.mid;
    NSData *smallImgData = [NSData dataWithData:UIImageJPEGRepresentation(theImage, 1.0f)];
    NSString *imageBase64 = [GTMBase64 stringByEncodingData:smallImgData];
    NSDictionary *param = @{@"dataString":imageBase64,@"merid":[NSNumber numberWithInteger:merid].stringValue};
    [AFNHttpRequest afnHttpRequestUrl:kHttpUploadMerImg param:param success:^(id responseObject) {
        if (kRspCode(responseObject) == 0) {
            _storeImgView.image = theImage;
            [UIHelper alertWithMsg:@"门店图片设置成功"];
            ApplicationDelegate.shareLoginData.userdata.logo = kRspMsg(responseObject);
        }else{
            [UIHelper alertWithMsg:kRspMsg(responseObject)];
        }
    } failure:^(NSError *error) {
        [UIHelper alertWithMsg:kNetworkErrorDesp];
    } view:self.view];

    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return 2;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    if (index == 0) {
        return @"门店信息";
    }else{
        return @"门店定位";
    }
}
- (void)backEvent:(UIBarButtonItem *)paramItem
{
    [ApplicationDelegate goBackHomeView];
}

@end
