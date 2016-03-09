//
//  FlikrDetailsCell.m
//  Flikr
//
//  Created by Smbat Tumasyan on 3/9/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FlikrDetailsCell.h"

@interface FlikrDetailsCell ()

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation FlikrDetailsCell

- (void)setATag:(Tag *)aTag
{
    _aTag              = aTag;
    self.tagLabel.text = [aTag tag];
}

@end
