//
//  FlikrDetailsDataController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 3/3/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrDetailsDataController.h"

@interface FlikrDetailsDataController ()



@end

@implementation FlikrDetailsDataController

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

+ (instancetype)createInstance
{
    FlikrDetailsDataController *dataController = [[FlikrDetailsDataController alloc] init];
    return dataController;
}

- (void)updateSelectedPhoto:(Photo *)aPhoto updatedPhoto:(nullable void(^)(Photo * _Nullable))photo
{
    [self.service imageRequest:aPhoto.photoID completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *imageJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [aPhoto setValue:[imageJson valueForKeyPath:@"photo.description._content"] forKey:@"photoDescription"];
            [aPhoto setValue:[self setPhotoDateFormat:[imageJson valueForKeyPath: @"photo.dates.taken"]] forKey:@"photoDate"];
            [self loadTags:data];
            [self.photoManager.coreDataManager saveContext];
            self.aPhoto = [self.photoManager fetchSelectedPhoto:self.selectedIndexPath];
            
            photo(self.aPhoto);
        });
    }];
}

//------------------------------------------------------------------------------------------
#pragma mark - CollectionView Data Source
//------------------------------------------------------------------------------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.tagManager.fetchedResultsController fetchedObjects] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagsCollectionIdentifier" forIndexPath:indexPath];
    cell.backgroundView        = nil;

    cell.backgroundColor = [UIColor grayColor];
    UILabel *tagLabel    = [[UILabel alloc]initWithFrame:CGRectMake(2,0,cell.bounds.size.width,15)];
    tagLabel.tag         = 200;

    Tag *aTag               = [self.tagManager fetchSelectedTag:indexPath];
    NSLog(@"tag:::%@",aTag.tag);
    tagLabel.text           = aTag.tag;
    [cell.contentView addSubview:tagLabel];
    cell.layer.cornerRadius = 10;
    
//    CGSize textSize = [[tagLabel text] sizeWithAttributes:@{NSFontAttributeName:[tagLabel font]}];
    
    return cell;
}

//------------------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------------------

/////
- (UIImageView *)getPhotoFromURL
{
    NSURL *url         = [NSURL URLWithString:[self loadPhotoURL]];
    NSData *data       = [NSData dataWithContentsOfURL:url];
    UIImage *img       = [[UIImage alloc] initWithData:data];
    
    return [[UIImageView alloc ] initWithImage:img];
}

/////
- (NSString *)loadPhotoURL
{
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",self.aPhoto.farmID,self.aPhoto.serverID,self.aPhoto.photoID,self.aPhoto.secret];
    
    return photoURL;
}

- (void)loadTags:(NSData *)data
{
    NSDictionary *tagsJson    = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableArray *tags      = [[tagsJson valueForKeyPath:@"photo.tags.tag.raw"] mutableCopy];
    NSMutableArray *savedTags = [[[self.tagManager fetchedResultsController] fetchedObjects] mutableCopy];
    
    for (NSInteger i = savedTags.count - 1; i >= 0; i--) {
        Tag *aTag = savedTags[i];
        if ([tags containsObject:aTag.tag]) {
            [savedTags removeObject:aTag];
        }
    }
    [self.tagManager deleteTag:savedTags];
    
    tags      = [[tagsJson valueForKeyPath:@"photo.tags.tag.raw"] mutableCopy];
    savedTags = [[[self.photoManager fetchedResultsController] fetchedObjects] mutableCopy];
    for (NSInteger i = tags.count - 1; i >= 0; i--) {
        NSString *aTag = tags[i];
        if ([savedTags containsObject:aTag]) {
            [tags removeObject:aTag];
        }
    }
    
    [self.tagManager addTags:tags];
}

- (NSDate *)setPhotoDateFormat:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *photoDate           = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",dateString]];
    
    return photoDate;
}

- (void)initFetchResultControler
{
    self.tagManager.fetchedResultsController.delegate = self;
}

@end
