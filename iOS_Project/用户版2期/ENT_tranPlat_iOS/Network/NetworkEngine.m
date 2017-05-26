//
//  NetworkEngine.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 15/12/24.
//  Copyright © 2015年 ___ENT___. All rights reserved.
//

#import "NetworkEngine.h"

@implementation NetworkEngine

+ (NetworkEngine*)sharedNetwork{
    static NetworkEngine *network;
    __block NSString *host = nil;
    
    @synchronized(self){
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            if (ENT_DEBUG) {
                host = kWebserviceUrl;
            }else{
                host = kWebserviceUrl;
            }
            network = [[NetworkEngine alloc]initWithHostName:host customHeaderFields:nil];
        });
    }
    
    return network;
}

- (MKNetworkOperation *)postBody:(NSDictionary *)body
                         apiPath:(NSString *)apiPath
                       hasHeader:(BOOL)header
                          finish:(void (^)(ResultState state, id resObj))finish
                          failed:(MKNKErrorBlock)errorBlock{

    if ([body.allKeys containsObject:@"body"]) {
        body = body[@"body"];
    }
    NSDictionary *dic = nil;
    if (header) {
        dic = @{@"head":@{@"version":@"1"},
                              @"body":body?body:@{}};
    }else{
        dic = body;
    }
    
    MKNetworkOperation *operation = [self operationWithPath:apiPath params:dic httpMethod:@"POST"];
    operation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *resposeStr = completedOperation.responseString;
        DDLogDebug(@">>>>>>>>>>url->%@\n>>>>>>>>>>requestBody->%@\n>>>>>>>>>>resposeString->%@\n===================",completedOperation.url,body,resposeStr);
        id responseDic = completedOperation.responseJSON;
        if ([responseDic[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            
            finish(StateSucceed,responseDic);
            
        }else{
            [UITools alertWithMsg:responseDic[@"head"][@"rspMsg"]];
            finish(StateFailed,responseDic);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
        DDLogError(error.description,nil);
    }];
    
    [self enqueueOperation:operation];
    
    return operation;
}

@end
