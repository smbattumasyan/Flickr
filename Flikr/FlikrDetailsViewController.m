//
//  FlikrDetailsViewController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/16/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrDetailsViewController.h"

@interface FlikrDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *flikrImageView;
@property (weak, nonatomic) IBOutlet UILabel     *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel     *photoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *dateLabel;
@property (weak, nonatomic) IBOutlet UIView      *tagsView;

@end

@implementation FlikrDetailsViewController

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *tagView = [[UIView alloc] initWithFrame: CGRectMake ( 5, 5, 50, 20)];
    
    tagView.backgroundColor = [UIColor blackColor];
    
    [self.tagsView addSubview:tagView];
    
    tagView = [[UIView alloc] initWithFrame: CGRectMake ( 60, 5, 50, 20)];
    
    tagView.backgroundColor = [UIColor orangeColor];
    
    [self.tagsView addSubview:tagView];
    
    
    [self updateSelectedPhoto:[self.flikrFeedDataController loadPhoto:self.selectedIndexPath]];
    [self setFlikrImageView:self.flikrImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------------------

- (void)setFlikrImageView:(UIImageView *)flikrImageView
{
    flikrImageView.image               = self.flikrImage.image;
    flikrImageView.layer.cornerRadius  = 10;
    flikrImageView.layer.masksToBounds = YES;
}

- (NSDate *)setPhotoDateFormat:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *photoDate           = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",dateString]];
    
    return photoDate;
}

- (Photo *)savePhotoNewData:(Photo *)aPhoto data:(NSData *)data
{
    NSDictionary *imageJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [aPhoto setValue:[imageJson valueForKeyPath:@"photo.description._content"] forKey:@"photoDescription"];
    [aPhoto setValue:[self setPhotoDateFormat:[imageJson valueForKeyPath: @"photo.dates.taken"]] forKey:@"photoDate"];
    [self.flikrFeedDataController.coreDataManager saveContext];
    
    return [self.flikrFeedDataController loadPhoto:self.selectedIndexPath];
}

- (void)updateSelectedPhoto:(Photo *)aPhoto
{
    [self.flikrFeedDataController.service imageRequest:aPhoto.photoID completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupIBOutelts:[self savePhotoNewData:aPhoto data:data]];
        });
    }];
}

- (void)setupIBOutelts:(Photo *)aPhoto
{
    self.photoNameLabel.text   = [aPhoto photoName];
    self.descriptionLabel.text = aPhoto.photoDescription;
    self.dateLabel.text        = [NSDateFormatter localizedStringFromDate:aPhoto.photoDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
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
