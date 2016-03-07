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
#import "TagManager.h"

@interface FlikrDetailsDataController : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nullable, strong, nonatomic) NSIndexPath      *selectedIndexPath;
@property (nullable, strong, nonatomic) Photo            *aPhoto;
@property (nullable, strong, nonatomic) Tag *aTag;
@property (nullable, strong, nonatomic) UICollectionView *collectionView;

@property (nullable, strong, nonatomic) id<FlikrServiceProtocol> service;
@property (nullable, strong, nonatomic) PhotoManager         *photoManager;
@property (nullable, strong, nonatomic) TagManager           *tagManager;
@property (nullable, strong, nonatomic) NSMutableArray * tagTextSizes;

+ (nullable instancetype)createInstance;
- (nullable UIImageView *)getPhotoFromURL;
- (void)initFetchResultControler;
- ( void)updateSelectedPhoto:(nullable Photo *)aPhoto updatedPhoto:(nullable void(^)(Photo * _Nullable))photo;

@end
