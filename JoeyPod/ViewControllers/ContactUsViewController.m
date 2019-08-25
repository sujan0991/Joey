//
//  ContactUsViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/5/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MapViewController.h"
#import "SettingViewController.h"
#import "FavoritesViewController.h"
#import "FAQsViewController.h"
#import "AboutJoeyViewController.h"
#import "LeaderBoardViewController.h"
#import "MessagesViewController.h"
#import "HexColors.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "HostPagerViewController.h"
#import "Reachability.h"
#import "JTMaterialSpinner.h"


@interface ContactUsViewController (){

    NSString* messageType;
    JTMaterialSpinner* spinner;
    
}


@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"User id in contect us %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    
    self.backBtn.hidden = YES;
    self.drawerBtn.hidden = NO;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"contactUs"] isEqualToString:@"1"]) {
        
        self.backBtn.hidden = NO;
        self.drawerBtn.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"contactUs"];
    }
    else
    {
        self.rootNav = (CCKFNavDrawer *)self.navigationController;
        [self.rootNav setCCKFNavDrawerDelegate:self];
        

    }
    //drawer
    
    self.view1.hidden =NO;
    self.view2.hidden =YES;
    

//    self.contecUsLabel.hidden = YES;
//    self.backBtn.hidden =YES;
    
    
    //border
    self.messageText.layer.cornerRadius = 5.0;
    self.messageText.layer.borderWidth = 0.5f;
    self.messageText.layer.borderColor=[[UIColor grayColor] CGColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.tagListView addGestureRecognizer:tapGesture];


    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    
    [self configureTagList];
}


-(void)viewDidAppear:(BOOL)animated{

    
}

//// method to hide keyboard when user taps on a scrollview
-(void)hideKeyboard
{
    [self.messageText resignFirstResponder];
    
    if (self.messageText.text.length == 0) {
        
        self.hintLabel.hidden = NO;
    }
}

-(void) configureTagList
{
    
    //R- 45, G- 204, B- 112
    //2DCC70
    
    self.tagListView.canSelectTags = YES;
    self.tagListView.tagStrokeColor = [UIColor grayColor];
    self.tagListView.tagBackgroundColor = [UIColor whiteColor];
    self.tagListView.tagTextColor = [UIColor grayColor];
    self.tagListView.tagSelectedBackgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    self.tagListView.tagSelectedBorderColor = [UIColor colorWithRed:45/255.0f green:204/255.0f blue:112/255.0f alpha:1];
    self.tagListView.tagSelectedTextColor = [UIColor whiteColor];
    self.tagListView.tagCornerRadius = 5.0f;
    
    [self.tagListView.tags addObjectsFromArray:@[@"General", @"App Issues", @"Feeding Rooms"]];
    [self.tagListView.selectedTags addObjectsFromArray:@[@"General"]];
    
    [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
        [self.tagListView.selectedTags removeAllObjects];
        [self.tagListView.selectedTags addObject:[self.tagListView.tags objectAtIndex:index]];
        [self.tagListView.collectionView reloadData];
        NSLog(@"______%ld______", (long)index);
        
        
        messageType = [NSString stringWithFormat:@"%ld",(long)index +1];
        
    }];
    
    [self.tagListView.collectionView reloadData];
    [self.tagListView.collectionView performBatchUpdates:^{}
                                              completion:^(BOOL finished) {
                                                  /// collection-view finished reload
                                                  float newHeight = self.tagListView.collectionView.collectionViewLayout.collectionViewContentSize.height;
                                                  NSLog(@"height %lf",newHeight);
                                                  
                                                  self.tagListHeight.constant=self.tagListView.collectionView.collectionViewLayout.collectionViewContentSize.height;
                                              }];
    //

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 113) {
        
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
        
        
    }else if (alertView.tag == 112){
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.messageText resignFirstResponder];
    
    if (self.messageText.text.length == 0) {
        
        self.hintLabel.hidden = NO;
    }
    
    NSLog(@"Is it called");
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.hintLabel.hidden = YES;
    

    
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    
////    NSString * str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSLog(@"textView.text.length %lu",(unsigned long)textView.text.length);
//    
//       self.numberLabel.text = [NSString stringWithFormat:@"%lu",300-textView.text.length];
//    
//    return YES;
//
//}

-(void) textViewDidChange:(UITextView *)textView
{
    NSLog(@"textView.text.length %lu",(unsigned long)textView.text.length);
    
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",300-textView.text.length];
    
   

}



- (IBAction)sendButton:(id)sender {
  
    [self.messageText resignFirstResponder];
    
    
    
    NSString* message = self.messageText.text;
    
    
    if (message.length == 0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please provide details"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }else{
        
      
        
        //Network connection
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        NSLog(@"status %ld",(long)status);
        
        if(status == NotReachable)
        {
            
            //self.loader.hidden =YES;
            
            [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
            
        }
        else{
            
            self.sendMessageBtn.userInteractionEnabled = NO;
            self.backBtn.userInteractionEnabled = NO;
            self.drawerBtn.userInteractionEnabled = NO;
            self.faceBookBtn.userInteractionEnabled = NO;
            self.messageBtn.userInteractionEnabled = NO;
            self.phoneBtn.userInteractionEnabled = NO;
            
            spinner.hidden =NO;
            [spinner beginRefreshing];
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *params;
            if (messageType == nil) {
                params = @{@"access_key": @"flowdigital",
                           @"contact_message_type_id":@"1",
                           @"message":message,
                           @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]};
            } else {
                params = @{@"access_key": @"flowdigital",
                           @"contact_message_type_id":messageType,
                           @"message":message,
                           @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]};
            }
            
            NSLog(@"params  %@",params);
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"contact-messages/api-add-contact-message"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"responseObject  JSON in login state: %@", responseObject);
                
                self.sendMessageBtn.userInteractionEnabled = YES;
                self.backBtn.userInteractionEnabled = YES;
                self.drawerBtn.userInteractionEnabled = YES;
                self.faceBookBtn.userInteractionEnabled = YES;
                self.messageBtn.userInteractionEnabled = YES;
                self.phoneBtn.userInteractionEnabled = YES;
                
                spinner.hidden =YES;
                [spinner endRefreshing];
                
                
                NSString *successMsg = [responseObject objectForKey:@"success"];
                
                if ([successMsg integerValue]==1 ){
                    
                    self.view1.hidden =YES;
                    self.view2.hidden =NO;
                    
                    
                }
                
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                self.sendMessageBtn.userInteractionEnabled = YES;
                self.backBtn.userInteractionEnabled = YES;
                self.drawerBtn.userInteractionEnabled = YES;
                self.faceBookBtn.userInteractionEnabled = YES;
                self.messageBtn.userInteractionEnabled = YES;
                self.phoneBtn.userInteractionEnabled = YES;
                
                spinner.hidden =YES;
                [spinner endRefreshing];
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:@"Sorry, we're facing issues with the network. Please try again"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
            }];
            
        }

        
    }
    
}

- (IBAction)crossButton:(id)sender {
    
    self.view1.hidden =NO;
    self.view2.hidden =YES;
    
    [self.tagListView.selectedTags removeAllObjects];

    [self.tagListView.selectedTags addObject:[self.tagListView.tags objectAtIndex:0]];
    [self.tagListView.collectionView reloadData];
    self.messageText.text = @"";
    self.numberLabel.text = @"300";
    self.hintLabel.hidden = NO;
    
}

- (IBAction)drawerToggle:(id)sender {
    
    [self.messageText resignFirstResponder];
    
    [self.rootNav drawerToggle];
}

- (IBAction)phoneButton:(id)sender {
    
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+16138786287"]];

}

- (IBAction)messageButton:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:prajakta@thejoeyapp.com"]];
    
}

- (IBAction)faceBookButton:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/thejoeyapp/"]];
}

#pragma mark - CCKFNavDrawerDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection contact = %li", (long)selectionIndex);
    
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
            alert.tag = 113;
            [alert show];
        }
    } else if (selectionIndex==2)
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
            alert.tag = 112;
            [alert show];
        }
        
        

        
    }

}


- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
