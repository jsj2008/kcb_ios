//
//  ForgotPasswordViewController.h
//  ENT_tranPlat_iOS
//
//  Created by yanyan on 14-8-12.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : BasicViewController<
UITextFieldDelegate
>
{
    UITextField             *_userNameTF;
    
}

@end