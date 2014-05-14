#import "DAEntity.h"

@implementation DAEntity

- (NSArray *) multiInitWithArray:(NSArray *)array{
    
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:[array count]];
    for (NSDictionary *dic in array) {
        DACategory *obj = [[DACategory alloc] initWithDictionary: dic];
        [result addObject:obj];
    }
    return result;
}

+ (NSArray *) multiObjectFromArray:(NSArray *)array{
    return [[self alloc] multiInitWithArray:array];
}
@end