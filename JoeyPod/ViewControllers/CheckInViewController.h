//
//  CheckInViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/3/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface CheckInViewController : UIViewController<RateViewDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (strong) NSString* roomId;
@property (strong) NSString* userId;

@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *easyFindYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *easyFindNoBtn;

@property (weak, nonatomic) IBOutlet UIButton *cleanYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *cleanNoBtn;

@property (weak, nonatomic) IBOutlet UIButton *quietYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *quietNoBtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;


@property (weak, nonatomic) IBOutlet UIButton *doneBtn;



- (IBAction)doneButton:(id)sender;

- (IBAction)easyFindYesButton:(UIButton *)sender;

- (IBAction)easyFindNoButton:(UIButton *)sender;

- (IBAction)cleanYesButton:(UIButton *)sender;

- (IBAction)cleanNoButton:(UIButton *)sender;

- (IBAction)quietYesButton:(UIButton *)sender;

- (IBAction)quietNoButton:(UIButton *)sender;


@end
