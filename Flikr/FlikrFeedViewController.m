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
#import "FlikrWebService.h"
#import "FlikrMockService.h"
#import "FlikrDetailsViewController.h"

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

    [self setupCollectionView];
    [self.flikrFeedDataController initFetchResultControler];
    [self.flikrFeedDataController loadPhotos];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor orangeColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark - UICollectionView Delegate
//------------------------------------------------------------------------------------------

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"FlikrFeedViewController" sender:self];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Scroll!");
}

//------------------------------------------------------------------------------------------
#pragma mark - View IBOutlets Action
//------------------------------------------------------------------------------------------

- (IBAction)updateButtonAction:(UIBarButtonItem *)sender
{
    [self.flikrFeedDataController loadPhotos];
}

//------------------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------------------

- (void)setupCollectionView
{
    PhotoManager *photoManager   = [[PhotoManager alloc] init];
    photoManager.coreDataManager = [CoreDataManager createInstance];
    self.flikrFeedDataController = [FlikrFeedDataController createInstance];
    self.flikrFeedDataController.service = [[FlikrWebService alloc] init];
    self.flikrFeedDataController.photoManager   = photoManager;
    self.collectionView.dataSource              = self.flikrFeedDataController;
    self.flikrFeedDataController.collectionView = self.collectionView;
}

- (NSIndexPath *)selectedIndexPath
{
    NSArray *selectedIndexPathArray = [self.collectionView indexPathsForSelectedItems];
    return selectedIndexPathArray[0];
}

//------------------------------------------------------------------------------------------
#pragma mark - Navigation
//------------------------------------------------------------------------------------------

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"FlikrFeedViewController"]) {
        FlikrDetailsViewController *flikrDetailsVC = [segue destinationViewController];
        flikrDetailsVC.flikrImage = [self.flikrFeedDataController setPhotos:[self selectedIndexPath]];
        flikrDetailsVC.selectedIndexPath = [self selectedIndexPath];
        flikrDetailsVC.flikrFeedDataController = self.flikrFeedDataController;
    }
}

@end
