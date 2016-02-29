//
//  Photo+CoreDataProperties.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/25/16.
//  Copyright © 2016 EGS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *farmID;
@property (nullable, nonatomic, retain) NSDate *photoDate;
@property (nullable, nonatomic, retain) NSString *photoDescription;
@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSString *photoName;
@property (nullable, nonatomic, retain) NSString *secret;
@property (nullable, nonatomic, retain) NSString *serverID;

@end

NS_ASSUME_NONNULL_END
