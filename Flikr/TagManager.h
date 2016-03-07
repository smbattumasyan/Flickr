//
//  TagManager.h
//  Flikr
//
//  Created by Smbat Tumasyan on 3/7/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "Tag.h"

@interface TagManager : NSObject

@property (nonnull, strong, nonatomic ) CoreDataManager            *coreDataManager;
@property (nonnull, strong, nonatomic ) NSFetchedResultsController *fetchedResultsController;

#pragma mark - Instance Methods

- (void)addTags:(nullable NSArray *)tag;
- (void)deleteTag:(nullable NSArray *)tags;
- (nullable Tag *)fetchSelectedTag:(nullable NSIndexPath *)indexPath;

@end
