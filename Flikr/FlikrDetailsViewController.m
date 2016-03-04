//
//  FlikrDetailsViewController.m
//  Flikr
//
//  Created by Smbat Tumasyan on 2/16/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrDetailsViewController.h"
#import "FlikrWebService.h"
#import "FlikrMockService.h"

@interface FlikrDetailsViewController ()

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------

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
    
    [self setFlikrImageView:[self.flikerDetailsDataController getPhotoFromURL]];
    [self.flikerDetailsDataController updateSelectedPhoto:self.flikerDetailsDataController.aPhoto updatedPhoto:^(Photo * _Nullable photo) {
         [self setupIBOutelts:photo];
    }];
    [self addViewTags:4];         
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
    flikrImageView.image               = [[self.flikerDetailsDataController getPhotoFromURL] image];
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

- (void)setupIBOutelts:(Photo *)aPhoto
{
    self.photoNameLabel.text   = [aPhoto photoName];
    self.descriptionLabel.text = aPhoto.photoDescription;
    self.dateLabel.text        = [NSDateFormatter localizedStringFromDate:aPhoto.photoDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (void)addViewTags:(NSInteger )tags
{
    for (int i = 0; i < tags; i++) {
        UIView *tagView = [[UIView alloc] initWithFrame: CGRectMake ( 5+i*60, 5, 50, 20)];
        
        tagView.backgroundColor = [UIColor grayColor];
        
        tagView.layer.cornerRadius = 10;
        tagView.layer.masksToBounds = YES;
        
        [self.tagsView addSubview:tagView];
    }
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
