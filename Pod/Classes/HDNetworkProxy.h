//
//  HDNetworkProxy.h
//  Pods
//
//  Created by Dailingchi on 15/10/23.
//
//

#import <Foundation/Foundation.h>
#import "HDNetworkDefines.h"

@interface HDNetworkProxy : NSObject

+ (instancetype)sharedInstance;

//发送请求
- (NSString *)sendRequest:
    (id<HDNetworkRequest, HDNetworkValidator, HDNetworkRequestCallBack>)request;
- (void)cancelRequest:(NSString *)requestID;
- (void)cancelAllRequests;

@end
