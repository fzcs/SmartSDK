//
//  DAStorable.m
//  Pods
//
//  Created by 罗浩 on 14-5-13.
//
//

#import "DAStorable.h"

@implementation DAStorable
+ (instancetype)sharedManager {
    static DAStorable *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //_sharedManager = [[self alloc] init];
        _sharedManager = [[self alloc] initWithCacher:[[NSCache alloc] init]];
    });
    return _sharedManager;
}

- (id)loadByKey:(NSString *)key {
    return nil;
}

- (id)store:(id)obj withKey:(NSString *)key {
    return nil;
}


- (instancetype)initWithCacher:(NSCache *)cacher {
    if ((self = [super init])) {
        _cacher = cacher;
    }
    return self;
}
@end
