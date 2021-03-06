//
//  CoreDataManager.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/15/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

#pragma mark - Properties
@property (nullable, readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (nullable, readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (nullable, readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - Class Methods
+ (nonnull instancetype)createInstance;
- (void)saveContext;
- (nullable NSURL *)applicationDocumentsDirectory;

@end
