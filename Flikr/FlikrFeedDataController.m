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
    return [[self.photoManager.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    Photo *aPhoto              = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];

    NSString *photoURL         = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",aPhoto.farmID,aPhoto.serverID,aPhoto.photoID,aPhoto.secret];
    NSURL *url                 = [NSURL URLWithString:photoURL];
    NSLog(@"__indexPath:(%ld) photourl:(%@)",(long)indexPath.row, photoURL);
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
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
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
//    [self.collectionView reloadData];
}


//------------------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------------------

- (UIImageView *)setPhotos:(NSIndexPath *)indexPath
{
    Photo *aPhoto        = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",aPhoto.farmID,aPhoto.serverID,aPhoto.photoID,aPhoto.secret];
    NSURL *url   = [NSURL URLWithString:photoURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    return [[UIImageView alloc ] initWithImage:img];
}

- (void)savePhotos
{
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *imageJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *photosIDs      = [imageJson valueForKeyPath:@"photos.photo.id"];
        NSMutableArray *savedPhotos;
        
        for (NSString *aPhotoID in photosIDs) {
            savedPhotos = [[self.photoManager photosRequest] valueForKey:@"photoID"];
            [savedPhotos containsObject:aPhotoID];

            if (![savedPhotos containsObject:aPhotoID]) {
                [self.service imageRequest:aPhotoID completionHandler:^(NSData * _Nullable dataImg, NSURLResponse * _Nullable responseImg, NSError * _Nullable errorImg) {
                    NSDictionary *aImageJson = [NSJSONSerialization JSONObjectWithData:dataImg options:0 error:nil];
                    [self.photoManager addPhoto:[aImageJson valueForKeyPath:@"photo"]];
                }];
            }
        }
        savedPhotos = [self.photoManager photosRequest];
        
        for (Photo *aSavedPhotoID in savedPhotos) {
            if (![photosIDs containsObject:aSavedPhotoID.photoID]) {
                [self.photoManager deletePhoto:aSavedPhotoID];
            }
        }
    }];
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
