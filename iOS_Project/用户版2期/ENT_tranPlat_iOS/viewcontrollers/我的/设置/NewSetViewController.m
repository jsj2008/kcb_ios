//
//  NewSetViewController.m
//  ENT_tranPlat_iOS
//
//  Created by Lin_LL on 16/2/19.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "NewSetViewController.h"
#import "AdviceSetViewController.h"
#import "ShareSetViewController.h"
#import "DriverServicePlatDealViewController.h"
#import "SelfHelpDealViewController.h"
#import "AboutSetViewController.h"
#import "RidersInteractionViewController.h"
#import "ShareSetViewController.h"
#import "MovieListViewController.h"
#import "UIImageView+WebCache.h"


@interface NewSetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation NewSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.rightHidden = YES;
    [self setCustomNavigationTitle:@"我的开车邦"];
    [self setBackButtonHidden:NO];
    
}
- (UIView *)footerView{
    if (_footerView) {
        return _footerView;
    }
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-144*y_6_plus, APP_WIDTH, 144*y_6_plus)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _footerView.height-144*y_6_plus, _footerView.width, 144*y_6_plus);
    btn.backgroundColor = COLOR_NAV;
    [btn setTitle:@"退出登录"];
    [btn addActionBlock:^(id weakSender) {
        [UITools alertWithMsg:@"是否确定退出登录？" viewController:self confirmAction:^{
            UserInfo *user = [[[DataBase sharedDataBase] selectUserByName:APP_DELEGATE.userName] lastObject];
            user.isActive = ACTIVE_USER_NO;
            [user update];
            APP_DELEGATE.loginSuss = NO;
            APP_DELEGATE.userId = @"";
            APP_DELEGATE.userName = @"";
            
            [self gobackPage];
        } cancelAction:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:kWhiteColor];
    [_footerView addSubview:btn];
    
    return _footerView;
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APP_VIEW_Y, self.view.width, APP_HEIGHT-APP_VIEW_Y-200*y_6_plus)
                                             style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    return _tableView;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return  20*y_6_plus;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
//    if (section == 4) {
//        return 60*y_6_plus;
//    }else {

    return 20*y_6_plus;
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 5;
    }else {
        
        return 1;
    }
    
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 260*y_6_plus;
//    }else if (indexPath.section == 1){
//        return 110*y_6_plus;
//    }
    
   return 120*y_6_plus;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"setting_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:LGRectMake(tableView.w - 30 - 24, 20, 24, 24)];
        [imgView setImage:[UIImage imageNamed:@"arrow_right.png"]];
        [cell.contentView addSubview:imgView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:LGRectMake(30, 15, 650, 30)];
        [textLabel convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_NOMAL textAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:textLabel];
        UILabel *hcLabel = [[UILabel alloc] initWithFrame:LGRectMake(500, 15, 600, 30)];
        [hcLabel convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_NOMAL textAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:hcLabel];
    }
   
    if (indexPath.section == 0) {
        
      //  UILabel *textLabel = [cell.contentView.subviews lastObject];
        UILabel *textLabel = [cell.contentView.subviews objectAtIndex:1];
        textLabel.text = @"告诉朋友";
        return cell;
       
    }else if (indexPath.section == 1){
    
       // UILabel *textLabel = [cell.contentView.subviews lastObject];
        UILabel *textLabel = [cell.contentView.subviews objectAtIndex:1];
        textLabel.text = @"用户操作说明";
        return cell;
    
    }else if (indexPath.section == 2){
        
        NSString *string = @"";
         NSString *string1 =@"";
        switch (indexPath.row) {
            case 0:
                string = @"用户协议";
                break;
            case 1:
                string = @"交通违法网上自助处理使用协议";
                break;
            case 2:
                string = @"车友互动使用协议";
                break;
            case 3:
                
                string =@"清除缓存";
                string1 =[NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];

                break;
            case 4:
                string = @"版本更新";
                break;
            default:
                
                break;
        }
       // UILabel *textLabel = [cell.contentView.subviews lastObject];
       // UIImageView *logoImgView = [cell.contentView.subviews objectAtIndex:1];
        UILabel *textLabel = [cell.contentView.subviews objectAtIndex:1];
        textLabel.text = string;
        UILabel *hcLabel = [cell.contentView.subviews objectAtIndex:2];
        hcLabel.text = string1;
        
        return cell;
        
    }else if (indexPath.section == 3){
        
        //UILabel *textLabel = [cell.contentView.subviews lastObject];
        UILabel *textLabel = [cell.contentView.subviews objectAtIndex:1];
        textLabel.text = @"关于开车邦";
        return cell;
        
    }
    
   
     return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
      
        
        ShareSetViewController *shareVC = [[ShareSetViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }else if (indexPath.section == 1){
      
        MovieListViewController *vc = [[MovieListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 2){
        
      
        if (indexPath.row == 0) {//用户协议
            DriverServicePlatDealViewController *dspdVC = [[DriverServicePlatDealViewController alloc] init];
            dspdVC.showOtherDeals = NO;
            [self.navigationController pushViewController:dspdVC animated:YES];
        }else if (indexPath.row == 1) {//交通违法网上自助处理使用协议
            SelfHelpDealViewController *selfhelpVC = [[SelfHelpDealViewController alloc] init];
            [self.navigationController pushViewController:selfhelpVC animated:YES];
        }else if (indexPath.row == 2) {//车友互动使用协议
            RidersInteractionViewController *ridersVC = [[RidersInteractionViewController alloc] init];
            [self.navigationController pushViewController:ridersVC animated:YES];
        }else if (indexPath.row == 3) {//清除缓存
            
            [UITools alertWithTitle:@"温馨提示" msg:@"即将对缓存图片及临时文件进行清理" viewController:self
                      confirmAction:^{
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                               [UITools alertWithMsg:@"清除缓存成功"];
                               [self.tableView reloadData];
                           }];
                      } cancelAction:nil];

        }else if (indexPath.row == 4) {//
            [self checkAppUpdate];
        }
    }else{
        
        AboutSetViewController *aboutVC = [[AboutSetViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
   
    }
}
//+(float)folderSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    float folderSize;
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            //folderSize +=[FileService fileSizeAtPath:absolutePath];
//        }
//        　　　　　//SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//        return folderSize;
//    }
//    return 0;
//}
-(void)checkAppUpdate{
    MKNetworkEngine *en = [[MKNetworkEngine alloc] initWithHostName:@"yetapi.956122.com"];
    MKNetworkOperation *op = [en operationWithPath:@"androidapk/ver_ios.xml"];
    ENTLog(@"检查更新url=%@", op.url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //<root> <appurl_ios> https://itunes.apple.com/us/app/quan-guo-jia-shi-yuan-fu-wu/id862897685?l=zh&ls=1&mt=8 </appurl_ios> <version>2.1.4</version> </root>
        
        NSString *urlString = @"";
        NSString *newVersionString = @"";
        //解析newversion
        NSString *resString = completedOperation.responseString;
        NSRange range = [resString rangeOfString:@"<version>"];
        if (range.location != NSNotFound) {
            newVersionString = [resString substringFromIndex:range.location + range.length];
            range = [newVersionString rangeOfString:@"</version>"];
            newVersionString = [newVersionString substringToIndex:range.location];
        }
        //组成当前版本，新版本 int
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSArray *currentVersionA = [currentVersion componentsSeparatedByString:@"."];
        NSArray *newVersionA = [newVersionString componentsSeparatedByString:@"."];
        
        currentVersion = [NSString stringWithFormat:@"%@%@%@",[currentVersionA objectAtIndex:0], [currentVersionA objectAtIndex:1], [currentVersionA objectAtIndex:2]];
        newVersionString = [NSString stringWithFormat:@"%@%@%@",[newVersionA objectAtIndex:0], [newVersionA objectAtIndex:1], [newVersionA objectAtIndex:2]];
        NSInteger currentV = [currentVersion integerValue];
        NSInteger newV = [newVersionString integerValue];
        
        //比较版本
        if (newV > currentV) {//有新版本
            [UITools alertWithMsg:@"已有新版本,是否更新APP" viewController:self confirmAction:^{
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/quan-guo-jia-shi-yuan-fu-wu/id862897685?l=zh&ls=1&mt=8"]]];
                
            } cancelAction:nil];
            //解析url
            range = [resString rangeOfString:@"<appurl_ios>"];
            if (range.location != NSNotFound) {//有AppStore地址
                urlString = [resString substringFromIndex:range.location + range.length];
                range = [urlString rangeOfString:@"</appurl_ios>"];
                urlString = [urlString substringToIndex:range.location];
            }
            
        }else{
            [UITools alertWithMsg:@"当前版本已是最新版本!"];
            return ;
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_UPDATE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString, @"url", newVersionString, @"version", nil]];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_UPDATE object:nil userInfo:nil];
    }];
    [en enqueueOperation:op];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
