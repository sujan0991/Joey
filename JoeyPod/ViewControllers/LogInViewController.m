//
//  LogInViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/25/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "LogInViewController.h"
#import <AFNetworking.h>
#import "MapViewController.h"
#import "DrawerView.h"
#import "Urls.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"
#import "ForGotPassWordViewController.h"

@interface LogInViewController (){

    JTMaterialSpinner * spinner;
    JTMaterialSpinner * spinnerInNickNameView;
}

@property (strong, nonatomic) DrawerView *drawerView;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;

    self.loader.hidden =YES;
    self.nickNameView.hidden = YES;
    
    
    //Button round shape
   
    [self.view layoutIfNeeded];
    
    self.googleButton.layer.cornerRadius = 5.0;
    self.faceBookButton.layer.cornerRadius = 5.0;
    
    self.loginButton.layer.cornerRadius = 3.0;
    
    UIImageView *email = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_icon.png"]];
    email.frame = CGRectMake(0, 7, 20, 15);
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [paddingView2 addSubview:email];
    
    [self.emailText setLeftView:paddingView2];
    self.emailText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *password = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon.png"]];
    password.frame = CGRectMake(0, 5, 20, 18);
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [paddingView3 addSubview:password];
    
    [self.passText setLeftView:paddingView3];
    self.passText.leftViewMode = UITextFieldViewModeAlways;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.scrollview addGestureRecognizer:tapGesture];

    [self registerForKeyboardNotifications];

}

-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void) viewDidAppear:(BOOL)animated{

    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 17, [UIScreen mainScreen].bounds.size.height/2 - 60 , 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    NSLog(@"main screen size %f",[UIScreen mainScreen].bounds.size.height);
    
     [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(finishGoogleLogIn:) name:@"googleLogin" object:nil];
    
    [GIDSignIn sharedInstance].uiDelegate = self;

   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)hideKeyboard
{
    [self.emailText resignFirstResponder];
    [self.passText resignFirstResponder];
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
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your app might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, self.emailText.frame.origin) ) {
        
        [self.scrollview scrollRectToVisible:self.emailText.frame animated:YES];
        
    }else if (!CGRectContainsPoint(aRect, self.passText.frame.origin) ) {
        
        [self.scrollview scrollRectToVisible:self.passText.frame animated:YES];
        
    }
    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.scrollview.contentInset = contentInsets;
    
    self.scrollview.scrollIndicatorInsets = contentInsets;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.emailText resignFirstResponder];
    [self.passText resignFirstResponder];
    [self.nickNameTextView resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.emailText resignFirstResponder];
    [self.passText resignFirstResponder];
    [self.nickNameTextView resignFirstResponder];

}
//-(void)willPresentAlertView:(UIAlertView *)alertView{
//   
//     
//     UILabel *body = [alertView valueForKey:@"_bodyTextLabel"];
//     body.font = [UIFont fontWithName:@"Arial" size:15];
//     [body setTextColor:[UIColor grayColor];
// }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)logInButton:(id)sender {
    
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
        
        
    
    NSString *email = self.emailText.text;
    NSString *passWord = self.passText.text;

    
    if (email.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please insert your email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }else if (passWord.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please insert your password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }else{
        
        spinner.hidden = NO;
        [spinner beginRefreshing];
        
        self.loginButton.userInteractionEnabled = NO;
        self.signupBtn.userInteractionEnabled = NO;
        self.googleButton.userInteractionEnabled = NO;
        self.faceBookButton.userInteractionEnabled =NO;
        
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"username": email,
                             @"password":passWord};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/apilogin"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            self.loginButton.userInteractionEnabled = YES;
            self.signupBtn.userInteractionEnabled = YES;
            self.googleButton.userInteractionEnabled = YES;
            self.faceBookButton.userInteractionEnabled =YES;
            
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        NSLog(@"response after login:%@",response);
        NSDictionary *userDetail = [response objectForKey:@"UserDetail"];
        
        NSString *successMsg = [userDetail objectForKey:@"success"];
        
        if ([successMsg integerValue]==1 ){
            
            NSString* nickName = [userDetail objectForKey:@"nickname"];
            NSString* userId = [userDetail objectForKey:@"id"];
            NSString* email = [userDetail objectForKey:@"username"];
            
           // NSLog(@"nickname%@",nickName);
            
           [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
           [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
           [[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];
           
            NSLog(@"nick name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
            NSLog(@"email name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);

            
           NSLog(@"LOGIN DONE");
            

          
          NSLog(@" .................... :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);
         
           [self.rootNav setLoginButtonStat];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"1"]) {
            
                 [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
                
                 [self.navigationController popViewControllerAnimated:YES];
                

            }else{
          
            
                MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                [self.navigationController pushViewController:vc animated:YES];
                
                [self.rootNav setIndexToRow:0];
                
            }
            
         

        }else{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please insert correct username and password"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        self.loginButton.userInteractionEnabled = YES;
        self.signupBtn.userInteractionEnabled = YES;
        self.googleButton.userInteractionEnabled = YES;
        self.faceBookButton.userInteractionEnabled =YES;
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];

  }
    }
}

- (IBAction)loginwithGoogle:(id)sender {
    
    
    //self.googleButton.userInteractionEnabled  = NO;
    
    NSLog(@"google in login");
    
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
        
      [[NSUserDefaults standardUserDefaults] setObject:@"login" forKey:@"viewController"];

    
      [[GIDSignIn sharedInstance] signIn];
        
    }
    
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
      NSLog(@"signInWillDispatch");
    
    self.googleButton.userInteractionEnabled  = YES;
    self.loginButton.userInteractionEnabled = YES;
    
    spinner.hidden = YES;
    [spinner endRefreshing];
    
}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
     NSLog(@"viewController in login %@",viewController);
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    NSLog(@"dismissViewController");
    
     self.googleButton.userInteractionEnabled  = NO;
     self.loginButton.userInteractionEnabled =NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    spinner.hidden = YES;
    [spinner endRefreshing];
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    
    spinner.hidden = YES;
    [spinner endRefreshing];
    
    // ...
}


-(void)finishGoogleLogIn: (NSNotification *)notification
{
    NSLog(@"email in sign in %@",[notification userInfo]);
    
    NSDictionary* info = [notification userInfo];
    
    NSString* email = [info objectForKey:@"email"];
    NSString* fullName = [info objectForKey:@"fullName"];
    NSString* givenName = [info objectForKey:@"givenName"];
    
    NSLog(@"email in sign in %@",email);
    
    [[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];
    
    spinner.hidden = NO;
    [spinner beginRefreshing];
    
    //Network connection
    
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
                                 @"email":email,
                                 @"fname":fullName,
                                 @"lname":givenName};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //http://192.168.1.2:8888/joey/faqs/api-get-faqs
        
        [manager POST:[NSString stringWithFormat:@"%@/users/api-social-sign-up", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            self.googleButton.userInteractionEnabled  = YES;
            self.loginButton.userInteractionEnabled = YES;
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginTypeGoogle"];
            
            NSDictionary * response =  (NSDictionary *)responseObject;
            
            
            NSString* nickName = [response objectForKey:@"nickname"];
            NSString* userId = [response objectForKey:@"user_id"];
            NSString* email = [response objectForKey:@"email"];
            NSString* message = [response objectForKey:@"message"];
            
            
            [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
            
            if ([message isEqualToString:@"Matching user found"]) {
                
                
                [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
                
                
                NSLog(@"nick name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
                NSLog(@"email name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
                
                
                NSLog(@"LOGIN DONE");
                
                //change drewer
                
                
                [self.rootNav setLoginButtonStat];
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"1"]) {
                    
                    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }else{
                    
                    
                    MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    [self.rootNav setIndexToRow:0];
                    
                }
            }else{
                
                NSLog(@"no matching");
                
                //  [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"socialLogin"];
                
                spinnerInNickNameView.hidden = YES;
                [spinnerInNickNameView endRefreshing];
                
                self.scrollview.hidden = YES;
                self.nickNameView.hidden = NO;
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation: %@", operation.responseString);
            
            self.googleButton.userInteractionEnabled  = YES;
            self.loginButton.userInteractionEnabled = YES;
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
        
    }
    
    
}

- (IBAction)signUpButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"signup" object:self];
}



- (IBAction)loginwithFaceBook:(id)sender {
    
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
                 
                 self.faceBookButton.userInteractionEnabled = NO;
                 self.loginButton.userInteractionEnabled = NO;
                 
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
                             @"email":[result objectForKey:@"email" ],
                             @"fname":[result objectForKey:@"first_name" ],
                             @"lname":[result objectForKey:@"last_name" ]};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //http://192.168.1.2:8888/joey/faqs/api-get-faqs
    
    [manager POST:[NSString stringWithFormat:@"%@/users/api-social-sign-up", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.faceBookButton.userInteractionEnabled = YES;
        self.loginButton.userInteractionEnabled = YES;
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginTypeFacebook"];
        
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        
        NSString* nickName = [response objectForKey:@"nickname"];
        NSString* userId = [response objectForKey:@"user_id"];
        NSString* email = [response objectForKey:@"email"];
        NSString* message = [response objectForKey:@"message"];
        
        [[NSUserDefaults standardUserDefaults ] setObject:[result objectForKey:@"email"] forKey:@"email"];
        [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
        
        NSLog(@"email name in login......:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
        
        if ([message isEqualToString:@"Matching user found"]) {
            
            
            [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
            
            
            NSLog(@"nick name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
            NSLog(@"email name in login:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
            
            
            NSLog(@"LOGIN DONE");
            
            //change drewer
            
            [self.rootNav setLoginButtonStat];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"1"]) {
               [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                
                
                MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                NSLog(@"vc %@",vc);
                [self.navigationController pushViewController:vc animated:YES];
                
                [self.rootNav setIndexToRow:0];
                
            }
            
        }else{
            
            NSLog(@"no matching");
           // [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"socialLogin"];
            
            spinnerInNickNameView.hidden = YES;
            [spinnerInNickNameView endRefreshing];
            
            self.scrollview.hidden = YES;
            self.nickNameView.hidden = NO;
            
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@", operation.responseString);
        
        self.faceBookButton.userInteractionEnabled = YES;
        self.loginButton.userInteractionEnabled = YES;
        spinner.hidden = YES;
        [spinner endRefreshing];
        
//        self.loaderInNickNameView.hidden = YES;
//        [self.loaderInNickNameView stopAnimating];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    }
}

- (IBAction)takeMeToAppButton:(id)sender {
    
    NSString *nickName = self.nickNameTextView.text;
    
    if (nickName.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please insert your nickname"
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
            
            [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
            
        }
        else{
            
        spinner.hidden = NO;
        [spinner beginRefreshing];
            
        self.takeMeAppBtn.userInteractionEnabled =NO;
            
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"nickname":nickName,
                                 @"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"email"]};
        
        NSLog(@"");
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-update-nickname"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            self.takeMeAppBtn.userInteractionEnabled =YES;
            
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
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"1"]) {
                     [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"login"];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }else{
                    
                    
                    MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }else if ([successMsg integerValue]==0 ){
                
                spinner.hidden = YES;
                [spinner endRefreshing];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errormsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            self.takeMeAppBtn.userInteractionEnabled =YES;
            
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
}

- (IBAction)forgotPassButtonAction:(id)sender {
    
    ForGotPassWordViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForGotPassWordViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


@end
