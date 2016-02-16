//
//  FlikrFeedViewController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrFeedViewController.h"
#import "FlikrWebService.h"
#import "PhotoManager.h"

@interface FlikrFeedViewController ()< UICollectionViewDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FlikrFeedViewController

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCollectionView];
    [self.flikrFeedDataController initFetchResultControler];
    [self.flikrFeedDataController savePhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------

- (void)setupCollectionView
{
    PhotoManager *photoManager   = [[PhotoManager alloc] init];
    photoManager.coreDataManager = [CoreDataManager createInstance];
    self.flikrFeedDataController = [FlikrFeedDataController createInstance];
    self.flikrFeedDataController.photoManager   = photoManager;
    self.collectionView.dataSource              = self.flikrFeedDataController;
    self.flikrFeedDataController.collectionView = self.collectionView;
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
