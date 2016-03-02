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

#pragma mark - Properties

@property (nonnull, strong, nonatomic ) CoreDataManager            *coreDataManager;
@property (nonnull, strong, nonatomic ) NSFetchedResultsController *fetchedResultsController;

#pragma mark - Instance Methods

- (void)addPhoto:(nullable NSArray *)photo;
- (void)deletePhoto:(nullable NSArray *)photos;

@end
