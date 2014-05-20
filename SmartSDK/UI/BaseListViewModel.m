//
//  BaseListViewModel.m
//  ShotEyesiPAD
//
//  Created by kita on 14-5-13.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import "BaseListViewModel.h"
#import <SmartSDK/RestHTTPRequestManager.h>
#import <SmartSDK/RestHelper.h>
#import <Underscore.h>


@interface BaseListViewModel ()
@property RestHTTPRequestManager* requestManager;
@property BOOL isLogin;
@end

typedef id(^RACSignalErrorBlock)(NSError*);

@implementation BaseListViewModel
//-(instancetype)init
//{
//    self = [super init];
//    if (self) {
//        // init properties
//        self.requestManager = [RestHTTPRequestManager sharedManager];
//        self.start = 0;
//        self.limit = 20;
//        self.list = [[NSArray alloc] init];
//        self.isLogin = [RestHelper isLogin];
//    }
//    
//
//    
//    return self;
//}

- (id)initWithViewModelClass:(Class) modelClass
                     APIPath:(NSString *)path
{
    self = [super init];
    self.APIPath = path;
    self.modelClass = modelClass;
    
    self.requestManager = [RestHTTPRequestManager sharedManager];
    self.start = 0;
    self.limit = 20;
    self.list = [[NSArray alloc] init];
    self.isLogin = [RestHelper isLogin];
    
    
    [[self reloadSignal] subscribeCompleted:^{
        
    }];
    
    return self;
    
}

- (RACSignalErrorBlock)errorBlock {
    //    @weakify(self);
    return ^(NSError* error) {
        //        @strongify(self);
        NSLog(@"%@",error);
        return [RACSignal empty];
    };
}


-(RACSignal *)reloadSignal
{
    self.start = 0;
    return [self loadSignal];
}

-(RACSignal *)loadMoreSignal
{
    self.start += self.limit;
    return [self loadSignal];
}


-(RACSignal *)loadSignal
{
    if (_listCondition == nil) {
        _listCondition = [[NSDictionary alloc] init];
    }
    
    NSDictionary *params = Underscore.extend(_listCondition, @{ @"start": [NSNumber numberWithInt:self.start], @"limit": [NSNumber numberWithInt:self.limit] });
    
    RACSignal *sig = [[self.requestManager getPath:self.APIPath parameters:params] map:^id(id result) {
        
        NSDictionary *data =[result valueForKeyPath:@"data"];
        
        NSArray *array = [data valueForKey:@"items"];
        
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in array) {
            id category = [[self.modelClass alloc] initWithDictionary:dic];
            
            [tmp addObject:category];
        }
        
        if (self.start == 0) {
            self.list = [NSArray arrayWithArray:tmp];
        } else {
            self.list = [self.list arrayByAddingObjectsFromArray:tmp];
        }
        
        
        return result;
    }];
    
    return sig;
    
//    if (self.isLogin) {
//        return [sig catch:self.errorBlock];
//    } else {
//        RestHelper *helper = [RestHelper sharedInstance];
//        return [[[[helper authorize] catch:self.errorBlock] concat:sig] catch:self.errorBlock];
//    }
}

@end
