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
    aPhoto.farmID           = [NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"farm"]];
    aPhoto.serverID         = [NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"server"]];
    aPhoto.photoID          = [NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"id"]];
    aPhoto.secret           = [NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"secret"]];
    aPhoto.photoName        = [NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"title._content"]];    
    aPhoto.photoDate        = [self setPhotoDateFormat:[NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"dates.taken"]]];

    aPhoto.photoDescription = [NSString stringWithFormat:@"%@",[photo valueForKeyPath:@"description._content"]];
    [self.coreDataManager saveContext];
}

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
