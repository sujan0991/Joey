//
//  HostPagerViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/25/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "HostPagerViewController.h"
#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "MapViewController.h"
#import "SettingViewController.h"
#import "FavoritesViewController.h"
#import "MessagesViewController.h"
#import "FAQsViewController.h"
#import "AboutJoeyViewController.h"
#import "SettingViewController.h"
#import "LeaderBoardViewController.h"
#import "ContactUsViewController.h"
#import "HexColors.h"

@interface HostPagerViewController ()<ViewPagerDataSource, ViewPagerDelegate>{

    UILabel *label;
    

}


@property (nonatomic) NSUInteger numberOfTabs;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property(strong,nonatomic) LogInViewController* loginController;
@property(strong,nonatomic) SignUpViewController* signUpController;

@end

@implementation HostPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(login) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(signup) name:@"signup" object:nil];
    
    
    self.backBtn.hidden = YES;
    
    self.dataSource = self;
    self.delegate = self;
    self.numberOfTabs = 2;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"1"]) {
        
        self.backBtn.hidden = NO;
        self.drawerBtn.hidden = YES;
        
       // [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
        
    }else
    {
        self.rootNav = (CCKFNavDrawer *)self.navigationController;
        [self.rootNav setCCKFNavDrawerDelegate:self];
        
        
    }
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    
//    [super viewDidAppear:animated];
//    
//    //[self performSelector:@selector(loadContent) withObject:nil afterDelay:3.0];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

-(void)login{

    [self selectTabAtIndex:1];

     NSLog(@"login btn clicked");

}
-(void)signup{

    [self selectTabAtIndex:0];
     NSLog(@"signUP btn clicked");

}

#pragma mark - Helpers
//- (void)selectTabWithNumberFive {
//    [self selectTabAtIndex:2];
//}
- (void)loadContent {
    self.numberOfTabs = 2;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    //label = [[UILabel alloc] init];
   // label.backgroundColor = [UIColor clearColor];
    
     UIImageView* tabImageView=[[UIImageView alloc] init];
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        
        if([UIScreen mainScreen].bounds.size.width>320)
        {
            tabImageView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/6-20, 36.0/2);
            
        }
        else
        {
            tabImageView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/6-20, 32.0/2);
            
        }
    }
    
    if (index==0) {
        
        tabImageView.image = [[UIImage imageNamed:@"sign_up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else if (index==1)
    {
        tabImageView.image = [[UIImage imageNamed:@"log_in"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    }
    

    tabImageView.tag=index;
    tabImageView.backgroundColor=[UIColor clearColor];
    tabImageView.contentMode=UIViewContentModeScaleAspectFill;
  
    return tabImageView;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    
     NSLog(@"index for content %lu",(unsigned long)index);
    
    if (index == 0) {
        
        SignUpViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
       
        return signupVC;
        
    }else if (index == 1){
        
        LogInViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
      
        
        return loginVC;
    }
    return nil;
}



#pragma mark - ViewPagerDelegate

//- (void)selectTabAtIndex:(NSUInteger)index{
//
//    NSLog(@"tab...............");
//    [self reloadData];
//
//}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    

    [[viewPager getCurrentTabatIndex:0] setTintColor:[UIColor lightGrayColor]];
    [[viewPager getCurrentTabatIndex:1] setTintColor:[UIColor lightGrayColor]];

    [[viewPager getCurrentTabatIndex:index] setTintColor:[UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0]];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)index] forKey:@"startingPoint"];
     NSLog(@"index change to tab %f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"startingPoint"] floatValue]);
    
    
    
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
          
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 40;
            
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? self.view.layer.frame.size.width/2 :self.view.layer.frame.size.width/2;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
        case ViewPagerTabsView:
            return [[UIColor whiteColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor whiteColor] colorWithAlphaComponent:0.32];
        
            
        default:
            return color;
    }
}




- (IBAction)drawerToggle:(id)sender {
    
//    [self.loginController.view resignFirstResponder];
//    [self.signUpController.view resignFirstResponder];
    [self resignFirstResponder];
    
    [self.rootNav drawerToggle];
}

- (IBAction)backButton:(id)sender {
    
     [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CCKFNavDrawerDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
     [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
    if (selectionIndex==0)
    {
        MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex == 1)
    {
//                FavoritesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
//                [self.navigationController pushViewController:vc animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please login or sign up to use this feature."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else if (selectionIndex==2)
    {
      
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
            MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
      

        
       
    }else if (selectionIndex==3)
    {
        LeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaderBoardViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex==4)
    {
        MessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (selectionIndex==5)
    {
        FAQsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FAQsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (selectionIndex==6)
    {
        AboutJoeyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutJoeyViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        
    }else if (selectionIndex==7)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please login or sign up to use this feature."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else if (selectionIndex==8)
    {
//        SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please login or sign up to use this feature."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    
    }

}
@end
