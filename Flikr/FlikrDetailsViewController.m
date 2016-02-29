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
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation FlikrDetailsViewController

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoNameLabel.text   = [self.aPhoto photoName];
    self.dateLabel.text        = [NSDateFormatter localizedStringFromDate:self.aPhoto.photoDate dateStyle:NSDateFormatterShortStyle timeStyle:
                           NSDateFormatterShortStyle];
    NSLog(@"%@",self.aPhoto.photoDate);
    self.descriptionLabel.text = [self.aPhoto photoDescription];

    [self setFlikrImageView:self.flikrImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------------------

- (void)setFlikrImageView:(UIImageView *)flikrImageView {
    flikrImageView.image               = self.flikrImage.image;
    flikrImageView.layer.cornerRadius  = 10;
    flikrImageView.layer.masksToBounds = YES;
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
