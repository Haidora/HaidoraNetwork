//
//  HDNetworkProxy+HDNetworkPrivate.m
//  Pods
//
//  Created by Dailingchi on 15/10/30.
//
//

#import "HDNetworkProxy+HDNetworkPrivate.h"
#import "HDNetworkConfig.h"
#import "HDNetworkProxy+HDNetworkProxyUtils.h"

#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

static char *kHDNetworkProxy_manager = "kHDNetworkProxy_manager";

@interface HDNetworkProxy (HDNetwork)

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HDNetworkProxy (HDNetwork)

@dynamic manager;

- (void)setManager:(AFHTTPRequestOperationManager *)manager
{
    objc_setAssociatedObject(self, &kHDNetworkProxy_manager, manager,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFHTTPRequestOperationManager *)manager
{
    AFHTTPRequestOperationManager *manager =
        objc_getAssociatedObject(self, &kHDNetworkProxy_manager);
    if (nil == manager)
    {
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.operationQueue.maxConcurrentOperationCount = 4;
        [self setManager:manager];
    }
    return manager;
}

@end

@implementation HDNetworkProxy (HDNetworkPrivate)

#pragma mark
#pragma mark Serializer

- (Class)loadRequestSerializerWith:(id<HDNetworkRequest>)request
{
    Class serializerClass = [AFHTTPRequestSerializer class];
    // default Serializer
    if ([request respondsToSelector:@selector(requestSerializerType)])
    {
        HDSerializerType serializerType = [request requestSerializerType];
        if (serializerType == HDSerializerTypeHTTP)
        {
            serializerClass = [AFHTTPRequestSerializer class];
        }
        else if (serializerType == HDSerializerTypeJSON)
        {
            serializerClass = [AFJSONRequestSerializer class];
        }
    }

    // custom Serializer
    if ([request respondsToSelector:@selector(requestSerializerClass)] &&
        [request requestSerializerClass])
    {
        Class serializer = [request requestSerializerClass];
        if ([serializer isSubclassOfClass:[AFHTTPRequestSerializer class]])
        {
            serializerClass = serializer;
        }
        else
        {
            NSAssert(FALSE, @"%@ must be subClass of AFHTTPRequestSerializer",
                     NSStringFromClass(serializer));
        }
    }
    return serializerClass;
}

- (Class)loadResponseSerializerWith:(id<HDNetworkRequest>)request
{
    Class serializerClass = [AFHTTPResponseSerializer class];
    // default Serializer
    if ([request respondsToSelector:@selector(responseSerializerType)])
    {
        HDSerializerType serializerType = [request responseSerializerType];
        if (serializerType == HDSerializerTypeHTTP)
        {
            serializerClass = [AFHTTPResponseSerializer class];
        }
        else if (serializerType == HDSerializerTypeJSON)
        {
            serializerClass = [AFJSONResponseSerializer class];
        }
    }

    // custom Serializer
    if ([request respondsToSelector:@selector(responseSerializerClass)] &&
        [request requestSerializerClass])
    {
        Class serializer = [request responseSerializerClass];
        if ([serializer isSubclassOfClass:[AFHTTPResponseSerializer class]])
        {
            serializerClass = serializer;
        }
        else
        {
            NSAssert(FALSE, @"%@ must be subClass of AFHTTPResponseSerializer",
                     NSStringFromClass(serializer));
        }
    }
    return serializerClass;
}

#pragma mark
#pragma mark AFNetworking

/**
 *  请求的相关配置
 */
- (void)configureManagerwithRequest:(id<HDNetworkRequest>)requeset
{
    AFHTTPRequestOperationManager *manager = self.manager;
    //设置序列化
    manager.requestSerializer = [[self loadRequestSerializerWith:requeset] serializer];
    manager.responseSerializer = [[self loadResponseSerializerWith:requeset] serializer];
    //请求超时
    manager.requestSerializer.timeoutInterval = [self loadRequestTimeoutIntervalWith:requeset];
    // setAuthorizationHeaderFieldWithUsername
    // headerFieldValueDictionary
    NSDictionary *requestHeaderField = [self loadRequestHeaderFieldWith:requeset];
    [requestHeaderField
        enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
          if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]])
          {
              [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
          }
          else
          {
              //          YTKLog(@"Error, class of key/value in headerFieldValueDictionary shouldbe
              //          NSString.");
          }
        }];
}

- (NSOperation *)loadRequest:
                     (id<HDNetworkRequest, HDNetworkValidator, HDNetworkRequestCallBack>)request
            customURLRequest:(NSURLRequest *)customURLRequest
                  httpMethod:(HDRequestMethod)method
                   urlString:(NSString *)URLString
                  parameters:(id)parameters
                     success:(void (^)(NSOperation *operation, id responseObject))success
                     failure:(void (^)(NSOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = self.manager;
    AFHTTPRequestOperation *operation;

    //自定义request
    if (nil != customURLRequest)
    {
        operation = [manager HTTPRequestOperationWithRequest:customURLRequest
                                                     success:success
                                                     failure:failure];
        [manager.operationQueue addOperation:operation];
    }
    else
    {
        switch (method)
        {
        case HDRequestMethodGet:
        {
            // TODO: 暂时不支持文件下载
            operation =
                [manager GET:URLString parameters:parameters success:success failure:failure];
            break;
        }
        case HDRequestMethodPost:
        {
            operation =
                [manager POST:URLString parameters:parameters success:success failure:failure];
            break;
        }
        case HDRequestMethodHead:
        {
            operation = [manager HEAD:URLString
                parameters:parameters
                success:^(AFHTTPRequestOperation *_Nonnull operation) {
                  if (success)
                  {
                      success(operation, nil);
                  }
                }
                failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                  if (failure)
                  {
                      failure(operation, error);
                  }
                }];
            break;
        }
        case HDRequestMethodPut:
        {
            operation =
                [manager PUT:URLString parameters:parameters success:success failure:failure];
            break;
        }
        case HDRequestMethodDelete:
        {
            operation =
                [manager DELETE:URLString parameters:parameters success:success failure:failure];
            break;
        }
        case HDRequestMethodPatch:
        {
            operation =
                [manager PATCH:URLString parameters:parameters success:success failure:failure];
            break;
        }
        default:
            break;
        }
    }
    return operation;
}

@end