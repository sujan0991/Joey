//
//  ReportProblemViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/3/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "ReportProblemViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface ReportProblemViewController (){

    JTMaterialSpinner* spinner;
}

@end

@implementation ReportProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"IDs .........%@,%@",self.userId,self.roomId);
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    
    self.view1.hidden = NO;
    self.view2.hidden = YES;
    
    self.nameLabel.text = self.roomName;
    
    self.reportTextView.layer.cornerRadius = 5.0;
    self.reportTextView.layer.borderWidth = 0.5f;
    self.reportTextView.layer.borderColor=[[UIColor grayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.reportTextView resignFirstResponder];
    
    if (self.reportTextView.text.length == 0) {
        
        self.hintLabel.hidden = NO;
    }
    
    NSLog(@"Is it called");
}


- (void)textViewDidBeginEditing:(UITextView *)textView {

    self.hintLabel.hidden = YES;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendButton:(id)sender {
    
    [self.reportTextView resignFirstResponder];
    
    NSString *description = self.reportTextView.text;
    
    if (description.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please provide details to report a problem"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }else{
    
    NSLog(@" user id:::::::%@",self.userId);
    
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
        
        self.crossBtn.userInteractionEnabled = NO;
        self.sendbtn.userInteractionEnabled = NO;
        spinner.hidden = NO;
        [spinner beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"room_id": self.roomId,
                             @"user_id":self.userId,
                             @"description":description};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
//    [manager POST:@"http://192.168.1.2:8888/joey/problems/api-submit-problem" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [manager POST:[NSString stringWithFormat:@"%@problems/api-submit-problem", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            self.crossBtn.userInteractionEnabled = YES;
            self.sendbtn.userInteractionEnabled = YES;
            spinner.hidden = YES;
            [spinner endRefreshing];
        
        NSDictionary * response =  (NSDictionary *)responseObject;
     
        NSLog(@"%@",response);
        NSString *successMsg = [responseObject objectForKey:@"success"];
        
        if ([successMsg integerValue]==1 ){
        
                self.view1.hidden = YES;
                self.view2.hidden = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        self.crossBtn.userInteractionEnabled = YES;
        self.sendbtn.userInteractionEnabled = YES;
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
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

- (IBAction)crossButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

//    self.view1.hidden = NO;
//    self.view2.hidden = YES;
//    self.reportTextView.text= @"";
//    self.hintLabel.hidden = NO;
}

- (IBAction)backCrossButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
