//
//  AllPhotosViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/7/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPhotoView.h"

@interface AllPhotosViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic,strong)NSString* roomName;

@property (weak, nonatomic) IBOutlet UIView *fullPhotoView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;



@property (strong,nonatomic) NSMutableArray* imageArray;



@property (weak, nonatomic) IBOutlet UICollectionView *fullPhotoCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *joeyName;
@property (weak, nonatomic) IBOutlet VIPhotoView *singleImageView;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;

@end
