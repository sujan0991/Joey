//
//  ForGotPassWordViewController.m
//  Joey
//
//  Created by Sujan on 6/22/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "ForGotPassWordViewController.h"
#import "Reachability.h"
#import "JTMaterialSpinner.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "KSToastView.h"

@interface ForGotPassWordViewController (){


      JTMaterialSpinner * spinner;

}

@end

@implementation ForGotPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    
    self.doneView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.emailTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.emailTextField resignFirstResponder];
    
    return YES;
}

- (IBAction)sendNewPassButtonAction:(id)sender {
    
    [self.emailTextField resignFirstResponder];
    
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
        
        if (self.emailTextField.text.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please provide your email address"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            
            [alert show];
            
            
        }else{
            
            
        spinner.hidden = NO;
        [spinner beginRefreshing];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

     
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"username":self.emailTextField.text};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"users/api-forget-password"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            
            NSLog(@"responseObject  JSON : %@", responseObject);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSString* message = [responseObject objectForKey:@"success"];
            
            if ([message integerValue] == 1) {
                
                self.forgotPasswordView.hidden = YES;
                self.doneView.hidden = NO;
            }else{
            
                NSString* errorMsg = [responseObject objectForKey:@"error"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"%@" , errorMsg]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            
            
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSLog(@"responce............%@",operation.responseString);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please provide valid email address"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        
        
        
    }

    }
    
}

- (IBAction)crossButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
