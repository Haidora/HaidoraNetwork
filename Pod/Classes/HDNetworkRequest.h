//
//  HDNetworkRequest.h
//  Pods
//
//  Created by Dailingchi on 15/10/26.
//
//

#import <Foundation/Foundation.h>
#import "HDNetworkDefines.h"

/**
 *  一个具体的请求
 */
@interface HDNetworkRequest
    : NSObject <HDNetworkRequest, HDNetworkValidator, HDNetworkRequestCallBack>

// Default is nil
@property (nonatomic, copy) void (^successCompletionBlock)(id request, id responseObject);
@property (nonatomic, copy) void (^failureCompletionBlock)(id request, NSError *error);

- (NSString *)start;
- (NSString *)startWithCompletionBlockWithSuccess:(void (^)(id request, id responseObject))success
                                          failure:(void (^)(id request, NSError *error))failure;

- (void)stopWith:(NSString *)requestID;
- (void)clearCompletionBlock;

@end
