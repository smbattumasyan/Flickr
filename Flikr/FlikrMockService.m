//
//  FlikrMockService.m
//  Flikr
//
//  Created by Smbat Tumasyan on 3/1/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrMockService.h"

@implementation FlikrMockService

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

- (void)imagesRequest:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FlikrPhotos" ofType:@"json"];
    NSData *data       = [NSData dataWithContentsOfFile:filePath];
    completionHandler(data,nil,nil);
}

- (void)imageRequest:(NSString*)photoID completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FlikrPhoto" ofType:@"json"];
    NSData *data       = [NSData dataWithContentsOfFile:filePath];
    completionHandler(data,nil,nil);
}

@end
