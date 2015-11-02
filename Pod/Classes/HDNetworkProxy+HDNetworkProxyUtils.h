//
//  HDNetworkProxy+HDNetworkProxyUtils.h
//  Pods
//
//  Created by Dailingchi on 15/11/2.
//
//

#import "HDNetworkProxy.h"

@interface HDNetworkProxy (HDNetworkProxyUtils)

#pragma mark
#pragma mark Request
- (NSString *)buildRequestURLStringWith:(id<HDNetworkRequest>)request;
- (HDRequestMethod)loadRequestMethodWith:(id<HDNetworkRequest>)request;
- (NSTimeInterval)loadRequestTimeoutIntervalWith:(id<HDNetworkRequest>)request;
- (NSURLRequest *)loadCustomURLRequestWith:(id<HDNetworkRequest>)request;
- (NSDictionary *)loadRequestHeaderFieldWith:(id<HDNetworkRequest>)request;

#pragma mark
#pragma mark Params
- (id)loadParamsWith:(id<HDNetworkRequest>)request;
- (BOOL)shouldRequestWith:(id<HDNetworkValidator>)validator
                   params:(id)params
                    error:(NSError **)error;

#pragma mark
#pragma mark validator
- (BOOL)validatorRequestWith:(id<HDNetworkValidator>)validator
                      params:(id)params
                       error:(NSError **)error;
- (BOOL)validatorResponseWith:(id<HDNetworkValidator>)validator
                     response:(id)response
                        error:(NSError **)error;

@end
