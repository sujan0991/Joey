//
//  AboutJoeyViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/5/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@interface AboutJoeyViewController : UIViewController<UIScrollViewDelegate,CCKFNavDrawerDelegate,UIAlertViewDelegate>



@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@property (strong,nonatomic) NSMutableArray* imageNameArray;

@property NSInteger pageSelected;

@property (strong,nonatomic) UIPageControl *pageControl;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;


@property (weak, nonatomic) IBOutlet UIImageView *vedioImage;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *aboutTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailTextLabel;


@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;


- (IBAction)drawerToggle:(id)sender;

@end
