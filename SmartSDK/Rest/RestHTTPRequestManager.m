//
//  RestHTTPRequestManager.m
//  RestApi
//
//  Created by kita on 14-5-12.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import "RestHTTPRequestManager.h"
#import "RestHelper.h"

@implementation RestHTTPRequestManager
+(RestHTTPRequestManager *)sharedManager
{
    static RestHTTPRequestManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RestHTTPRequestManager alloc] initWithBaseURL:[NSURL URLWithString:[RestHelper getServerAddress]]];
    });
    
    return _sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return self;
}

- (RACSignal *)getPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self rac_GET:path parameters:parameters];
}



@end
