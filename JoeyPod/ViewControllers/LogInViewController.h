//
//  LogInViewController.h
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


@interface LogInViewController : UIViewController<UITextFieldDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property(weak, nonatomic) IBOutlet GIDSignInButton *googlesignInButton;

@property (weak, nonatomic) IBOutlet UIButton *googleButton;

@property (weak, nonatomic) IBOutlet UIButton *faceBookButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

@property (weak, nonatomic) IBOutlet UIButton *takeMeAppBtn;


@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *passText;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaderInNickNameView;


@property (weak, nonatomic) IBOutlet UIView *nickNameView;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextView;

- (IBAction)takeMeToAppButton:(id)sender;

- (IBAction)logInButton:(id)sender;

- (IBAction)signUpButton:(UIButton *)sender;

- (IBAction)loginwithGoogle:(id)sender;

- (IBAction)loginwithFaceBook:(id)sender;


@end
