//
//  EidtCarViewController.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/3/4.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "EidtCarViewController.h"

@implementation EidtCarViewController
{
    UITextField *textField;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [textField becomeFirstResponder];
    [self setCustomNavigationTitle:[NSString stringWithFormat:@"编辑%@",self.title]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(40*x_6_plus, APP_VIEW_Y, APP_WIDTH, 138*y_6_plus)];
    textField.text = self.text;
    textField.placeholder = [NSString stringWithFormat:@"请编辑%@",self.title];
    
    [self.view addSubview:textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addActionBlock:^(id weakSender) {
        if (![textField.text isLegal]) {
            [UITools alertWithMsg:[NSString stringWithFormat:@"请先编辑%@",self.title]];
            return ;
        }
        if (_block) {
            _block(textField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, self.view.height-136*y_6_plus, APP_WIDTH, 136*y_6_plus);
    btn.backgroundColor = COLOR_NAV;
    [btn setTitle:@"确定"];
    [btn setTitleColor:kWhiteColor];
    [self.view addSubview:btn];
}

@end
