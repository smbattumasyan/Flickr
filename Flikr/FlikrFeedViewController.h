//
//  FlikrFeedViewController.h
//  Flikr
//
//  Created by Smbat Tumasyan on 2/12/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlikrService.h"

@interface FlikrFeedViewController : UIViewController

@property (strong, nonatomic)  id<FlikrServiceProtocol>service;

@end
