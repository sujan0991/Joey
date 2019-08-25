//
//  TutorialSlideViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/18/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "TutorialSlideViewController.h"
#import "HexColors.h"


@interface TutorialSlideViewController (){

    int count;
}



@end

@implementation TutorialSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
   
   [self loadDescriptions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadDescriptions{
    
     CGFloat left = 0;

    self.imageNameArray= [[NSMutableArray alloc] init];
    [self.imageNameArray addObject:@"Tutorial 01"];
    [self.imageNameArray addObject:@"Tutorial 02"];
    [self.imageNameArray addObject:@"Tutorial 03"];
    
    for (int i=0; i<self.imageNameArray.count; i++) {
        UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(left,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        imageView.image=[UIImage imageNamed:[self.imageNameArray objectAtIndex:i]];
        
        [self.scrollView addSubview:imageView];
        
        left += [UIScreen mainScreen].bounds.size.width;
    }

    [self loadScroll];
    
    [self.view bringSubviewToFront:self.goMapButton];
}

- (void)loadScroll
{
    NSInteger pageCount = self.imageNameArray.count;
    _pageSelected = 0;
    // self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 520)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*pageCount, [UIScreen mainScreen].bounds.size.height)];
    //[self.view addSubview:self.scrollView];
    
    NSLog(@"scrollview  %@",self.scrollView );
    
 
    
    [self initializePageControl];
   
}

- (void)initializePageControl {
    
    CGRect pageControlFrame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 30);
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    _pageControl.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)*0.5, CGRectGetHeight([UIScreen mainScreen].bounds)-40);
    _pageControl.userInteractionEnabled = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor hx_colorWithHexString:@"2DCC70"];
    _pageControl.backgroundColor = [UIColor clearColor];
    [_pageControl setNumberOfPages:self.imageNameArray.count];
    [_pageControl setCurrentPage:_pageSelected];

    
    [self.view addSubview:_pageControl];
    
    [self.view bringSubviewToFront:self.pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSInteger pageIndex = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    
    self.pageControl.currentPage = pageIndex;
}

@end
