//
//  FlikrDetailsDataController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 3/3/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrDetailsDataController.h"

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
            [self.photoManager.coreDataManager saveContext];
            self.aPhoto = [self.photoManager fetchSelectedPhoto:self.selectedIndexPath];
            photo(self.aPhoto);
        });
    }];
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

- (NSDate *)setPhotoDateFormat:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *photoDate           = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",dateString]];
    
    return photoDate;
}

@end
