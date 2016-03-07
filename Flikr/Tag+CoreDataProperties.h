//
//  Tag+CoreDataProperties.h
//  Flikr
//
//  Created by Smbat Tumasyan on 3/7/16.
//  Copyright © 2016 EGS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) Photo *photos;

@end

NS_ASSUME_NONNULL_END
