//
//  BaseViewModel.m
//  ShotEyesiPAD
//
//  Created by kita on 14-5-14.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import "BaseViewModel.h"
#import "Jastor.h"
#import <SmartSDK/RestHTTPRequestManager.h>
#import <SmartSDK/RestHelper.h>
#import <Underscore.h>

@interface BaseViewModel ()
@property RestHTTPRequestManager* requestManager;

@end

typedef id(^RACSignalErrorBlock)(NSError*);

@implementation BaseViewModel
-(id)init
{
    self = [super init];
    
    return [self initWithModel:[[[self.model class] alloc] init]];
}

-(id)initWithModel:(id)model
{
    self = [super init];
    self.model = model;
    self.requestManager = [RestHTTPRequestManager sharedManager];
    
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


-(RACSignal *)saveSignal
{
    NSLog([self.model valueForKey:@"_id"],nil);
    if ([self.model valueForKey:@"_id"]) {
        return [self updateSignal];
    } else {
        return [self createSignal];
    }
}

-(RACSignal *)createSignal
{
    
    NSMutableDictionary *data = [(Jastor *)self.model toDictionary];
    
    NSDictionary *params = @{@"data": data};
    
    RACSignal * sig = [[self.requestManager postPath:self.createAPIPath parameters:params] map:^id(id result) {
        NSDictionary *data =[result valueForKeyPath:@"data"];
        
        self.model = [[[self.model class] alloc] initWithDictionary:data];
        
        return result;
    }];
    
    return [sig catch:self.errorBlock];
}


-(RACSignal *)updateSignal
{
    NSDictionary *data = [(Jastor *)self.model toDictionary];
    
    
    NSDictionary *params = @{@"filter":self.updateFilter,@"data": data};
    
    RACSignal * sig = [[self.requestManager putPath:self.updateAPIPath parameters:params] map:^id(id result) {
        NSDictionary *data =[result valueForKeyPath:@"data"];
        
        self.model = [[[self.model class] alloc] initWithDictionary:data];
        
        return result;
    }];
    
    return [sig catch:self.errorBlock];
}

-(RACSignal *)fetchSignal
{
    RACSignal * sig = [[self.requestManager getPath:self.fetchAPIPath parameters:self.fetchFilter] map:^id(id result) {
        NSDictionary *data =[result valueForKeyPath:@"data"];
        
        self.model = [[[self.model class] alloc] initWithDictionary:data];
        
        return result;
    }];
    
    return [sig catch:self.errorBlock];
}

@end
