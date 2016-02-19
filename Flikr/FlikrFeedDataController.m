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
    cell.layer.cornerRadius = 10;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
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
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",self.aPhoto.farmID,self.aPhoto.serverID,self.aPhoto.photoID,self.aPhoto.secret];
    NSURL *url   = [NSURL URLWithString:photoURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    return [[UIImageView alloc ] initWithImage:img];
}

- (void)savePhotos
{
    __block  NSMutableArray *savedPhotos;
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *imageJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *photosIDs      = [imageJson valueForKeyPath:@"photos.photo.id"];
        BOOL isTherePhoto       = NO;
        BOOL isThereNoPhoto     = NO;
        for (NSString *aPhotoID in photosIDs) {
            savedPhotos = [self.photoManager photosRequest];
            for (Photo *aSavedPhotos in savedPhotos) {
                if ([aSavedPhotos.photoID isEqualToString:aPhotoID]) {
                    isTherePhoto = YES;
                }
            }
            if (!isTherePhoto) {
                [self.service imageRequest:aPhotoID completionHandler:^(NSData * _Nullable dataImg, NSURLResponse * _Nullable responseImg, NSError * _Nullable errorImg) {
                    NSDictionary *aImageJson = [NSJSONSerialization JSONObjectWithData:dataImg options:0 error:nil];
                    [self.photoManager addPhoto:[aImageJson valueForKeyPath:@"photo"]];
                }];
            }
            isTherePhoto = NO;
        }
        savedPhotos = [self.photoManager photosRequest];
        for (Photo *aSavedPhoto in savedPhotos) {
            for (NSString *aPhotoID in photosIDs) {
                if ([aSavedPhoto.photoID isEqualToString:aPhotoID]) {
                    isThereNoPhoto = YES;
                }
            }
            if (!isThereNoPhoto) {
                [self.photoManager deletePhoto:aSavedPhoto];
            }
            isThereNoPhoto = NO;
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
