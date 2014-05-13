//
//  DAStorable.h
//  Pods
//
//  Created by 罗浩 on 14-5-13.
//
//

#import <Foundation/Foundation.h>

@interface DAStorable : NSObject {
    NSCache *_cacher;
}

/**
 init with NSCache
 */
- (instancetype)initWithCacher:(NSCache *)cacher;

/**
 Returns the shared storable instance.
 */
+ (instancetype)sharedManager;

/**
 从存储获取对象
 */

- (id)loadByKey:(NSString *)key;

/**
 存储对象
 */
- (id)store:(id)obj withKey:(NSString *)key;

/**
 设置存储文件的路径
 */
@property(nonatomic, strong) NSString *storeDirPath;

@end
