//
//  DALogger.h
//  ShotEyes
//
//  Created by 罗浩 on 14-5-12.
//  Copyright (c) 2014年 DreamArts. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DALoggerHeader.h"


@interface DALogger : NSObject

+ (void)initWithLoggerType:(DALoggerType)type logLevel:(int)level;

@end
