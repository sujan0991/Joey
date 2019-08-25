//
//  ReportProblemViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/3/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportProblemViewController : UIViewController<UITextViewDelegate>




@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UITextView *reportTextView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIButton *crossBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendbtn;


@property (strong)NSString* userId;
@property (strong)NSString* roomId;
@property(strong)NSString* roomName;

- (IBAction)sendButton:(id)sender;

- (IBAction)crossButton:(id)sender;

- (IBAction)backCrossButton:(id)sender;

@end
