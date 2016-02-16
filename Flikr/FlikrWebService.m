//
//  FlikrWebService.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrWebService.h"


@implementation FlikrWebService 

- (void)imagesRequest:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    NSURLSession *session          = [NSURLSession sharedSession];
    NSString *urlString            = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=dfa0cb9a0759c6b988869bf35040b1ef&user_id=138446653%40N07&format=json&nojsoncallback=1&auth_token=72157662390960394-5ca396ed494fc928&api_sig=112e91558a26f5b7ad7e50036ee350ed";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
    [dataTask resume];
}

@end
