//
//  UserCarViewController.m
//  ENT_tranPlat_iOS
//
//  Created by Lin_LL on 15/10/28.
//  Copyright (c) 2015年 ___ENT___. All rights reserved.
//

#import "UserCarViewController.h"
#import "ProvinceViewController.h"
#import "UsedCarViewController.h"


@interface UserCarViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UILabel     *_SZDQ;//所在地区
    UILabel     *_JTCX;//具体车型
    UILabel         *_SCSP;//首次上牌
    UITextField         *_XSLC;//行驶里程
    NSString *_szdq;
    NSString *_jtcx;
    
 
    
    
}
@property (nonatomic, strong) UIScrollView  *rootScrollView;

@property (nonatomic, strong) UIImageView   *perfectCarinfoFormBgView;

@end

@implementation UserCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
-(void)creatUI{

    CGFloat buttonBgHeight = 60 + 20 + 20;
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, APP_VIEW_Y, APP_WIDTH, APP_HEIGHT - APP_NAV_HEIGHT - buttonBgHeight*PX_Y_SCALE)];
    _rootScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_rootScrollView];
    _rootScrollView.backgroundColor=COLOR_FRAME_LINE;

    CGFloat singleLineHeightPX = 30*3;
    _perfectCarinfoFormBgView = [UIImageView backgroudTwoLineImageViewWithPXX:0 y: 0 width:APP_PX_WIDTH height:singleLineHeightPX*4];
    [_rootScrollView addSubview:_perfectCarinfoFormBgView];
    //*********************************横线*********************************
    UILabel *lineLabel = [UILabel lineLabelWithPXPoint:CGPointMake(0, singleLineHeightPX - 1)];
    [lineLabel setSize:CGSizeMake((APP_PX_WIDTH -60)*PX_X_SCALE, lineLabel.height)];
    [_perfectCarinfoFormBgView addSubview:lineLabel];
    lineLabel = [UILabel lineLabelWithPXPoint:CGPointMake(30, singleLineHeightPX * 2 - 1)];
    [lineLabel setSize:CGSizeMake((APP_PX_WIDTH - 60)*PX_X_SCALE, lineLabel.height)];
    [_perfectCarinfoFormBgView addSubview:lineLabel];
    lineLabel = [UILabel lineLabelWithPXPoint:CGPointMake(30, singleLineHeightPX * 3 - 1)];
    [lineLabel setSize:CGSizeMake((APP_PX_WIDTH - 60)*PX_X_SCALE, lineLabel.height)];
    [_perfectCarinfoFormBgView addSubview:lineLabel];

    
    //*********************************所在地区*********************************
    UILabel *label = [[UILabel alloc] initWithFrame:LGRectMake(30, 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [label convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_INFO_SHOW textAlignment:NSTextAlignmentLeft];
    [label setText:@"所在地区："];
    
    [_perfectCarinfoFormBgView addSubview:label];
    _SZDQ = [[UILabel alloc] initWithFrame:LGRectMake(280, 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [_SZDQ convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_LINK textAlignment:NSTextAlignmentLeft];
     [_SZDQ setText:@"请选择地区"];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeP:) name:@"shengfen" object:nil];
    [_perfectCarinfoFormBgView addSubview:_SZDQ];
    [_SZDQ setUserInteractionEnabled:YES];
    
    UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleButton setFrame:_SZDQ.bounds];
    [deleButton setBackgroundColor:[UIColor clearColor]];
    [deleButton addTarget:self action:@selector(setDateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleButton.tag = 100;
    [_SZDQ addSubview:deleButton];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:LGRectMake(APP_PX_WIDTH-60, 30,40, 40)];
    [arrowImgView setImage:[UIImage imageNamed:@"arrow_right.png"]];
    [_perfectCarinfoFormBgView addSubview:arrowImgView];
    
//    //*********************************具体车型*********************************
    label = [[UILabel alloc] initWithFrame:LGRectMake(30, singleLineHeightPX + 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [label convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_INFO_SHOW textAlignment:NSTextAlignmentLeft];
    [label setText:@"具体车型："];
    [_perfectCarinfoFormBgView addSubview:label];
    
    _JTCX = [[UILabel alloc] initWithFrame:LGRectMake(280, singleLineHeightPX + 30, _perfectCarinfoFormBgView.w - 30*12, 40)];
    [_JTCX convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_LINK textAlignment:NSTextAlignmentLeft];
    [_JTCX setText:@"请选择车型"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"chexing" object:nil];
    [_perfectCarinfoFormBgView addSubview:_JTCX];
    [_JTCX setUserInteractionEnabled:YES];
    arrowImgView = [[UIImageView alloc] initWithFrame:LGRectMake(APP_PX_WIDTH-60, singleLineHeightPX + 30,40, 40)];
    [arrowImgView setImage:[UIImage imageNamed:@"arrow_right.png"]];
    [_perfectCarinfoFormBgView addSubview:arrowImgView];
    
    deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleButton setFrame:_JTCX.bounds];
    [deleButton setBackgroundColor:[UIColor clearColor]];
    [deleButton addTarget:self action:@selector(setDateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleButton.tag = 101;
    [_JTCX addSubview:deleButton];

    
//    //*********************************首次上牌*********************************
    label = [[UILabel alloc] initWithFrame:LGRectMake(30, singleLineHeightPX*2 + 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [label convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_INFO_SHOW textAlignment:NSTextAlignmentLeft];
    [label setText:@"首次上牌："];
    [_perfectCarinfoFormBgView addSubview:label];
    _SCSP = [[UILabel alloc] initWithFrame:LGRectMake(280, singleLineHeightPX*2 + 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [_SCSP convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_LINK textAlignment:NSTextAlignmentLeft];
    [_SCSP setText:@"上牌时间"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeS:) name:@"shangpai" object:nil];
    
    [_perfectCarinfoFormBgView addSubview:_SCSP];
    [_SCSP setUserInteractionEnabled:YES];
    arrowImgView = [[UIImageView alloc] initWithFrame:LGRectMake(APP_PX_WIDTH-60, singleLineHeightPX*2 + 30,40, 40)];
    [arrowImgView setImage:[UIImage imageNamed:@"arrow_right.png"]];
    [_perfectCarinfoFormBgView addSubview:arrowImgView];
    deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleButton setFrame:_SCSP.bounds];
    [deleButton setBackgroundColor:[UIColor clearColor]];
    [deleButton addTarget:self action:@selector(setDateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleButton.tag = 102;
    [_SCSP addSubview:deleButton];

  
//    //*********************************行驶里程*********************************
    label = [[UILabel alloc] initWithFrame:LGRectMake(30, singleLineHeightPX*3 + 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [label convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_INFO_SHOW textAlignment:NSTextAlignmentLeft];
    [label setText:@"行驶里程："];
    [_perfectCarinfoFormBgView addSubview:label];
    _XSLC = [[UITextField alloc] initWithFrame:LGRectMake(280, singleLineHeightPX*3 + 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    _XSLC.delegate = self;
   
    [_XSLC setFont:V3_38PX_FONT];
    [_XSLC setBorderStyle:UITextBorderStyleNone];
    [_XSLC setPlaceholder:@"请输入累计里程"];
    [_XSLC limitCHTextLength:11];
    [_XSLC setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_perfectCarinfoFormBgView addSubview:_XSLC];
    label = [[UILabel alloc] initWithFrame:LGRectMake(APP_PX_WIDTH-120, singleLineHeightPX*3 + 30, _perfectCarinfoFormBgView.w - 30*4, 40)];
    [label convertNewLabelWithFont:V3_38PX_FONT textColor:COLOR_FONT_INFO_SHOW textAlignment:NSTextAlignmentLeft];
    [label setText:@"万公里"];
    [_perfectCarinfoFormBgView addSubview:label];

    /*_______________________下一步____________________________________________*/
    
    UIView *buttonBgView = [[UIView alloc] initWithFrame:BGRectMake(0, _rootScrollView.b, APP_PX_WIDTH, buttonBgHeight)];
    buttonBgView.backgroundColor = kClearColor;
    [self.view addSubview:buttonBgView];
    lineLabel = [UILabel lineLabelWithPXPoint:CGPointMake(0, 0)];
    [lineLabel setSize:CGSizeMake((APP_PX_WIDTH)*PX_X_SCALE, lineLabel.height)];
    [buttonBgView addSubview:lineLabel];
  
    
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = LGRectMake(30, 15, buttonBgView.w - 30*2, buttonBgView.h - 15*2);
    [button setTitle:@"在线估价" forState:UIControlStateNormal];
    button.titleLabel.font = V3_38PX_FONT;
    [button addTarget:self action:@selector(nextStepButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[[UIImage imageNamed:@"button_green"] resizableImageWithCapInsets:UIEdgeInsetsMake(44, 200, 44, 200)] forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonBgView addSubview:button];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    
    if(textField == _XSLC)
    {
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if(!basicTest)
            
            return NO;
        
    }
    
    return YES;
    
}
-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}
- (void)nextStepButtonClicked{
   
    if ([_SZDQ.text isEqualToString:@"请选地区"]) {
        
        [UIAlertView alertTitle:nil msg:@"请填写具体信息!"];
        
        
        
    }else if([_SCSP.text isEqualToString:@"上牌时间"]  ){
    
    [UIAlertView alertTitle:nil msg:@"请选择上牌时间!"];
        
        
    }else if(!_XSLC.text || [_XSLC.text isEqualToString:@"请输入累计里程"] )
    
    {
      [UIAlertView alertTitle:nil msg:@"请选择上牌时间!"];
    
    }else if([self IsChinese:_XSLC.text]){
        
        [UIAlertView alertTitle:nil msg:@"请输入正确行驶里程!"];
    
    }else{
        
        
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     NSString *url=[NSString stringWithFormat:@"http://buss.956122.com/eval/getEval/%@/%@/%@/%@/1.do?callback=handler&_=1443490323354", [[NSUserDefaults standardUserDefaults]valueForKey:KEY_CITY_CODE_IN_USERDEFAULTUSE],_SCSP.text,_XSLC.text,[[NSUserDefaults standardUserDefaults]valueForKey:@"modelID"]];
        
       [BLMHttpTool kcbgetWithURL:url params:nil success:^(id json) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       NSMutableString *mutString=[[NSMutableString alloc] initWithData:json encoding:NSUTF8StringEncoding];
       NSRange range=[mutString rangeOfString:@"])"];
       [mutString deleteCharactersInRange:range];
       [mutString deleteCharactersInRange:NSMakeRange(0, 9)];
     //  NSLog(@"%@",mutString);
       
       NSData *jsonData = [mutString dataUsingEncoding:NSUTF8StringEncoding];
       NSError *err;
       NSDictionary *dict=[[NSDictionary alloc]init];
       dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingMutableContainers
                                                 error:&err];
       if([[dict valueForKey:@"status"] isEqualToString:@"1"]){
       UsedCarInfoViewController *vc=[[UsedCarInfoViewController alloc]init];
//           NSLog(@"%@",[dict valueForKey:@"status"]);
       vc.dic=dict;
       vc.way=_XSLC.text;
       vc.time=_SCSP.text;
       [self.navigationController pushViewController:vc animated:YES];
           
       }else{
       
        [UIAlertView alertTitle:nil msg:@"请输入正确年份."];
       
       }
       
   } failure:^(NSError *error) {
       
   }];
    
    }
}
- (void)setDateButtonClicked:(UIButton*)button{
    if (button.tag == 100){
     

        ProvinceViewController *vc =[[ProvinceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag ==101){
        UsedCarViewController *vc=[[UsedCarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
        
    }else if (button.tag ==102){
        
        if ([_JTCX.text isEqualToString:@"请选择车型"]) {
            
            [UIAlertView alertTitle:nil msg:@"请选择具体车型!"];

            
        }else {
        
        UsedLicenseViewController *vc=[[UsedLicenseViewController alloc]init];
        
        NSString *string=_JTCX.text;
        NSString *str2 = [string substringToIndex:4];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy"];
        NSDate* inputDate = [dateFormat dateFromString:str2];
        NSString *string1=[NSString stringWithFormat:@"%@",inputDate];
        NSString *str3 = [string1 substringToIndex:4];
        //NSLog(@"%@",str3);
        vc.years=str3;
        [self.navigationController pushViewController:vc animated:YES];
    
        }
    }

    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ( [textField isEqual:_XSLC]) {
        textField.text = [textField.text uppercaseString];
    }
    return YES;
}
-(void)change:(NSNotification*)noti{
    
    _JTCX.text=[noti.userInfo valueForKey:@"modelName"];

   // _JTCX.text=_jtcx;
}
-(void)changeP:(NSNotification*)noti{
    
    
    _SZDQ.text=[noti.userInfo valueForKey:@"name"];
    
    //_SZDQ.text=_szdq;
    
    
    
    
}
-(void)changeS:(NSNotification*)noti{
    
    
    _SCSP.text=[noti.userInfo valueForKey:@"time"];
    

   

    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadNavigationBarWithBackHomeButton:NO];
    [self setCustomNavigationTitle:@"二手车估值"];
   
//    [_SZDQ setText:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME_IN_USERDEFAULTUSE]];
//    if (_SZDQ.text==nil) {
//        [_SZDQ setText:@"请选择省份"];
//    }
    
}
//视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示框" message:@"viewWillDisappear" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    //显示提示框
//    //    [alertView show];
    
}
//界面已经消失
-(void)viewDidDisappear:(BOOL)animated{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
