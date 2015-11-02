//
//  HDNetworkConfig.m
//  Pods
//
//  Created by Dailingchi on 15/10/23.
//
//

#import "HDNetworkConfig.h"

@implementation HDNetworkConfig

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _requestTimeoutInterval = 60;
    }
    return self;
}

@end
