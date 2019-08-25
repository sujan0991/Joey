//
//  MessagesViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesTableViewCell.h"
#import "FavoritesViewController.h"
#import "FacilityListTableViewCell.h"
#import "SettingViewController.h"
#import "MapViewController.h"
#import "FAQsViewController.h"
#import "AboutJoeyViewController.h"
#import "ContactUsViewController.h"
#import "LeaderBoardViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "MessagesDetailViewController.h"
#import "HostPagerViewController.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"


@interface MessagesViewController (){

    UIActivityIndicatorView* loader;
    JTMaterialSpinner *spinner;
    
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property(strong,nonatomic) NSMutableArray* messagesArray;
@property(strong,nonatomic) NSMutableArray* repliesMsgArray;
@property(strong,nonatomic) NSMutableArray* allMessageArray;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messagesTableView.estimatedRowHeight = 100.0;
    self.messagesTableView.rowHeight = UITableViewAutomaticDimension;
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.messagesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.messagesTableView.frame.size.width, 1)];

    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    [self makerequest];
    
    

}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFromAlart"] isEqualToString:@"1"]) {
        
        
        NSLog(@"index  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
        [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"loginFromAlart"];
        
    }
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 105) {
        
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
        
        
    }else if (alertView.tag == 106){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 506){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 507){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            
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

-(void) makerequest{

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
      NSDictionary *params;
        
        
      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
      {
       
        params = @{@"access_key": @"flowdigital",
                                  @"current_user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]};
    
    
      }else{
    
        params = @{@"access_key": @"flowdigital",
                                  @"current_user_id":@"0"};

      }
 
      manager.responseSerializer = [AFJSONResponseSerializer serializer];
      manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
      NSLog(@"params : %@", params);
    
      [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"messages/api-get-messages"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
       // NSDictionary * response =  (NSDictionary *)responseObject;
        
       //   NSLog(@"all response :%@",response);

        
        
       // self.messagesArray = [response objectForKey:@"Messages"];
       // self.repliesMsgArray = [response objectForKey:@"Replies"];
          
       // self.allMessageArray = [[self.messagesArray arrayByAddingObjectsFromArray:self.repliesMsgArray]mutableCopy];
          
          self.allMessageArray = (NSMutableArray*) responseObject;
          
          NSLog(@"all message :%@",self.allMessageArray);
        
        if (self.allMessageArray.count == 0 ) {
            
            self.messagesTableView.hidden = YES;
        }
        
        
        [self.messagesTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
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
    
    return self.allMessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesCell"];
    
    NSDictionary* message = [self.allMessageArray objectAtIndex:indexPath.row];
    
    NSLog(@"Messages Are:%@",message);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    
    NSString* formatString = [message objectForKey:@"created"];
    
    [serverDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
    
    NSDate *commentdate = [serverDateFormatter dateFromString:formatString];
    
    [dateFormatter setDateFormat:@"EEE MMM d yyyy, HH:mm"];
    
    cell.dateLabel.text =[dateFormatter stringFromDate:commentdate];
    cell.dateLabel.font = [UIFont fontWithName:@"Museo-300" size:13];
    
    if ([[message objectForKey:@"type"]intValue] == 1)
    {
        
       cell.subjectLabel.text = [message objectForKey:@"subject"];
       cell.messageDetail.text = [message objectForKey:@"message"];
        
    }else if([[message objectForKey:@"type"]intValue] == 2)
    {
    
        cell.subjectLabel.text = [message objectForKey:@"message"];
        cell.messageDetail.text = [message objectForKey:@"reply"];
    }
    
    cell.subjectLabel.font = [UIFont fontWithName:@"Museo-300" size:18];
    
    cell.messageDetail.font = [UIFont fontWithName:@"Museo-300" size:16];
    
   // NSLog(@"shortmessage is:%@",[shortmessage substringToIndex:60]);

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

     NSDictionary* message = [self.allMessageArray objectAtIndex:indexPath.row];
    
   
    MessagesDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesDetailViewController"];
    
    if ([[message objectForKey:@"type"]intValue] == 1)
    {
     
        vc.subject = [message objectForKey:@"subject"];
        
    }else if([[message objectForKey:@"type"]intValue] == 2)
    {
        
      vc.subject = [message objectForKey:@"message"];
    }
    
    vc.date = [message objectForKey:@"created"];
    vc.messageId = [message objectForKey:@"id"];
    vc.typeId = [[message objectForKey:@"type"]intValue];
    
    [self.navigationController pushViewController:vc animated:YES];

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
          //  vc.favoriteListArray = self.favoriteListArray;
            //vc.distance = distancesArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 105;
            
            [alert show];
        }
        
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
        [self makerequest];
        
        
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
            alert.tag = 506;
            
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
            alert.tag = 106;
            
            [alert show];
        }
        
        

        
    }

}

- (IBAction)contectButton:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"contactUs"];
        
        ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please login or sign up to use this feature."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Sign up/Login", nil];
        alert.tag = 507;
        
        [alert show];
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

@end
