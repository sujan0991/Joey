//
//  SignUpViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/25/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "MapViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "DrawerView.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"
#import "TermsViewController.h"

@interface SignUpViewController (){


    JTMaterialSpinner * spinner;
    JTMaterialSpinner * mainspinner;

}

@property (strong, nonatomic) DrawerView *drawerView;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    
    
    //    // TODO(developer) Configure the sign-in button look/feel
    //
   
    //
    //    // Uncomment to automatically sign in the user.
    //    //[[GIDSignIn sharedInstance] signInSilently];
    
    
   
    
    
    [self.view layoutIfNeeded];
    
    self.loader.hidden = YES;
    self.mainLoader.hidden = YES;
    
    self.scrollview1.hidden = NO;
    self.scrollview2.hidden = YES;
    
    
    self.googleButton.layer.cornerRadius = 5.0;
    self.facebookButton.layer.cornerRadius = 5.0;
    
    self.signupbutton.layer.cornerRadius = 3.0;
    
    UIImageView *name = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon.png"]];
    name.frame = CGRectMake(0, 2, 20, 20);
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [paddingView1 addSubview:name];
    
    [self.fullNameText setLeftView:paddingView1];
    self.fullNameText.leftViewMode = UITextFieldViewModeAlways;
    
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
    
    [self.passwordText setLeftView:paddingView3];
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.scrollview1 addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *secondTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    secondTapGesture.cancelsTouchesInView = NO;
    
    [self.scrollview2 addGestureRecognizer:secondTapGesture];
    
    
   // [self.scrollview2 addGestureRecognizer:tapGesture];
    
    [self registerForKeyboardNotifications];

    }

-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}


-(void) viewDidAppear:(BOOL)animated{
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 17, [UIScreen mainScreen].bounds.size.height/2 -60 , 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    mainspinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 17, [UIScreen mainScreen].bounds.size.height/2 -60, 35, 35)];
    [self.view bringSubviewToFront:mainspinner];
    [self.view addSubview:mainspinner];
    mainspinner.hidden =YES;
    
    
    NSLog(@" main spinner %@",mainspinner);
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(finishGoogleSignIn:) name:@"googleSignUp" object:nil];
    
    [GIDSignIn sharedInstance].uiDelegate = self;


}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//// method to hide keyboard when user taps on a scrollview
-(void)hideKeyboard
{
    [self.fullNameText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.nicknameText resignFirstResponder];
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

    self.scrollview1.contentInset = contentInsets;

    self.scrollview1.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible

    // Your app might not need or want this behavior.

    CGRect aRect = self.view.frame;

    aRect.size.height -= kbSize.height;

    if (!CGRectContainsPoint(aRect, self.fullNameText.frame.origin) ) {

        [self.scrollview1 scrollRectToVisible:self.fullNameText.frame animated:YES];

    }else if (!CGRectContainsPoint(aRect, self.emailText.frame.origin) ) {

        [self.scrollview1 scrollRectToVisible:self.emailText.frame animated:YES];

    }else if (!CGRectContainsPoint(aRect, self.passwordText.frame.origin) ) {

        [self.scrollview1 scrollRectToVisible:self.passwordText.frame animated:YES];

    }

}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;

    self.scrollview1.contentInset = contentInsets;

    self.scrollview1.scrollIndicatorInsets = contentInsets;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.emailText resignFirstResponder];
    [self.fullNameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.nicknameText resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.fullNameText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.nicknameText resignFirstResponder];
    
    NSLog(@"Is it called");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)textFieldDidEndEditing:(UITextField *)textField{

}

- (IBAction)googleLoginButton:(id)sender {
    
     NSLog(@"google in signup");
    
    //self.googleButton.userInteractionEnabled = NO;
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
        
      [[NSUserDefaults standardUserDefaults] setObject:@"signup" forKey:@"viewController"];

      [[GIDSignIn sharedInstance] signIn];
     //   [[GIDSignIn sharedInstance] signInSilently]
        
    }
}

- (IBAction)facebookLoginButton:(id)sender {
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
                 
                 self.facebookButton.userInteractionEnabled = NO;
                 self.signupbutton.userInteractionEnabled = NO;
                 
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
    
        mainspinner.hidden = NO;
        [mainspinner beginRefreshing];
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"email":[result objectForKey:@"email" ],
                             @"fname":[result objectForKey:@"first_name" ],
                             @"lname":[result objectForKey:@"last_name" ]};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //http://192.168.1.2:8888/joey/faqs/api-get-faqs
    
    [manager POST:[NSString stringWithFormat:@"%@/users/api-social-sign-up", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.facebookButton.userInteractionEnabled = YES;
        self.signupbutton.userInteractionEnabled = YES;
        mainspinner.hidden = YES;
        [mainspinner endRefreshing];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginTypeFacebook"];
        
        
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        NSLog(@" response %@",responseObject);
        
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
            [self.navigationController pushViewController:vc animated:YES];
            
            [self.rootNav setIndexToRow:0];
            
        }
        
        }else{
        
            NSLog(@"no matching");
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"socialLogin"];
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            self.scrollview1.hidden = YES;
            self.scrollview2.hidden = NO;
        
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@", operation.responseString);
        
        self.facebookButton.userInteractionEnabled = YES;
        self.signupbutton.userInteractionEnabled = YES;
        mainspinner.hidden = YES;
        [mainspinner endRefreshing];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    
    
    }
    
    
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
    NSLog(@"signInWillDispatch");

    self.googleButton.userInteractionEnabled  = YES;
    self.signupbutton.userInteractionEnabled = YES;

}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    NSLog(@"viewController in signup %@",viewController);
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
   // self.googleButton.userInteractionEnabled  = YES;
    
    NSLog(@"dismissViewController");
    
    self.googleButton.userInteractionEnabled  = NO;
    self.signupbutton.userInteractionEnabled = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
   
}

-(void)finishGoogleSignIn: (NSNotification *)notification
{
    NSLog(@"email in sign in %@",[notification userInfo]);
    
    NSDictionary* info = [notification userInfo];
  
    NSString* email = [info objectForKey:@"email"];
    NSString* fullName = [info objectForKey:@"fullName"];
    NSString* givenName = [info objectForKey:@"givenName"];
    
  
    [[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];

    spinner.hidden = NO;
    [spinner beginRefreshing];
    
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
            
            mainspinner.hidden = NO;
            [mainspinner beginRefreshing];
            
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
                self.signupbutton.userInteractionEnabled = YES;
                
                mainspinner.hidden = YES;
                [mainspinner endRefreshing];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginTypeGoogle"];
                NSDictionary * response =  (NSDictionary *)responseObject;
                
                NSLog(@"%@",responseObject);
                
                NSString* nickName = [response objectForKey:@"nickname"];
                NSString* userId = [response objectForKey:@"user_id"];
                NSString* email = [response objectForKey:@"email"];
                NSString* message = [response objectForKey:@"message"];
                
                [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
                
                NSLog(@"user id .......??????%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
                
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
                    
                    spinner.hidden = YES;
                    [spinner endRefreshing];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"socialLogin"];
                    
                    self.scrollview1.hidden = YES;
                    self.scrollview2.hidden = NO;
                    
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"operation: %@", operation.responseString);
                
                self.googleButton.userInteractionEnabled  = YES;
                self.signupbutton.userInteractionEnabled = YES;

                mainspinner.hidden = YES;
                [mainspinner endRefreshing];
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:@"Sorry, we're facing issues with the network. Please try again"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
            }];
            
            
        }
    

}

- (IBAction)signUpButton:(id)sender {
    
       if (self.emailText.text.length == 0){
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please insert your email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alert show];
           
           
       }else if (![self.emailText.text containsString:@"@"]) {
           
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                           message:@"Please insert correct email"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
           [alert show];
           
       }else if (self.passwordText.text.length==0){
       
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                           message:@"Please insert your password"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
           [alert show];
       
       }else{
    
          
           
           NSArray *componentsSeparatedByWhiteSpace = [self.fullNameText.text componentsSeparatedByString:@" "];
   
           NSMutableArray *nameArray=[[NSMutableArray alloc] initWithArray:componentsSeparatedByWhiteSpace];
           NSLog(@"componebnt%@",nameArray);
           
           for (int i=0; i<nameArray.count; i++) {
               if([nameArray[i] isEqualToString:@" "])
               {
                   [nameArray removeObjectAtIndex:i ];
                   continue;
               }
           }
           
            if([nameArray count] >= 2 ){
                
               NSLog(@"Found whitespace");
             
               self.scrollview1.hidden = YES;
               self.scrollview2.hidden = NO;
             
            }else{
            
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"Fullname must have first and last name"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
              [alert show];
           }
       }

}

//[[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
//[[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
//[[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];

//2016-05-15 18:27:30.670 Joey[4622:1111698] {
//    email = "tanvir@gmail.com";
//    message = "The user has been saved.";
//    nickname = "tan ";
//    success = 1;
//    "user_id" = 16;
//}

- (IBAction)takeMeAppbutton:(id)sender {
    
    
    NSString *fullname = self.fullNameText.text;
    NSString *email = self.emailText.text;
    NSString *passWord = self.passwordText.text;
    NSString *nickName = self.nicknameText.text;
    
    NSArray *names = [fullname componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *lastName;
    
    for (int i=1; i< names.count; i++) {
        
        if (i>1) {
            
        lastName = [NSString stringWithFormat:@"%@ %@",lastName,names[i]];
        }
        else
        {
            lastName=[NSString stringWithFormat:@"%@",names[i]];
        }
        
    }
   
    
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
         
             self.takeMeAppBtn.userInteractionEnabled = NO;
             
             spinner.hidden = NO;
             [spinner beginRefreshing];
    
         if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"socialLogin"] isEqualToString:@"1"]) {
             
             [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"socialLogin"];
             
             NSLog(@"nickname needed");
             NSLog(@"nickname in social %@",nickName);
             
             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             NSDictionary *params = @{@"access_key": @"flowdigital",
                                      @"nickname":nickName,
                                      @"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"email"]};
             
             NSLog(@"");
             
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
             
             
             [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-update-nickname"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
                 
                 
                 self.takeMeAppBtn.userInteractionEnabled = YES;
                 
                 NSDictionary * response =  (NSDictionary *)responseObject;
                 
                 NSLog(@"response %@",response);
                 
                 NSString* errormsg = [response objectForKey:@"message"];
                 
                 NSString *successMsg = [response objectForKey:@"success"];
                 
                 if ([successMsg integerValue]==1 ){
                     

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
                         
                         [self.rootNav setIndexToRow:0];
                         
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
                 
                 self.takeMeAppBtn.userInteractionEnabled = YES;
                 spinner.hidden = YES;
                 [spinner endRefreshing];
                 
                 self.scrollview1.hidden = NO;
                 self.scrollview2.hidden = YES;
                 
                 NSLog(@"Error: %@", error);
                 
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                 message:@"Sorry, we're facing issues with the network. Please try again"
//                                                                delegate:nil
//                                                       cancelButtonTitle:@"OK"
//                                                       otherButtonTitles:nil];
//                 [alert show];
             }];
             
         }else{
             
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
           NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"fname": names[0],
                             @"lname":lastName,
                             @"email":email,
                             @"password":passWord,
                             @"nickname":nickName};
         
         NSLog(@"");
 
       manager.responseSerializer = [AFJSONResponseSerializer serializer];
       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
      [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/apiSignUp"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        self.takeMeAppBtn.userInteractionEnabled = YES;
         
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        NSLog(@"response %@",response);
        
         NSString* errormsg = [response objectForKey:@"message"];
         
         NSString *successMsg = [response objectForKey:@"success"];
        
         if ([successMsg integerValue]==1 ){
            
             
             NSString* nickName = [response objectForKey:@"nickname"];
             NSString* userId = [response objectForKey:@"user_id"];
             NSString* email = [response objectForKey:@"email"];
             
             [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"userId"];
             [[NSUserDefaults standardUserDefaults ] setObject:nickName forKey:@"nickName"];
             [[NSUserDefaults standardUserDefaults ] setObject:email forKey:@"email"];
             
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
        
        self.takeMeAppBtn.userInteractionEnabled = YES;
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        self.scrollview1.hidden = NO;
        self.scrollview2.hidden = YES;
        
        NSLog(@"Error: %@", error);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
         
  }
     }
     }

}

- (IBAction)goLogIn:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:self];

}

- (IBAction)termsButtonAction:(id)sender {
    
    TermsViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


//[self presentViewController:self.imagePicker animated:YES completion:nil];
@end
