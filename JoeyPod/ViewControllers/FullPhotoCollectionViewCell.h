//
//  FullPhotoCollectionViewCell.h
//  Joey
//
//  Created by Sujan on 2/27/17.
//  Copyright © 2017 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPhotoView.h"

@interface FullPhotoCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet VIPhotoView *singleImageView;

@property (strong, nonatomic) UIImage *pageImage;

@property (weak, nonatomic) IBOutlet UIView *frameView;




@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedingRoomLabel;

-(void)configueViewPhoto;

@end
