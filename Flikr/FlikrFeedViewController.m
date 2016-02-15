//
//  FlikrFeedViewController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrFeedViewController.h"
#import "FlikrWebService.h"

@interface FlikrFeedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Photo *aPhoto;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FlikrFeedViewController

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoManager = [[PhotoManager alloc] init];
    self.photoManager.coreDataManager = [CoreDataManager createInstance];
    self.service = [[FlikrWebService alloc] init];
    self.photoManager.fetchedResultsController.delegate = self;
    
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *photos = [json valueForKeyPath:@"photos.photo"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    

    self.aPhoto = [[self.photoManager fetchedResultsController] objectAtIndexPath:indexPath];
    NSLog(@"fetchedRR%@",self.aPhoto.farmID);
//    NSString *photoURL = @"https://farm2.staticflickr.com/1491/24340991964_4e13f9a143.jpg";
    NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",self.aPhoto.farmID,self.aPhoto.serverID,self.aPhoto.photoID,self.aPhoto.secret];
    
    
    NSURL *url = [NSURL URLWithString:photoURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.backgroundView = [[UIImageView alloc ] initWithImage:img];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
