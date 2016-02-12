//
//  FlikrFeedViewController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrFeedViewController.h"
#import "FlikrWebService.h"

@interface FlikrFeedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *farmIDs;
@property (strong, nonatomic) NSArray *serverIDs;
@property (strong, nonatomic) NSArray *photoIDs;
@property (strong, nonatomic) NSArray *secrets;

@end

@implementation FlikrFeedViewController

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.service = [[FlikrWebService alloc] init];
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.farmIDs = [dict valueForKeyPath:@"photos.photo.farm"];
            self.serverIDs = [dict valueForKeyPath:@"photos.photo.server"];
            self.photoIDs = [dict valueForKeyPath:@"photos.photo.id"];
            self.secrets = [dict valueForKeyPath:@"photos.photo.secret"];
        });
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
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    self.service = [[FlikrWebService alloc] init];
    [self.service imagesRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",self.farmIDs[1],self.serverIDs[1],self.photoIDs[1],self.secrets[1]];
            
            NSURL *url = [NSURL URLWithString:photoURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            cell.backgroundView = [[UIImageView alloc ] initWithImage:img];
        });
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
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
