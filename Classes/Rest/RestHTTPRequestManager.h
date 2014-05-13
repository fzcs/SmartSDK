//
//  RestHTTPRequestManager.h
//  RestApi
//
//  Created by kita on 14-5-12.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "ReactiveCocoa.h"
#import "RACAFNetworking.h"

@interface RestHTTPRequestManager : AFHTTPRequestOperationManager
+(RestHTTPRequestManager *)sharedManager;

- (RACSignal *)getPath:(NSString *)path parameters:(NSDictionary *)parameters;
@end
