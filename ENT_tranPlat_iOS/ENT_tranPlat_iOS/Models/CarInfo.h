//
//  CarInfo.h
//  ENT_tranPlat_iOS
//
//  Created by 张永维 on 14-7-18.
//  Copyright (c) 2014年 ___ENT___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSObject

@property (nonatomic, retain) NSString *userId;        //标识
@property(nonatomic,strong)NSString *hpzl;             //号牌种类
@property(nonatomic,strong)NSString *hpzlname;         //号牌种类名称
@property(nonatomic,strong)NSString *hphm;             //号牌号码
@property(nonatomic,strong)NSString *clsbdh;           //车辆识别代号
@property(nonatomic,strong)NSString *clpp1;            //车辆品牌
@property(nonatomic,strong)NSString *vehicletypename;  //车辆类型名称
@property(nonatomic,strong)NSString *vehiclepic;       //车辆图片
@property(nonatomic,strong)NSString *vehiclestatus;    //车辆验证状态
@property(nonatomic,strong)NSString *yxqz;             //检验有效期止
@property(nonatomic,strong)NSString *bxzzrq;           //保险终止日期
@property(nonatomic,strong)NSString *ccdjrq;           //初次登记日期
@property(nonatomic,strong)NSString *vehiclegxsj;      //车辆信息更新时间
@property(nonatomic,strong)NSString *isupdate;            //车辆违法更新状态
@property(nonatomic,strong)NSString *createTime;    //车辆

@property(nonatomic,strong)NSString *zt;            //车辆状态
@property(nonatomic,strong)NSString *sfzmhm;            //身份证
@property(nonatomic,strong)NSString *syr;            //所有人
@property(nonatomic,strong)NSString *fdjh;            //发动机号


//单用于界面(首页违章数据的)显示
@property(nonatomic,strong)NSString                         *peccancyCount;            //车辆违法条数
@property(nonatomic,assign)LoadingPeccancyRecordStatus      loadingPeccancyRecordStatus; //是否正在网络刷新




//初始化
- (id)initWithHpzl:(NSString *)hpzl
          hpzlname:(NSString *)hpzlname
              hphm:(NSString *)hphm
            clsbdh:(NSString *)clsbdh
             clpp1:(NSString *)clpp1
   vehicletypename:(NSString *)vehicletypename
        vehiclepic:(NSString *)vehiclepic
     vehiclestatus:(NSString *)vehiclestatus
              yxqz:(NSString *)yxqz
            bxzzrq:(NSString *)bxzzrq
            ccdjrq:(NSString *)ccdjrq
       vehiclegxsj:(NSString *)vehiclegxsj
          isupdate:(NSString *)isupdate
        createTime:(NSString *)createTime

                zt:(NSString *)zt
            sfzmhm:(NSString *)sfzmhm
               syr:(NSString *)syr
              fdjh:(NSString *)fdjh
          andUseId:(NSString*)userId;

//向数据库添加一条car信息
- (void)add;

//解绑
- (void)unbind;



@end
