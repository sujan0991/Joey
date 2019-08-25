//
//  AboutJoeyViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/5/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "AboutJoeyViewController.h"
#import "FavoritesViewController.h"
#import "SettingViewController.h"
#import "MapViewController.h"
#import "MessagesViewController.h"
#import "FAQsViewController.h"
#import "ContactUsViewController.h"
#import "LeaderBoardViewController.h"
#import "HostPagerViewController.h"
#import "Reachability.h"
#import "JTMaterialSpinner.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "KSToastView.h"


@interface AboutJoeyViewController (){

    JTMaterialSpinner * spinner;

    
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation AboutJoeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];

    
    self.aboutTextLabel.hidden = YES;
    self.vedioImage.hidden = YES;
    self.scrollview.hidden = YES;
    self.emailTextLabel.hidden = YES;
    
    
    [self makerequest];
    
    //[self loadDescriptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFromAlart"] isEqualToString:@"1"]) {
        
        
        NSLog(@"index  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
        [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"loginFromAlart"];
        
    }

}

-(void)makerequest{

    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
        
    }
    else{
        
        spinner.hidden = NO;
        [spinner beginRefreshing];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"message_id":@"1"};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"abouts/api-get-joey"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            
            
            NSLog(@"responseObject  JSON for detail: %@", responseObject);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSString* message = [responseObject objectForKey:@"body"];
            
            NSString *htmlString = [NSString stringWithFormat:@"<font face='Museo-300' size='3'>%@", message];
            
            [self.aboutWebView loadHTMLString:htmlString baseURL:nil];
            
            self.aboutWebView.scrollView.showsHorizontalScrollIndicator = NO;
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSLog(@"responce............%@",operation.responseString);
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
        
        
        
    }
    
    



}


//-(void) loadDescriptions{
//    
//    CGFloat left = 0;
//    
//    self.imageNameArray= [[NSMutableArray alloc] init];
//    [self.imageNameArray addObject:@"image1.jpg"];
//    [self.imageNameArray addObject:@"image2.jpg"];
//    [self.imageNameArray addObject:@"image3.jpg"];
//    
//    for (int i=0; i<self.imageNameArray.count; i++) {
//        
//        UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(left + i*10 ,0, self.scrollview.bounds.size.width*0.7, self.scrollview.bounds.size.height)];
//        
//        imageView.backgroundColor = [UIColor grayColor];
//        imageView.image=[UIImage imageNamed:[self.imageNameArray objectAtIndex:i]];
//        
//        [self.scrollview addSubview:imageView];
//        
//        left += self.scrollview.bounds.size.width*0.7;
//    }
//    
//    [self loadScroll];
//    
//}
//
//- (void)loadScroll
//{
//    NSInteger pageCount = self.imageNameArray.count;
//    _pageSelected = 0;
//    // self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 520)];
//    [self.scrollview setBackgroundColor:[UIColor clearColor]];
//    [self.scrollview setPagingEnabled:NO];
//    [self.scrollview setBounces:NO];
//    [self.scrollview setScrollEnabled:YES];
//    [self.scrollview setShowsHorizontalScrollIndicator:NO];
//    [self.scrollview setShowsVerticalScrollIndicator:NO];
//    [self.scrollview setDelegate:self];
//    [self.scrollview setContentSize:CGSizeMake(self.scrollview.bounds.size.width*pageCount*0.7 + (pageCount-1)*10, self.scrollview.bounds.size.height)];
//    //[self.view addSubview:self.scrollView];
//    
//   // NSLog(@"scrollview  %@",self.scrollview );
//    
//    
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    NSInteger pageIndex = self.scrollview.contentOffset.x / CGRectGetWidth(self.scrollview.frame);
//    
//    self.pageControl.currentPage = pageIndex;
//}




-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 109) {
        
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
        
        
    }else if (alertView.tag == 110){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 502){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }

}

- (IBAction)drawerToggle:(id)sender {
    
    [self.rootNav drawerToggle];
}


#pragma mark - CCKFNavDrawerDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
    if (selectionIndex==0)
    {
        MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex==1)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            FavoritesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
//            vc.favoriteListArray = self.favoriteListArray;
//            vc.distance = _distanceArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 109;
            [alert show];
        }
        
    } else if (selectionIndex==2)
    {
           // [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"searchLocation"];
            
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
       
        [self makerequest];
        
        
    }else if (selectionIndex==7)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 502;
            
            [alert show];
        }
    }else if (selectionIndex==8)
    {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            
//            vc.favoriteListArray = self.favoriteListArray;
//            vc.distanceArray = _distanceArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            
            alert.tag = 110;
            [alert show];
        }
        
        

        
    }

}

@end
