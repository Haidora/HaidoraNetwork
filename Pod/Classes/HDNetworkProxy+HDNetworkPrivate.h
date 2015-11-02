//
//  HDNetworkProxy+HDNetworkPrivate.h
//  Pods
//
//  Created by Dailingchi on 15/10/30.
//
//

#import "HDNetworkProxy.h"

@interface HDNetworkProxy (HDNetworkPrivate)

#pragma mark
#pragma mark Serializer

- (Class)loadRequestSerializerWith:(id<HDNetworkRequest>)request;
- (Class)loadResponseSerializerWith:(id<HDNetworkRequest>)request;

#pragma mark
#pragma mark AFNetworking
// TODO: 暂时不考虑AFNetwork3.x

- (void)configureManagerwithRequest:(id<HDNetworkRequest>)requeset;

//创建request
- (NSOperation *)loadRequest:
                     (id<HDNetworkRequest, HDNetworkValidator, HDNetworkRequestCallBack>)request
            customURLRequest:(NSURLRequest *)customURLRequest
                  httpMethod:(HDRequestMethod)method
                   urlString:(NSString *)URLString
                  parameters:(id)parameters
                     success:(void (^)(NSOperation *operation, id responseObject))success
                     failure:(void (^)(NSOperation *operation, NSError *error))failure;

@end
