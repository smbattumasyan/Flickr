//
//  FlikrService.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#ifndef FlikrService_h
#define FlikrService_h

#import <UIKit/UIKit.h>

@protocol FlikrServiceProtocol <NSObject>

#pragma mark - Protocol Methods

@optional

- (void)imagesRequest:(nullable void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler;


@end

#endif /* FlikrService_h */
