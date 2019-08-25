//
//  LeaderBoardViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "MapViewController.h"
#import "FavoritesViewController.h"
#import "MessagesViewController.h"
#import "SettingViewController.h"
#import "AboutJoeyViewController.h"
#import "MessagesViewController.h"
#import "FAQsViewController.h"
#import "ContactUsViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "HostPagerViewController.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface LeaderBoardViewController (){

    JTMaterialSpinner *spinner;
    
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonnull,strong) NSMutableArray* checkIns;




@end

@implementation LeaderBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loader.hidden = YES;
    self.noUserLabel.hidden =YES;
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    
    self.leaderTableView.estimatedRowHeight = 50.0;
    self.leaderTableView.rowHeight = UITableViewAutomaticDimension;
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.leaderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leaderTableView.frame.size.width, 1)];
    
    [self makerequest];
    
   // NSLog(@"favorite array %@",self.favoriteListArray);
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFromAlart"] isEqualToString:@"1"]) {
        
        
        NSLog(@"index  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
        [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"loginFromAlart"];
        
    }
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 103) {
 
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
        
        
    }else if (alertView.tag == 104){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 505){
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
        self.leaderTableView.hidden = YES;
        
        spinner.hidden = NO;
        [spinner beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital"};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-leader-board"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.leaderTableView.hidden = NO;
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        
        
        self.checkIns = [response objectForKey:@"Checkins"];
        
        if (self.checkIns.count == 0) {
            
            self.leaderTableView.hidden =YES;
            self.noUserLabel.hidden = NO;
            
        }else{
        
            self.leaderTableView.hidden =NO;
            self.noUserLabel.hidden = YES;
        
        }
        
        NSLog(@"Checkins :%@",self.checkIns);

       [self.leaderTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        //self.leaderTableView.hidden = NO;
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    
    
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return 3;
    return self.checkIns.count;
    
  //  NSLog(@"Checkins count :%lu",(unsigned long)self.checkIns.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"leaderCell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
      if (!cell)
          cell  = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
 
    NSDictionary* checkinInfo = [self.checkIns objectAtIndex:indexPath.row];
    
    NSLog(@"CheckinsInfo :%@",checkinInfo);
    
    NSString* rank = [checkinInfo objectForKey:@"rank"];
    
    NSLog(@"RAnk  :%@",rank);
        
   
    
    UILabel *ranking= (UILabel*) [cell viewWithTag:1];
    

    
    UIImageView *tropy = (UIImageView*) [cell viewWithTag:5];
    tropy.hidden =YES;
    
    if (indexPath.row < 3) {
        
        tropy.hidden = NO;
        ranking.hidden = YES;
        
    }
    else
    {
        tropy.hidden = YES;
        ranking.hidden = NO;
        ranking.layer.cornerRadius = ranking.frame.size.width/2;
        ranking.layer.borderWidth =0.5f;
        ranking.layer.borderColor =[[UIColor greenColor] CGColor];
        ranking.layer.masksToBounds = YES;
        ranking.text = [NSString stringWithFormat:@"%@",rank];
    }
  
    UILabel *nickName= (UILabel*) [cell viewWithTag:2];
    nickName.text = [checkinInfo objectForKey:@"nickname"];
    
    NSLog(@"nickname :%@",[checkinInfo objectForKey:@"nickname"]);
    
    UILabel *city= (UILabel*) [cell viewWithTag:3];
    city.text = @"city,Country";
    
    UILabel *activity= (UILabel*) [cell viewWithTag:4];
    activity.text = [NSString stringWithFormat:@"%@",[checkinInfo objectForKey:@"checkins"]];
    
    //NSLog(@"count :%@",[checkinInfo objectForKey:@"checkins"]);
    
    return cell;
    
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
           // vc.favoriteListArray = self.favoriteListArray;
            //vc.distance = distancesArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 103;
            
            [alert show];
        }
        
    } else if (selectionIndex==2)
    {
        
//        //Network connection
//        
//        Reachability *reachability = [Reachability reachabilityForInternetConnection];
//        [reachability startNotifier];
//        
//        NetworkStatus status = [reachability currentReachabilityStatus];
//        
//        if(status == NotReachable)
//        {
//            
//            MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }else{
        
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
            
            MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            [self.navigationController pushViewController:vc animated:YES];


        //}
        
    }else if (selectionIndex==3)
    {
        
        [self makerequest];
        
        
    }
    else if (selectionIndex==4)
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
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 505;
            
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
            alert.tag = 104;
            
            [alert show];
        }
        
        
        
        
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)drawerToggle:(id)sender {
    
    [self.rootNav drawerToggle];
}
@end
