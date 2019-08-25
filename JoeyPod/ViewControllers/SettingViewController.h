//
//  SettingViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/28/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "ViewPagerController.h"
#import "CCKFNavDrawer.h"

#import <Google/SignIn.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SettingViewController : ViewPagerController<UITableViewDataSource,UITableViewDelegate,CCKFNavDrawerDelegate,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate>

@property NSString* userid;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;



@property (weak, nonatomic) IBOutlet UIView *emailView;

@property (weak, nonatomic) IBOutlet UIView *nickNameView;


@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *nicknameText;

@property (weak, nonatomic) IBOutlet UITextField *passWordText;

@property (weak, nonatomic) IBOutlet UITextField *NewPasswordText;

@property (weak, nonatomic) IBOutlet UITextField *confirnPaddText;


@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

@property (weak, nonatomic) IBOutlet UIButton *nickNameBtn;

@property (weak, nonatomic) IBOutlet UIButton *passWordBtn;


@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

- (IBAction)takeMeAppButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIView *confirmPasswordView;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapBetPassViewToOtherAcc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirnPassHeight;


- (IBAction)emailChangeButton:(UIButton*)sender;

- (IBAction)nameChangeButton:(UIButton*)sender;

- (IBAction)passwordChangeButton:(UIButton*)sender;




@property (weak, nonatomic) IBOutlet UITableView *socialTable;



- (IBAction)drawerToggle:(id)sender;

@end
