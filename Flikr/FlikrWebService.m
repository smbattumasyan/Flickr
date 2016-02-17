//
//  FlikrWebService.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrWebService.h"


@implementation FlikrWebService 

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

- (void)imagesRequest:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    NSURLSession *session          = [NSURLSession sharedSession];
    NSString *urlString            = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=76d55f7653f69d24d85728b5e760d552&user_id=138446653%40N07&format=json&nojsoncallback=1";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
    [dataTask resume];
}

- (void)imageRequest:(NSString*)photoID completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    NSURLSession *session          = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=76d55f7653f69d24d85728b5e760d552&photo_id=%@&format=json&nojsoncallback=1",photoID];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
    [dataTask resume];
}

@end
