//
//  ForGotPassWordViewController.h
//  Joey
//
//  Created by Sujan on 6/22/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForGotPassWordViewController : UIViewController<UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UIView *forgotPasswordView;

@property (weak, nonatomic) IBOutlet UIView *doneView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@end
