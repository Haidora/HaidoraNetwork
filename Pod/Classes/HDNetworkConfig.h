//
//  HDNetworkConfig.h
//  Pods
//
//  Created by Dailingchi on 15/10/23.
//
//

#import <Foundation/Foundation.h>

/**
 *  网络相关配置
 */
@interface HDNetworkConfig : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *cdnURL;

/**
 *  请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

@end
