//
//  HDNetworkDefines.h
//  Pods
//
//  Created by Dailingchi on 15/10/23.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HDRequestMethod)
{
    HDRequestMethodGet = 0,
    HDRequestMethodPost,
    HDRequestMethodHead,
    HDRequestMethodPut,
    HDRequestMethodDelete,
    HDRequestMethodPatch
};

typedef NS_ENUM(NSInteger, HDSerializerType)
{
    HDSerializerTypeHTTP = 0,
    HDSerializerTypeJSON
};

#pragma mark
#pragma mark HDNetworkRequest

@protocol HDNetworkRequest <NSObject>

@optional

#pragma mark
#pragma mark Request Config

//服务相对或绝对地址
- (NSString *)requesetURLString;
- (BOOL)useCDN;
- (NSString *)cdnURLString;
- (NSString *)baseURLString;
- (HDRequestMethod)requestMethod;
- (NSTimeInterval)requestTimeoutInterval;
- (NSURLRequest *)customURLRequest;
- (NSDictionary *)requestHeaderField;

#pragma mark
#pragma mark Params

//请求参数
- (id)requestArgument;
//在调用request之前额外添加一些参数,但不应该在这个函数里面修改已有的参数
- (id)reformParams:(id)params;

#pragma mark
#pragma mark Serializer

- (HDSerializerType)requestSerializerType;
- (HDSerializerType)responseSerializerType;
- (Class)requestSerializerClass;
- (Class)responseSerializerClass;

@end

#pragma mark
#pragma mark HDNetworkValidator
//请求参数和返回接口check
@protocol HDNetworkValidator <NSObject>

@optional

//默认返回YES,如果返回为NO,则不发出请求
- (BOOL)requestIsCorrectWithParams:(id)params error:(NSError **)error;
//默认返回YES,如果返回为NO,则回调错误
- (BOOL)responseIsCorrectWithResponse:(id)data error:(NSError **)error;

@end

#pragma mark
#pragma mark HDNetworkRequestCallBack

@protocol HDNetworkRequestCallBack <NSObject>

@optional
- (void)requestFinished:(id)request response:(id)responseObject;
- (void)requestFailed:(id)request error:(NSError *)error;

@end

@protocol HDNetworkInterceptor <NSObject>

@optional
//- (void)requestDidStart:(HDNetworkRequest *)request;
//- (void)requestDidStop:(HDNetworkRequest *)request;

@end