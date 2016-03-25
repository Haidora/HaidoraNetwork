//
//  HDNetworkProxy+HDNetworkProxyUtils.m
//  Pods
//
//  Created by Dailingchi on 15/11/2.
//
//

#import "HDNetworkProxy+HDNetworkProxyUtils.h"
#import "HDNetworkConfig.h"

@implementation HDNetworkProxy (HDNetworkProxyUtils)

#pragma mark
#pragma mark Request

- (NSString *)buildRequestURLStringWith:(id<HDNetworkRequest>)request
{
    NSString *detailUrl;
    if ([request respondsToSelector:@selector(requesetURLString)])
    {
        detailUrl = [request requesetURLString];
    }
    //绝对地址
    if ([detailUrl hasPrefix:@"http"])
    {
        return detailUrl;
    }
    // filter url

    NSString *baseUrl;
    if ([request respondsToSelector:@selector(useCDN)] &&
        [request respondsToSelector:@selector(cdnURL)] && [request useCDN])
    {
        NSString *tempUrl = [request cdnURLString];
        if (tempUrl.length > 0)
        {
            baseUrl = tempUrl;
        }
        else
        {
            baseUrl = [[HDNetworkConfig sharedInstance] cdnURL];
        }
    }
    else if ([request respondsToSelector:@selector(baseURLString)])
    {
        NSString *tempUrl = [request baseURLString];
        if (tempUrl.length > 0)
        {
            baseUrl = tempUrl;
        }
        else
        {
            baseUrl = [[HDNetworkConfig sharedInstance] baseURL];
        }
    }
    if (baseUrl.length <= 0)
    {
        baseUrl = [[HDNetworkConfig sharedInstance] baseURL];
    }
    //可以处理结尾是否是"/"
    NSAssert(baseUrl != nil, @"请求地址为空");
    if ([baseUrl hasSuffix:@"/"])
    {
        baseUrl = [baseUrl stringByReplacingCharactersInRange:NSMakeRange(baseUrl.length - 1, 1)
                                                   withString:@""];
    }
    if ([detailUrl hasPrefix:@"/"])
    {
        detailUrl = [detailUrl stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    if (detailUrl)
    {
        return [baseUrl stringByAppendingFormat:@"/%@", detailUrl];
    }
    else
    {
        return baseUrl;
    }
}

- (HDRequestMethod)loadRequestMethodWith:(id<HDNetworkRequest>)request
{
    HDRequestMethod result = HDRequestMethodGet;
    if ([request respondsToSelector:@selector(requestMethod)])
    {
        result = [request requestMethod];
    }
    return result;
}

- (NSTimeInterval)loadRequestTimeoutIntervalWith:(id<HDNetworkRequest>)request
{
    NSTimeInterval result = [HDNetworkConfig sharedInstance].requestTimeoutInterval;
    if ([request respondsToSelector:@selector(requestTimeoutInterval)])
    {
        result = [request requestTimeoutInterval];
    }
    return result;
}

- (NSURLRequest *)loadCustomURLRequestWith:(id<HDNetworkRequest>)request
{
    NSURLRequest *result = nil;
    if ([request respondsToSelector:@selector(customURLRequest)])
    {
        result = [request customURLRequest];
    }
    return result;
}

- (NSDictionary *)loadRequestHeaderFieldWith:(id<HDNetworkRequest>)request
{
    NSDictionary *result = nil;
    if ([request respondsToSelector:@selector(requestHeaderField)])
    {
        result = [request requestHeaderField];
    }
    return result;
}

#pragma mark
#pragma mark Params

- (id)loadParamsWith:(id<HDNetworkRequest>)request
{
    id params = nil;
    if ([request respondsToSelector:@selector(requestArgument)])
    { // 1.获取请求参数。
        params = [request requestArgument];
        if ([request respondsToSelector:@selector(reformParams:)])
        {
            // 2.是否需要添加额外的参数。
            params = [request reformParams:params];
        }
    }
    return params;
}

- (BOOL)shouldRequestWith:(id<HDNetworkValidator>)validator
                   params:(id)params
                    error:(NSError **)error
{
    BOOL result = YES;
    if (result && [validator respondsToSelector:@selector(requestIsCorrectWithParams:error:)])
    {
        // 请求数据是否正确
        result = [validator requestIsCorrectWithParams:params error:error];
    }

    return result;
}

#pragma mark
#pragma mark validator

- (BOOL)validatorRequestWith:(id<HDNetworkValidator>)validator
                      params:(id)params
                       error:(NSError **)error
{
    BOOL result = YES;
    if ([validator respondsToSelector:@selector(requestIsCorrectWithParams:error:)])
    {
        result = [validator requestIsCorrectWithParams:params error:error];
    }
    return result;
}

- (BOOL)validatorResponseWith:(id<HDNetworkValidator>)validator
                     response:(id)response
                        error:(NSError **)error
{
    BOOL result = YES;
    if ([validator respondsToSelector:@selector(responseIsCorrectWithResponse:error:)])
    {
        result = [validator responseIsCorrectWithResponse:response error:error];
    }
    return result;
}

@end
