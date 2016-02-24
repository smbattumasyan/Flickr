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
    NSString *urlString            = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=8619830dd39d92f864697d8c60a5e910&tags=BeautifulCity&format=json&nojsoncallback=1";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
    [dataTask resume];
}

- (void)imageRequest:(NSString*)photoID completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    NSURLSession *session          = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=8619830dd39d92f864697d8c60a5e910&photo_id=%@&secret=795c4cef2fdc0001&format=json&nojsoncallback=1",photoID];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
    [dataTask resume];
}

@end
