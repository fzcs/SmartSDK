//
//  ImageViewModel.h
//  ShotEyesiPAD
//
//  Created by kita on 14-5-16.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Jastor.h>

@interface DAFile : Jastor
@property NSString *_id;
@end


@interface ImageViewModel : NSObject
@property(retain,nonatomic) DAFile *model;
@property(retain, nonatomic) UIImage *image;
@property(retain, nonatomic) NSString* uploadPath;

-(void)upLoadImageThenDo:(void (^)(void))uploadDone;
@end
