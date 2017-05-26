//
//  Database.m
//  ENT_tranPlat_iOS
//
//  Created by yanyan on 14-7-15.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//

/******************************************************
 * 模块名称:   Database.m
 * 模块功能:   数据库操作
 * 创建日期:   14-7-15
 * 创建作者:   闫燕
 * 修改日期:
 * 修改人员:
 * 修改内容:
 ******************************************************/

#import "DataBase.h"

@implementation DataBase

static DataBase *_db = nil;
//创建数据库
-(void)createDB
{
    _queue = [[FMDatabaseQueue alloc] initWithPath:_dbPath];
}
//创建表
-(void)createTable
{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         //用户表不存在则创建
         if(![db tableExists:TABLE_USER])
         {
             [db executeUpdate:CREATE_USER_TABLE];
         }
         
         if(![db tableExists:TABLE_CAR])
         {
             [db executeUpdate:CREATE_CAR_TABLE];
         }
         
         if(![db tableExists:TABLE_DRIVER])
         {
             [db executeUpdate:CREATE_DRIVER_TABLE];
         }
         
         if(![db tableExists:TABLE_CAR_PECCANCY])
         {
             [db executeUpdate:CREATE_CAR_PECCANCY_TABLE];
         }
         
         if(![db tableExists:TABLE_LICENSE_PECCANCY])
         {
             [db executeUpdate:CREATE_LICENSE_PECCANCY_TABLE];
         }
         
         if(![db tableExists:TABLE_MSG])
         {
             [db executeUpdate:CREATE_MSG_TABLE];
         }
         if(![db tableExists:TABLE_WEATHER]){
             [db executeUpdate:CREATE_WEATHER_TABLE];
         }
         if(![db tableExists:TABLE_XIANXING]) {
             [db executeUpdate:CREATE_XIANXING_TABLE];
         }
         if(![db tableExists:TABLE_ZHAOHUI]) {
             [db executeUpdate:CREATE_ZHAOHUI_TABLE];
         }
     }];
}

- (id)init
{
    self = [super init];
    if(nil != self)
    {
        
        NSURL *oldAppUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *oldPath = [[NSString alloc] initWithFormat:@"%@",[[oldAppUrl path] stringByAppendingPathComponent:DATABASE_NAME]];
        NSString *oldPath0 = [[NSString alloc] initWithFormat:@"%@",[[oldAppUrl path] stringByAppendingPathComponent:DATABASE_NAME_V0]];
        NSString *oldPath1 = [[NSString alloc] initWithFormat:@"%@",[[oldAppUrl path] stringByAppendingPathComponent:DATABASE_NAME_V1]];
        
        NSFileManager *fileMana = [NSFileManager defaultManager];
        BOOL existOldDB = [fileMana fileExistsAtPath:oldPath];
        NSError *err = nil;
        if (existOldDB) {
            [fileMana removeItemAtPath:oldPath error:&err];
            if (err) {
                ENTLog(@"删除旧库失败，下次启动继续执行删除任务！")
            }
        }
        BOOL existOldDB0 = [fileMana fileExistsAtPath:oldPath0];
        NSError *err0 = nil;
        if (existOldDB0) {
            [fileMana removeItemAtPath:oldPath0 error:&err0];
            if (err0) {
                ENTLog(@"删除旧库0失败，下次启动继续执行删除任务！")
            }
        }
        BOOL existOldDB1 = [fileMana fileExistsAtPath:oldPath1];
        NSError *err1 = nil;
        if (existOldDB1) {
            [fileMana removeItemAtPath:oldPath1 error:&err1];
            if (err1) {
                ENTLog(@"删除旧库1失败，下次启动继续执行删除任务！")
            }
        }
        NSURL *appUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        _dbPath = [[NSString alloc] initWithFormat:@"%@",[[appUrl path] stringByAppendingPathComponent:DATABASE_NAME_V2]];
        
        [self createDB];//创建数据库
        [self createTable];//创建表
    }
    return self;
}


+(DataBase*) sharedDataBase
{
    @synchronized(self)
    {
        if (_db == nil)
        {
            _db = [[DataBase alloc] init];
        }
    }
    
    return _db;
}




#pragma mark- 用户信息表相关操作
/****************************************************
 功能：插入一条用户信息
 参数：UserInfo 用户信息model
 返回：无
 **************************************************/
- (void)insertUserInfo:(UserInfo*)user{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO user (user_id, user_name, password, email, contact_num, post_code, real_name, addr, regist_time, verify_status, load_time, city_set, version, photo_local_path, photo_server_path, is_active) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          user.userId,
          user.userName,
          user.password,
          user.email,
          user.contactNum,
          user.postCode,
          user.realName,
          user.addr,
          user.registTime,
          user.verifyStatus,
          user.loadTime,
          user.citySet,
          user.version,
          user.photoLocalPath,
          user.photoServerPath,
          user.isActive
          ];
     }];
}

/****************************************************
 功能：删除所有用户信息
 参数：无
 返回：无
 **************************************************/
-(void)deleteAllUses{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM user"];
     }];
    
}

/****************************************************
 功能：更新一条用户信息（根据userid）
 参数：UserInfo 用户信息model
 返回：无
 **************************************************/
- (void)updateUserInfo:(UserInfo*)user{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE user SET user_name = '%@', password = '%@', email = '%@', contact_num = '%@',post_code = '%@',real_name = '%@',addr = '%@',regist_time = '%@',verify_status = '%@',load_time = '%@',city_set = '%@',version = '%@',photo_local_path = '%@',photo_server_path = '%@', is_active = '%@' where user_id = '%@'",user.userName, user.password, user.email, user.contactNum, user.postCode, user.realName, user.addr, user.registTime, user.verifyStatus, user.loadTime, user.citySet, user.version, user.photoLocalPath, user.photoServerPath, user.isActive, user.userId];
         [db executeUpdate:SQL];
     }];
}

/****************************************************
 功能：查询当前活跃用户信息
 参数：无
 返回：NSArray[UserInfo] 用户信息model数组
 **************************************************/
- (NSArray*)selectActiveUser{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM user WHERE is_active = '%@'", ACTIVE_USER_YES];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             UserInfo *user = [[UserInfo alloc] initWithUserId:[rs stringForColumn:@"user_id"]
                                                      isActive:[rs stringForColumn:@"is_active"]
                                                      userName:[rs stringForColumn:@"user_name"]
                                                      password:[rs stringForColumn:@"password"]
                                                         email:[rs stringForColumn:@"email"]
                                                    contactNum:[rs stringForColumn:@"contact_num"]
                                                      postCode:[rs stringForColumn:@"post_code"]
                                                      realName:[rs stringForColumn:@"real_name"]
                                                          addr:[rs stringForColumn:@"addr"]
                                                    registTime:[rs stringForColumn:@"regist_time"]
                                                  verifyStatus:[rs stringForColumn:@"verify_status"]
                                                      loadTime:[rs stringForColumn:@"load_time"]
                                                       citySet:[rs stringForColumn:@"city_set"]
                                                       version:[rs stringForColumn:@"version"]
                                                photoLocalPath:[rs stringForColumn:@"photo_local_path"]
                                            andPhotoServerPath:[rs stringForColumn:@"photo_server_path"]];
             [res addObject:user];
         }
         [rs close];
     }];
    return res;
}


/****************************************************
 功能：查询用户信息
 参数：NSString username
 返回：NSArray[UserInfo] 用户信息model数组
 **************************************************/
- (NSArray*)selectUserByName:(NSString*)username{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM user WHERE user_name = '%@'", username];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             UserInfo *user = [[UserInfo alloc] initWithUserId:[rs stringForColumn:@"user_id"]
                                                      isActive:[rs stringForColumn:@"is_active"]
                                                      userName:[rs stringForColumn:@"user_name"]
                                                      password:[rs stringForColumn:@"password"]
                                                         email:[rs stringForColumn:@"email"]
                                                    contactNum:[rs stringForColumn:@"contact_num"]
                                                      postCode:[rs stringForColumn:@"post_code"]
                                                      realName:[rs stringForColumn:@"real_name"]
                                                          addr:[rs stringForColumn:@"addr"]
                                                    registTime:[rs stringForColumn:@"regist_time"]
                                                  verifyStatus:[rs stringForColumn:@"verify_status"]
                                                      loadTime:[rs stringForColumn:@"load_time"]
                                                       citySet:[rs stringForColumn:@"city_set"]
                                                       version:[rs stringForColumn:@"version"]
                                                photoLocalPath:[rs stringForColumn:@"photo_local_path"]
                                            andPhotoServerPath:[rs stringForColumn:@"photo_server_path"]];
             [res addObject:user];
         }
         [rs close];
     }];
    return res;
    
    
}



#pragma mark- 车辆信息表相关操作
/****************************************************
 功能：插入一条车辆信息
 参数：CarInfo 车辆信息model
 返回：无
 **************************************************/
- (void)insertCarInfo:(CarInfo *)car
{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO car (hpzl, hpzlname, hphm, clsbdh, clpp1, vehicletypename, vehiclepic, vehiclestatus, yxqz, bxzzrq, ccdjrq, vehiclegxsj, isupdate, createTime, user_id, zt, sfzmhm, syr, fdjh) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          car.hpzl,
          car.hpzlname,
          car.hphm,
          car.clsbdh,
          car.clpp1,
          car.vehicletypename,
          car.vehiclepic,
          car.vehiclestatus,
          car.yxqz,
          car.bxzzrq,
          car.ccdjrq,
          car.vehiclegxsj,
          car.isupdate,
          car.createTime,
          car.userId,
          car.zt,
          car.sfzmhm,
          car.syr,
          car.fdjh
          ];
     }];
}

/****************************************************
 功能：删除所有车辆信息
 参数：无
 返回：无
 **************************************************/
-(void)deleteAllCarInfo
{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM car"];
     }];
    
}


/****************************************************
 功能：删除一条车辆信息
 参数：NSString user_id
 返回：无
 **************************************************/
-(void)deleteCarInfoByUserId:(NSString*)userId
{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM car WHERE user_id = ?", userId];
     }];
    
}


///****************************************************
// 功能：删除一条车辆信息
// 参数：
// 返回：无
// **************************************************/
//- (void)deleteCarInfoByVehiclegxsj:(NSString*)vehiclegxsj{
//    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
//     {
//         [db executeUpdate:@"DELETE FROM car WHERE vehiclegxsj = ?", vehiclegxsj];
//     }];
//}


/****************************************************
 功能：删除一条车辆信息
 参数：
 返回：无
 **************************************************/
- (void)deleteCarInfoByHphm:(NSString*)hphm andUserId:(NSString*)userId{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM car WHERE hphm = ? and user_id = ?", hphm, userId];
     }];
}

# if 0
/****************************************************
 功能：更新一条车辆信息(根据user_id)
 参数：CarInfo 车辆信息model
 返回：无
 **************************************************/
- (void)updateCarInfo:(CarInfo *)car
{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE car SET hpzl = '%@', hpzlname = '%@', hphm = '%@', clsbdh = '%@',clpp1 = '%@',vehicletypename = '%@',vehiclepic = '%@',vehiclestatus = '%@',yxqz = '%@',bxzzrq = '%@',ccdjrq = '%@',vehiclegxsj = '%@',isupdate = '%@',createTime = '%@',zt = '%@', sfzmhm = '%@', syr = '%@' where user_id = '%@'",car.hpzl, car.hpzlname, car.hphm, car.clsbdh, car.clpp1, car.vehicletypename, car.vehiclepic, car.vehiclestatus, car.yxqz, car.bxzzrq, car.ccdjrq, car.vehiclegxsj, car.isupdate, car.createTime, car.userId];
         [db executeUpdate:SQL];
     }];
}
#endif

/****************************************************
 功能：查询车辆信息
 参数：NSString user_id
 返回：NSArray[CarInfo] 车辆信息model数组
 **************************************************/
- (NSArray*)selectCarByUserId:(NSString *)userId
{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM car WHERE user_id = '%@'",userId];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             CarInfo *car = [[CarInfo alloc] initWithHpzl:[rs stringForColumn:@"hpzl" ]
                                                 hpzlname:[rs stringForColumn:@"hpzlname" ]
                                                     hphm:[rs stringForColumn:@"hphm" ]
                                                   clsbdh:[rs stringForColumn:@"clsbdh" ]
                                                    clpp1:[rs stringForColumn:@"clpp1" ]
                                          vehicletypename:[rs stringForColumn:@"vehicletypename" ]
                                               vehiclepic:[rs stringForColumn:@"vehiclepic" ]
                                            vehiclestatus:[rs stringForColumn:@"vehiclestatus" ]
                                                     yxqz:[rs stringForColumn:@"yxqz"]
                                                   bxzzrq:[rs stringForColumn:@"bxzzrq"]
                                                   ccdjrq:[rs stringForColumn:@"ccdjrq"]
                                              vehiclegxsj:[rs stringForColumn:@"vehiclegxsj"]
                                                 isupdate:[rs stringForColumn:@"isupdate"]
                                               createTime:[rs stringForColumn:@"createTime"]
                                                       zt:[rs stringForColumn:@"zt"]
                                                   sfzmhm:[rs stringForColumn:@"sfzmhm"]
                                                      syr:[rs stringForColumn:@"syr"]
                                                     fdjh:[rs stringForColumn:@"fdjh"]
                                                 andUseId:[rs stringForColumn:@"user_id"]];
             [res addObject:car];
         }
         [rs close];
     }];
    if ([res count] > 2) {
        if (iOS6) {
            if (USE_COUNTLY) {
                [[Countly sharedInstance] recordEvent:[NSString stringWithFormat:@"用户：%@，绑定车辆数超过2，网络超时导致", APP_DELEGATE.userName] count:1];
            }
        }
        ENTLog(@"%@", [NSString stringWithFormat:@"用户：%@，绑定车辆数超过2，网络超时导致", APP_DELEGATE.userName]);
        [res removeLastObject];
    }
    return res;
}


/****************************************************
 功能：查询车辆信息
 参数：NSString user_id NSString hphm
 返回：NSArray[CarInfo] 车辆信息model数组
 **************************************************/
- (NSArray*)selectCarByUserId:(NSString *)userId andHphm:(NSString*)hphm
{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM car WHERE user_id = '%@' and hphm = '%@'",userId, hphm];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             CarInfo *car = [[CarInfo alloc] initWithHpzl:[rs stringForColumn:@"hpzl" ]
                                                 hpzlname:[rs stringForColumn:@"hpzlname" ]
                                                     hphm:[rs stringForColumn:@"hphm" ]
                                                   clsbdh:[rs stringForColumn:@"clsbdh" ]
                                                    clpp1:[rs stringForColumn:@"clpp1" ]
                                          vehicletypename:[rs stringForColumn:@"vehicletypename" ]
                                               vehiclepic:[rs stringForColumn:@"vehiclepic" ]
                                            vehiclestatus:[rs stringForColumn:@"vehiclestatus" ]
                                                     yxqz:[rs stringForColumn:@"yxqz"]
                                                   bxzzrq:[rs stringForColumn:@"bxzzrq"]
                                                   ccdjrq:[rs stringForColumn:@"ccdjrq"]
                                              vehiclegxsj:[rs stringForColumn:@"vehiclegxsj"]
                                                 isupdate:[rs stringForColumn:@"isupdate"]
                                               createTime:[rs stringForColumn:@"createTime"]
                             
                                                       zt:[rs stringForColumn:@"zt"]
                                                   sfzmhm:[rs stringForColumn:@"sfzmhm"]
                                                      syr:[rs stringForColumn:@"syr"]
                                                     fdjh:[rs stringForColumn:@"fdjh"]
                                                 andUseId:[rs stringForColumn:@"user_id"]];
             
             [res addObject:car];
         }
         [rs close];
     }];
    return res;
}


#pragma mark- 驾驶员信息表相关操作

/****************************************************
 功能：插入一条驾驶员信息
 参数：DriverInfo 驾驶员信息model
 返回：无
 **************************************************/
- (void)insertDriverInfo:(DriverInfo *)driver{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO driver (driversfzmhm, dabh, xm, driverstatus, ljjf, zjcx, yxqz, zxbh, drivergxsj, djzsxxdz, driverzt, user_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
          driver.driversfzmhm,
          driver.dabh,
          driver.xm,
          driver.driverstatus,
          driver.ljjf,
          driver.zjcx,
          driver.yxqz,
          driver.zxbh,
          driver.drivergxsj,
          driver.djzsxxdz,
          driver.driverzt,
          driver.userId
          ];
     }];
}

/****************************************************
 功能：删除所有驾驶员信息
 参数：无
 返回：无
 **************************************************/
-(void)deleteAllDriverInfo{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM driver"];
     }];
}


/****************************************************
 功能：删除一条驾驶员信息
 参数：NSString userId
 返回：无
 **************************************************/
-(void)deleteDriverInfoByUserId:(NSString*)userId{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM driver WHERE user_id = ?", userId];
     }];
}


/****************************************************
 功能：删除一条驾驶员信息
 参数：NSString driversfzmhm
 返回：无
 **************************************************/
-(void)deleteDriverInfoByDriversfzmhm:(NSString*)driversfzmhm{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM driver WHERE driversfzmhm = ?", driversfzmhm];
     }];
}


#if 0
/****************************************************
 功能：更新一条驾驶员信息(根据user_id、driversfzmhm)
 参数：DriverInfo 驾驶员信息model
 返回：无
 **************************************************/
- (void)updateDriverInfo:(DriverInfo *)driver{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;//driverzt
         SQL = [NSString stringWithFormat:@"UPDATE driver SET dabh = '%@', xm = '%@', driverstatus = '%@',ljjf = '%@',zjcx = '%@',yxqz = '%@',zxbh = '%@',drivergxsj = '%@',djzsxxdz = '%@'' where driversfzmhm = '%@'",driver.dabh, driver.xm, driver.driverstatus, driver.ljjf, driver.zjcx, driver.yxqz, driver.zxbh, driver.drivergxsj, driver.djzsxxdz, driver.driversfzmhm];
         [db executeUpdate:SQL];
     }];
}
#endif

/****************************************************
 功能：查询驾驶员信息
 参数：NSString   userId
 返回：NSArray[DriverInfo] 驾驶员信息model数组
 **************************************************/
- (NSArray*)selectDriverByUserId:(NSString *)userId{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM driver WHERE user_id = '%@'",userId];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             DriverInfo *driver = [[DriverInfo alloc]
                                   initWithDriverfzmhm:[rs stringForColumn:@"driversfzmhm"]
                                   dabh:[rs stringForColumn:@"dabh"]
                                   xm:[rs stringForColumn:@"xm"]
                                   driverstatus:[rs stringForColumn:@"driverstatus"]
                                   ljjf:[rs stringForColumn:@"ljjf"]
                                   zjcx:[rs stringForColumn:@"zjcx"]
                                   yxqz:[rs stringForColumn:@"yxqz"]
                                   zxbh:[rs stringForColumn:@"zxbh"]
                                   drivergxsj:[rs stringForColumn:@"drivergxsj"]
                                   djzsxxdz:[rs stringForColumn:@"djzsxxdz"]
                                   driverzt:[rs stringForColumn:@"driverzt"]
                                   andUseId:[rs stringForColumn:@"user_id"]
                                   ];
             [res addObject:driver];
         }
         [rs close];
     }];
    return res;
}



#pragma mark-    机动车违法记录

/****************************************************
 功能：插入一条机动车违法记录
 参数：CarPeccancyRecord 机动车违法记录model
 返回：无
 **************************************************/
- (void)insertCarPeccancyRecord:(CarPeccancyRecord *)record{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO car_peccancy (hpzl, hphm, jdcwf_detail, jdcwf_gxsj, user_id) VALUES (?,?,?,?,?)",
          record.hpzl,
          record.hphm,
          record.jdcwf_detail,
          record.jdcwf_gxsj,
          record.userId
          ];
     }];
}

/****************************************************
 功能：删除一条机动车违法记录
 参数：NSString userId, NSString hphm车牌号码
 返回：无
 **************************************************/
-(void)deleteCarPeccancyRecordByUserId:(NSString *)userId andHphm:(NSString*)hphm{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM car_peccancy WHERE user_id = ? and hphm = ?",
          userId,
          hphm
          ];
     }];
    
}

/****************************************************
 功能：删除所有机动车违法记录
 参数：无
 返回：无
 **************************************************/
-(void)deleteAllCarPeccancyRecord{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM car_peccancy"];
     }];
    
}


#if 0
/****************************************************
 功能：更新一条机动车违法记录
 参数：CarPeccancyRecord 机动车违法记录model
 返回：无
 **************************************************/
- (void)updateCarPeccancyRecord:(CarPeccancyRecord *)record{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE car_peccancy SET hpzl = '%@', jdcwf_detail = '%@',jdcwf_gxsj = '%@' where hphm = '%@'",record.hpzl, record.jdcwf_detail, record.jdcwf_gxsj, record.hphm];
         [db executeUpdate:SQL];
     }];
}
#endif
/****************************************************
 功能：查询机动车违法记录
 参数：NSString userId NSString hphm车牌号码
 返回：NSArray[CarPeccancyRecord] 机动车违法记录model数组
 **************************************************/
- (NSArray*)selectCarPeccancyRecordByUserId:(NSString *)userId andHphm:(NSString*)hphm{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM car_peccancy WHERE user_id = '%@' and hphm = '%@'",userId, hphm];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             CarPeccancyRecord *record = [[CarPeccancyRecord alloc]
                                          initWithHpzl:[rs stringForColumn:@"hpzl"]
                                          hphm:[rs stringForColumn:@"hphm"]
                                          jdcwf_detail:[rs stringForColumn:@"jdcwf_detail"]
                                          jdcwf_gxsj:[rs stringForColumn:@"jdcwf_gxsj"]
                                          andUserId:[rs stringForColumn:@"user_id"]];
             [res addObject:record];
         }
         [rs close];
     }];
    return res;
    
}



#pragma mark- 驾驶证违法记录表相关操作

/****************************************************
 功能：插入一条驾驶证违法记录
 参数：DriveLicensePeccancyRecord 驾驶证违法记录model
 返回：无
 **************************************************/
- (void)insertDriveLicensePeccancyRecord:(DriveLicensePeccancyRecord *)record{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO driver_license_peccancy (driversfzmhm, jszwf_detail, jszwf_gxsj, user_id) VALUES (?,?,?,?)",
          record.driversfzmhm,
          record.jszwf_detail,
          record.jszwf_gxsj,
          record.userId
          ];
     }];
    
}

/****************************************************
 功能：删除一条驾驶证违法记录
 参数：NSString userId
 返回：无
 **************************************************/
-(void)deleteDriveLicensePeccancyRecordByUserId:(NSString *)userId{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM driver_license_peccancy WHERE user_id = ?",
          userId
          ];
     }];
}


/****************************************************
 功能：删除所有驾驶证违法记录
 参数：无
 返回：无
 **************************************************/
-(void)deleteAllDriveLicensePeccancyRecord{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM driver_license_peccancy"];
     }];
}

#if 0
/****************************************************
 功能：更新一条驾驶证违法记录
 参数：DriveLicensePeccancyRecord 驾驶证违法记录model
 返回：无
 **************************************************/
- (void)updateDriveLicensePeccancyRecord:(DriveLicensePeccancyRecord *)record{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE driver_license_peccancy SET jszwf_detail = '%@', jszwf_gxsj = '%@' where driversfzmhm = '%@'",record.jszwf_detail, record.jszwf_gxsj, record.driversfzmhm];
         [db executeUpdate:SQL];
     }];
    
}
#endif

/****************************************************
 功能：查询驾驶证违法记录
 参数：NSString userId
 返回：NSArray[DriveLicensePeccancyRecord] 驾驶证违法记录model数组
 **************************************************/
- (NSArray*)selectDriveLicensePeccancyRecordByUserId:(NSString *)userId{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM driver_license_peccancy WHERE user_id = '%@'",userId];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             DriveLicensePeccancyRecord *record = [[DriveLicensePeccancyRecord alloc]
                                                   initWithDriversfzmhm:[rs  stringForColumn:@"driversfzmhm"]
                                                   jszwf_detail:[rs stringForColumn:@"jszwf_detail"]
                                                   jszwf_gxsj:[rs stringForColumn:@"jszwf_gxsj"]
                                                   andUseId:[rs stringForColumn:@"user_id"]];
             [res addObject:record];
         }
         [rs close];
     }];
    return res;
    
}

#pragma mark- 通知、消息表相关操作

/****************************************************
 功能：插入一条消息
 参数：Msg 消息model
 返回：无
 **************************************************/
- (void)insertMsg:(Msg *)msg{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO msg (msg_ID, msg_time, msg_title, msg_content, msg_read_status, msg_classify, msg_user) VALUES (?,?,?,?,?,?,?)",
          msg.msg_ID,
          msg.msg_time,
          msg.msg_title,
          msg.msg_content,
          msg.msg_read_status,
          msg.msg_classify,
          msg.msg_user
          ];
     }];
    
}

/****************************************************
 功能：更新消息
 参数：Msg msg 消息model
 返回：无
 **************************************************/
- (void)updateMsg:(Msg *)msg{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE msg SET msg_read_status = '%@' where msg_time = '%@'",msg.msg_read_status, msg.msg_time];
         [db executeUpdate:SQL];
     }];
    
}


/****************************************************
 功能：查询消息
 参数：NSString username 用户名
 返回：NSArray[Msg] 消息model数组
 **************************************************/
- (NSArray*)selectAllMsgByUser:(NSString*)username{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM msg WHERE msg_user = '%@'",username];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             Msg *msg = [[Msg alloc] initWithMsg_ID:[rs stringForColumn:@"msg_ID"] msg_time:[rs stringForColumn:@"msg_time"] msg_title:[rs stringForColumn:@"msg_title"] msg_content:[rs stringForColumn:@"msg_content"] msg_read_status:[rs stringForColumn:@"msg_read_status"] msg_classify:[rs stringForColumn:@"msg_classify"] andMsg_user:[rs stringForColumn:@"msg_user"]];
             [res addObject:msg];
         }
         [rs close];
     }];
    return res;
    
}


/****************************************************
 功能：查询消息
 参数：NSString username 用户名
 NSString msg_classify 消息类别
 返回：NSArray[Msg] 消息model数组
 **************************************************/
- (NSArray*)selectMsgByUser:(NSString*)username msg_classify:(NSString *)classify{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM msg WHERE msg_classify = '%@' and msg_user = '%@'",classify, username];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             Msg *msg = [[Msg alloc] initWithMsg_ID:[rs stringForColumn:@"msg_ID"] msg_time:[rs stringForColumn:@"msg_time"] msg_title:[rs stringForColumn:@"msg_title"] msg_content:[rs stringForColumn:@"msg_content"] msg_read_status:[rs stringForColumn:@"msg_read_status"] msg_classify:[rs stringForColumn:@"msg_classify"] andMsg_user:[rs stringForColumn:@"msg_user"]];
             [res addObject:msg];
         }
         [rs close];
     }];
    return res;
    
}

/****************************************************
 功能：查询消息
 参数：NSString username 用户名
 NSString status 消息读取状态
 返回：NSArray[Msg] 消息model数组
 **************************************************/
- (NSArray*)selectMsgByUser:(NSString*)username status:(NSString *)status{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM msg WHERE msg_read_status = '%@' and msg_user = '%@'",status, username];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             Msg *msg = [[Msg alloc] initWithMsg_ID:[rs stringForColumn:@"msg_ID"] msg_time:[rs stringForColumn:@"msg_time"] msg_title:[rs stringForColumn:@"msg_title"] msg_content:[rs stringForColumn:@"msg_content"] msg_read_status:[rs stringForColumn:@"msg_read_status"] msg_classify:[rs stringForColumn:@"msg_classify"] andMsg_user:[rs stringForColumn:@"msg_user"]];
             [res addObject:msg];
         }
         [rs close];
     }];
    return res;
    
}


#pragma mark- 天气表相关操作
/****************************************************
 功能：插入一条天气
 参数：Weather 天气model
 返回：无
 **************************************************/
- (void)insertWeather:(Weather *)wea{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO weather (temp, des, detail, logo_url, xiche, update_time, other) VALUES (?,?,?,?,?,?,?)",
          wea.temp,
          wea.des,
          wea.detail,
          wea.logoUrl,
          wea.xiche,
          wea.updateTime,
          wea.other
          ];
     }];
    
}


/****************************************************
 功能：更新天气
 参数：Weather  天气model
 返回：无
 **************************************************/
- (void)updateWeather:(Weather *)wea{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE weather SET temp = '%@', des = '%@', detail = '%@', logo_url = '%@',xiche = '%@',update_time = '%@' where other = '%@'",wea.temp, wea.des, wea.detail, wea.logoUrl, wea.xiche, wea.updateTime, wea.other];
         [db executeUpdate:SQL];
     }];
    
}


/****************************************************
 功能：查询天气
 参数：无
 返回：NSArray[Weather] 天气model数组
 **************************************************/
- (NSArray*)selectWeather{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = @"SELECT * FROM weather";
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             Weather *wea = [[Weather alloc] initWithTemp:[rs stringForColumn:@"temp"] des:[rs stringForColumn:@"des"] detail:[rs stringForColumn:@"detail"] logoUrl:[rs stringForColumn:@"logo_url"] xiche:[rs stringForColumn:@"xiche"] updateTime:[rs stringForColumn:@"update_time"] other:[rs stringForColumn:@"other"]];
             [res addObject:wea];
         }
         [rs close];
     }];
    return res;
    
}




#pragma mark- 限行表相关操作
/****************************************************
 功能：插入一条限行
 参数：Xianxing 限行model
 返回：无
 **************************************************/
- (void)insertXianxing:(Xianxing *)xianxing{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO xianxing (start_date, end_date, special_date, monday, tuesday, wednesday, thursday, friday, saturday, sunday) VALUES (?,?,?,?,?,?,?,?,?,?)",
          xianxing.startDate,
          xianxing.endDate,
          xianxing.specialDate,
          xianxing.monday,
          xianxing.tuesday,
          xianxing.wednesday,
          xianxing.thursday,
          xianxing.friday,
          xianxing.saturday,
          xianxing.sunday
          ];
     }];
    
}


/****************************************************
 功能：删除限行
 参数：无
 返回：无
 **************************************************/
-(void)deleteXianxing{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"DELETE FROM xianxing"];
     }];
    
}


/****************************************************
 功能：查询限行
 参数：无
 返回：NSArray[Xianxing] 限行model数组
 **************************************************/
- (NSArray*)selectXianxing{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = @"SELECT * FROM xianxing";
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             Xianxing *xianxing = [[Xianxing alloc] initWithStartDate:[rs stringForColumn:@"start_date"] endDate:[rs stringForColumn:@"end_date"] specialDate:[rs stringForColumn:@"special_date"] monday:[rs stringForColumn:@"monday"] tuesday:[rs stringForColumn:@"tuesday"] wednesday:[rs stringForColumn:@"wednesday"] thursday:[rs stringForColumn:@"thursday"] friday:[rs stringForColumn:@"friday"] saturday:[rs stringForColumn:@"saturday"] sunday:[rs stringForColumn:@"sunday"]];
             [res addObject:xianxing];
         }
         [rs close];
     }];
    return res;
    
}




#pragma mark- 车辆召回信息表相关操作
/****************************************************
 功能：插入一条召回信息
 参数：Zhaohui 限行model
 返回：无
 **************************************************/
- (void)insertZhaohui:(ZhaohuiMsg *)zhaohui{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db executeUpdate:@"INSERT INTO zhaohui (brand, cartype, dealway, id_fanhui, method, period, reason, result, clsbdh) VALUES (?,?,?,?,?,?,?,?,?)",
          zhaohui.brand,
          zhaohui.cartype,
          zhaohui.dealway,
          zhaohui.id_fanhui,
          zhaohui.method,
          zhaohui.period,
          zhaohui.reason,
          zhaohui.result,
          zhaohui.clsbdh
          ];
     }];
}

/****************************************************
 功能：更新召回信息
 参数：Zhaohui  召回信息model
 返回：无
 **************************************************/
- (void)updateZhaohui:(ZhaohuiMsg *)zhaohui{
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *SQL = NULL;
         SQL = [NSString stringWithFormat:@"UPDATE zhaohui SET brand = '%@', cartype = '%@', dealway = '%@', id_fanhui = '%@',method = '%@',period = '%@',reason = '%@',result = '%@' where clsbdh = '%@'",zhaohui.brand, zhaohui.cartype, zhaohui.dealway, zhaohui.id_fanhui, zhaohui.method, zhaohui.period, zhaohui.reason, zhaohui.result, zhaohui.clsbdh];
         [db executeUpdate:SQL];
     }];
    
}


/****************************************************
 功能：查询召回信息
 参数：车辆识别码==vin车架号
 返回：NSArray[Zhaohui] 召回信息model数组
 **************************************************/
- (NSArray*)selectZhaohuiByClsbdh:(NSString*)clsbdh{
    __block NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:0];
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM zhaohui WHERE clsbdh = '%@'",clsbdh];
         rs = [db executeQuery:SQL];
         while ([rs next])
         {
             ZhaohuiMsg *zhaohui = [[ZhaohuiMsg alloc] initWithBrand:[rs stringForColumn:@"brand"] cartype:[rs stringForColumn:@"cartype"] dealway:[rs stringForColumn:@"dealway"] id_fanhui:[rs stringForColumn:@"id_fanhui"] method:[rs stringForColumn:@"method"] period:[rs stringForColumn:@"period"] reason:[rs stringForColumn:@"reason"] result:[rs stringForColumn:@"result"] clsbdh:[rs stringForColumn:@"clsbdh"]];
             
             [res addObject:zhaohui];
         }
         [rs close];
     }];
    return res;
    
}

@end

