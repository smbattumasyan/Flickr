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
    NSArray *photos    = [[self.photoManager fetchedResultsController] fetchedObjects];
    Photo *aPhoto      = [photos lastObject];
    NSArray *photoID    = [aPhoto.photoID componentsSeparatedByString:@","];
    return photoID.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundView        = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSURL *url         = [NSURL URLWithString:[self loadPhotoURL:indexPath]];
        NSLog(@"__indexPath:(%ld) photourl:(%@)",(long)indexPath.row, [self loadPhotoURL:indexPath]);
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
//    Photo *aPhoto      = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];
    NSString *photoURL = [self loadPhotoURL:indexPath];
    NSURL *url   = [NSURL URLWithString:photoURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    return [[UIImageView alloc ] initWithImage:img];
}

- (void)savePhotos
{
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *imageJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.photoManager addPhoto:[imageJson valueForKeyPath:@"photos.photo"]];
        
        for (NSDictionary *aPhoto in [imageJson valueForKeyPath:@"photos.photo"]) {
            [self.photoManager addPhoto:aPhoto];
        }
        
        [self.coreDataManager saveContext];
//        NSDictionary *dict = @{@"name":@"anun", @"names":@[@{@"photoID":@"123456"}, @{@"photoID": @"654132"}]};
//        NSLog(@"%@",[dict valueForKeyPath:@"names.photoID"]);
//        if ([[dict valueForKeyPath:@"names.photoID"] isKindOfClass:[NSArray class]]) {
//            NSLog(@"yes");
//        } else NSLog(@"no");
        
//        NSLog(@"ImageJson:%@",imageJson);
        
//        NSArray *photos = [imageJson valueForKeyPath:@"photos.photo"];
//        for (NSDictionary *dict in photos) {
//            [self.photoManager addPhoto:dict];
//        }
//
//        NSDictionary *addressesDict = @{@"head":@"head",@"new":@"new", @"home" : @[@{@"cc":@"dd", @"gg":@"hh"},@{@"cc":@"ff",@"ii":@"jj",@"qq":@"ll"}]};
//        NSLog(@"asdf%@",addressesDict);
        
        
//        NSArray *photosIDs      = [imageJson valueForKeyPath:@"photos.photo.id"];
//        NSMutableArray *savedPhotos;
//        savedPhotos = [[self.photoManager photosRequest] valueForKey:@"photoID"];
//        for (NSString *aPhotoID in photosIDs) {
//            
//            [savedPhotos containsObject:aPhotoID];
//
//            if (![savedPhotos containsObject:aPhotoID]) {
//                [self.service imageRequest:aPhotoID completionHandler:^(NSData * _Nullable dataImg, NSURLResponse * _Nullable responseImg, NSError * _Nullable errorImg) {
//                    NSDictionary *aImageJson = [NSJSONSerialization JSONObjectWithData:dataImg options:0 error:nil];
//                    
//                }];
//            }
//        }
//        savedPhotos = [self.photoManager photosRequest];
//        
//        for (Photo *aSavedPhotoID in savedPhotos) {
//            if (![photosIDs containsObject:aSavedPhotoID.photoID]) {
//                [self.photoManager deletePhoto:aSavedPhotoID];
//            }
//        }
    }];
}

- (NSString *)loadPhotoURL:(NSIndexPath *)indexPath
{
    Photo *aPhoto    = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];

    NSString *farmID    = [NSString stringWithFormat:@"%@",aPhoto.farmID];
    NSString *serverID  = [NSString stringWithFormat:@"%@",aPhoto.serverID];
    NSString *photosIDs = [NSString stringWithFormat:@"%@",aPhoto.photoID];
    NSString *secret    = [NSString stringWithFormat:@"%@",aPhoto.secret];
    
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",farmID,serverID,photosIDs,secret];
    NSLog(@"------%@",photoURL);
    return photoURL;
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
