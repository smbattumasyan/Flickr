//
//  FlikrDetailsViewController.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/16/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlikrFeedDataController.h"

@interface FlikrDetailsViewController : UIViewController

@property(strong, nonatomic) FlikrFeedDataController *dataController;

@property (strong, nonatomic) UIImageView *flikrImage;

@end
