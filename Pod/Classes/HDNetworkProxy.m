//
//  HDNetworkProxy.m
//  Pods
//
//  Created by Dailingchi on 15/10/23.
//
//

#import "HDNetworkProxy.h"
#import "HDNetworkProxy+HDNetworkProxyUtils.h"
#import "HDNetworkProxy+HDAFNetworking.h"

@interface HDNetworkProxy ()

@property (nonatomic, strong) NSMutableDictionary *requestsRecord;

@end

@implementation HDNetworkProxy

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark
#pragma mark Utils

- (NSString *)requestHashKey:(NSOperation *)operation
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}

- (void)addOperation:(NSOperation *)operation
{
    if (operation != nil)
    {
        NSString *key = [self requestHashKey:operation];
        @synchronized(self)
        {
            self.requestsRecord[key] = operation;
        }
    }
}

- (void)removeOperation:(NSOperation *)operation
{
    if (operation != nil)
    {
        NSString *key = [self requestHashKey:operation];
        @synchronized(self)
        {
            [self.requestsRecord removeObjectForKey:key];
        }
    }
}

#pragma mark
#pragma mark Getter/Setter

- (NSMutableDictionary *)requestsRecord
{
    if (nil == _requestsRecord)
    {
        _requestsRecord = [[NSMutableDictionary alloc] init];
    }
    return _requestsRecord;
}

#pragma mark
#pragma mark 处理回调

- (void)requestFinished:(id<HDNetworkRequestCallBack>)callBack response:(id)responseObject
{
    if ([callBack respondsToSelector:@selector(requestFinished:response:)])
    {
        [callBack requestFinished:callBack response:responseObject];
    }
}

- (void)requestFailed:(id<HDNetworkRequestCallBack>)callBack error:(NSError *)error
{
    if ([callBack respondsToSelector:@selector(requestFailed:error:)])
    {
        [callBack requestFailed:callBack error:error];
    }
}

#pragma mark
#pragma mark Public method

- (NSString *)sendRequest:
    (id<HDNetworkRequest, HDNetworkValidator, HDNetworkRequestCallBack>)request
{
    NSString *requestID;
    //参数处理
    id parameters = [self loadParamsWith:request];
    NSError *error;
    //验证参数
    if ([self shouldRequestWith:request params:parameters error:&error])
    {
        NSString *URLString = [self buildRequestURLStringWith:request];
        HDRequestMethod method = [self loadRequestMethodWith:request];
        //配置请求参数
        [self configureManagerwithRequest:request];
        //创建请求
        NSOperation *operation;
        NSURLRequest *customURLRequest = [self loadCustomURLRequestWith:request];

        operation = [self loadRequest:request
            customURLRequest:customURLRequest
            httpMethod:method
            urlString:URLString
            parameters:parameters
            success:^(NSOperation *operation, id responseObject) {
              //处理成功
              NSString *requestId = [self requestHashKey:operation];
              NSOperation *storedOperation = self.requestsRecord[requestId];
              if (storedOperation)
              {
                  NSError *error = nil;
                  if ([self validatorResponseWith:request response:responseObject error:&error])
                  {
                      [self requestFinished:request response:responseObject];
                  }
                  else
                  {
                      [self requestFailed:request error:error];
                  }
              }
              [self removeOperation:operation];
            }
            failure:^(NSOperation *operation, NSError *error) {
              //处理失败
              NSString *requestId = [self requestHashKey:operation];
              NSOperation *storedOperation = self.requestsRecord[requestId];
              if (storedOperation)
              {
                  [self requestFailed:request error:error];
              }
              [self removeOperation:operation];

            }];
        requestID = [self requestHashKey:operation];
        [self addOperation:operation];
    }
    else
    {
        //参数check失败
        [self requestFailed:request error:error];
    }
    return requestID;
}

- (void)cancelRequest:(NSString *)requestID
{
    NSOperation *operation = self.requestsRecord[requestID];
    [operation cancel];
    [self removeOperation:operation];
}

- (void)cancelAllRequests
{
    NSDictionary *requestList = [self.requestsRecord copy];
    [requestList.allKeys
        enumerateObjectsUsingBlock:^(NSString *requestID, NSUInteger idx, BOOL *_Nonnull stop) {
          [self cancelRequest:requestID];
        }];
}

@end
