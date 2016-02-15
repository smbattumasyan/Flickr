//
//  PhotoManager.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/15/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "Photo.h"

@interface PhotoManager : NSObject

@property (nonnull, strong, nonatomic ) CoreDataManager *coreDataManager;
@property (nonnull, strong, nonatomic ) NSFetchedResultsController *fetchedResultsController;

#pragma marik - Instance Methods

- (nullable NSMutableArray<Photo *> *)photosRequest;
- (void)addPhoto:(nullable NSDictionary *)photo;
- (void)deletePhoto:(nonnull Photo *)managedObject;

@end
