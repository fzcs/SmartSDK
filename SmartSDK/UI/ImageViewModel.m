//
//  ImageViewModel.m
//  ShotEyesiPAD
//
//  Created by kita on 14-5-16.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import "ImageViewModel.h"
#import <SmartSDK/RestHTTPRequestManager.h>
#import <SmartSDK/RestHelper.h>
@implementation DAFile
@end

@interface ImageViewModel()
@property RestHTTPRequestManager* requestManager;
@end

@implementation ImageViewModel
-(id)init
{
    self = [super init];
    self.requestManager = [RestHTTPRequestManager sharedManager];
    
    return self;
}


-(void)upLoadImageThenDo:(void (^)(void))uploadDone
{
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.5);
    self.requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestManager POST:@"/Picture/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data =[responseObject valueForKeyPath:@"data"];
        
        self.model = [[DAFile alloc] initWithDictionary:data];
        
        if (uploadDone) {
            uploadDone();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
    
    
//    [op start];
}
@end
