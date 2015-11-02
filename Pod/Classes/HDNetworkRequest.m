//
//  HDNetworkRequest.m
//  Pods
//
//  Created by Dailingchi on 15/10/26.
//
//

#import "HDNetworkRequest.h"
#import "HDNetworkProxy.h"

@implementation HDNetworkRequest

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // TODO: 添加日志功能
        // TODO: 添加请求缓存
    }
    return self;
}

- (void)dealloc
{
    [self clearCompletionBlock];
}

#pragma mark
#pragma mark HDNetworkRequestCallBack

- (void)requestFinished:(id)request response:(id)responseObject
{
    if (_successCompletionBlock)
    {
        _successCompletionBlock(request, responseObject);
    }
    [self clearCompletionBlock];
}

- (void)requestFailed:(id)request error:(NSError *)error
{
    if (_failureCompletionBlock)
    {
        _failureCompletionBlock(request, error);
    }
    [self clearCompletionBlock];
}

#pragma mark
#pragma mark Public

- (NSString *)start
{
    return [[HDNetworkProxy sharedInstance] sendRequest:self];
}

- (void)stopWith:(NSString *)requestID;
{
    [self clearCompletionBlock];
    [[HDNetworkProxy sharedInstance] cancelRequest:requestID];
}

- (NSString *)startWithCompletionBlockWithSuccess:(void (^)(id request, id responseObject))success
                                          failure:(void (^)(id request, NSError *error))failure
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    return [self start];
}

- (void)clearCompletionBlock
{
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark
#pragma mark Utils

//- (BOOL)respondsToSelector:(SEL)aSelector
//{
//    if ([super respondsToSelector:aSelector])
//    {
//        return YES;
//    }
//    else if (self.delegate != self && [self.delegate respondsToSelector:aSelector])
//    {
//        return YES;
//    }
//    else if (self.validator != self && [self respondsToSelector:aSelector])
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (self.delegate != self && [self.delegate respondsToSelector:aSelector])
//    {
//        return self.delegate;
//    }
//    else if (self.validator != self && [self.validator respondsToSelector:aSelector])
//    {
//        return self.validator;
//    }
//    else
//    {
//        // never call
//        return nil;
//    }
//}

@end
