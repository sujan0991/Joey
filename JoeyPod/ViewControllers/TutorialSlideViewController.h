//
//  TutorialSlideViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/18/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialSlideViewController : UIViewController<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *goMapButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) NSMutableArray* imageNameArray;

@property NSInteger pageSelected;

@property (strong,nonatomic) UIPageControl *pageControl;

@end
