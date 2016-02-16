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

@property (strong, nonatomic) Photo *aPhoto;


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
    cell.backgroundView        = [self setPhotos:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
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
    self.aPhoto        = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];
    NSLog(@"fetchedRR%@",self.aPhoto.farmID);
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",self.aPhoto.farmID,self.aPhoto.serverID,self.aPhoto.photoID,self.aPhoto.secret];
    NSURL *url   = [NSURL URLWithString:photoURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    return [[UIImageView alloc ] initWithImage:img];
}

- (void)savePhotos
{
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        NSDictionary *json   = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *photos      = [json valueForKeyPath:@"photos.photo"];
        NSArray *savedPhotos = [self.photoManager photosRequest];

        NSLog(@"%lu--%lu",(unsigned long)photos.count,(unsigned long)savedPhotos.count);
        
        for (int i = 0; i < [photos count]; i++) {
            Photo *aSavedPhoto;
            if (savedPhotos.count == 0) {
                aSavedPhoto = nil;
            } else {
                aSavedPhoto = savedPhotos[i];
            }
            NSDictionary *dict = photos[i];
            
            if (![aSavedPhoto.photoID isEqualToString:[dict valueForKey:@"id"]]) {
                [self.photoManager addPhoto:dict];
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
