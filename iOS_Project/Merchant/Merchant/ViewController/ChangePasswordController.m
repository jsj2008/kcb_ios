//
//  ChangePasswordController.m
//  Merchant
//
//  Created by Wendy on 16/1/11.
//  Copyright © 2016年 tranPlat. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *oldPwdTF;
@property (nonatomic, strong) UITextField *nnewPwdTF;
@property (nonatomic, strong) UITextField *confirmPwdTF;
@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackgroud;
    [self setNavTitle:@"修改密码"];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI{
    CGFloat leftMargin = 10.0f;
    CGFloat spaceVer = 10.0f;
    CGFloat width = APP_WIDTH- 2*leftMargin;
    CGFloat height = 40;
    _oldPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, 30, width, height)];
    _oldPwdTF.borderStyle = UITextBorderStyleRoundedRect;
    _oldPwdTF.placeholder = @"请输入旧密码";
    _oldPwdTF.secureTextEntry = YES;
    _oldPwdTF.delegate = self;
    [self.view addSubview:_oldPwdTF];
    
    _nnewPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, _oldPwdTF.bottom + spaceVer, width, height)];
    _nnewPwdTF.borderStyle = UITextBorderStyleRoundedRect;
    _nnewPwdTF.placeholder = @"请输入新密码";
    _nnewPwdTF.secureTextEntry = YES;
    _nnewPwdTF.delegate = self;
    [self.view addSubview:_nnewPwdTF];
    
    _confirmPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, _nnewPwdTF.bottom + spaceVer, width, height)];
    _confirmPwdTF.borderStyle = UITextBorderStyleRoundedRect;
    _confirmPwdTF.placeholder = @"请输入确认密码";
    _confirmPwdTF.secureTextEntry = YES;
    _confirmPwdTF.delegate = self;
    [self.view addSubview:_confirmPwdTF];
    
    UIButton *logonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logonBtn.frame = CGRectMake(leftMargin, _confirmPwdTF.bottom +30, width, 40);
    logonBtn.titleLabel.font = V3_38PX_FONT;
    logonBtn.tintColor = [UIColor purpleColor];
    logonBtn.backgroundColor = kColor0X39B44A;
    logonBtn.showsTouchWhenHighlighted = YES;
    [logonBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [logonBtn setTitleColor:[UIColor whiteColor]];
    [logonBtn addBorderWithWidth:1 color:kColor0X39B44A corner:3];
    [logonBtn addTarget:self action:@selector(changePwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logonBtn];

}
- (void)changePwdAction:(UIButton *)sender{
    NSString *errorMsg = nil;
    if (_oldPwdTF.text.length == 0) {
        errorMsg = @"请输入旧密码";
    }else if (_nnewPwdTF.text.length == 0) {
        errorMsg = @"请输入新密码";
    }else if (_confirmPwdTF.text.length == 0) {
        errorMsg = @"请输入确认密码";
    }else if (![_nnewPwdTF.text isEqualToString:_confirmPwdTF.text]) {
        errorMsg = @"确认密码必须与新密码相同";
    }else if(_nnewPwdTF.text.length > 8 || _nnewPwdTF.text.length < 6){
        errorMsg = @"密码长度6～8位";
    }
    if (errorMsg) {
        [UIHelper alertWithMsg:errorMsg];
        return;
    }
    NSDictionary *param = @{@"account":ApplicationDelegate.accountId,@"newpassword":[[_nnewPwdTF.text md5] uppercaseString],@"oldpassword":[[_oldPwdTF.text md5] uppercaseString]};
    
    [AFNHttpRequest afnHttpRequestUrl:kHttpChangePwd param:param success:^(id responseObject){
        NSDictionary *dict  = responseObject[@"body"][0];
        if ([dict[@"status"] integerValue] == 1) {
            ApplicationDelegate.shareLoginData.userdata.logined = @"1";
            if (_from == 0) {
                [ApplicationDelegate loadHomeView];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [UIHelper alertWithMsg:dict[@"message"]];
        }
    } failure:^(NSError *error) {
        [UIHelper alertWithMsg:kNetworkErrorDesp];
    } view:self.view];
    

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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    }
    
    if (range.location >= 8) {
        return NO;
    }
    
    return YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _oldPwdTF) {
        [_nnewPwdTF becomeFirstResponder];
    } else if (textField == _nnewPwdTF) {
        [_confirmPwdTF becomeFirstResponder];
    }else if (textField == _confirmPwdTF){
        [_confirmPwdTF resignFirstResponder];
    }
    
    return YES;
}

@end