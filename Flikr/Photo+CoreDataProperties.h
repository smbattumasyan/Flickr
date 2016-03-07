//
//  Photo+CoreDataProperties.h
//  Flikr
//
//  Created by Smbat Tumasyan on 3/7/16.
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
@property (nullable, nonatomic, retain) NSSet<Tag *> *tags;

@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet<Tag *> *)values;
- (void)removeTags:(NSSet<Tag *> *)values;

@end

NS_ASSUME_NONNULL_END
