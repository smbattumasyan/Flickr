//
//  PhotoManager.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/15/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

- (NSMutableArray<Photo *> *)photosRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    return [[self.coreDataManager.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

- (void)addPhoto:(nullable NSDictionary *)photo
{
    Photo *aPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.coreDataManager.managedObjectContext];
//    NSLog(@"%@",[[photo valueForKey:@"id"] componentsJoinedByString:@","]);
    
    NSDictionary *description = [photo valueForKey:@"descripotion"];
    NSDictionary *dates       = [photo valueForKey:@"dates"];
    aPhoto.farmID             = [[photo valueForKey:@"farm"] componentsJoinedByString:@","];
    aPhoto.serverID           = [[photo valueForKey:@"server"] componentsJoinedByString:@","];
    aPhoto.photoID            = [[photo valueForKey:@"id"] componentsJoinedByString:@","];
    aPhoto.secret             = [[photo valueForKey:@"secret"] componentsJoinedByString:@","];
    aPhoto.photoName          = [[photo valueForKey:@"title"] componentsJoinedByString:@","];
    aPhoto.photoDate          = [self setPhotoDateFormat:[NSString stringWithFormat:@"%@",[dates valueForKey:@"taken"]]];
    aPhoto.photoDescription   = [[description valueForKey:@"_content"] componentsJoinedByString:@","];

//    [aPhoto setValue:[NSString stringWithFormat:@"%@",[photo valueForKey:@"farm"]] forKey:@"farmID"];

    
    [self.coreDataManager saveContext];
}

//- (void)updatePhoto:(nullable Photo *)aPhoto newPhoto:(nullable NSDictionary *)newPhoto
//{
//    NSDictionary *description = [newPhoto valueForKey:@"descripotion"];
//    NSDictionary *dates       = [newPhoto valueForKey:@"dates"];
//    [aPhoto setValue: forKey:@"description"];
//}

- (NSDate *)setPhotoDateFormat:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *photoDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",dateString]];
    return photoDate;
}

- (void)deletePhoto:(Photo *)managedObject
{
    [self.coreDataManager.managedObjectContext deleteObject:managedObject];
    [self.coreDataManager saveContext];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"farmID" ascending: NO];
    [request setSortDescriptors:@[sortDescriptor]];
    _fetchedResultsController        = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                           managedObjectContext:self.coreDataManager.managedObjectContext
                                                                             sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    
    if( ! [_fetchedResultsController performFetch: &error] ) {
        NSLog( @"Error Description: %@", [error userInfo] );
    }
    return _fetchedResultsController;
}


@end
