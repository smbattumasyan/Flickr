//
//  FlikrDetailsDataController.h
//  Flikr
//
//  Created by Smbat Tumasyan on 3/3/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlikrService.h"
#import "CoreDataManager.h"
#import "PhotoManager.h"
#import "Photo.h"

@interface FlikrDetailsDataController : NSObject


@property (nullable, strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nullable, strong, nonatomic) Photo *aPhoto;

@property (nullable, strong, nonatomic) id<FlikrServiceProtocol> service;
@property (nullable, strong, nonatomic) PhotoManager         *photoManager;

+ (nullable instancetype)createInstance;
- (nullable UIImageView *)getPhotoFromURL;
- (void)updateSelectedPhoto:(nullable Photo *)aPhoto updatedPhoto:(nullable void(^)(Photo * _Nullable))photo;

@end
