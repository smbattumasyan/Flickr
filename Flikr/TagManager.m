//
//  TagManager.m
//  Flikr
//
//  Created by Smbat Tumasyan on 3/7/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "TagManager.h"

@implementation TagManager

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

- (void)addTags:(nullable NSArray *)jsonDict
{
    for (NSString *tagName in jsonDict) {
        Tag *aTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.coreDataManager.managedObjectContext];
        aTag.tag = [NSString stringWithFormat:@"%@",tagName];
    }
}


- (Tag *)fetchSelectedTag:(NSIndexPath *)indexPath
{
    return [[self fetchedResultsController] objectAtIndexPath:indexPath];
}

- (void)deleteTag:(NSArray *)photos
{
    for (Tag *aTag in photos) {
        [self.coreDataManager.managedObjectContext deleteObject:aTag];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending: NO];
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
