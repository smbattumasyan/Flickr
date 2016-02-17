//
//  FlikrFeedDataController.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/16/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlikrService.h"
#import "PhotoManager.h"

@interface FlikrFeedDataController : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

#pragma mark - Propertes
@property (strong, nonatomic)  id<FlikrServiceProtocol>service;
@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (strong, nonatomic) PhotoManager *photoManager;
@property (strong, nonatomic) UICollectionView *collectionView;

#pragma mark - Class Methods
- (void)savePhotos;
+ (instancetype)createInstance;
- (void)initFetchResultControler;
- (UIImageView *)setPhotos:(NSIndexPath *)indexPath;

@end
