//
//  SignUpViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/25/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CCKFNavDrawer.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview1;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview2;

@property (weak, nonatomic) IBOutlet UIButton *googleButton;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (weak, nonatomic) IBOutlet UIButton *signupbutton;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *takeMeAppBtn;

@property (weak, nonatomic) IBOutlet UITextField *fullNameText;

@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UITextField *nicknameText;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainLoader;



- (IBAction)googleLoginButton:(id)sender;

- (IBAction)facebookLoginButton:(id)sender;


- (IBAction)signUpButton:(id)sender;
- (IBAction)takeMeAppbutton:(id)sender;


- (IBAction)goLogIn:(id)sender;


@end
