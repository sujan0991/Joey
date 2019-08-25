//
//  SettingViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/28/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "SettingViewController.h"
#import "ContactUsViewController.h"
#import "MapViewController.h"
#import "FavoritesViewController.h"
#import "FAQsViewController.h"
#import "AboutJoeyViewController.h"
#import "LeaderBoardViewController.h"
#import "ContactUsViewController.h"
#import "MessagesViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "DrawerView.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface SettingViewController (){
    
    NSArray *loginOptions;
    NSMutableArray* connectionType;
    JTMaterialSpinner * spinner;
    
}
@property (strong, nonatomic) DrawerView *drawerView;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    self.nickNameView.hidden =YES;
    
    //    // TODO(developer) Configure the sign-in button look/feel
    //
    [GIDSignIn sharedInstance].uiDelegate = self;
    //
    //    // Uncomment to automatically sign in the user.
    //    //[[GIDSignIn sharedInstance] signInSilently];
    
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    
    connectionType = [[NSMutableArray alloc] init];
    [connectionType addObject:@"Connect with Facebook"];
    [connectionType addObject:@"Connect with Google"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeFacebook"] isEqualToString:@"1"]) {

        [connectionType replaceObjectAtIndex:0 withObject:@"Connected with Facebook"];
        
        
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeGoogle"] isEqualToString:@"1"]) {
        
     
        [connectionType replaceObjectAtIndex:1 withObject:@"Connected with Google"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeFacebook"] isEqualToString:@"1"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeGoogle"] isEqualToString:@"1"])
    {
        self.emailText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        self.nicknameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        self.passWordText.placeholder = @"";
        self.passWordBtn.userInteractionEnabled = NO;
    }
    else
    {
        self.emailText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        self.nicknameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        self.nickNameBtn.userInteractionEnabled = YES;
        self.passWordBtn.userInteractionEnabled = YES;

    }
        
        
 
    
    [self.socialTable reloadData];
    
    self.passwordView.hidden = NO;
    self.confirmPasswordView.hidden =YES;
    
    self.emailView.layer.borderWidth = 0.3f;
    self.emailView.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.nickNameView.layer.borderWidth = 0.3f;
    self.nickNameView.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    self.passwordView.layer.borderWidth = 0.3f;
    self.passwordView.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    

    
    
    loginOptions = @[ @"facebook", @"google"];

    
    //tableView
    self.socialTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.socialTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Button round shape
    UIBezierPath *maskPath1;
    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.emailBtn.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.emailBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.emailBtn.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2;
    maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.nickNameBtn.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.nickNameBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.nickNameBtn.layer.mask = maskLayer2;
    
    
    UIBezierPath *maskPath3;
    maskPath3 = [UIBezierPath bezierPathWithRoundedRect:self.passWordBtn.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer3 = [[CAShapeLayer alloc] init];
    maskLayer3.frame = self.passWordBtn.bounds;
    maskLayer3.path = maskPath3.CGPath;
    self.passWordBtn.layer.mask = maskLayer3;
    
    //to move textfield up when keyboard show
    
//    [self registerForKeyboardNotifications];
    
    NSLog(@" email %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
    
  
 
    
    self.emailText.enabled = NO;
    self.nicknameText.enabled = NO;
    self.passWordText.enabled = NO;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.emailText resignFirstResponder];
    [self.nicknameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
    [self.NewPasswordText resignFirstResponder];
    [self.confirnPaddText resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
   
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return connectionType.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel * connectionName= (UILabel*) [cell viewWithTag:150];
    
    [connectionName setText:[connectionType objectAtIndex:indexPath.section]];
    
    UIImageView *icon=(UIImageView*) [cell viewWithTag:151];
    if(indexPath.section==0)
    {
        
        icon.image=[UIImage imageNamed:@"iconn"];
    }else
    {
        icon.image=[UIImage imageNamed:@"iconn3"];
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeFacebook"] isEqualToString:@"1"] && indexPath.section==0) {
        
        cell.userInteractionEnabled=NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeGoogle"] isEqualToString:@"1"] && indexPath.section==1) {
        
        cell.userInteractionEnabled=NO;
    }
    else
        cell.userInteractionEnabled=YES;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginTypeGoogle"] isEqualToString:@"1"]) {
//        
//        
//        [connectionType replaceObjectAtIndex:1 withObject:@"Connected with Google"];
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *CellIdentifier = [loginOptions objectAtIndex:indexPath.section];
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//   
//    

    if (indexPath.section == 1) {
        
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
        
       [[NSUserDefaults standardUserDefaults] setObject:@"google" forKey:@"loginType"];
    
         [[GIDSignIn sharedInstance] signIn];
        
        NSLog(@"GOOGLE");
            
        }
    }else if (indexPath.section == 0){
    
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
            
        [[NSUserDefaults standardUserDefaults] setObject:@"fb" forKey:@"loginType"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult* result, NSError* error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 // NSLog(@"Logged in");
                 NSLog(@"fetched user:%@", result);
                 
                 NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
                 NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
                 
                 [self fetchUserInfo];
                 // NSLog(@"email %@",result[@"email"]);
             }
         }];

    }
    }

}


-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection* connection, id result, NSError* error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 
                 
                 [self fbLogin:result];
                 
                 //                 TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                 //                 [self.navigationController pushViewController:viewController animated:NO];
                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}

-(void)fbLogin: (id) result{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"email":[result objectForKey:@"email" ],
                             @"fname":[result objectForKey:@"first_name" ],
                             @"lname":[result objectForKey:@"last_name" ]};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //http://192.168.1.2:8888/joey/faqs/api-get-faqs
    
    [manager POST:[NSString stringWithFormat:@"%@/users/api-social-sign-up", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"response %@",responseObject);
        self.emailText.text = @"";
        self.nicknameText.text = @"";
        
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        
        NSString* nickName = [response objectForKey:@"nickname"];
        NSString* userId = [response objectForKey:@"user_id"];
        NSString* email = [response objectForKey:@"email"];
         NSString* message = [response objectForKey:@"message"];
        
        NSLog(@"email userd  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
        
//        if (email != [[NSUserDefaults standardUserDefaults] objectForKey: @"email"] && [[[NSUserDefaults standardUserDefaults] objectForKey: @"loginTypeGoogle"] isEqualToString:@"1"]) {
//            
//            NSLog(@"inside Facebook");
//            
//            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"loginTypeGoogle"];
//            [connectionType replaceObjectAtIndex:1 withObject:@"Connect with Google"];
//        }
        
        [[NSUserDefaults standardUserDefaults ] setObject:[result objectForKey:@"email"] forKey:@"email"];
        [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
    
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginTypeFacebook"];
        [connectionType replaceObjectAtIndex:0 withObject:@"Connected with Facebook"];
        
       
        
        // NSLog(@"nickname%@",nickName);
        
          if ([message isEqualToString:@"Matching user found"]) {
              
        [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
        
        
        NSLog(@"nick name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
        NSLog(@"email name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
        
        
        NSLog(@"LOGIN DONE");
              
        self.emailText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        self.nicknameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
              
        
        //change drewer
        
        [self.rootNav setLoginButtonStat];
        
          }
          else
          {
              
//                   [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"loginTypeGoogle"];
//              
//                    [connectionType replaceObjectAtIndex:1 withObject:@"Connect with Google"];
           
              self.scrollview.hidden = YES;
              self.nickNameView.hidden = NO;
          }
        
         [self.socialTable reloadData];
        
         self.passWordText.placeholder = @"";
         self.passWordBtn.userInteractionEnabled = NO;
        
        //NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@", operation.responseString);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *spaceView = [[UIView alloc]init];
    
    spaceView.backgroundColor = [UIColor clearColor];
    
    return spaceView;
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)e {
    
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    NSLog(@"user email from google %@",user.profile.name);
 //   [[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];
    
//    self.loader.hidden =NO;
//    [self.loader startAnimating];
    
    //show map map
    
    if (!e) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"email":email,
                                 @"fname":fullName,
                                 @"lname":givenName};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //http://192.168.1.2:8888/joey/faqs/api-get-faqs
        
        [manager POST:[NSString stringWithFormat:@"%@/users/api-social-sign-up", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            self.emailText.text = @"";
            self.nicknameText.text = @"";
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginTypeGoogle"];
            [connectionType replaceObjectAtIndex:1 withObject:@"Connected with Google"];
            
            NSDictionary * response =  (NSDictionary *)responseObject;
            
            
            NSString* nickName = [response objectForKey:@"nickname"];
            NSString* userId = [response objectForKey:@"user_id"];
            NSString* email = [response objectForKey:@"email"];
            NSString* message = [response objectForKey:@"message"];
            
            NSLog(@"email userd ........... %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
            
            
//            if (email != [[NSUserDefaults standardUserDefaults] objectForKey: @"email"] && [[[NSUserDefaults standardUserDefaults] objectForKey: @"loginTypeFacebook"] isEqualToString:@"1"]) {
//                
//                NSLog(@"inside google");
//                
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"loginTypeFacebook"];
//                [connectionType replaceObjectAtIndex:0 withObject:@"Connect with Facebook"];
//            }
            
            [[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];

            [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
            
            if ([message isEqualToString:@"Matching user found"]) {

            
            [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
            
            
            NSLog(@"nick name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
            NSLog(@"email name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
            
            
            NSLog(@"LOGIN DONE");
            
            self.emailText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
            self.nicknameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
                
            //change drewer
            
            
            
             [self.rootNav setLoginButtonStat];
            }
            else
            {
             
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"loginTypeFacebook"];
//                [connectionType replaceObjectAtIndex:0 withObject:@"Connect with Facebook"];
                
                
                self.scrollview.hidden = YES;
                self.nickNameView.hidden = NO;
            }
            
            [self.socialTable reloadData];
            
            self.passWordText.placeholder = @"";

            self.passWordBtn.userInteractionEnabled = NO;
            
            
            
            NSLog(@"%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation: %@", operation.responseString);
            
            //        self.loader.hidden =YES;
            //        [self.loader stopAnimating];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];

    }
    
    
    
    
    
    
}

- (IBAction)emailChangeButton:(UIButton*)sender {
    
//http://192.168.1.2:8888/joey/users/api-update-user-info


//    //edit textfield
//    if (!sender.selected) {
//        
//         self.emailText.enabled = YES;
//        [self.emailText becomeFirstResponder];
//        
//    } else {
//        
//        [self.emailText resignFirstResponder];
//        
//        NSString* newEmail = self.emailText.text;
//        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
//            
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            NSDictionary *params = @{@"access_key": @"flowdigital",
//                                     @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
//                                     @"email":newEmail };
//            
//            manager.responseSerializer = [AFJSONResponseSerializer serializer];
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            
//            [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-update-user-info"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//            NSLog(@"responseObject  JSON in login state: %@", responseObject);
//                
//            NSString *success = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
//                
//                if ([success isEqualToString:@"1"]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                                    message:@"Email changed"
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                }else{
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                                message:@"Problem occured when changing email"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                     [alert show];
//                }
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                                message:@"Problem occured when changing email"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//            }];
//        }
//        
//        NSLog(@"SAVE button clicked");
//    }
//    
//    //to change buttin text
//    sender.selected =!sender.selected;
   
}

- (IBAction)nameChangeButton:(UIButton*)sender {
    
    
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
 
    //edit textfield
    if (!sender.selected) {
        
        self.nicknameText.enabled = YES;
        [self.nicknameText becomeFirstResponder];
        
    } else {
        
        [self.nicknameText resignFirstResponder];
        
        if (self.nicknameText.text.length == 0) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"Please insert nickname"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
    
        [alert show];
            
        }else{
        
        NSString* newName = self.nicknameText.text;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
            
      
            spinner.hidden  = NO;
            [spinner beginRefreshing];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *params = @{@"access_key": @"flowdigital",
                                     @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                     @"nickname":newName };
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-update-user-info"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"responseObject  JSON in login state: %@", responseObject);
                
                spinner.hidden  = YES;
                [spinner endRefreshing];
                
                
               // self.nicknameText.text = newName;
                NSString *success = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
                
                if ([success isEqualToString:@"1"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Nickname changed"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:newName forKey:@"nickName"];
                    
                    [self.rootNav setLoginButtonStat];

                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                spinner.hidden  = YES;
                [spinner endRefreshing];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Problem occured when changing nickname"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }];
        }
        }
        NSLog(@"SAVE button clicked");
    }
    
    sender.selected =!sender.selected;
    }


    }

- (IBAction)passwordChangeButton:(UIButton*)sender {
    
    
    
    [UIView animateWithDuration:15.0 animations:^{
        
        self.confirnPassHeight.constant = 120;
   
    } completion:^(BOOL finished) {
        
    }];
    

    self.passwordView.hidden = YES;
    self.confirmPasswordView.hidden = NO;
    
//http://192.168.1.2:8888/joey/users/api-update-user-info

}

- (IBAction)updatePassButton:(UIButton *)sender {
    
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
    
    self.confirnPassHeight.constant = 30;
    
    self.passwordView.hidden = NO;
    self.confirmPasswordView.hidden = YES;
    
    NSString* newpass = self.NewPasswordText.text;
    NSString* confirmPass = self.confirnPaddText.text;
    NSString *finalPass;
    if ([newpass isEqualToString:confirmPass]) {
    
        finalPass = newpass;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
        if (finalPass.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please insert password"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }else{
        
            spinner.hidden  = NO;
            [spinner beginRefreshing];
            
              AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
              NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                 @"password":finalPass };
        
              manager.responseSerializer = [AFJSONResponseSerializer serializer];
              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
              [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-update-user-info"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
                  
                  spinner.hidden  = YES;
                  [spinner endRefreshing];
                  
            NSLog(@"responseObject  JSON in login state: %@", responseObject);
            
             // self.emailText.text = newEmail;
              NSString *success = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
            
            if ([success isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Password changed"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden  = YES;
            [spinner endRefreshing];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Problem occured when changing password"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
    }
  }
    
    NSLog(@"update button clicked");
}

- (IBAction)drawerToggle:(id)sender {
    
    [self.emailText resignFirstResponder];
    [self.nicknameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
    [self.NewPasswordText resignFirstResponder];
    [self.confirnPaddText resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
    
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
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
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
        
        
        
        
    }else if (selectionIndex==7)
    {
        ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        [self.navigationController pushViewController:vc animated:YES];

    }

}
- (IBAction)takeMeAppButton:(id)sender {
    
    NSString *nickName = self.nickNameTextField.text;
    
    if (nickName.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please insert your nickname"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"nickname":nickName,
                                 @"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"email"]};
        
        NSLog(@"");
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-update-nickname"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            
            NSDictionary * response =  (NSDictionary *)responseObject;
            
            NSLog(@"response %@",response);
            
            NSString* errormsg = [response objectForKey:@"message"];
            
            NSString *successMsg = [response objectForKey:@"success"];
            
            if ([successMsg integerValue]==1 ){
                
                
                //                NSString* nickName = [response objectForKey:@"nickname"];
                //                NSString* userId = [response objectForKey:@"user_id"];
                
                //   [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
                
                
                NSLog(@"user id .......%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
                
                //change drewer
                
                [self.rootNav setLoginButtonStat];
                
                self.emailText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
                self.nicknameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
                
                self.scrollview.hidden = NO;
                self.nickNameView.hidden = YES;
               
                
            }else if ([successMsg integerValue]==0 ){
               
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errormsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
           
            
            self.scrollview.hidden = NO;
            self.nickNameView.hidden = YES;
            
            NSLog(@"Error: %@", error);
            
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
