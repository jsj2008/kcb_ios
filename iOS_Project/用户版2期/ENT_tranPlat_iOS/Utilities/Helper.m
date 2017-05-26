//
//  Helper.m
//  ENT_tranPlat_iOS
//
//  Created by yanyan on 14-7-14.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//
/******************************************************
 * 模块名称:   Helper.m
 * 模块功能:   工具类方法
 * 创建日期:   14-7-14
 * 创建作者:   闫燕
 * 修改日期:
 * 修改人员:
 * 修改内容:
 ******************************************************/

#import "Helper.h"

@implementation Helper

+ (BOOL)netAvailible {
    Reachability *reach=[Reachability reachabilityWithHostname:@"yetapi.956122.com"];
    return [reach isReachable];
}




+ (BOOL)locationServiceEnable{
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            if(iOS8){
                if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
                    return NO;
                }else{
                    return YES;
                }
            }else{
                return NO;
            }
            
        }else{
            return YES;
        }
    }
    else{
        return NO;
    }
    
}

#pragma mark- 违章信息过滤
+ (NSDictionary*)filtrateCarPeccancyRecordMessages:(NSArray*)carPeccancyMessages withHpzl:(NSString*)hpzl andHphm:(NSString*)hphm {
    NSMutableArray *carPays = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *carDeals = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (CarPeccancyMsg *carmsg in carPeccancyMessages) {
        
        if ([carmsg.xh rangeOfString:SERVER_BACK_WITHOUT].location == NSNotFound) {//服务器返回了该字段
            if ([carmsg.xh isEqualToString:@""] || [carmsg.xh isEqualToString:@"null"]) {
                continue;
            }
        }
        
        
        if ([carmsg.qrbj isEqualToString:@"1"] ) {//现修改为大于200的可显示，不可处理&& [carmsg.fkje intValue] <= 200
            
            
            //现修改为云南大型车可显示   不可处理
            //            if ([hphm hasPrefix:@"云"] && [hpzl isEqualToString:@"01"]) {     //如果是云南车辆，排除小型车以外的
            //                continue;
            //            }
            
            [carDeals addObject:carmsg];
            
        }else if([carmsg.wzzt isEqualToString:@"已确认"]){
            //缴款记录
            [carPays addObject:carmsg];
            
        }else{
            
        }
        
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:carPays, KEY_FILTRATE_CAR_PECCANCY_MSGS_RESULT_PAY_MSG, carDeals, KEY_FILTRATE_CAR_PECCANCY_MSGS_RESULT_DEAL_MSG, nil];
}








#pragma mark- 网络数据解析
+ (UserInfo*)loginAnalysisUser:(NSDictionary*)resDict withUserId:(NSString*)userId userName:(NSString*)userName andPassword:(NSString*)password{
    
    NSString *email = [resDict analysisStrValueByKey:@"email"];
    NSString *mobile = [resDict analysisStrValueByKey:@"mobile"];
    NSString *postcoce = [resDict analysisStrValueByKey:@"postcoce"];
    NSString *realname = [resDict analysisStrValueByKey:@"realname"];
    NSString *address = [resDict analysisStrValueByKey:@"address"];
    NSString *registertime = [resDict analysisStrValueByKey:@"registertime"];
    NSString *registStatus = @"";//[resDict objectForKey:@"registerstatus"];//为了之后开发用户验证功能而保留的,暂不处理
    NSString *photoServerPath = [resDict analysisStrValueByKey:@"photo"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    UserInfo *user = [[UserInfo alloc] initWithUserId:userId
                                             isActive:ACTIVE_USER_YES
                                             userName:userName
                                             password:password
                                                email:email
                                           contactNum:mobile
                                             postCode:postcoce
                                             realName:realname
                                                 addr:address
                                           registTime:registertime
                                         verifyStatus:registStatus
                                             loadTime:[[NSDate date] string]
                                              citySet:@""
                                              version:version
                                       photoLocalPath:@""
                                   andPhotoServerPath:photoServerPath];
    return user;
}


+ (NSArray*)loginAnalysisDriver:(NSDictionary*)resDict withUserId:(NSString*)userId{
    
    NSString *driversfzmhm = [resDict analysisStrValueByKey:@"driversfzmhm"];
    NSString *dabh = [resDict analysisStrValueByKey:@"dabh"];
    NSString *xm = [resDict analysisStrValueByKey:@"xm"];
    NSString *ljjf = [resDict analysisStrValueByKey:@"ljjf"];
    NSString *zxbh = [resDict analysisStrValueByKey:@"zxbh"];
    NSString *zjcx = [resDict analysisStrValueByKey:@"zjcx"];
    NSString *yxqz = [resDict analysisStrValueByKey:@"yxqz"];
    NSString *djzsxxdz = [resDict analysisStrValueByKey:@"djzsxxdz"];
    
    NSString *driverzt = [resDict analysisStrValueByKey:@"driverzt"];
    
    NSString *driverStatus = [resDict analysisStrValueByKey:@"driverstatus"];
    if ([driverStatus isEqualToString:@"驾照验证成功"]) {
        driverStatus = @"验证成功";
    }
    //    NSInteger driverstatusCode = [[resDict objectForKey:@"driverstatus"] integerValue];//driverstatus取值：0:验证中；1:验证成功；2:驾照号码不存在;3:档案编号不正确;4:姓名不正确;5:档案所在省没有开通;6:网络服务异常;7:证芯编号不正确
    //
    //    NSString *driverStatus = @"";
    //    switch (driverstatusCode) {
    //        case 0:
    //        driverStatus = @"验证中";
    //        break;
    //        case 1:
    //        driverStatus = @"验证成功";
    //        break;
    //        case 2:
    //        driverStatus = @"驾照号码不存在";
    //        break;
    //        case 3:
    //        driverStatus = @"档案编号不正确";
    //        break;
    //        case 4:
    //        driverStatus = @"姓名不正确";
    //        break;
    //        case 5:
    //        driverStatus = @"档案所在省没有开通";
    //        break;
    //        case 6:
    //        driverStatus = @"网络服务异常";
    //        break;
    //        case 7:
    //        driverStatus = @"证芯编号不正确";
    //        break;
    //        default:
    //        break;
    //    }
    
    DriverInfo *driver = [[DriverInfo alloc] initWithDriverfzmhm:driversfzmhm dabh:dabh xm:xm driverstatus:driverStatus ljjf:ljjf zjcx:zjcx yxqz:yxqz zxbh:zxbh drivergxsj:[[NSDate date] string] djzsxxdz:djzsxxdz driverzt:driverzt andUseId:userId];
    if (![driver.driversfzmhm isEqualToString:@""]) {
        return [NSArray arrayWithObjects:driver, nil];
    }else{
        return [NSArray arrayWithObjects:nil];
    }
    
}

+ (NSArray*)loginAnalysisCarInfo:(NSDictionary*)resDict withUserId:(NSString*)userId{
    NSMutableArray *cars = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *vehicles = [resDict objectForKey:@"vehicles"];
    NSArray *vehiclecs = [resDict objectForKey:@"vehiclecs"];
    

    for (NSDictionary *dict in vehicles) {
        
        NSString *hpzl = [dict analysisStrValueByKey:@"hpzl"];
        NSString *hpzlname = [dict analysisStrValueByKey:@"hpzlname"];
        NSString *hphm = [dict analysisStrValueByKey:@"hphm"];
        
        NSString *clsbdh = [dict analysisStrValueByKey:@"clsbdh"];
        NSString *clpp1 = [dict analysisStrValueByKey:@"clpp1"];
        
        NSString *vehiclestatusStr = [dict analysisStrValueByKey:@"vehiclestatus"];
        
        if ([vehiclestatusStr isEqualToString:@"车辆验证成功"]) {
            vehiclestatusStr = @"验证成功";
        }
        //        //vehiclestatus取值：0:验证中；1:验证成功；2:号牌号码不存在;3:车辆识别代号不正确;4:网络服务异常
        //        NSInteger vehiclestatus = [[dict objectForKey:@"vehiclestatus"] integerValue];
        //        NSString *vehiclestatusStr = @"";
        //        switch (vehiclestatus) {
        //            case 0:
        //                vehiclestatusStr = @"验证中";
        //            break;
        //            case 1:
        //                vehiclestatusStr = @"验证成功";
        //            break;
        //            case 2:
        //                vehiclestatusStr = @"号牌号码不存在";
        //            break;
        //            case 3:
        //                vehiclestatusStr = @"车辆识别代号不正确";
        //            break;
        //            case 4:
        //                vehiclestatusStr = @"网络服务异常";
        //            break;
        //
        //            default:
        //            break;
        //        }
        NSString *yxqz = [dict analysisStrValueByKey:@"yxqz"];
        NSString *bxzzrq = [dict analysisStrValueByKey:@"bxzzrq"];
        NSString *ccdjrq = [dict analysisStrValueByKey:@"ccdjrq"];
        NSString *createTime = [dict analysisStrValueByKey:@"createTime"];
        
        NSString *zt = [dict analysisStrValueByKey:@"zt"];
        NSString *sfzmhm = [dict analysisStrValueByKey:@"sfzmhm"];
        NSString *syr = [dict analysisStrValueByKey:@"syr"];
        NSString *fdjh = [dict analysisStrValueByKey:@"fdjh"];
        
        NSString *vehiclepic = @"";//[dict objectForKey:@"vehiclepic"];//后续会用，暂时空
        NSString *vehicletypename = @"";//[dict objectForKey:@"vehicletypename"];//后续会用，暂时空
        NSString *isupdate = @"";//安卓用于该单是否可处理、是否可缴款。暂时搁置，待用。
        
        CarInfo *car = [[CarInfo alloc] initWithHpzl:hpzl hpzlname:hpzlname hphm:hphm clsbdh:clsbdh clpp1:clpp1 vehicletypename:vehicletypename vehiclepic:vehiclepic vehiclestatus:vehiclestatusStr yxqz:yxqz bxzzrq:bxzzrq ccdjrq:ccdjrq vehiclegxsj:[[NSDate date] string] isupdate:isupdate createTime:createTime zt:zt sfzmhm:sfzmhm syr:syr fdjh:fdjh andUseId:userId];
        [cars addObject:car];
    }
    for (NSDictionary *dict in vehiclecs) {
       
        
        NSString *hpzl = [dict analysisStrValueByKey:@"hpzl"];
        NSString *hpzlname = [dict analysisStrValueByKey:@"hpzlname"];
        NSString *hphm = [dict analysisStrValueByKey:@"hphm"];
        
        NSString *clsbdh = [dict analysisStrValueByKey:@"clsbdh"];
        
        NSString *vehiclestatusStr = @"验证成功";
        
        NSString *fdjh = [dict analysisStrValueByKey:@"fdjh"];
        
       
        
        CarInfo *car = [[CarInfo alloc] initWithHpzl:hpzl hpzlname:hpzlname hphm:hphm clsbdh:clsbdh clpp1:@"" vehicletypename:@"" vehiclepic:@"" vehiclestatus:vehiclestatusStr yxqz:@"" bxzzrq:@"" ccdjrq:@"" vehiclegxsj:[[NSDate date] string] isupdate:@"" createTime:@"" zt:@"" sfzmhm:@"" syr:@"" fdjh:fdjh andUseId:userId];
        [cars addObject:car];
    }
   
    return cars;
}

/*
 功能：根据指定字符，过滤出字符串数组
 参数：NSString messStr需要过滤的字符串 NSString charstring过滤条件字符
 返回：NSArray 字符串数组
 */
+ (NSArray*)filtrateSubstringsFromString:(NSString*)messStr withCharstring:(NSString*)charstring{
    if (!messStr || [messStr isEqualToString:@""]) {
        return [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSCharacterSet *setedChar = [NSCharacterSet characterSetWithCharactersInString:charstring];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *messStr_now = [[NSString alloc] initWithString:messStr];
    
    while (1) {
        NSRange range = [messStr_now rangeOfCharacterFromSet:setedChar options:NSCaseInsensitiveSearch];
        NSString *subStr;
        if (range.location != NSNotFound) {
            subStr = [messStr_now substringToIndex:range.location];
            messStr_now = [messStr_now substringFromIndex:range.location + 1];
            [array addObject:subStr];
        }else{
            subStr = messStr_now;
            [array addObject:subStr];
            break;
        }
    }
    
    return array;
}

//常用车辆
//+ (NSArray *)UcarPeccancyMsgAnalysis:(NSString*)jsonStr withHphm:(NSString*)hphm{
//    SBJsonParser *parse = [[SBJsonParser alloc] init];
//    //    jsonStr = @"{\"datasource\":\"01\",\"vehicles\":[{\"jszh\":\"46002219910228701X\",\"fkje\":100,\"clsj\":\"2014-11-22 10:11:47.0\",\"fltw\":\"《中华人民共和国道路交通安全法》第九十条、《实施办法》第82条第3项\",\"xxly\":\"2\",\"wfxw\":\"13521\",\"fxjgmc\":\"屯昌大队\",\"jdsbh\":\"469080190107790\",\"dsr\":\"沈名强\",\"wfdz\":\"海榆中线97公里00米\",\"wfsj\":\"2014-11-05 14:51:00.0\",\"wfjfs\":3,\"cljg\":\"469080000000\",\"wfdd\":\"10224\",\"cljgmc\":\"琼南车管所支队\",\"fxjg\":\"469022000000\",\"wfgd\":\"《中华人民共和国道路交通安全法》第四十二条、《中华人民共和国道路交通安全法实施条例》第四十五条、第四十六条\",\"wfms\":\"驾驶中型以上载客载货汽车、危险物品运输车辆以外的其他机动车行驶超过规定时速10%未达20%的\",\"wfnr\":\"驾驶中型以上载客载货汽车、危险物品运输车辆以外的其他机动车行驶超过规定时速10%未达20%的\",\"wzzt\":\"已确认\",\"sd\":\"海南\",\"znj\":0}],\"count\":1,\"琼ALJ692\":\"1\"}";
//    NSDictionary *reqDic = [parse objectWithString:jsonStr];
//    
//    NSString *datasource = [reqDic analysisStrValueByKey:@"datasource"];
//    NSString *count = [reqDic analysisStrValueByKey:@"count"];
//    NSString *yxqz = [reqDic analysisStrValueByKey:@"yxqz"];
//    NSString *bxzzrq = [reqDic analysisStrValueByKey:@"bxzzrq"];
//    
//    
//    
//    NSString *messStr = [reqDic analysisStrValueByKey:hphm];
//    
//    NSArray *strings = [Helper filtrateSubstringsFromString:messStr withCharstring:@","];
//    NSString *hphm_head = @"";
//    NSString *syxz = @"";
//    NSString *cllx = @"";
//    NSString *dsrdz = @"";
//    NSString *sfzmhm = @"";
//    NSString *dsr_jsonLastStr = @"";
//    if ([strings count] > 5) {
//        hphm_head = [strings objectAtIndex:0];
//        syxz = [strings objectAtIndex:1];
//        cllx = [strings objectAtIndex:2];
//        dsrdz = [strings objectAtIndex:3];
//        sfzmhm = [strings objectAtIndex:4];
//        dsr_jsonLastStr = [strings objectAtIndex:5];
//    }
//    
//    
//    
//    NSArray *arr = [reqDic objectForKey:@"vehicles"];
//    NSMutableArray  *carPeccancyMsgs = [[NSMutableArray alloc] initWithCapacity:0];
//    for (NSDictionary *dict in arr) {
//   
//        
//        NSString *fkje = [dict analysisStrValueByKey:@"fkje"];
//
//        NSString *wfxw = [dict analysisStrValueByKey:@"wfxw"];
//        
//        NSString *fxjgmc = [dict analysisStrValueByKey:@"fxjgmc"];
//        
//   
//        NSString *wztype = [dict analysisStrValueByKey:@"wztype"];
//        NSString *wfdz = [dict analysisStrValueByKey:@"wfdz"];
//        //"wfsj":"2014-04-01 13:44:00.0",
//        NSString *wfsj = [dict analysisStrValueByKey:@"wfsj"];
//        if ([wfsj length] == 21) {
//            wfsj = [wfsj substringToIndex:19];
//        }
//        NSString *wfsj1 = [dict analysisStrValueByKey:@"wfsj1"];
//        
//        NSString *wfjfs = [dict analysisStrValueByKey:@"wfjfs"];
//       // NSString *cjjgmc = [dict analysisStrValueByKey:@"cjjgmc"];
//     //   NSString *dh = [dict analysisStrValueByKey:@"dh"];
//      //  NSString *ddms = [dict analysisStrValueByKey:@"ddms"];
//      //  NSString *ddms1 = [dict analysisStrValueByKey:@"ddms1"];
//        
////        NSString *wfdd = [dict analysisStrValueByKey:@"wfdd"];
////        NSString *wfdd1 = [dict analysisStrValueByKey:@"wfdd1"];
//        
//       // NSString *wfgd = [dict analysisStrValueByKey:@"wfgd"];
//      //  NSString *wfms = [dict analysisStrValueByKey:@"wfms"];
//        NSString *wfnr = [dict analysisStrValueByKey:@"wfnr"];
//       // NSString *qrbj = [dict analysisStrValueByKey:@"qrbj"];
//       // NSString *cfd = [dict analysisStrValueByKey:@"cfd"];
//      //  NSString *wzzt = [dict analysisStrValueByKey:@"wzzt"];
//      //  NSString *sd = [dict analysisStrValueByKey:@"sd"];
//     //   NSString *cjfs = [dict analysisStrValueByKey:@"cjfs"];
//        
//        
//        NSString    *znj = [dict analysisStrValueByKey:@"znj"];
//        NSString    *jdsbh = [dict analysisStrValueByKey:@"jdsbh"];
//        NSString    *fxjg = [dict analysisStrValueByKey:@"fxjg"];
//        NSString    *cljg = [dict analysisStrValueByKey:@"cljg"];
//        NSString    *cljgmc = [dict analysisStrValueByKey:@"cljgmc"];
//        NSString    *wsjyw = [dict analysisStrValueByKey:@"wsjyw"];
//        
//      //  NSString    *photoStauts = [dict analysisStrValueByKey:@"photostatus"];
//        
//       // NSString    *jszh = [dict analysisStrValueByKey:@"jszh"];
//      //  NSString    *clsj = [dict analysisStrValueByKey:@"clsj"];
//         NSString    *CanprocessMsg = [dict analysisStrValueByKey:@"CanprocessMsg"];
//        if (clsj.length == 21) {
//            clsj = [clsj substringToIndex:19];
//        }
//        
//        CarPeccancyMsg *pM = [[CarPeccancyMsg alloc] init];
//        pM.xh = xh;
//        pM.fkje = fkje;
//        pM.fltw = fltw;
//        pM.lddm = lddm;
//        pM.lddm1 = lddm1;
//        pM.wfxw = wfxw;
//        pM.fxjgmc = fxjgmc;
//        pM.cjjg = cjjg;
//        pM.dsr = dsr;
//        pM.wztype = wztype;
//        pM.wfdz = wfdz;
//        pM.wfsj = wfsj;
//        pM.wfsj1 = wfsj1;
//        pM.wfjfs = wfjfs;
//        pM.cjjgmc = cjjgmc;
//        pM.dh = dh;
//        pM.ddms = ddms;
//        pM.ddms1 = ddms1;
//        pM.wfdd = wfdd;
//        pM.wfdd1 = wfdd1;
//        pM.wfgd = wfgd;
//        pM.wfms = wfms;
//        pM.wfnr = wfnr;
//        pM.qrbj = qrbj;
//        pM.cfd = cfd;
//        pM.wzzt = wzzt;
//        pM.sd = sd;
//        pM.cjfs = cjfs;
//        
//        
//        pM.datasource = datasource;
//        pM.count = count;
//        pM.yxqz = yxqz;
//        pM.bxzzrq = bxzzrq;
//        
//        pM.hphm_head = hphm_head;
//        pM.syxz = syxz;
//        pM.cllx = cllx;
//        pM.dsrdz = dsrdz;
//        pM.sfzmhm = sfzmhm;
//        pM.dsr_jsonLastStr = dsr_jsonLastStr;
//        
//        pM.znj = znj;
//        pM.jdsbh = jdsbh;
//        pM.fxjg = fxjg;
//        pM.cljg = cljg;
//        pM.cljgmc = cljgmc;
//        pM.wsjyw = wsjyw;
//        pM.photostatus = photoStauts;
//        
//        pM.jszh = jszh;
//        pM.clsj = clsj;
//        
//        [carPeccancyMsgs addObject:pM];
//    }
//    
//    return carPeccancyMsgs;
//    
//
//
//}
//绑定车辆

+ (NSArray *)carPeccancyMsgAnalysis:(NSString*)jsonStr withHphm:(NSString*)hphm{
    SBJsonParser *parse = [[SBJsonParser alloc] init];
    //    jsonStr = @"{\"datasource\":\"01\",\"vehicles\":[{\"jszh\":\"46002219910228701X\",\"fkje\":100,\"clsj\":\"2014-11-22 10:11:47.0\",\"fltw\":\"《中华人民共和国道路交通安全法》第九十条、《实施办法》第82条第3项\",\"xxly\":\"2\",\"wfxw\":\"13521\",\"fxjgmc\":\"屯昌大队\",\"jdsbh\":\"469080190107790\",\"dsr\":\"沈名强\",\"wfdz\":\"海榆中线97公里00米\",\"wfsj\":\"2014-11-05 14:51:00.0\",\"wfjfs\":3,\"cljg\":\"469080000000\",\"wfdd\":\"10224\",\"cljgmc\":\"琼南车管所支队\",\"fxjg\":\"469022000000\",\"wfgd\":\"《中华人民共和国道路交通安全法》第四十二条、《中华人民共和国道路交通安全法实施条例》第四十五条、第四十六条\",\"wfms\":\"驾驶中型以上载客载货汽车、危险物品运输车辆以外的其他机动车行驶超过规定时速10%未达20%的\",\"wfnr\":\"驾驶中型以上载客载货汽车、危险物品运输车辆以外的其他机动车行驶超过规定时速10%未达20%的\",\"wzzt\":\"已确认\",\"sd\":\"海南\",\"znj\":0}],\"count\":1,\"琼ALJ692\":\"1\"}";
    NSDictionary *reqDic = [parse objectWithString:jsonStr];
    
    NSString *datasource = [reqDic analysisStrValueByKey:@"datasource"];
    NSString *count = [reqDic analysisStrValueByKey:@"count"];
    NSString *yxqz = [reqDic analysisStrValueByKey:@"yxqz"];
    NSString *bxzzrq = [reqDic analysisStrValueByKey:@"bxzzrq"];
    
    NSString *messStr = [reqDic analysisStrValueByKey:hphm];
    
    NSArray *strings = [Helper filtrateSubstringsFromString:messStr withCharstring:@","];
    NSString *hphm_head = @"";
    NSString *syxz = @"";
    NSString *cllx = @"";
    NSString *dsrdz = @"";
    NSString *sfzmhm = @"";
    NSString *dsr_jsonLastStr = @"";
    if ([strings count] > 5) {
        hphm_head = [strings objectAtIndex:0];
        syxz = [strings objectAtIndex:1];
        cllx = [strings objectAtIndex:2];
        dsrdz = [strings objectAtIndex:3];
        sfzmhm = [strings objectAtIndex:4];
        dsr_jsonLastStr = [strings objectAtIndex:5];
    }
    
    
    
    NSArray *arr = [reqDic objectForKey:@"vehicles"];
    NSMutableArray  *carPeccancyMsgs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dict in arr) {
        NSString *xh = [dict objectForKey:@"xh"];
        if (!xh) {
            xh = [SERVER_BACK_WITHOUT stringByAppendingString:[[NSDate date] string]];
        }
        
        NSString *fkje = [dict analysisStrValueByKey:@"fkje"];
        NSString *fltw = [dict analysisStrValueByKey:@"fltw"];
        NSString *lddm = [dict analysisStrValueByKey:@"lddm"];
        NSString *lddm1 = [dict analysisStrValueByKey:@"lddm1"];
        
        NSString *wfxw = [dict analysisStrValueByKey:@"wfxw"];
        NSString *fxjgmc = [dict analysisStrValueByKey:@"fxjgmc"];
        NSString *cjjg = [dict analysisStrValueByKey:@"cjjg"];
        NSString *dsr = [dict analysisStrValueByKey:@"dsr"];
        NSString *wztype = [dict analysisStrValueByKey:@"wztype"];
        NSString *wfdz = [dict analysisStrValueByKey:@"wfdz"];
        //"wfsj":"2014-04-01 13:44:00.0",
        NSString *wfsj = [dict analysisStrValueByKey:@"wfsj"];
        if ([wfsj length] == 21) {
            wfsj = [wfsj substringToIndex:19];
        }
        NSString *wfsj1 = [dict analysisStrValueByKey:@"wfsj1"];
        
        NSString *wfjfs = [dict analysisStrValueByKey:@"wfjfs"];
        NSString *cjjgmc = [dict analysisStrValueByKey:@"cjjgmc"];
        NSString *dh = [dict analysisStrValueByKey:@"dh"];
        NSString *ddms = [dict analysisStrValueByKey:@"ddms"];
        NSString *ddms1 = [dict analysisStrValueByKey:@"ddms1"];
        
        NSString *wfdd = [dict analysisStrValueByKey:@"wfdd"];
        NSString *wfdd1 = [dict analysisStrValueByKey:@"wfdd1"];
        
        NSString *wfgd = [dict analysisStrValueByKey:@"wfgd"];
        NSString *wfms = [dict analysisStrValueByKey:@"wfms"];
        NSString *wfnr = [dict analysisStrValueByKey:@"wfnr"];
        NSString *qrbj = [dict analysisStrValueByKey:@"qrbj"];
        NSString *cfd = [dict analysisStrValueByKey:@"cfd"];
        NSString *wzzt = [dict analysisStrValueByKey:@"wzzt"];
        NSString *sd = [dict analysisStrValueByKey:@"sd"];
        NSString *cjfs = [dict analysisStrValueByKey:@"cjfs"];
        
        
        NSString    *znj = [dict analysisStrValueByKey:@"znj"];
        NSString    *jdsbh = [dict analysisStrValueByKey:@"jdsbh"];
        NSString    *fxjg = [dict analysisStrValueByKey:@"fxjg"];
        NSString    *cljg = [dict analysisStrValueByKey:@"cljg"];
        NSString    *cljgmc = [dict analysisStrValueByKey:@"cljgmc"];
        NSString    *wsjyw = [dict analysisStrValueByKey:@"wsjyw"];
        
        NSString    *photoStauts = [dict analysisStrValueByKey:@"photostatus"];
        
        NSString    *jszh = [dict analysisStrValueByKey:@"jszh"];
        NSString    *clsj = [dict analysisStrValueByKey:@"clsj"];
        if (clsj.length == 21) {
            clsj = [clsj substringToIndex:19];
        }
        
        CarPeccancyMsg *pM = [[CarPeccancyMsg alloc] init];
        pM.xh = xh;
        pM.fkje = fkje;
        pM.fltw = fltw;
        pM.lddm = lddm;
        pM.lddm1 = lddm1;
        pM.wfxw = wfxw;
        pM.fxjgmc = fxjgmc;
        pM.cjjg = cjjg;
        pM.dsr = dsr;
        pM.wztype = wztype;
        pM.wfdz = wfdz;
        pM.wfsj = wfsj;
        pM.wfsj1 = wfsj1;
        pM.wfjfs = wfjfs;
        pM.cjjgmc = cjjgmc;
        pM.dh = dh;
        pM.ddms = ddms;
        pM.ddms1 = ddms1;
        pM.wfdd = wfdd;
        pM.wfdd1 = wfdd1;
        pM.wfgd = wfgd;
        pM.wfms = wfms;
        pM.wfnr = wfnr;
        pM.qrbj = qrbj;
        pM.cfd = cfd;
        pM.wzzt = wzzt;
        pM.sd = sd;
        pM.cjfs = cjfs;
        
        
        pM.datasource = datasource;
        pM.count = count;
        pM.yxqz = yxqz;
        pM.bxzzrq = bxzzrq;
        
        pM.hphm_head = hphm_head;
        pM.syxz = syxz;
        pM.cllx = cllx;
        pM.dsrdz = dsrdz;
        pM.sfzmhm = sfzmhm;
        pM.dsr_jsonLastStr = dsr_jsonLastStr;
        
        pM.znj = znj;
        pM.jdsbh = jdsbh;
        pM.fxjg = fxjg;
        pM.cljg = cljg;
        pM.cljgmc = cljgmc;
        pM.wsjyw = wsjyw;
        pM.photostatus = photoStauts;
        
        pM.jszh = jszh;
        pM.clsj = clsj;
        
        [carPeccancyMsgs addObject:pM];
    }
    
    return carPeccancyMsgs;
    
}

+ (NSArray *)drivePeccancyMsgAnalysis:(NSString*)jsonStr{
    SBJsonParser *parse = [[SBJsonParser alloc] init];
    NSDictionary *resDict = [parse objectWithString:jsonStr];
    NSString *datasource = [resDict objectForKey:@"datasource"];
    
    NSArray *arr = [resDict objectForKey:@"violationhis"];
    NSMutableArray *driveLicensePeccancyMsgs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dict in arr) {
        NSString *fkje = [dict analysisStrValueByKey:@"fkje"];
        NSString *hphm = [dict analysisStrValueByKey:@"hphm"];
        NSString *wfxw = [dict analysisStrValueByKey:@"wfxw"];
        NSString *fxjgmc = [dict analysisStrValueByKey:@"fxjgmc"];
        NSString *jdsbh = [dict analysisStrValueByKey:@"jdsbh"];
        NSString *dsr = [dict analysisStrValueByKey:@"dsr"];
        NSString *jkbj = [dict analysisStrValueByKey:@"jkbj"];
        
        NSString *wfdz = [dict analysisStrValueByKey:@"wfdz"];
        NSString *wfsj = [dict analysisStrValueByKey:@"wfsj"];
        if ([wfsj length] == 21) {
            wfsj = [wfsj substringToIndex:19];
        }
        NSString *wfjfs = [dict analysisStrValueByKey:@"wfjfs"];
        NSString *wfdd = [dict analysisStrValueByKey:@"wfdd"];
        
        NSString *fxjg = [dict analysisStrValueByKey:@"fxjg"];
        NSString *znj = [dict analysisStrValueByKey:@"znj"];
        NSString *wfms = [dict analysisStrValueByKey:@"wfms"];
        NSString *wfnr = [dict analysisStrValueByKey:@"wfnr"];
        
        DriveLicensePeccancyMsg *pm = [[DriveLicensePeccancyMsg alloc] init];
        pm.fkje = fkje;
        pm.hphm = hphm;
        pm.wfxw = wfxw;
        pm.fxjgmc = fxjgmc;
        pm.jdsbh = jdsbh;
        pm.dsr = dsr;
        pm.jkbj = jkbj;
        pm.wfdz = wfdz;
        pm.wfsj = wfsj;
        pm.wfjfs = wfjfs;
        pm.wfdd = wfdd;
        pm.fxjg = fxjg;
        pm.znj = znj;
        pm.wfms = wfms;
        pm.wfnr = wfnr;
        pm.datasource = datasource;
        
        [driveLicensePeccancyMsgs addObject:pm];
    }
    
    
    
    return driveLicensePeccancyMsgs;
    
}


+ (NSArray *)jdsbhSearchPeccancyMsgAnalysis:(NSArray*)violationArr{
    NSMutableArray *peccancyMsgs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dict in violationArr) {
        NSString *cljg = [dict analysisStrValueByKey:@"cljg"];
        NSString *cljgmc = [dict analysisStrValueByKey:@"cljgmc"];
        NSString *clsj = [dict analysisStrValueByKey:@"clsj"];
        if (clsj.length == 21) {
            clsj = [clsj substringToIndex:19];
        }
        NSString *dsr = [dict analysisStrValueByKey:@"dsr"];
        
        NSString *fkje = [dict analysisStrValueByKey:@"fkje"];
        NSString *fxjg = [dict analysisStrValueByKey:@"fxjg"];
        NSString *fxjgmc = [dict analysisStrValueByKey:@"fxjgmc"];
        NSString *hphm = [dict analysisStrValueByKey:@"hphm"];
        
        NSString *jdsbh = [dict analysisStrValueByKey:@"jdsbh"];
        NSString *jkbj = [dict analysisStrValueByKey:@"jkbj"];
        NSString *wfdd = [dict analysisStrValueByKey:@"wfdd"];
        NSString *wfdz = [dict analysisStrValueByKey:@"wfdz"];
        
        NSString *wfjfs = [dict analysisStrValueByKey:@"wfjfs"];
        NSString *wfms = [dict analysisStrValueByKey:@"wfms"];
        NSString *wfnr = [dict analysisStrValueByKey:@"wfnr"];
        NSString *wfsj = [dict analysisStrValueByKey:@"wfsj"];
        if (wfsj.length > 19) {
            wfsj = [wfsj substringToIndex:19];
        }
        
        NSString *wfxw = [dict analysisStrValueByKey:@"wfxw"];
        NSString *wsjyw = [dict analysisStrValueByKey:@"wsjyw"];
        NSString *wztype = [dict analysisStrValueByKey:@"wztype"];
        NSString *znj = [dict analysisStrValueByKey:@"znj"];
        
        PeccancyMsg *p = [[PeccancyMsg alloc] init];
        p.cljg = cljg;
        p.cljgmc = cljgmc;
        p.clsj = clsj;
        p.dsr = dsr;
        
        p.fkje = fkje;
        p.fxjg = fxjg;
        p.fxjgmc = fxjgmc;
        p.hphm = hphm;
        
        p.jdsbh = jdsbh;
        p.jkbj = jkbj;
        p.wfdd = wfdd;
        p.wfdz = wfdz;
        
        p.wfjfs = wfjfs;
        p.wfms = wfms;
        p.wfnr = wfnr;
        p.wfsj = wfsj;
        
        p.wfxw = wfxw;
        p.wsjyw = wsjyw;
        p.wztype = wztype;
        p.znj = znj;
        
        [peccancyMsgs addObject:p];
    }
    return peccancyMsgs;
}








#if 0
+ (char)getShellByChinese:(unsigned short) hanzi
{
    // 汉字拼音首字母列表 本列表包含了20902个汉字,收录的字符的Unicode编码范围为19968至40869
    NSString* strChineseFirstPY = @"YDYQSXMWZSSXJBYMGCCZQPSSQBYCDSCDQLDYLYBSSJGYZZJJFKCCLZDHWDWZJLJPFYYNWJJTMYHZWZHFLZPPQHGSCYYYNJQYXXGJHHSDSJNKKTMOMLCRXYPSNQSECCQZGGLLYJLMYZZSECYKYYHQWJSSGGYXYZYJWWKDJHYCHMYXJTLXJYQBYXZLDWRDJRWYSRLDZJPCBZJJBRCFTLECZSTZFXXZHTRQHYBDLYCZSSYMMRFMYQZPWWJJYFCRWFDFZQPYDDWYXKYJAWJFFXYPSFTZYHHYZYSWCJYXSCLCXXWZZXNBGNNXBXLZSZSBSGPYSYZDHMDZBQBZCWDZZYYTZHBTSYYBZGNTNXQYWQSKBPHHLXGYBFMJEBJHHGQTJCYSXSTKZHLYCKGLYSMZXYALMELDCCXGZYRJXSDLTYZCQKCNNJWHJTZZCQLJSTSTBNXBTYXCEQXGKWJYFLZQLYHYXSPSFXLMPBYSXXXYDJCZYLLLSJXFHJXPJBTFFYABYXBHZZBJYZLWLCZGGBTSSMDTJZXPTHYQTGLJSCQFZKJZJQNLZWLSLHDZBWJNCJZYZSQQYCQYRZCJJWYBRTWPYFTWEXCSKDZCTBZHYZZYYJXZCFFZZMJYXXSDZZOTTBZLQWFCKSZSXFYRLNYJMBDTHJXSQQCCSBXYYTSYFBXDZTGBCNSLCYZZPSAZYZZSCJCSHZQYDXLBPJLLMQXTYDZXSQJTZPXLCGLQTZWJBHCTSYJSFXYEJJTLBGXSXJMYJQQPFZASYJNTYDJXKJCDJSZCBARTDCLYJQMWNQNCLLLKBYBZZSYHQQLTWLCCXTXLLZNTYLNEWYZYXCZXXGRKRMTCNDNJTSYYSSDQDGHSDBJGHRWRQLYBGLXHLGTGXBQJDZPYJSJYJCTMRNYMGRZJCZGJMZMGXMPRYXKJNYMSGMZJYMKMFXMLDTGFBHCJHKYLPFMDXLQJJSMTQGZSJLQDLDGJYCALCMZCSDJLLNXDJFFFFJCZFMZFFPFKHKGDPSXKTACJDHHZDDCRRCFQYJKQCCWJDXHWJLYLLZGCFCQDSMLZPBJJPLSBCJGGDCKKDEZSQCCKJGCGKDJTJDLZYCXKLQSCGJCLTFPCQCZGWPJDQYZJJBYJHSJDZWGFSJGZKQCCZLLPSPKJGQJHZZLJPLGJGJJTHJJYJZCZMLZLYQBGJWMLJKXZDZNJQSYZMLJLLJKYWXMKJLHSKJGBMCLYYMKXJQLBMLLKMDXXKWYXYSLMLPSJQQJQXYXFJTJDXMXXLLCXQBSYJBGWYMBGGBCYXPJYGPEPFGDJGBHBNSQJYZJKJKHXQFGQZKFHYGKHDKLLSDJQXPQYKYBNQSXQNSZSWHBSXWHXWBZZXDMNSJBSBKBBZKLYLXGWXDRWYQZMYWSJQLCJXXJXKJEQXSCYETLZHLYYYSDZPAQYZCMTLSHTZCFYZYXYLJSDCJQAGYSLCQLYYYSHMRQQKLDXZSCSSSYDYCJYSFSJBFRSSZQSBXXPXJYSDRCKGJLGDKZJZBDKTCSYQPYHSTCLDJDHMXMCGXYZHJDDTMHLTXZXYLYMOHYJCLTYFBQQXPFBDFHHTKSQHZYYWCNXXCRWHOWGYJLEGWDQCWGFJYCSNTMYTOLBYGWQWESJPWNMLRYDZSZTXYQPZGCWXHNGPYXSHMYQJXZTDPPBFYHZHTJYFDZWKGKZBLDNTSXHQEEGZZYLZMMZYJZGXZXKHKSTXNXXWYLYAPSTHXDWHZYMPXAGKYDXBHNHXKDPJNMYHYLPMGOCSLNZHKXXLPZZLBMLSFBHHGYGYYGGBHSCYAQTYWLXTZQCEZYDQDQMMHTKLLSZHLSJZWFYHQSWSCWLQAZYNYTLSXTHAZNKZZSZZLAXXZWWCTGQQTDDYZTCCHYQZFLXPSLZYGPZSZNGLNDQTBDLXGTCTAJDKYWNSYZLJHHZZCWNYYZYWMHYCHHYXHJKZWSXHZYXLYSKQYSPSLYZWMYPPKBYGLKZHTYXAXQSYSHXASMCHKDSCRSWJPWXSGZJLWWSCHSJHSQNHCSEGNDAQTBAALZZMSSTDQJCJKTSCJAXPLGGXHHGXXZCXPDMMHLDGTYBYSJMXHMRCPXXJZCKZXSHMLQXXTTHXWZFKHCCZDYTCJYXQHLXDHYPJQXYLSYYDZOZJNYXQEZYSQYAYXWYPDGXDDXSPPYZNDLTWRHXYDXZZJHTCXMCZLHPYYYYMHZLLHNXMYLLLMDCPPXHMXDKYCYRDLTXJCHHZZXZLCCLYLNZSHZJZZLNNRLWHYQSNJHXYNTTTKYJPYCHHYEGKCTTWLGQRLGGTGTYGYHPYHYLQYQGCWYQKPYYYTTTTLHYHLLTYTTSPLKYZXGZWGPYDSSZZDQXSKCQNMJJZZBXYQMJRTFFBTKHZKBXLJJKDXJTLBWFZPPTKQTZTGPDGNTPJYFALQMKGXBDCLZFHZCLLLLADPMXDJHLCCLGYHDZFGYDDGCYYFGYDXKSSEBDHYKDKDKHNAXXYBPBYYHXZQGAFFQYJXDMLJCSQZLLPCHBSXGJYNDYBYQSPZWJLZKSDDTACTBXZDYZYPJZQSJNKKTKNJDJGYYPGTLFYQKASDNTCYHBLWDZHBBYDWJRYGKZYHEYYFJMSDTYFZJJHGCXPLXHLDWXXJKYTCYKSSSMTWCTTQZLPBSZDZWZXGZAGYKTYWXLHLSPBCLLOQMMZSSLCMBJCSZZKYDCZJGQQDSMCYTZQQLWZQZXSSFPTTFQMDDZDSHDTDWFHTDYZJYQJQKYPBDJYYXTLJHDRQXXXHAYDHRJLKLYTWHLLRLLRCXYLBWSRSZZSYMKZZHHKYHXKSMDSYDYCJPBZBSQLFCXXXNXKXWYWSDZYQOGGQMMYHCDZTTFJYYBGSTTTYBYKJDHKYXBELHTYPJQNFXFDYKZHQKZBYJTZBXHFDXKDASWTAWAJLDYJSFHBLDNNTNQJTJNCHXFJSRFWHZFMDRYJYJWZPDJKZYJYMPCYZNYNXFBYTFYFWYGDBNZZZDNYTXZEMMQBSQEHXFZMBMFLZZSRXYMJGSXWZJSPRYDJSJGXHJJGLJJYNZZJXHGXKYMLPYYYCXYTWQZSWHWLYRJLPXSLSXMFSWWKLCTNXNYNPSJSZHDZEPTXMYYWXYYSYWLXJQZQXZDCLEEELMCPJPCLWBXSQHFWWTFFJTNQJHJQDXHWLBYZNFJLALKYYJLDXHHYCSTYYWNRJYXYWTRMDRQHWQCMFJDYZMHMYYXJWMYZQZXTLMRSPWWCHAQBXYGZYPXYYRRCLMPYMGKSJSZYSRMYJSNXTPLNBAPPYPYLXYYZKYNLDZYJZCZNNLMZHHARQMPGWQTZMXXMLLHGDZXYHXKYXYCJMFFYYHJFSBSSQLXXNDYCANNMTCJCYPRRNYTYQNYYMBMSXNDLYLYSLJRLXYSXQMLLYZLZJJJKYZZCSFBZXXMSTBJGNXYZHLXNMCWSCYZYFZLXBRNNNYLBNRTGZQYSATSWRYHYJZMZDHZGZDWYBSSCSKXSYHYTXXGCQGXZZSHYXJSCRHMKKBXCZJYJYMKQHZJFNBHMQHYSNJNZYBKNQMCLGQHWLZNZSWXKHLJHYYBQLBFCDSXDLDSPFZPSKJYZWZXZDDXJSMMEGJSCSSMGCLXXKYYYLNYPWWWGYDKZJGGGZGGSYCKNJWNJPCXBJJTQTJWDSSPJXZXNZXUMELPXFSXTLLXCLJXJJLJZXCTPSWXLYDHLYQRWHSYCSQYYBYAYWJJJQFWQCQQCJQGXALDBZZYJGKGXPLTZYFXJLTPADKYQHPMATLCPDCKBMTXYBHKLENXDLEEGQDYMSAWHZMLJTWYGXLYQZLJEEYYBQQFFNLYXRDSCTGJGXYYNKLLYQKCCTLHJLQMKKZGCYYGLLLJDZGYDHZWXPYSJBZKDZGYZZHYWYFQYTYZSZYEZZLYMHJJHTSMQWYZLKYYWZCSRKQYTLTDXWCTYJKLWSQZWBDCQYNCJSRSZJLKCDCDTLZZZACQQZZDDXYPLXZBQJYLZLLLQDDZQJYJYJZYXNYYYNYJXKXDAZWYRDLJYYYRJLXLLDYXJCYWYWNQCCLDDNYYYNYCKCZHXXCCLGZQJGKWPPCQQJYSBZZXYJSQPXJPZBSBDSFNSFPZXHDWZTDWPPTFLZZBZDMYYPQJRSDZSQZSQXBDGCPZSWDWCSQZGMDHZXMWWFYBPDGPHTMJTHZSMMBGZMBZJCFZWFZBBZMQCFMBDMCJXLGPNJBBXGYHYYJGPTZGZMQBQTCGYXJXLWZKYDPDYMGCFTPFXYZTZXDZXTGKMTYBBCLBJASKYTSSQYYMSZXFJEWLXLLSZBQJJJAKLYLXLYCCTSXMCWFKKKBSXLLLLJYXTYLTJYYTDPJHNHNNKBYQNFQYYZBYYESSESSGDYHFHWTCJBSDZZTFDMXHCNJZYMQWSRYJDZJQPDQBBSTJGGFBKJBXTGQHNGWJXJGDLLTHZHHYYYYYYSXWTYYYCCBDBPYPZYCCZYJPZYWCBDLFWZCWJDXXHYHLHWZZXJTCZLCDPXUJCZZZLYXJJTXPHFXWPYWXZPTDZZBDZCYHJHMLXBQXSBYLRDTGJRRCTTTHYTCZWMXFYTWWZCWJWXJYWCSKYBZSCCTZQNHXNWXXKHKFHTSWOCCJYBCMPZZYKBNNZPBZHHZDLSYDDYTYFJPXYNGFXBYQXCBHXCPSXTYZDMKYSNXSXLHKMZXLYHDHKWHXXSSKQYHHCJYXGLHZXCSNHEKDTGZXQYPKDHEXTYKCNYMYYYPKQYYYKXZLTHJQTBYQHXBMYHSQCKWWYLLHCYYLNNEQXQWMCFBDCCMLJGGXDQKTLXKGNQCDGZJWYJJLYHHQTTTNWCHMXCXWHWSZJYDJCCDBQCDGDNYXZTHCQRXCBHZTQCBXWGQWYYBXHMBYMYQTYEXMQKYAQYRGYZSLFYKKQHYSSQYSHJGJCNXKZYCXSBXYXHYYLSTYCXQTHYSMGSCPMMGCCCCCMTZTASMGQZJHKLOSQYLSWTMXSYQKDZLJQQYPLSYCZTCQQPBBQJZCLPKHQZYYXXDTDDTSJCXFFLLCHQXMJLWCJCXTSPYCXNDTJSHJWXDQQJSKXYAMYLSJHMLALYKXCYYDMNMDQMXMCZNNCYBZKKYFLMCHCMLHXRCJJHSYLNMTJZGZGYWJXSRXCWJGJQHQZDQJDCJJZKJKGDZQGJJYJYLXZXXCDQHHHEYTMHLFSBDJSYYSHFYSTCZQLPBDRFRZTZYKYWHSZYQKWDQZRKMSYNBCRXQBJYFAZPZZEDZCJYWBCJWHYJBQSZYWRYSZPTDKZPFPBNZTKLQYHBBZPNPPTYZZYBQNYDCPJMMCYCQMCYFZZDCMNLFPBPLNGQJTBTTNJZPZBBZNJKLJQYLNBZQHKSJZNGGQSZZKYXSHPZSNBCGZKDDZQANZHJKDRTLZLSWJLJZLYWTJNDJZJHXYAYNCBGTZCSSQMNJPJYTYSWXZFKWJQTKHTZPLBHSNJZSYZBWZZZZLSYLSBJHDWWQPSLMMFBJDWAQYZTCJTBNNWZXQXCDSLQGDSDPDZHJTQQPSWLYYJZLGYXYZLCTCBJTKTYCZJTQKBSJLGMGZDMCSGPYNJZYQYYKNXRPWSZXMTNCSZZYXYBYHYZAXYWQCJTLLCKJJTJHGDXDXYQYZZBYWDLWQCGLZGJGQRQZCZSSBCRPCSKYDZNXJSQGXSSJMYDNSTZTPBDLTKZWXQWQTZEXNQCZGWEZKSSBYBRTSSSLCCGBPSZQSZLCCGLLLZXHZQTHCZMQGYZQZNMCOCSZJMMZSQPJYGQLJYJPPLDXRGZYXCCSXHSHGTZNLZWZKJCXTCFCJXLBMQBCZZWPQDNHXLJCTHYZLGYLNLSZZPCXDSCQQHJQKSXZPBAJYEMSMJTZDXLCJYRYYNWJBNGZZTMJXLTBSLYRZPYLSSCNXPHLLHYLLQQZQLXYMRSYCXZLMMCZLTZSDWTJJLLNZGGQXPFSKYGYGHBFZPDKMWGHCXMSGDXJMCJZDYCABXJDLNBCDQYGSKYDQTXDJJYXMSZQAZDZFSLQXYJSJZYLBTXXWXQQZBJZUFBBLYLWDSLJHXJYZJWTDJCZFQZQZZDZSXZZQLZCDZFJHYSPYMPQZMLPPLFFXJJNZZYLSJEYQZFPFZKSYWJJJHRDJZZXTXXGLGHYDXCSKYSWMMZCWYBAZBJKSHFHJCXMHFQHYXXYZFTSJYZFXYXPZLCHMZMBXHZZSXYFYMNCWDABAZLXKTCSHHXKXJJZJSTHYGXSXYYHHHJWXKZXSSBZZWHHHCWTZZZPJXSNXQQJGZYZYWLLCWXZFXXYXYHXMKYYSWSQMNLNAYCYSPMJKHWCQHYLAJJMZXHMMCNZHBHXCLXTJPLTXYJHDYYLTTXFSZHYXXSJBJYAYRSMXYPLCKDUYHLXRLNLLSTYZYYQYGYHHSCCSMZCTZQXKYQFPYYRPFFLKQUNTSZLLZMWWTCQQYZWTLLMLMPWMBZSSTZRBPDDTLQJJBXZCSRZQQYGWCSXFWZLXCCRSZDZMCYGGDZQSGTJSWLJMYMMZYHFBJDGYXCCPSHXNZCSBSJYJGJMPPWAFFYFNXHYZXZYLREMZGZCYZSSZDLLJCSQFNXZKPTXZGXJJGFMYYYSNBTYLBNLHPFZDCYFBMGQRRSSSZXYSGTZRNYDZZCDGPJAFJFZKNZBLCZSZPSGCYCJSZLMLRSZBZZLDLSLLYSXSQZQLYXZLSKKBRXBRBZCYCXZZZEEYFGKLZLYYHGZSGZLFJHGTGWKRAAJYZKZQTSSHJJXDCYZUYJLZYRZDQQHGJZXSSZBYKJPBFRTJXLLFQWJHYLQTYMBLPZDXTZYGBDHZZRBGXHWNJTJXLKSCFSMWLSDQYSJTXKZSCFWJLBXFTZLLJZLLQBLSQMQQCGCZFPBPHZCZJLPYYGGDTGWDCFCZQYYYQYSSCLXZSKLZZZGFFCQNWGLHQYZJJCZLQZZYJPJZZBPDCCMHJGXDQDGDLZQMFGPSYTSDYFWWDJZJYSXYYCZCYHZWPBYKXRYLYBHKJKSFXTZJMMCKHLLTNYYMSYXYZPYJQYCSYCWMTJJKQYRHLLQXPSGTLYYCLJSCPXJYZFNMLRGJJTYZBXYZMSJYJHHFZQMSYXRSZCWTLRTQZSSTKXGQKGSPTGCZNJSJCQCXHMXGGZTQYDJKZDLBZSXJLHYQGGGTHQSZPYHJHHGYYGKGGCWJZZYLCZLXQSFTGZSLLLMLJSKCTBLLZZSZMMNYTPZSXQHJCJYQXYZXZQZCPSHKZZYSXCDFGMWQRLLQXRFZTLYSTCTMJCXJJXHJNXTNRZTZFQYHQGLLGCXSZSJDJLJCYDSJTLNYXHSZXCGJZYQPYLFHDJSBPCCZHJJJQZJQDYBSSLLCMYTTMQTBHJQNNYGKYRQYQMZGCJKPDCGMYZHQLLSLLCLMHOLZGDYYFZSLJCQZLYLZQJESHNYLLJXGJXLYSYYYXNBZLJSSZCQQCJYLLZLTJYLLZLLBNYLGQCHXYYXOXCXQKYJXXXYKLXSXXYQXCYKQXQCSGYXXYQXYGYTQOHXHXPYXXXULCYEYCHZZCBWQBBWJQZSCSZSSLZYLKDESJZWMYMCYTSDSXXSCJPQQSQYLYYZYCMDJDZYWCBTJSYDJKCYDDJLBDJJSODZYSYXQQYXDHHGQQYQHDYXWGMMMAJDYBBBPPBCMUUPLJZSMTXERXJMHQNUTPJDCBSSMSSSTKJTSSMMTRCPLZSZMLQDSDMJMQPNQDXCFYNBFSDQXYXHYAYKQYDDLQYYYSSZBYDSLNTFQTZQPZMCHDHCZCWFDXTMYQSPHQYYXSRGJCWTJTZZQMGWJJTJHTQJBBHWZPXXHYQFXXQYWYYHYSCDYDHHQMNMTMWCPBSZPPZZGLMZFOLLCFWHMMSJZTTDHZZYFFYTZZGZYSKYJXQYJZQBHMBZZLYGHGFMSHPZFZSNCLPBQSNJXZSLXXFPMTYJYGBXLLDLXPZJYZJYHHZCYWHJYLSJEXFSZZYWXKZJLUYDTMLYMQJPWXYHXSKTQJEZRPXXZHHMHWQPWQLYJJQJJZSZCPHJLCHHNXJLQWZJHBMZYXBDHHYPZLHLHLGFWLCHYYTLHJXCJMSCPXSTKPNHQXSRTYXXTESYJCTLSSLSTDLLLWWYHDHRJZSFGXTSYCZYNYHTDHWJSLHTZDQDJZXXQHGYLTZPHCSQFCLNJTCLZPFSTPDYNYLGMJLLYCQHYSSHCHYLHQYQTMZYPBYWRFQYKQSYSLZDQJMPXYYSSRHZJNYWTQDFZBWWTWWRXCWHGYHXMKMYYYQMSMZHNGCEPMLQQMTCWCTMMPXJPJJHFXYYZSXZHTYBMSTSYJTTQQQYYLHYNPYQZLCYZHZWSMYLKFJXLWGXYPJYTYSYXYMZCKTTWLKSMZSYLMPWLZWXWQZSSAQSYXYRHSSNTSRAPXCPWCMGDXHXZDZYFJHGZTTSBJHGYZSZYSMYCLLLXBTYXHBBZJKSSDMALXHYCFYGMQYPJYCQXJLLLJGSLZGQLYCJCCZOTYXMTMTTLLWTGPXYMZMKLPSZZZXHKQYSXCTYJZYHXSHYXZKXLZWPSQPYHJWPJPWXQQYLXSDHMRSLZZYZWTTCYXYSZZSHBSCCSTPLWSSCJCHNLCGCHSSPHYLHFHHXJSXYLLNYLSZDHZXYLSXLWZYKCLDYAXZCMDDYSPJTQJZLNWQPSSSWCTSTSZLBLNXSMNYYMJQBQHRZWTYYDCHQLXKPZWBGQYBKFCMZWPZLLYYLSZYDWHXPSBCMLJBSCGBHXLQHYRLJXYSWXWXZSLDFHLSLYNJLZYFLYJYCDRJLFSYZFSLLCQYQFGJYHYXZLYLMSTDJCYHBZLLNWLXXYGYYHSMGDHXXHHLZZJZXCZZZCYQZFNGWPYLCPKPYYPMCLQKDGXZGGWQBDXZZKZFBXXLZXJTPJPTTBYTSZZDWSLCHZHSLTYXHQLHYXXXYYZYSWTXZKHLXZXZPYHGCHKCFSYHUTJRLXFJXPTZTWHPLYXFCRHXSHXKYXXYHZQDXQWULHYHMJTBFLKHTXCWHJFWJCFPQRYQXCYYYQYGRPYWSGSUNGWCHKZDXYFLXXHJJBYZWTSXXNCYJJYMSWZJQRMHXZWFQSYLZJZGBHYNSLBGTTCSYBYXXWXYHXYYXNSQYXMQYWRGYQLXBBZLJSYLPSYTJZYHYZAWLRORJMKSCZJXXXYXCHDYXRYXXJDTSQFXLYLTSFFYXLMTYJMJUYYYXLTZCSXQZQHZXLYYXZHDNBRXXXJCTYHLBRLMBRLLAXKYLLLJLYXXLYCRYLCJTGJCMTLZLLCYZZPZPCYAWHJJFYBDYYZSMPCKZDQYQPBPCJPDCYZMDPBCYYDYCNNPLMTMLRMFMMGWYZBSJGYGSMZQQQZTXMKQWGXLLPJGZBQCDJJJFPKJKCXBLJMSWMDTQJXLDLPPBXCWRCQFBFQJCZAHZGMYKPHYYHZYKNDKZMBPJYXPXYHLFPNYYGXJDBKXNXHJMZJXSTRSTLDXSKZYSYBZXJLXYSLBZYSLHXJPFXPQNBYLLJQKYGZMCYZZYMCCSLCLHZFWFWYXZMWSXTYNXJHPYYMCYSPMHYSMYDYSHQYZCHMJJMZCAAGCFJBBHPLYZYLXXSDJGXDHKXXTXXNBHRMLYJSLTXMRHNLXQJXYZLLYSWQGDLBJHDCGJYQYCMHWFMJYBMBYJYJWYMDPWHXQLDYGPDFXXBCGJSPCKRSSYZJMSLBZZJFLJJJLGXZGYXYXLSZQYXBEXYXHGCXBPLDYHWETTWWCJMBTXCHXYQXLLXFLYXLLJLSSFWDPZSMYJCLMWYTCZPCHQEKCQBWLCQYDPLQPPQZQFJQDJHYMMCXTXDRMJWRHXCJZYLQXDYYNHYYHRSLSRSYWWZJYMTLTLLGTQCJZYABTCKZCJYCCQLJZQXALMZYHYWLWDXZXQDLLQSHGPJFJLJHJABCQZDJGTKHSSTCYJLPSWZLXZXRWGLDLZRLZXTGSLLLLZLYXXWGDZYGBDPHZPBRLWSXQBPFDWOFMWHLYPCBJCCLDMBZPBZZLCYQXLDOMZBLZWPDWYYGDSTTHCSQSCCRSSSYSLFYBFNTYJSZDFNDPDHDZZMBBLSLCMYFFGTJJQWFTMTPJWFNLBZCMMJTGBDZLQLPYFHYYMJYLSDCHDZJWJCCTLJCLDTLJJCPDDSQDSSZYBNDBJLGGJZXSXNLYCYBJXQYCBYLZCFZPPGKCXZDZFZTJJFJSJXZBNZYJQTTYJYHTYCZHYMDJXTTMPXSPLZCDWSLSHXYPZGTFMLCJTYCBPMGDKWYCYZCDSZZYHFLYCTYGWHKJYYLSJCXGYWJCBLLCSNDDBTZBSCLYZCZZSSQDLLMQYYHFSLQLLXFTYHABXGWNYWYYPLLSDLDLLBJCYXJZMLHLJDXYYQYTDLLLBUGBFDFBBQJZZMDPJHGCLGMJJPGAEHHBWCQXAXHHHZCHXYPHJAXHLPHJPGPZJQCQZGJJZZUZDMQYYBZZPHYHYBWHAZYJHYKFGDPFQSDLZMLJXKXGALXZDAGLMDGXMWZQYXXDXXPFDMMSSYMPFMDMMKXKSYZYSHDZKXSYSMMZZZMSYDNZZCZXFPLSTMZDNMXCKJMZTYYMZMZZMSXHHDCZJEMXXKLJSTLWLSQLYJZLLZJSSDPPMHNLZJCZYHMXXHGZCJMDHXTKGRMXFWMCGMWKDTKSXQMMMFZZYDKMSCLCMPCGMHSPXQPZDSSLCXKYXTWLWJYAHZJGZQMCSNXYYMMPMLKJXMHLMLQMXCTKZMJQYSZJSYSZHSYJZJCDAJZYBSDQJZGWZQQXFKDMSDJLFWEHKZQKJPEYPZYSZCDWYJFFMZZYLTTDZZEFMZLBNPPLPLPEPSZALLTYLKCKQZKGENQLWAGYXYDPXLHSXQQWQCQXQCLHYXXMLYCCWLYMQYSKGCHLCJNSZKPYZKCQZQLJPDMDZHLASXLBYDWQLWDNBQCRYDDZTJYBKBWSZDXDTNPJDTCTQDFXQQMGNXECLTTBKPWSLCTYQLPWYZZKLPYGZCQQPLLKCCYLPQMZCZQCLJSLQZDJXLDDHPZQDLJJXZQDXYZQKZLJCYQDYJPPYPQYKJYRMPCBYMCXKLLZLLFQPYLLLMBSGLCYSSLRSYSQTMXYXZQZFDZUYSYZTFFMZZSMZQHZSSCCMLYXWTPZGXZJGZGSJSGKDDHTQGGZLLBJDZLCBCHYXYZHZFYWXYZYMSDBZZYJGTSMTFXQYXQSTDGSLNXDLRYZZLRYYLXQHTXSRTZNGZXBNQQZFMYKMZJBZYMKBPNLYZPBLMCNQYZZZSJZHJCTZKHYZZJRDYZHNPXGLFZTLKGJTCTSSYLLGZRZBBQZZKLPKLCZYSSUYXBJFPNJZZXCDWXZYJXZZDJJKGGRSRJKMSMZJLSJYWQSKYHQJSXPJZZZLSNSHRNYPZTWCHKLPSRZLZXYJQXQKYSJYCZTLQZYBBYBWZPQDWWYZCYTJCJXCKCWDKKZXSGKDZXWWYYJQYYTCYTDLLXWKCZKKLCCLZCQQDZLQLCSFQCHQHSFSMQZZLNBJJZBSJHTSZDYSJQJPDLZCDCWJKJZZLPYCGMZWDJJBSJQZSYZYHHXJPBJYDSSXDZNCGLQMBTSFSBPDZDLZNFGFJGFSMPXJQLMBLGQCYYXBQKDJJQYRFKZTJDHCZKLBSDZCFJTPLLJGXHYXZCSSZZXSTJYGKGCKGYOQXJPLZPBPGTGYJZGHZQZZLBJLSQFZGKQQJZGYCZBZQTLDXRJXBSXXPZXHYZYCLWDXJJHXMFDZPFZHQHQMQGKSLYHTYCGFRZGNQXCLPDLBZCSCZQLLJBLHBZCYPZZPPDYMZZSGYHCKCPZJGSLJLNSCDSLDLXBMSTLDDFJMKDJDHZLZXLSZQPQPGJLLYBDSZGQLBZLSLKYYHZTTNTJYQTZZPSZQZTLLJTYYLLQLLQYZQLBDZLSLYYZYMDFSZSNHLXZNCZQZPBWSKRFBSYZMTHBLGJPMCZZLSTLXSHTCSYZLZBLFEQHLXFLCJLYLJQCBZLZJHHSSTBRMHXZHJZCLXFNBGXGTQJCZTMSFZKJMSSNXLJKBHSJXNTNLZDNTLMSJXGZJYJCZXYJYJWRWWQNZTNFJSZPZSHZJFYRDJSFSZJZBJFZQZZHZLXFYSBZQLZSGYFTZDCSZXZJBQMSZKJRHYJZCKMJKHCHGTXKXQGLXPXFXTRTYLXJXHDTSJXHJZJXZWZLCQSBTXWXGXTXXHXFTSDKFJHZYJFJXRZSDLLLTQSQQZQWZXSYQTWGWBZCGZLLYZBCLMQQTZHZXZXLJFRMYZFLXYSQXXJKXRMQDZDMMYYBSQBHGZMWFWXGMXLZPYYTGZYCCDXYZXYWGSYJYZNBHPZJSQSYXSXRTFYZGRHZTXSZZTHCBFCLSYXZLZQMZLMPLMXZJXSFLBYZMYQHXJSXRXSQZZZSSLYFRCZJRCRXHHZXQYDYHXSJJHZCXZBTYNSYSXJBQLPXZQPYMLXZKYXLXCJLCYSXXZZLXDLLLJJYHZXGYJWKJRWYHCPSGNRZLFZWFZZNSXGXFLZSXZZZBFCSYJDBRJKRDHHGXJLJJTGXJXXSTJTJXLYXQFCSGSWMSBCTLQZZWLZZKXJMLTMJYHSDDBXGZHDLBMYJFRZFSGCLYJBPMLYSMSXLSZJQQHJZFXGFQFQBPXZGYYQXGZTCQWYLTLGWSGWHRLFSFGZJMGMGBGTJFSYZZGZYZAFLSSPMLPFLCWBJZCLJJMZLPJJLYMQDMYYYFBGYGYZMLYZDXQYXRQQQHSYYYQXYLJTYXFSFSLLGNQCYHYCWFHCCCFXPYLYPLLZYXXXXXKQHHXSHJZCFZSCZJXCPZWHHHHHAPYLQALPQAFYHXDYLUKMZQGGGDDESRNNZLTZGCHYPPYSQJJHCLLJTOLNJPZLJLHYMHEYDYDSQYCDDHGZUNDZCLZYZLLZNTNYZGSLHSLPJJBDGWXPCDUTJCKLKCLWKLLCASSTKZZDNQNTTLYYZSSYSSZZRYLJQKCQDHHCRXRZYDGRGCWCGZQFFFPPJFZYNAKRGYWYQPQXXFKJTSZZXSWZDDFBBXTBGTZKZNPZZPZXZPJSZBMQHKCYXYLDKLJNYPKYGHGDZJXXEAHPNZKZTZCMXCXMMJXNKSZQNMNLWBWWXJKYHCPSTMCSQTZJYXTPCTPDTNNPGLLLZSJLSPBLPLQHDTNJNLYYRSZFFJFQWDPHZDWMRZCCLODAXNSSNYZRESTYJWJYJDBCFXNMWTTBYLWSTSZGYBLJPXGLBOCLHPCBJLTMXZLJYLZXCLTPNCLCKXTPZJSWCYXSFYSZDKNTLBYJCYJLLSTGQCBXRYZXBXKLYLHZLQZLNZCXWJZLJZJNCJHXMNZZGJZZXTZJXYCYYCXXJYYXJJXSSSJSTSSTTPPGQTCSXWZDCSYFPTFBFHFBBLZJCLZZDBXGCXLQPXKFZFLSYLTUWBMQJHSZBMDDBCYSCCLDXYCDDQLYJJWMQLLCSGLJJSYFPYYCCYLTJANTJJPWYCMMGQYYSXDXQMZHSZXPFTWWZQSWQRFKJLZJQQYFBRXJHHFWJJZYQAZMYFRHCYYBYQWLPEXCCZSTYRLTTDMQLYKMBBGMYYJPRKZNPBSXYXBHYZDJDNGHPMFSGMWFZMFQMMBCMZZCJJLCNUXYQLMLRYGQZCYXZLWJGCJCGGMCJNFYZZJHYCPRRCMTZQZXHFQGTJXCCJEAQCRJYHPLQLSZDJRBCQHQDYRHYLYXJSYMHZYDWLDFRYHBPYDTSSCNWBXGLPZMLZZTQSSCPJMXXYCSJYTYCGHYCJWYRXXLFEMWJNMKLLSWTXHYYYNCMMCWJDQDJZGLLJWJRKHPZGGFLCCSCZMCBLTBHBQJXQDSPDJZZGKGLFQYWBZYZJLTSTDHQHCTCBCHFLQMPWDSHYYTQWCNZZJTLBYMBPDYYYXSQKXWYYFLXXNCWCXYPMAELYKKJMZZZBRXYYQJFLJPFHHHYTZZXSGQQMHSPGDZQWBWPJHZJDYSCQWZKTXXSQLZYYMYSDZGRXCKKUJLWPYSYSCSYZLRMLQSYLJXBCXTLWDQZPCYCYKPPPNSXFYZJJRCEMHSZMSXLXGLRWGCSTLRSXBZGBZGZTCPLUJLSLYLYMTXMTZPALZXPXJTJWTCYYZLBLXBZLQMYLXPGHDSLSSDMXMBDZZSXWHAMLCZCPJMCNHJYSNSYGCHSKQMZZQDLLKABLWJXSFMOCDXJRRLYQZKJMYBYQLYHETFJZFRFKSRYXFJTWDSXXSYSQJYSLYXWJHSNLXYYXHBHAWHHJZXWMYLJCSSLKYDZTXBZSYFDXGXZJKHSXXYBSSXDPYNZWRPTQZCZENYGCXQFJYKJBZMLJCMQQXUOXSLYXXLYLLJDZBTYMHPFSTTQQWLHOKYBLZZALZXQLHZWRRQHLSTMYPYXJJXMQSJFNBXYXYJXXYQYLTHYLQYFMLKLJTMLLHSZWKZHLJMLHLJKLJSTLQXYLMBHHLNLZXQJHXCFXXLHYHJJGBYZZKBXSCQDJQDSUJZYYHZHHMGSXCSYMXFEBCQWWRBPYYJQTYZCYQYQQZYHMWFFHGZFRJFCDPXNTQYZPDYKHJLFRZXPPXZDBBGZQSTLGDGYLCQMLCHHMFYWLZYXKJLYPQHSYWMQQGQZMLZJNSQXJQSYJYCBEHSXFSZPXZWFLLBCYYJDYTDTHWZSFJMQQYJLMQXXLLDTTKHHYBFPWTYYSQQWNQWLGWDEBZWCMYGCULKJXTMXMYJSXHYBRWFYMWFRXYQMXYSZTZZTFYKMLDHQDXWYYNLCRYJBLPSXCXYWLSPRRJWXHQYPHTYDNXHHMMYWYTZCSQMTSSCCDALWZTCPQPYJLLQZYJSWXMZZMMYLMXCLMXCZMXMZSQTZPPQQBLPGXQZHFLJJHYTJSRXWZXSCCDLXTYJDCQJXSLQYCLZXLZZXMXQRJMHRHZJBHMFLJLMLCLQNLDXZLLLPYPSYJYSXCQQDCMQJZZXHNPNXZMEKMXHYKYQLXSXTXJYYHWDCWDZHQYYBGYBCYSCFGPSJNZDYZZJZXRZRQJJYMCANYRJTLDPPYZBSTJKXXZYPFDWFGZZRPYMTNGXZQBYXNBUFNQKRJQZMJEGRZGYCLKXZDSKKNSXKCLJSPJYYZLQQJYBZSSQLLLKJXTBKTYLCCDDBLSPPFYLGYDTZJYQGGKQTTFZXBDKTYYHYBBFYTYYBCLPDYTGDHRYRNJSPTCSNYJQHKLLLZSLYDXXWBCJQSPXBPJZJCJDZFFXXBRMLAZHCSNDLBJDSZBLPRZTSWSBXBCLLXXLZDJZSJPYLYXXYFTFFFBHJJXGBYXJPMMMPSSJZJMTLYZJXSWXTYLEDQPJMYGQZJGDJLQJWJQLLSJGJGYGMSCLJJXDTYGJQJQJCJZCJGDZZSXQGSJGGCXHQXSNQLZZBXHSGZXCXYLJXYXYYDFQQJHJFXDHCTXJYRXYSQTJXYEFYYSSYYJXNCYZXFXMSYSZXYYSCHSHXZZZGZZZGFJDLTYLNPZGYJYZYYQZPBXQBDZTZCZYXXYHHSQXSHDHGQHJHGYWSZTMZMLHYXGEBTYLZKQWYTJZRCLEKYSTDBCYKQQSAYXCJXWWGSBHJYZYDHCSJKQCXSWXFLTYNYZPZCCZJQTZWJQDZZZQZLJJXLSBHPYXXPSXSHHEZTXFPTLQYZZXHYTXNCFZYYHXGNXMYWXTZSJPTHHGYMXMXQZXTSBCZYJYXXTYYZYPCQLMMSZMJZZLLZXGXZAAJZYXJMZXWDXZSXZDZXLEYJJZQBHZWZZZQTZPSXZTDSXJJJZNYAZPHXYYSRNQDTHZHYYKYJHDZXZLSWCLYBZYECWCYCRYLCXNHZYDZYDYJDFRJJHTRSQTXYXJRJHOJYNXELXSFSFJZGHPZSXZSZDZCQZBYYKLSGSJHCZSHDGQGXYZGXCHXZJWYQWGYHKSSEQZZNDZFKWYSSTCLZSTSYMCDHJXXYWEYXCZAYDMPXMDSXYBSQMJMZJMTZQLPJYQZCGQHXJHHLXXHLHDLDJQCLDWBSXFZZYYSCHTYTYYBHECXHYKGJPXHHYZJFXHWHBDZFYZBCAPNPGNYDMSXHMMMMAMYNBYJTMPXYYMCTHJBZYFCGTYHWPHFTWZZEZSBZEGPFMTSKFTYCMHFLLHGPZJXZJGZJYXZSBBQSCZZLZCCSTPGXMJSFTCCZJZDJXCYBZLFCJSYZFGSZLYBCWZZBYZDZYPSWYJZXZBDSYUXLZZBZFYGCZXBZHZFTPBGZGEJBSTGKDMFHYZZJHZLLZZGJQZLSFDJSSCBZGPDLFZFZSZYZYZSYGCXSNXXCHCZXTZZLJFZGQSQYXZJQDCCZTQCDXZJYQJQCHXZTDLGSCXZSYQJQTZWLQDQZTQCHQQJZYEZZZPBWKDJFCJPZTYPQYQTTYNLMBDKTJZPQZQZZFPZSBNJLGYJDXJDZZKZGQKXDLPZJTCJDQBXDJQJSTCKNXBXZMSLYJCQMTJQWWCJQNJNLLLHJCWQTBZQYDZCZPZZDZYDDCYZZZCCJTTJFZDPRRTZTJDCQTQZDTJNPLZBCLLCTZSXKJZQZPZLBZRBTJDCXFCZDBCCJJLTQQPLDCGZDBBZJCQDCJWYNLLZYZCCDWLLXWZLXRXNTQQCZXKQLSGDFQTDDGLRLAJJTKUYMKQLLTZYTDYYCZGJWYXDXFRSKSTQTENQMRKQZHHQKDLDAZFKYPBGGPZREBZZYKZZSPEGJXGYKQZZZSLYSYYYZWFQZYLZZLZHWCHKYPQGNPGBLPLRRJYXCCSYYHSFZFYBZYYTGZXYLXCZWXXZJZBLFFLGSKHYJZEYJHLPLLLLCZGXDRZELRHGKLZZYHZLYQSZZJZQLJZFLNBHGWLCZCFJYSPYXZLZLXGCCPZBLLCYBBBBUBBCBPCRNNZCZYRBFSRLDCGQYYQXYGMQZWTZYTYJXYFWTEHZZJYWLCCNTZYJJZDEDPZDZTSYQJHDYMBJNYJZLXTSSTPHNDJXXBYXQTZQDDTJTDYYTGWSCSZQFLSHLGLBCZPHDLYZJYCKWTYTYLBNYTSDSYCCTYSZYYEBHEXHQDTWNYGYCLXTSZYSTQMYGZAZCCSZZDSLZCLZRQXYYELJSBYMXSXZTEMBBLLYYLLYTDQYSHYMRQWKFKBFXNXSBYCHXBWJYHTQBPBSBWDZYLKGZSKYHXQZJXHXJXGNLJKZLYYCDXLFYFGHLJGJYBXQLYBXQPQGZTZPLNCYPXDJYQYDYMRBESJYYHKXXSTMXRCZZYWXYQYBMCLLYZHQYZWQXDBXBZWZMSLPDMYSKFMZKLZCYQYCZLQXFZZYDQZPZYGYJYZMZXDZFYFYTTQTZHGSPCZMLCCYTZXJCYTJMKSLPZHYSNZLLYTPZCTZZCKTXDHXXTQCYFKSMQCCYYAZHTJPCYLZLYJBJXTPNYLJYYNRXSYLMMNXJSMYBCSYSYLZYLXJJQYLDZLPQBFZZBLFNDXQKCZFYWHGQMRDSXYCYTXNQQJZYYPFZXDYZFPRXEJDGYQBXRCNFYYQPGHYJDYZXGRHTKYLNWDZNTSMPKLBTHBPYSZBZTJZSZZJTYYXZPHSSZZBZCZPTQFZMYFLYPYBBJQXZMXXDJMTSYSKKBJZXHJCKLPSMKYJZCXTMLJYXRZZQSLXXQPYZXMKYXXXJCLJPRMYYGADYSKQLSNDHYZKQXZYZTCGHZTLMLWZYBWSYCTBHJHJFCWZTXWYTKZLXQSHLYJZJXTMPLPYCGLTBZZTLZJCYJGDTCLKLPLLQPJMZPAPXYZLKKTKDZCZZBNZDYDYQZJYJGMCTXLTGXSZLMLHBGLKFWNWZHDXUHLFMKYSLGXDTWWFRJEJZTZHYDXYKSHWFZCQSHKTMQQHTZHYMJDJSKHXZJZBZZXYMPAGQMSTPXLSKLZYNWRTSQLSZBPSPSGZWYHTLKSSSWHZZLYYTNXJGMJSZSUFWNLSOZTXGXLSAMMLBWLDSZYLAKQCQCTMYCFJBSLXCLZZCLXXKSBZQCLHJPSQPLSXXCKSLNHPSFQQYTXYJZLQLDXZQJZDYYDJNZPTUZDSKJFSLJHYLZSQZLBTXYDGTQFDBYAZXDZHZJNHHQBYKNXJJQCZMLLJZKSPLDYCLBBLXKLELXJLBQYCXJXGCNLCQPLZLZYJTZLJGYZDZPLTQCSXFDMNYCXGBTJDCZNBGBQYQJWGKFHTNPYQZQGBKPBBYZMTJDYTBLSQMPSXTBNPDXKLEMYYCJYNZCTLDYKZZXDDXHQSHDGMZSJYCCTAYRZLPYLTLKXSLZCGGEXCLFXLKJRTLQJAQZNCMBYDKKCXGLCZJZXJHPTDJJMZQYKQSECQZDSHHADMLZFMMZBGNTJNNLGBYJBRBTMLBYJDZXLCJLPLDLPCQDHLXZLYCBLCXZZJADJLNZMMSSSMYBHBSQKBHRSXXJMXSDZNZPXLGBRHWGGFCXGMSKLLTSJYYCQLTSKYWYYHYWXBXQYWPYWYKQLSQPTNTKHQCWDQKTWPXXHCPTHTWUMSSYHBWCRWXHJMKMZNGWTMLKFGHKJYLSYYCXWHYECLQHKQHTTQKHFZLDXQWYZYYDESBPKYRZPJFYYZJCEQDZZDLATZBBFJLLCXDLMJSSXEGYGSJQXCWBXSSZPDYZCXDNYXPPZYDLYJCZPLTXLSXYZYRXCYYYDYLWWNZSAHJSYQYHGYWWAXTJZDAXYSRLTDPSSYYFNEJDXYZHLXLLLZQZSJNYQYQQXYJGHZGZCYJCHZLYCDSHWSHJZYJXCLLNXZJJYYXNFXMWFPYLCYLLABWDDHWDXJMCXZTZPMLQZHSFHZYNZTLLDYWLSLXHYMMYLMBWWKYXYADTXYLLDJPYBPWUXJMWMLLSAFDLLYFLBHHHBQQLTZJCQJLDJTFFKMMMBYTHYGDCQRDDWRQJXNBYSNWZDBYYTBJHPYBYTTJXAAHGQDQTMYSTQXKBTZPKJLZRBEQQSSMJJBDJOTGTBXPGBKTLHQXJJJCTHXQDWJLWRFWQGWSHCKRYSWGFTGYGBXSDWDWRFHWYTJJXXXJYZYSLPYYYPAYXHYDQKXSHXYXGSKQHYWFDDDPPLCJLQQEEWXKSYYKDYPLTJTHKJLTCYYHHJTTPLTZZCDLTHQKZXQYSTEEYWYYZYXXYYSTTJKLLPZMCYHQGXYHSRMBXPLLNQYDQHXSXXWGDQBSHYLLPJJJTHYJKYPPTHYYKTYEZYENMDSHLCRPQFDGFXZPSFTLJXXJBSWYYSKSFLXLPPLBBBLBSFXFYZBSJSSYLPBBFFFFSSCJDSTZSXZRYYSYFFSYZYZBJTBCTSBSDHRTJJBYTCXYJEYLXCBNEBJDSYXYKGSJZBXBYTFZWGENYHHTHZHHXFWGCSTBGXKLSXYWMTMBYXJSTZSCDYQRCYTWXZFHMYMCXLZNSDJTTTXRYCFYJSBSDYERXJLJXBBDEYNJGHXGCKGSCYMBLXJMSZNSKGXFBNBPTHFJAAFXYXFPXMYPQDTZCXZZPXRSYWZDLYBBKTYQPQJPZYPZJZNJPZJLZZFYSBTTSLMPTZRTDXQSJEHBZYLZDHLJSQMLHTXTJECXSLZZSPKTLZKQQYFSYGYWPCPQFHQHYTQXZKRSGTTSQCZLPTXCDYYZXSQZSLXLZMYCPCQBZYXHBSXLZDLTCDXTYLZJYYZPZYZLTXJSJXHLPMYTXCQRBLZSSFJZZTNJYTXMYJHLHPPLCYXQJQQKZZSCPZKSWALQSBLCCZJSXGWWWYGYKTJBBZTDKHXHKGTGPBKQYSLPXPJCKBMLLXDZSTBKLGGQKQLSBKKTFXRMDKBFTPZFRTBBRFERQGXYJPZSSTLBZTPSZQZSJDHLJQLZBPMSMMSXLQQNHKNBLRDDNXXDHDDJCYYGYLXGZLXSYGMQQGKHBPMXYXLYTQWLWGCPBMQXCYZYDRJBHTDJYHQSHTMJSBYPLWHLZFFNYPMHXXHPLTBQPFBJWQDBYGPNZTPFZJGSDDTQSHZEAWZZYLLTYYBWJKXXGHLFKXDJTMSZSQYNZGGSWQSPHTLSSKMCLZXYSZQZXNCJDQGZDLFNYKLJCJLLZLMZZNHYDSSHTHZZLZZBBHQZWWYCRZHLYQQJBEYFXXXWHSRXWQHWPSLMSSKZTTYGYQQWRSLALHMJTQJSMXQBJJZJXZYZKXBYQXBJXSHZTSFJLXMXZXFGHKZSZGGYLCLSARJYHSLLLMZXELGLXYDJYTLFBHBPNLYZFBBHPTGJKWETZHKJJXZXXGLLJLSTGSHJJYQLQZFKCGNNDJSSZFDBCTWWSEQFHQJBSAQTGYPQLBXBMMYWXGSLZHGLZGQYFLZBYFZJFRYSFMBYZHQGFWZSYFYJJPHZBYYZFFWODGRLMFTWLBZGYCQXCDJYGZYYYYTYTYDWEGAZYHXJLZYYHLRMGRXXZCLHNELJJTJTPWJYBJJBXJJTJTEEKHWSLJPLPSFYZPQQBDLQJJTYYQLYZKDKSQJYYQZLDQTGJQYZJSUCMRYQTHTEJMFCTYHYPKMHYZWJDQFHYYXWSHCTXRLJHQXHCCYYYJLTKTTYTMXGTCJTZAYYOCZLYLBSZYWJYTSJYHBYSHFJLYGJXXTMZYYLTXXYPZLXYJZYZYYPNHMYMDYYLBLHLSYYQQLLNJJYMSOYQBZGDLYXYLCQYXTSZEGXHZGLHWBLJHEYXTWQMAKBPQCGYSHHEGQCMWYYWLJYJHYYZLLJJYLHZYHMGSLJLJXCJJYCLYCJPCPZJZJMMYLCQLNQLJQJSXYJMLSZLJQLYCMMHCFMMFPQQMFYLQMCFFQMMMMHMZNFHHJGTTHHKHSLNCHHYQDXTMMQDCYZYXYQMYQYLTDCYYYZAZZCYMZYDLZFFFMMYCQZWZZMABTBYZTDMNZZGGDFTYPCGQYTTSSFFWFDTZQSSYSTWXJHXYTSXXYLBYQHWWKXHZXWZNNZZJZJJQJCCCHYYXBZXZCYZTLLCQXYNJYCYYCYNZZQYYYEWYCZDCJYCCHYJLBTZYYCQWMPWPYMLGKDLDLGKQQBGYCHJXY";
    //此处收录了375个多音字
    NSString* MultiPinyin = @"19969:DZ,19975:WM,19988:QJ,20048:YL,20056:SC,20060:NM,20094:QG,20127:QJ,20167:QC,20193:YG,20250:KH,20256:ZC,20282:SC,20285:QJG,20291:TD,20314:YD,20340:NE,20375:TD,20389:YJ,20391:CZ,20415:PB,20446:YS,20447:SQ,20504:TC,20608:KG,20854:QJ,20857:ZC,20911:PF,20504:TC,20608:KG,20854:QJ,20857:ZC,20911:PF,20985:AW,21032:PB,21048:XQ,21049:SC,21089:YS,21119:JC,21242:SB,21273:SC,21305:YP,21306:QO,21330:ZC,21333:SDC,21345:QK,21378:CA,21397:SC,21414:XS,21442:SC,21477:JG,21480:TD,21484:ZS,21494:YX,21505:YX,21512:HG,21523:XH,21537:PB,21542:PF,21549:KH,21571:E,21574:DA,21588:TD,21589:O,21618:ZC,21621:KHA,21632:ZJ,21654:KG,21679:LKG,21683:KH,21710:A,21719:YH,21734:WOE,21769:A,21780:WN,21804:XH,21834:A,21899:ZD,21903:RN,21908:WO,21939:ZC,21956:SA,21964:YA,21970:TD,22003:A,22031:JG,22040:XS,22060:ZC,22066:ZC,22079:MH,22129:XJ,22179:XA,22237:NJ,22244:TD,22280:JQ,22300:YH,22313:XW,22331:YQ,22343:YJ,22351:PH,22395:DC,22412:TD,22484:PB,22500:PB,22534:ZD,22549:DH,22561:PB,22612:TD,22771:KQ,22831:HB,22841:JG,22855:QJ,22865:XQ,23013:ML,23081:WM,23487:SX,23558:QJ,23561:YW,23586:YW,23614:YW,23615:SN,23631:PB,23646:ZS,23663:ZT,23673:YG,23762:TD,23769:ZS,23780:QJ,23884:QK,24055:XH,24113:DC,24162:ZC,24191:GA,24273:QJ,24324:NL,24377:TD,24378:QJ,24439:PF,24554:ZS,24683:TD,24694:WE,24733:LK,24925:TN,25094:ZG,25100:XQ,25103:XH,25153:PB,25170:PB,25179:KG,25203:PB,25240:ZS,25282:FB,25303:NA,25324:KG,25341:ZY,25373:WZ,25375:XJ,25384:A,25457:A,25528:SD,25530:SC,25552:TD,25774:ZC,25874:ZC,26044:YW,26080:WM,26292:PB,26333:PB,26355:ZY,26366:CZ,26397:ZC,26399:QJ,26415:ZS,26451:SB,26526:ZC,26552:JG,26561:TD,26588:JG,26597:CZ,26629:ZS,26638:YL,26646:XQ,26653:KG,26657:XJ,26727:HG,26894:ZC,26937:ZS,26946:ZC,26999:KJ,27099:KJ,27449:YQ,27481:XS,27542:ZS,27663:ZS,27748:TS,27784:SC,27788:ZD,27795:TD,27812:O,27850:PB,27852:MB,27895:SL,27898:PL,27973:QJ,27981:KH,27986:HX,27994:XJ,28044:YC,28065:WG,28177:SM,28267:QJ,28291:KH,28337:ZQ,28463:TL,28548:DC,28601:TD,28689:PB,28805:JG,28820:QG,28846:PB,28952:TD,28975:ZC,29100:A,29325:QJ,29575:SL,29602:FB,30010:TD,30044:CX,30058:PF,30091:YSP,30111:YN,30229:XJ,30427:SC,30465:SX,30631:YQ,30655:QJ,30684:QJG,30707:SD,30729:XH,30796:LG,30917:PB,31074:NM,31085:JZ,31109:SC,31181:ZC,31192:MLB,31293:JQ,31400:YX,31584:YJ,31896:ZN,31909:ZY,31995:XJ,32321:PF,32327:ZY,32418:HG,32420:XQ,32421:HG,32438:LG,32473:GJ,32488:TD,32521:QJ,32527:PB,32562:ZSQ,32564:JZ,32735:ZD,32793:PB,33071:PF,33098:XL,33100:YA,33152:PB,33261:CX,33324:BP,33333:TD,33406:YA,33426:WM,33432:PB,33445:JG,33486:ZN,33493:TS,33507:QJ,33540:QJ,33544:ZC,33564:XQ,33617:YT,33632:QJ,33636:XH,33637:YX,33694:WG,33705:PF,33728:YW,33882:SR,34067:WM,34074:YW,34121:QJ,34255:ZC,34259:XL,34425:JH,34430:XH,34485:KH,34503:YS,34532:HG,34552:XS,34558:YE,34593:ZL,34660:YQ,34892:XH,34928:SC,34999:QJ,35048:PB,35059:SC,35098:ZC,35203:TQ,35265:JX,35299:JX,35782:SZ,35828:YS,35830:E,35843:TD,35895:YG,35977:MH,36158:JG,36228:QJ,36426:XQ,36466:DC,36710:JC,36711:ZYG,36767:PB,36866:SK,36951:YW,37034:YX,37063:XH,37218:ZC,37325:ZC,38063:PB,38079:TD,38085:QY,38107:DC,38116:TD,38123:YD,38224:HG,38241:XTC,38271:ZC,38415:YE,38426:KH,38461:YD,38463:AE,38466:PB,38477:XJ,38518:YT,38551:WK,38585:ZC,38704:XS,38739:LJ,38761:GJ,38808:SQ,39048:JG,39049:XJ,39052:HG,39076:CZ,39271:XT,39534:TD,39552:TD,39584:PB,39647:SB,39730:LG,39748:TPB,40109:ZQ,40479:ND,40516:HG,40536:HG,40583:QJ,40765:YQ,40784:QJ,40840:YK,40863:QJG,";
    
    
    NSString *uniStr = [NSString stringWithFormat:@"%d",hanzi];
    ;
    //检查是否是多音字,是按多音字处理,不是就直接在strChineseFirstPY字符串中找对应的首字母
    if ([MultiPinyin rangeOfString:(uniStr)].location == NSNotFound)
        //获取非多音字汉字首字母
        
        int index = hanzi - 19968;
    if (index >= 0 && index <= 40869)
    {
        return [strChineseFirstPY characterAtIndex:index];
    }
    else if(hanzi >= 'A' && hanzi <= 'Z') {
        
        return hanzi + 32;
    }
    else if( hanzi >= 'a' && hanzi <= 'z') {
        
        return hanzi;
    }
    else
    {
        return '#';
    }
    
    //    NSString* resStr = @"";
    //    NSInteger i, j;
    //    int uni;
    //    uni = (UInt16)chineseCh;
    //    if (uni > 40869 || uni < 19968)
    //        return resStr;
    //返回该字符在Unicode字符集中的编码值
    NSString *uniStr = [NSString stringWithFormat:@"%d",hanzi];
    ;
    //检查是否是多音字,是按多音字处理,不是就直接在strChineseFirstPY字符串中找对应的首字母
    if ([MultiPinyin rangeOfString:(uniStr)].location == NSNotFound)
        //获取非多音字汉字首字母
    {
        resStr = [strChineseFirstPY substringWithRange:NSMakeRange(uni - 19968, 1)];
    }
    else
    {   //获取多音字汉字首字母
        j = MultiPinyin.IndexOf(",", i);
        resStr = MultiPinyin.Substring(i + 6, j - i - 6);
    }
    
    return resStr;
}
#endif
@end
