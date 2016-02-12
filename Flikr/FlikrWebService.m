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
    NSString *urlString            = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=8c281139eedad28ec824677fbd0651a0&user_id=138446653%40N07&format=json&nojsoncallback=1&auth_token=72157662252407623-8eab43a880e6ae09&api_sig=04f1e883022d733dd8daa302bb722beb";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
    [dataTask resume];
}

@end
