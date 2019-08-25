//
//  ContactUsViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/5/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "JCTagListView.h"

@interface ContactUsViewController : UIViewController<CCKFNavDrawerDelegate,UITextViewDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UIButton *drawerBtn;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;

@property (weak, nonatomic) IBOutlet UIButton *faceBookBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;


@property (weak, nonatomic) IBOutlet UITextView *messageText;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;

- (IBAction)backButton:(id)sender;

- (IBAction)sendButton:(id)sender;

- (IBAction)crossButton:(id)sender;

- (IBAction)drawerToggle:(id)sender;

- (IBAction)phoneButton:(id)sender;

- (IBAction)messageButton:(id)sender;

- (IBAction)faceBookButton:(id)sender;


@property (weak, nonatomic) IBOutlet JCTagListView *tagListView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagListHeight;


@end
