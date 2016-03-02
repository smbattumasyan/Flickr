//
//  FlikrFeedDataController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/16/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrFeedDataController.h"
#import "FlikrWebService.h"

@interface FlikrFeedDataController ()

@end

@implementation FlikrFeedDataController

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

+ (instancetype)createInstance
{
    FlikrFeedDataController *dataController = [[FlikrFeedDataController alloc] init];
    return dataController;
}
//------------------------------------------------------------------------------------------
#pragma mark - CollectionView Data Source
//------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.photoManager.fetchedResultsController fetchedObjects] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundView        = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSURL *url         = [NSURL URLWithString:[self loadPhotoURL:indexPath]];
        NSLog(@"__indexPath:(%ld) photourl:(%@)",(long)indexPath.row, [self loadPhotoURL:indexPath]);
        cell.backgroundView = nil;
        cell.backgroundColor   = [UIColor grayColor];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.backgroundView = [[UIImageView alloc ] initWithImage:image];
                        NSLog(@"set!");
                    });
                }
            }
        }];
         [task resume];
        cell.layer.cornerRadius = 10;
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
//            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadData];
            break;
            
        case NSFetchedResultsChangeMove:
            
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

//------------------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------------------

- (UIImageView *)setPhotos:(NSIndexPath *)indexPath
{
    NSString *photoURL = [self loadPhotoURL:indexPath];
    NSURL *url   = [NSURL URLWithString:photoURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    return [[UIImageView alloc ] initWithImage:img];
}

- (void)loadPhotos
{
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *imageJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *photos      = [[imageJson valueForKeyPath:@"photos.photo.id"] mutableCopy];
        NSMutableArray *savedPhotos = [[[self.photoManager fetchedResultsController] fetchedObjects] mutableCopy];
        
        for (NSInteger i = savedPhotos.count - 1; i >= 0; i--) {
            Photo *aPhoto = savedPhotos[i];
            if ([photos containsObject:aPhoto.photoID]) {
                [savedPhotos removeObject:aPhoto];
            }
        }
        [self.photoManager deletePhoto:savedPhotos];
        
        photos      = [[imageJson valueForKeyPath:@"photos.photo"] mutableCopy];
        savedPhotos = [[[[self.photoManager fetchedResultsController] fetchedObjects] valueForKey:@"photoID"] mutableCopy];
        for (NSInteger i = photos.count - 1; i >= 0; i--) {
            NSDictionary *aPhoto = photos[i];
            if ([savedPhotos containsObject:[aPhoto valueForKey:@"id"]]) {
                [photos removeObject:aPhoto];
            }
        }
        
//        NSLog(@"tosave%@",);
        [self.photoManager addPhoto:photos];
    }];
}

- (NSString *)loadPhotoURL:(NSIndexPath *)indexPath
{
    Photo *aPhoto    = [self loadPhoto:indexPath];
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",aPhoto.farmID,aPhoto.serverID,aPhoto.photoID,aPhoto.secret];
    NSLog(@"------%@",photoURL);
    return photoURL;
}

- (Photo *)loadPhoto:(NSIndexPath *)indexPath
{
    Photo *aPhoto = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];
    return aPhoto;
}

- (void)initFetchResultControler
{
    self.photoManager.fetchedResultsController.delegate = self;
}


- (NSString *)jsonStringWithPrettyPrint:(NSDictionary *)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (!jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint:error:%@",error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
