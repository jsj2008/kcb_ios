//
//  Macro.h
//  Merchant
//
//  Created by Wendy on 15/12/17.
//  Copyright © 2015年 tranPlat. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define IsIOS7              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IsIOS8              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define IsIPHONE5           (([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO)
#define IsIPHONE6           (([UIScreen mainScreen].bounds.size.width == 375) ? YES : NO)
#define IsIPHONE6P          (([UIScreen mainScreen].bounds.size.width == 414) ? YES : NO)

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define NULLSTRING    @""
#define BLANK(STRING) STRING == nil ? NULLSTRING : STRING

#define BLANKSPACE(STRING) STRING == nil ? @" " : STRING
#define VersionNum @"1"


#define kLoginUserData @"LoginUserData"
#define kLoginUserAccount @"LoginUserAccount"
#define kLoginUserPassword @"LoginUserPassword"

#define DeviceTokenKey @"DeviceTokenKey"

#endif /* Macro_h */