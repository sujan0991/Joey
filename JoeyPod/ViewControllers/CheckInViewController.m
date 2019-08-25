//
//  CheckInViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/3/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "CheckInViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "HostPagerViewController.h"
#import "HexColors.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface CheckInViewController (){
  
    NSString* easyState;
    

    NSString* cleanState;
    
 
    NSString* calmState;
    
    JTMaterialSpinner * spinner;
 
    NSString* comment;
    
    NSString* totalRating;

}

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    easyState =@"2";
    cleanState=@"2";
    calmState = @"2";
    
    self.loader.hidden = YES;
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    self.doneBtn.enabled=NO;
    
    self.rateView.notSelectedImage = [UIImage imageNamed:@"star_notselected.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_selected.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star_selected.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.scrollview addGestureRecognizer:tapGesture];
    

    
   

    
    [self registerForKeyboardNotifications];
}

// method to hide keyboard when user taps on a scrollview
-(void)hideKeyboard
{
    [self.commentTextView resignFirstResponder];
    
    if (self.commentTextView.text.length == 0) {
        
        self.hintLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications{

    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWasShown:)

                                                 name:UIKeyboardDidShowNotification object:nil];



    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWillBeHidden:)

                                                 name:UIKeyboardWillHideNotification object:nil];

}



// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification{

    NSDictionary* info = [aNotification userInfo];

    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;



    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);

    self.scrollview.contentInset = contentInsets;

    self.scrollview.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visiblec

    // Your app might not need or want this behavior.

    CGRect aRect = self.view.frame;

    aRect.size.height -= kbSize.height;

    if (!CGRectContainsPoint(aRect, self.commentTextView.frame.origin) ) {

        [self.scrollview scrollRectToVisible:self.commentTextView.frame animated:YES];

    }

}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;

    self.scrollview.contentInset = contentInsets;

    self.scrollview.scrollIndicatorInsets = contentInsets;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.commentTextView resignFirstResponder];
    
    if (self.commentTextView.text.length == 0) {
        
        self.hintLabel.hidden = NO;
    }
    
    NSLog(@"Is it called");
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.hintLabel.hidden = YES;
    
    
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    
    NSLog(@"RATING is :)%d", (int)rating);
    
    totalRating =[NSString stringWithFormat:@"%.2f", rating];
    
    if (totalRating!=NULL) {
        
        self.doneBtn.backgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
        self.doneBtn.enabled =  YES;
    }
    
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 117) {
        
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
             [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }
        
    }
}

- (IBAction)easyFindYesButton:(UIButton *)sender {
    
     sender.selected = !sender.selected;
    
    if (self.easyFindNoBtn.selected) {
        
        self.easyFindNoBtn.selected = NO;
    }
    
}

- (IBAction)easyFindNoButton:(UIButton *)sender {
    
     sender.selected = !sender.selected;
    
    if (self.easyFindYesBtn.selected) {
        
        self.easyFindYesBtn.selected = NO;
    }
}

- (IBAction)cleanYesButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.cleanNoBtn.selected) {
        
        self.cleanNoBtn.selected = NO;
    }
}

- (IBAction)cleanNoButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.cleanYesBtn.selected) {
        
        self.cleanYesBtn.selected = NO;
    }
}

- (IBAction)quietYesButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.quietNoBtn.selected) {
        
        self.quietNoBtn.selected = NO;
    }
}

- (IBAction)quietNoButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.quietYesBtn.selected) {
        
        self.quietYesBtn.selected = NO;
    }
}


- (IBAction)doneButton:(id)sender {
    
    NSLog(@"room id....%@",self.roomId);
    
    
    
    if (self.easyFindYesBtn.selected) {
        
        easyState = @"1";
        
    }else if (self.easyFindNoBtn.selected) {
        
        easyState = @"0";
    }
    
    if (self.cleanYesBtn.selected) {
        cleanState = @"1";
    }else if (self.cleanNoBtn.selected){
    
        cleanState = @"0";
    }
    
    if (self.quietYesBtn.selected) {
        calmState = @"1";
    }else if (self.quietNoBtn.selected){
        
        calmState = @"0";
    }

    
    comment = self.commentTextView.text;
    

    
        NSLog(@"total rating %@",totalRating);

    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);

    if(status == NotReachable)
    {
      
         self.loader.hidden =YES;
        spinner.hidden = YES;
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
        
    }
    else{
    
        spinner.hidden = NO;
        [spinner beginRefreshing];
        
        self.backBtn.userInteractionEnabled = NO;
        self.doneBtn.userInteractionEnabled = NO;
     
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params;
//        if (totalRating == NULL) {
//            params = @{@"access_key": @"flowdigital",
//                                     @"room_id":self.roomId,
//                                     @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
//                                     @"is_easy_find":easyState,
//                                     @"is_neat":cleanState,
//                                     @"is_quiet":calmState,
//                                     @"comment":comment,
//                                     @"rating": @"1"};
//        }else{
          params = @{@"access_key": @"flowdigital",
                                 @"room_id":self.roomId,
                                 @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                 @"is_easy_find":easyState,
                                 @"is_neat":cleanState,
                                 @"is_quiet":calmState,
                                 @"comment":comment,
                                 @"rating": totalRating};
//        }
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"checkins/api-submit-checkin"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.loader.hidden =YES;
            spinner.hidden = YES;
            [spinner endRefreshing];
            self.backBtn.userInteractionEnabled = YES;
            self.doneBtn.userInteractionEnabled = YES;
            
           NSLog(@"responseObject  JSON in login state: %@", responseObject);
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            NSString* checkInTime = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],self.roomId];
            [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:checkInTime];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            self.backBtn.userInteractionEnabled = YES;
            self.doneBtn.userInteractionEnabled = YES;
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
    }

}


@end
