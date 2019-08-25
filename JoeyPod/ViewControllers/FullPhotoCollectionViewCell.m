//
//  FullPhotoCollectionViewCell.m
//  Joey
//
//  Created by Sujan on 2/27/17.
//  Copyright © 2017 Sujan. All rights reserved.
//

#import "FullPhotoCollectionViewCell.h"

@implementation FullPhotoCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.singleImageView.layer.zPosition = 100;
        self.dateLabel.layer.zPosition=101;
        self.feedingRoomLabel.layer.zPosition=101;
        
    }
    return self;
}

-(void)configueViewPhoto
{
    if(self.singleImageView)
    {
        [self.singleImageView removeFromSuperview];
        
    }
    
    
        
    self.singleImageView = [[VIPhotoView alloc] initWithFrame:self.frameView.bounds andImage:self.pageImage];
    self.singleImageView.autoresizingMask = (1 << 6) -1;
    [self addSubview:self.singleImageView];
    
    
    
}

@end
