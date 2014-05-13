//
//  NSString+DAUtil.m
//  Pods
//
//  Created by 罗浩 on 14-5-13.
//
//

#import "NSString+DAUtil.h"

@implementation NSString (DAUtil)

+ (BOOL)isEmpty:(NSString *)str {
    return (![self isNotEmpty:str]);
}

+ (BOOL)isNotEmpty:(NSString *)str {
    return (str && 0 < str.length);
}
@end
